/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.metadata
{
	import __AS3__.vec.Vector;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.osmf.elements.CompositeElement;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	import org.osmf.utils.OSMFStrings;
	
	[Event (name="positionReached", type="org.osmf.metadata.TemporalFacetEvent")]
	[Event (name="durationReached", type="org.osmf.metadata.TemporalFacetEvent")]

	/**
	 * The TemporalFacet class manages temporal metadata of the type
	 * <code>TemporalIdentifier</code> associated with a <code>MediaElement</code> 
	 * and dispatches events of type <code>TemporalFacetEvent</code> when 
	 * the TimeTrait position of the MediaElement matches any of the
	 * time values in it's collection of <code>TemporalIdentifer</code> objects. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class TemporalFacet extends Facet
	{
		/**
		 * Constructor.
		 * 
		 * @param namespaceURL The namespace of the facet.
		 * @param owner The media element this facet applies to.
		 * 
		 * @throws ArgumentError If owner argument is null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function TemporalFacet(namespaceURL:String, owner:MediaElement)
		{
			super(namespaceURL);

			if (owner == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}

			this.owner = owner;	
			enabled = true;
			
			intervalTimer = new Timer(CHECK_INTERVAL);
			intervalTimer.addEventListener(TimerEvent.TIMER, onIntervalTimer);
			
			// Check the owner media element for traits, if they are null here
			// 	that's okay we'll manage them in the event handlers.
			timeTrait = owner.getTrait(MediaTraitType.TIME) as TimeTrait;
			
			seekTrait = owner.getTrait(MediaTraitType.SEEK) as SeekTrait;
			setupTraitEventListener(MediaTraitType.SEEK);
			
			playTrait = owner.getTrait(MediaTraitType.PLAY) as PlayTrait;
			setupTraitEventListener(MediaTraitType.PLAY);
			
			owner.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
			owner.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
		}
		
		/**
		 * Enables/disables this facet (enabled by default). If enabled, the class
		 * will dispatch events of type TemporalFacetEvent. Setting
		 * this property to <code>false</code> will cause the class to stop
		 * dispatching events.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set enable(value:Boolean):void 
		{
			enabled = value;
			reset(value);
		}
		
		/**
		 * Adds temporal metadata to this facet.
		 * 
		 * @param value A <code>TemporalIdentifier</code> instance to
		 * be added to the class' internal collection.
		 * 
		 * @throws ArgumentError If value is null or the time in the value 
		 * object is less than zero.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function addValue(value:TemporalIdentifier):void
		{
			if (value == null || value.time < 0)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			if (temporalValueCollection == null)
			{
				temporalValueCollection = new Vector.<TemporalIdentifier>();
				temporalValueCollection.push(value);
			}
			else
			{
				// Find the index where we should insert this value
				var index:int = findTemporalMetadata(0, temporalValueCollection.length - 1, value.time);
				
				// A negative index value means it doesn't exist in the array and the absolute value is the
				// index where it should be inserted.  A positive index means a value exists and in this
				// case we'll overwrite the existing value rather than insert a duplicate.
				if (index < 0) 
				{
					index *= -1;
					temporalValueCollection.splice(index, 0, value);
				}
				
				// Make sure we don't insert a dup at index 0
				else if ((index == 0) && (value.time != temporalValueCollection[0].time)) 
				{
					temporalValueCollection.splice(index, 0, value);
				}
				else 
				{
					temporalValueCollection[index] = value;
				}
			}
			
			enable = true;
		}
		
		/**
		 * @private
		 */
		override public function getValue(identifier:IIdentifier):*
		{
			if (identifier is TemporalIdentifier)
			{
				for each (var temporalMetadata:TemporalIdentifier in temporalValueCollection)
				{
					if (temporalMetadata.equals(identifier))
					{
						return temporalMetadata;
					}
				}
			}
			
			return null;
		}
		
		/**
		 * The number of TemporalIdentifer values in this class' collection.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get numValues():int
		{
			return temporalValueCollection.length;
		}
		
		/**
		 * Gets the TemporalIdentifier item at the specified index in this
		 * class' internal collection. Note this collection is sorted by time.
		 *  
		 * @param index The index in the collection from which to retrieve 
		 * the TemporalIdentifier item.
		 * 
		 * @return The TemporalIdentifier item at the specified index or 
		 * <code>null</code> if there is none.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function getValueAt(index:int):TemporalIdentifier
		{
			if (index >= 0 && temporalValueCollection != null && index < temporalValueCollection.length)
			{
				return temporalValueCollection[index];
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * Starts / stops the interval timer.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function startTimer(start:Boolean=true):void
		{
			if (!start)
			{
				intervalTimer.stop();
			}
			else if (	timeTrait != null
					 && temporalValueCollection != null
					 && temporalValueCollection.length > 0 
					 && restartTimer
					 && enabled
					 && !intervalTimer.running
					) 
			{
				// If there is a PlayTrait and the media isn't playing, there is no reason to 
				// start the timer.
				if (playTrait != null && playTrait.playState == PlayState.PLAYING)
				{
					intervalTimer.start();
				}
			}
		}
						
		/**
		 * Perform a reset on the class' internal state.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function reset(startTimer:Boolean):void 
		{
			lastFiredTemporalMetadataIndex = -1;
			restartTimer = true;
			intervalTimer.reset();
			intervalTimer.delay = CHECK_INTERVAL;
			
			if (startTimer)
			{
				this.startTimer();
			}
		}
		
		/**
		 * The interval timer callback. Checks for temporal metadata 
		 * around the current TimeTrait.position and dispatches a TemporalFacetEvent
		 * if found. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
   		private function checkForTemporalMetadata():void 
   		{
			var now:Number = timeTrait.currentTime;
			
			// Start looking one index past the last one we found
			var index:int = findTemporalMetadata(lastFiredTemporalMetadataIndex + 1, temporalValueCollection.length - 1, now);
			
			// A negative index value means it doesn't exist in the collection and the absolute value is the
			// index where it should be inserted.  Therefore, to get the closest match, we'll look at the index
			// before this one.  A positive index means an exact match was found.
			if (index <= 0) 
			{
				index *= -1;
				index = (index > 0) ? (index - 1) : 0;
			}
			
			// See if the value at this index is within our tolerance
			if (!checkTemporalMetadata(index, now) && ((index + 1) < temporalValueCollection.length)) 
			{
				// Look at the next one, see if it is close enough to fire
				checkTemporalMetadata(index+1, now);
			}
   		}
   		
   		private function setupTraitEventListener(traitType:String, add:Boolean=true):void
   		{
   			if (add)
   			{
	   			if (traitType == MediaTraitType.SEEK && seekTrait != null)
	   			{
					seekTrait.addEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
	   			}
	   			
	   			else if (traitType == MediaTraitType.PLAY && playTrait != null)
	   			{
	   				playTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
	   				
	   				// We need to check the playing state, if the media is already playing, we won't 
	   				// get the play state change event and the interval timer will never start.
	   				if (playTrait.playState == PlayState.PLAYING)
	   				{
	   					var event:PlayEvent = new PlayEvent(PlayEvent.PLAY_STATE_CHANGE, false, false, PlayState.PLAYING);
	   					onPlayStateChange(event);
	   				}
	   			}
	   		}
	   		else
	   		{
	   			if (traitType == MediaTraitType.SEEK && seekTrait != null)
	   			{
					seekTrait.removeEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
	   			}
	   			
	   			else if (traitType == MediaTraitType.PLAY && playTrait != null)
	   			{
	   				playTrait.removeEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
	   			}
	   		}
   		}
   		
   		private function onSeekingChange(event:SeekEvent):void
   		{
   			if (event.seeking)
   			{
   				reset(true);
   			}
   		}
   		
   		private function onPlayStateChange(event:PlayEvent):void
   		{
   			var timer:Timer;
   			if (event.playState == PlayState.PLAYING)
   			{
   				// Start any duration timers.
   				if (durationTimers != null)
   				{
   					for each (timer in durationTimers)
   					{
   						timer.start();
   					}
   				}
   				startTimer();
   			}
   			else
   			{
  				// Pause any duration timers.
   				if (durationTimers != null)
   				{
   					for each (timer in durationTimers)
   					{
   						timer.stop();
   					}
   				}
 
   				startTimer(false);
   			}
   		}
   		
		/**
		 * Returns the index of the temporal metadata object matching the time. If no match is found, returns
		 * the index where the value should be inserted as a negative number.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function findTemporalMetadata(firstIndex:int, lastIndex:int, time:Number):int 
		{
			if (firstIndex <= lastIndex) 
			{
				var mid:int = (firstIndex + lastIndex) / 2;	// divide and conquer
				if (time == temporalValueCollection[mid].time) 
				{
					return mid;
				}
				else if (time < temporalValueCollection[mid].time) 
				{
					// search the lower part
					return findTemporalMetadata(firstIndex, mid - 1, time);
				}
				else 
				{
					// search the upper part
					return findTemporalMetadata(mid + 1, lastIndex, time);
				}
			}
			return -(firstIndex);
		}   		
		
		/**
		 * Dispatch the events for this temporal value. If there is a duration
		 * property on the value, dispatch a duration reached event after the 
		 * proper amount of time has passed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function dispatchTemporalEvents(index:int):void
		{
			var valueObj:TemporalIdentifier = temporalValueCollection[index];
			dispatchEvent(new TemporalFacetEvent(TemporalFacetEvent.POSITION_REACHED, valueObj));
			
			if (valueObj.duration > 0)
			{
				var timer:Timer = new Timer(CHECK_INTERVAL);
				var endTime:Number = valueObj.time + valueObj.duration;
				
				// Add it to the dictionary of duration timers so we can pause it 
				// if the media pauses
				if (durationTimers == null)
				{
					durationTimers = new Dictionary();
				}
				durationTimers[valueObj] = timer;

				timer.addEventListener(TimerEvent.TIMER, onDurationTimer);
				timer.start();
				
				function onDurationTimer(event:TimerEvent):void
				{
					if (timeTrait && timeTrait.currentTime >= endTime)
					{
						timer.removeEventListener(TimerEvent.TIMER, onDurationTimer);
						delete durationTimers[valueObj];
						dispatchEvent(new TemporalFacetEvent(TemporalFacetEvent.DURATION_REACHED, valueObj));
					}
				}
			}
		}
		
   		/**
   		 * Checks the item at the index passed in with the time passed in.
   		 * If the item time is within the class' tolerance, a 
   		 * TemporalFacetEvent is dispatched.
   		 * 
   		 * Returns True if a match was found, otherwise False.
   		 *  
   		 *  @langversion 3.0
   		 *  @playerversion Flash 10
   		 *  @playerversion AIR 1.5
   		 *  @productversion OSMF 1.0
   		 */
   		private function checkTemporalMetadata(index:int, now:Number):Boolean 
   		{ 		
			if (!temporalValueCollection || !temporalValueCollection.length) 
			{
				return false;
			}
			
			// Get the next time value after this one so we can decide to adjust the timer interval
			var nextTime:Number = temporalValueCollection[((index + 1) < temporalValueCollection.length) ? (index + 1) : 
																				(temporalValueCollection.length - 1)].time;
			var result:Boolean = false;																				
		
			if ( (temporalValueCollection[index].time >= (now - TOLERANCE)) && 
					(temporalValueCollection[index].time <= (now + TOLERANCE)) && 
					(index != lastFiredTemporalMetadataIndex)) 
			{
				lastFiredTemporalMetadataIndex = index;
				
				dispatchTemporalEvents(index);
				
				// Adjust the timer interval if necessary
				var thisTime:Number = temporalValueCollection[index].time;
				var newDelay:Number = ((nextTime - thisTime)*1000)/4;
				newDelay = (newDelay > CHECK_INTERVAL) ? newDelay : CHECK_INTERVAL;
								
				// If no more data, stop the timer
				if (thisTime == nextTime) 
				{
					startTimer(false);
					restartTimer = false;
				}
				else if (newDelay != intervalTimer.delay) 
				{
					intervalTimer.reset();
					intervalTimer.delay = newDelay;
					startTimer();
				}
				result = true;
			}
			
			// If we've optimized the interval time by reseting the delay, we could miss a data point
			//    if it happens to fall between this check and next one.
			// See if we are going to miss a data point (meaning there is one between now and the 
			//    next interval timer event).  If so, drop back down to the default check interval.
			else if ((intervalTimer.delay != CHECK_INTERVAL) && ((now + (intervalTimer.delay/1000)) > nextTime)) 
			{
				this.intervalTimer.reset();
				this.intervalTimer.delay = CHECK_INTERVAL;
				startTimer();
			}
			return result;				
   		}		

		/**
		 * The interval timer event handler.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function onIntervalTimer(event:TimerEvent):void 
		{
			checkForTemporalMetadata();
		}
		
		/**
		 * Called when traits are added to the owner media element.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function onTraitAdd(event:MediaElementEvent):void
		{
			switch (event.traitType)
			{
				case MediaTraitType.TIME:
					timeTrait = owner.getTrait(MediaTraitType.TIME) as TimeTrait;
					startTimer();
					break;
				case MediaTraitType.SEEK:
					seekTrait = owner.getTrait(MediaTraitType.SEEK) as SeekTrait;
					break;
				case MediaTraitType.PLAY:
					playTrait = owner.getTrait(MediaTraitType.PLAY) as PlayTrait;
					break;
			}
			
			setupTraitEventListener(event.traitType);
		}
		
		/**
		 * Called when traits are removed from the owner media element.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function onTraitRemove(event:MediaElementEvent):void
		{
			// Remove any event listeners
			setupTraitEventListener(event.traitType, false);

			switch (event.traitType)
			{
				case MediaTraitType.TIME:
					timeTrait = null;
					// This is a work around for FM-171. Traits are added and removed for
					// each child in a composition element when transitioning between child
					// elements. So don't stop the timer if the owner is a composition.
					//
					// $$$todo: remove this 'if' statement and the import for
					// 'org.osmf.composition.CompositeElement' when FM-171 is fixed.
					if (!(owner is CompositeElement))
					{
						startTimer(false);
					}
					break;
				case MediaTraitType.SEEK:
					seekTrait = null;
					break;
				case MediaTraitType.PLAY:
					playTrait = null;
					break;
			}
		}
			
		private static const CHECK_INTERVAL:Number = 100;	// The default interval (in milliseconds) the 
															// class will check for temporal metadata
		private static const TOLERANCE:Number = 0.25;	// A value must be within this tolerence to trigger
														//	a position reached event.				
		private var temporalValueCollection:Vector.<TemporalIdentifier>;
		private var owner:MediaElement;
		private var timeTrait:TimeTrait;
		private var seekTrait:SeekTrait;
		private var playTrait:PlayTrait;
		private var lastFiredTemporalMetadataIndex:int;
		private var intervalTimer:Timer;
		private var restartTimer:Boolean;
		private var enabled:Boolean;
		private var durationTimers:Dictionary;
	}
}
