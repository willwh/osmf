/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
* 
*  Contributor(s): Akamai Technologies
*  
*****************************************************/
package org.openvideoplayer.mast.managers
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import org.openvideoplayer.events.*;
	import org.openvideoplayer.mast.adapter.MASTAdapter;
	import org.openvideoplayer.mast.model.MASTCondition;
	import org.openvideoplayer.mast.types.MASTConditionOperator;
	import org.openvideoplayer.mast.types.MASTConditionType;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.MediaTraitType;
	
	/**
	 * Dispatched when the condition (and it's child conditions)
	 * evaluate to <code>true</code>
	 * 
	 * @eventType flash.events.Event
	 */
	[Event(name="conditionTrue",type="flash.events.Event")]
	
	
	/**
	 * Eacth MASTCondition has a MASTConditionManager which knows how to 
	 * listen for events and check properties on a MediaElement.
	 */
	public class MASTConditionManager extends EventDispatcher
	{		
		public static const CONDITION_TRUE:String = "conditionTrue";
		
		public function MASTConditionManager()
		{
			super();
		}
		
		public function setContext(mediaElement:MediaElement, condition:MASTCondition):void
		{
			_condition = condition;
			_mediaElement = mediaElement;
			_mastAdapter = new MASTAdapter();
			
			processCondition();
		}

		private function processCondition():void
		{
			// If the condition causes a pending play request, such as OnItemStart,
			// we don't need to set any event listeners, we just need to evaluate
			// the condition and dispatch the CONDITION_TRUE event.
			if (conditionCausesPendingPlayRequest())
			{
				if (this.evaluateChildConditions())
				{
					onConditionTrue();
				}
			}
			else
			{
				// Ask the MASTAdapter class to give us the OSMF trait.property or event.type
				var propOrEventName:String = _mastAdapter.lookup(_condition.name);
				
				if (propOrEventName == null)
				{
					throw new IllegalOperationError(UNKNOWN_TRAIT_OR_EVENT_ERROR);
				}
				
				if (_condition.type == MASTConditionType.EVENT)
				{
					processEventCondition(propOrEventName);
				}
				else // PROPERTY
				{
					processPropertyCondition(propOrEventName);
				}
			}
		}
		
		private function processPropertyCondition(propName:String):void
		{			
			var result:Array = propName.split(/\./);
			var traitName:String = result[0];
			var traitProperty:String = result[1];			 
			
			var traitType:MediaTraitType = getTraitTypeForTraitName(traitName);
			if (traitType == null)
			{
				throw new IllegalOperationError(UNKNOWN_TRAIT_OR_EVENT_ERROR);
			}
			
			listenForTraitProperty(traitType, traitProperty, _condition.value, _condition.operator);			
		}
		
		private function processEventCondition(eventName:String):void
		{					
			// Get the event class name and the event type
			var result:Array = eventName.match(/^(.*\.)(.*)$/);
			var eventClassName:String = result[1];
			var eventType:String = result[2];
			
			// Remove the trailing . from the event class name
			eventClassName = eventClassName.replace(/\.$/, "");
			
			var traitType:MediaTraitType = getTraitTypeForEventName(eventClassName);
			if (traitType == null)
			{
				throw new IllegalOperationError("Unable to map an event condition in the MAST document to a trait that dispatches that event.");
			}
						
			trace("adding a listener for this event: " +eventName);
									
			listenForTraitEvent(traitType, getDefinitionByName(eventClassName), eventType)			
		}
		
		private function conditionCausesPendingPlayRequest():Boolean
		{
			return (_condition.type == MASTConditionType.EVENT && (conditionIsPreRoll() || conditionIsPostRoll(_condition)));
		}
		
		private function conditionIsPreRoll():Boolean
		{
			return ((_condition.name == MASTAdapter.ON_ITEM_START) || (_condition.name == MASTAdapter.ON_PLAY));
		}
		
		public static function conditionIsPostRoll(cond:MASTCondition):Boolean
		{
			return ((cond.name == MASTAdapter.ON_ITEM_END) || (cond.name == MASTAdapter.ON_END) || (cond.name == MASTAdapter.ON_STOP));
		}
		
		
		private function listenForTraitEvent(traitType:MediaTraitType, eventClass:Object, eventType:String):void
		{
			var trait:IMediaTrait = _mediaElement.getTrait(traitType);
			if (trait != null)
			{
				// The trait is present, add the listener.
				trait.addEventListener(eventClass[eventType], evaluateEventCondition, false, 0, true);
				_mediaElement.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
			}
			else
			{
				// The trait is not present, we need to wait until it's added
				// before adding the listener.  (Ideally we would manage the
				// add/remove listeners more cleanly, but for the prototype
				// I'm just adding it as a closure.)
				_mediaElement.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
			}

			function onTraitAdd(event:TraitsChangeEvent):void
			{
				if (event.traitType == traitType)
				{
					_mediaElement.removeEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
					
					listenForTraitEvent(traitType, eventClass, eventType);
				}
			}

			function onTraitRemove(event:TraitsChangeEvent):void
			{
				if (event.traitType == traitType)
				{
					trait.removeEventListener(eventClass[eventType], onConditionTrue);
					_mediaElement.removeEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
					
					_mediaElement.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
				}
			}
		}
				
		private function listenForTraitProperty(traitType:MediaTraitType, propertyName:String, propertyValue:Object, operator:MASTConditionOperator):void
		{
			var trait:IMediaTrait = _mediaElement.getTrait(traitType);
			if (trait != null)
			{
				// The trait is present, add the listener.
				addPropertyListener(_mediaElement, traitType, trait, propertyName, propertyValue, operator);
			}

			// The trait is not present, we need to wait until it's added
			// before adding the listener.  (Ideally we would manage the
			// add/remove listeners more cleanly, but for the prototype
			// I'm just adding it as a closure.)
			_mediaElement.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);

			function onTraitAdd(event:TraitsChangeEvent):void
			{
				_mediaElement.removeEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
				if (event.traitType == traitType)
				{
					listenForTraitProperty(traitType, propertyName, propertyValue, operator);
				}
			}
		}
		
		private function addPropertyListener(mediaElement:MediaElement, traitType:MediaTraitType, trait:IMediaTrait, propertyName:String, propertyValue:Object, operator:MASTConditionOperator):void
		{
			if (isConditionTrue(trait, propertyName, propertyValue, operator) && evaluateChildConditions())
			{
				onConditionTrue();
			}
			else
			{
				var timer:Timer = new Timer(250);
				timer.addEventListener(TimerEvent.TIMER, onPropertyListenerTimer);
				timer.start();
				
				function onPropertyListenerTimer(event:TimerEvent):void
				{
					if (mediaElement.getTrait(traitType) == trait)
					{
						if (isConditionTrue(trait, propertyName, propertyValue, operator) && evaluateChildConditions())
						{
							timer.stop();
							timer.removeEventListener(TimerEvent.TIMER, onPropertyListenerTimer);
							
							onConditionTrue();
						}
					}
					else
					{
						timer.stop();
						timer.removeEventListener(TimerEvent.TIMER, onPropertyListenerTimer);
					}
				}
			}
		}
		
		private function onConditionTrue(event:Event=null):void
		{
			dispatchEvent(new Event(CONDITION_TRUE));
		}
		
		private function evaluateEventCondition(event:TraitEvent):void
		{
			trace("In evaluateEventCondition - event="+ event.toString());
			
			// Now evaluate the condition and all child conditions
			var conditionTrue:Boolean = false;
			
			switch (_condition.name)
			{
				case MASTAdapter.ON_PAUSE:
					{
						var pausedChangeEvent:PausedChangeEvent = event as PausedChangeEvent;
						if (pausedChangeEvent.paused)
						{
							conditionTrue = true;
						}
					}
					break;
				case MASTAdapter.ON_MUTE:
					{
						var mutedChangeEvent:MutedChangeEvent = event as MutedChangeEvent;
						if (mutedChangeEvent.muted)
						{
							conditionTrue = true;
						}
					}
					break;
				case MASTAdapter.ON_VOLUME_CHANGE:
					{
						var volumeChangeEvent:VolumeChangeEvent = event as VolumeChangeEvent;
						if (volumeChangeEvent.newVolume != volumeChangeEvent.oldVolume)
						{
							conditionTrue = true;
						}
					}
					break;
				case MASTAdapter.ON_SEEK:
					{
						var seekingChangeEvent:SeekingChangeEvent = event as SeekingChangeEvent;
						if (seekingChangeEvent.seeking)
						{
							conditionTrue = true;
						}
					}
					break;
			}
			
			if (conditionTrue && evaluateChildConditions())
			{ 
				onConditionTrue();			
			}
		}		
		
		/**
		 * Evaluate child conditions for the MASTCondition
		 * associated with this class. Child conditions are
		 * an implicit boolean 'AND', so all of them must
		 * evaluate to <code>true</code> in order for the parent condition
		 * to evaluate to <code>true</code>.
		 * 
		 * @returns true if all child conditions evaluate to <code>true</code>
		 */
		private function evaluateChildConditions():Boolean
		{
			var evaluation:Boolean = true;
			
			for each (var childCondition:MASTCondition in _condition.childConditions)
			{
				if (childCondition.type == MASTConditionType.EVENT)
				{
					// Event condition types are not allowed as child conditions
					continue;  //$$$todo: throw here?
				}
				
				// If any child conditions evaluate to false, this condition is false
				if (!evaluateChild(childCondition))
				{
					evaluation = false;
					break;
				}
			}
			
			return evaluation;
		}
		
		/**
		 * A recursive function to evaluate a child condition and all of it's children.
		 */
		private function evaluateChild(childCond:MASTCondition):Boolean
		{
			var evaluation:Boolean = false;
			var propertyName:String = _mastAdapter.lookup(childCond.name);
			
			if (propertyName == null)
			{
				throw new IllegalOperationError(UNKNOWN_TRAIT_OR_EVENT_ERROR);
			}

			var result:Array = propertyName.split(/\./);
			var traitName:String = result[0];
			var traitProperty:String = result[1];			 
		
			var traitType:MediaTraitType = getTraitTypeForTraitName(traitName);
			if (traitType == null)
			{
				throw new IllegalOperationError(UNKNOWN_TRAIT_OR_EVENT_ERROR);
			}
			
			// If the trait is null here, we are not going to wait for it, that 
			// should have already happened. If it is not present here, it never
			// will be.
			var trait:IMediaTrait = _mediaElement.getTrait(traitType);
			if (trait != null)
			{
				evaluation = isConditionTrue(trait, traitProperty, childCond.value, childCond.operator);
			}
			
			
			if (evaluation) 
			{
				// Evaluate children
				for each (var cond:MASTCondition in childCond.childConditions)
				{
					evaluation = evaluateChild(cond);
				}
			}
			
            return evaluation;			
		}
		
		private function isConditionTrue(trait:IMediaTrait, propertyName:String, propertyValue:Object, operator:MASTConditionOperator):Boolean
		{
			var property:* = trait[propertyName];
			if (property != undefined)
			{
				switch (operator)
				{
					case MASTConditionOperator.GTR:
						return Number(property) > Number(propertyValue);
					case MASTConditionOperator.LT:
						return Number(property) < Number(propertyValue);
					case MASTConditionOperator.GEQ:
						return Number(property) >= Number(propertyValue);
					case MASTConditionOperator.LEQ:
						return Number(property) <= Number(propertyValue);
					case MASTConditionOperator.MOD:
						return Number(property) % Number(propertyValue) > 0;
					case MASTConditionOperator.EQ:
						return propertyValue == property;
					case MASTConditionOperator.NEQ:
						return propertyValue != property;
					default:
						// TODO
				}
			}
			
			return false;
		}
		
		private function getTraitTypeForTraitName(traitName:String):MediaTraitType
		{
			var traitType:MediaTraitType = null;
			
			switch (traitName)
			{
				case "ITemporal":
					traitType = MediaTraitType.TEMPORAL;
					break;
				case "IPlayable":
					traitType = MediaTraitType.PLAYABLE;
					break;
				case "IPausable":
					traitType = MediaTraitType.PAUSABLE;
					break;
				case "ISpatial":
					traitType = MediaTraitType.SPATIAL;
					break;
			}
			
			return traitType;
		}
		
		private function getTraitTypeForEventName(eventName:String):MediaTraitType
		{
			var traitType:MediaTraitType = null;
			
			// Get the event class name without the package name
			var result:Array = eventName.match(/^(.*\.)(.*)$/);
			var eventClassName:String = result[2];
						
			switch (eventClassName)
			{
				case "PlayingChangeEvent":
					traitType = MediaTraitType.PLAYABLE;
					break;
				case "PausedChangeEvent":
					traitType = MediaTraitType.PAUSABLE;
					break;
				case "MutedChangeEvent":
				case "VolumeChangeEvent":
					traitType = MediaTraitType.AUDIBLE;
					break;
				case "SeekingChangeEvent":
					traitType = MediaTraitType.SEEKABLE;
					break;
				case "TraitEvent":
					traitType = MediaTraitType.TEMPORAL;
					break;
			}
			

			return traitType;
		}		
				
		private var _mediaElement:MediaElement;
		private var _condition:MASTCondition;
		private var _mastAdapter:MASTAdapter;
		
		private static const UNKNOWN_TRAIT_OR_EVENT_ERROR:String = "Unknown trait name or event name in MAST document";
	}
}
