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
	import org.openvideoplayer.traits.MediaTraitType;
	
	import org.openvideoplayer.mast.adapter.MASTAdapter;
	import org.openvideoplayer.mast.model.MASTCondition;
	import org.openvideoplayer.mast.types.MASTConditionOperator;
	import org.openvideoplayer.mast.types.MASTConditionType;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	
	public class MASTConditionManager extends EventDispatcher
	{
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
			// Ask the MASTAdapter class to give us the OSMF trait.property or event.type
			var propOrEventName:String = _mastAdapter.lookup(_condition.name);
			
			if (propOrEventName == null)
			{
				throw new IllegalOperationError("Unknown trait name or event name in MAST document");
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
		
		private function processPropertyCondition(propName:String):void
		{			
			var result:Array = propName.split(/\./);
			var traitName:String = result[0];
			var traitProperty:String = result[1];			 
			
			var traitType:MediaTraitType = getTraitTypeForTraitName(traitName);
			if (traitType == null)
			{
				throw new IllegalOperationError("Unknown trait name in MAST document");
			}
			
			listenForTraitProperty(traitType, traitProperty, _condition.value, _condition.operator);			
		}
		
		private function processEventCondition(eventName:String):void
		{		
			trace("adding a listener for this event: " +eventName);
			
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
									
			listenForTraitEvent(traitType, getDefinitionByName(eventClassName), eventType)			
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
			if (isConditionTrue(trait, propertyName, propertyValue, operator))
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
						if (isConditionTrue(trait, propertyName, propertyValue, operator))
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
			dispatchEvent(new Event("conditionTrue"));
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
			
			if (conditionTrue)
			{ 
				onConditionTrue(null);			
			}
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
	}
}