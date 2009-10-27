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
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.PausedChangeEvent;
	import org.osmf.events.PlayingChangeEvent;
	import org.osmf.events.SeekingChangeEvent;
	import org.osmf.events.TraitsChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.IPausable;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.ISeekable;
	import org.osmf.traits.ITemporal;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.MediaFrameworkStrings;
	import org.osmf.utils.URL;
	
	[Event (name="positionReached", type="org.osmf.metadata.TemporalFacetEvent")]
	[Event (name="durationReached", type="org.osmf.metadata.TemporalFacetEvent")]

	/**
	 * The TemporalFacet class represents temporal metadata.
	 */
	public class TemporalFacet extends EventDispatcher implements IFacet
	{
		/**
		 * Constructor.
		 * 
		 * @param nameSpace The namespace of the facet.
		 * @param owner The media element this facet applies to.
		 */
		public function TemporalFacet(nameSpace:URL, owner:MediaElement)
		{
			_namespace = nameSpace;

			if (owner == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.NULL_PARAM);
			}

			_owner = owner;	
			_enabled = true;
			_checkInterval = _DEFAULT_INTERVAL_;
			
			_intervalTimer = new Timer(_checkInterval);
			
			_intervalTimer.addEventListener(TimerEvent.TIMER, onIntervalTimer);
			_tolerance = (_checkInterval*5) / 1000;
			
			_temporal = owner.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			
			_seekable = owner.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			setupTraitEventListener(MediaTraitType.SEEKABLE);
			
			_playable = owner.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			setupTraitEventListener(MediaTraitType.PLAYABLE);
			
			_pausable = owner.getTrait(MediaTraitType.PAUSABLE) as IPausable;
			setupTraitEventListener(MediaTraitType.PAUSABLE);
			
			owner.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
			owner.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get namespaceURL():URL
		{
			return _namespace;
		}
		
		/**
		 * Enables/disables this facet (enabled by default). If enabled, the class
		 * will dispatch events of type TemporalFacetEvent. Setting
		 * this property to <code>false</code> will cause the class to stop
		 * dispatching events.
		 */
		public function set enable(value:Boolean):void 
		{
			_enabled = value;
			reset(value);
		}
		
		/**
		 * Adds temporal metadata to this facet.
		 */
		public function addValue(value:TemporalIdentifier):void
		{
			if (value == null ||value.time < 0)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			if (this._temporalValueCollection == null)
			{
				this._temporalValueCollection = new Vector.<TemporalIdentifier>();
				this._temporalValueCollection.push(value);
			}
			else
			{
				// Find the index where we should insert this value
				var index:int = findTemporalMetadata(0, _temporalValueCollection.length - 1, value.time);
				
				// A negative index value means it doesn't exist in the array and the absolute value is the
				// index where it should be inserted.  A positive index means a value exists and in this
				// case we will overwrite the existing cue point rather than insert a duplicate.
				if (index < 0) 
				{
					index *= -1;
					_temporalValueCollection.splice(index, 0, value);
				}
				
				// Make sure we don't insert a dup at index 0
				else if ((index == 0) && (value.time != _temporalValueCollection[0].time)) 
				{
					_temporalValueCollection.splice(index, 0, value);
				}
				else 
				{
					_temporalValueCollection[index] = value;
				}
			}
			
			this.enable = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getValue(identifier:IIdentifier):*
		{
			if (identifier is TemporalIdentifier)
			{
				for each(var temporalMetadata:TemporalIdentifier in _temporalValueCollection)
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
		 */
		public function get numValues():int
		{
			return _temporalValueCollection.length;
		}
		
		/**
		 * Gets the TemporalIdentifier item at the specified index in this
		 * class' internal collection. Note this collection is sorted by time.
		 *  
		 * @param index The index in the collection from which to retrieve the TemporalIdentifier item.
		 * 
		 * @return The TemporalIdentifier item at that index or <code>null</code> if there is none.
		 */
		public function getValueAt(index:int):TemporalIdentifier
		{
			if (index >= 0 && _temporalValueCollection != null && index < _temporalValueCollection.length)
			{
				return _temporalValueCollection[index];
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * @private
		 */
		public function merge(childFacet:IFacet):IFacet
		{
			return null;
		}
		
		/**
		 * Starts / stops the interval timer.
		 */
		private function startTimer(start:Boolean=true):void
		{
			if (!start)
			{
				_intervalTimer.stop();
			}
			else if (_temporal != null && _temporalValueCollection != null && _temporalValueCollection.length > 0 
						&& _restartTimer && _enabled && !_intervalTimer.running) 
			{
				_intervalTimer.start();
			}
		}
						
		/**
		 * Perform a reset on the class' internal data.
		 */
		private function reset(startTimer:Boolean):void 
		{
			_lastFiredTemporalMetadataIndex = -1;
			_restartTimer = true;
			_intervalTimer.reset();
			_intervalTimer.delay = _checkInterval;
			
			if (startTimer)
			{
				this.startTimer();
			}
		}
		
		/**
		 * The interval timer callback. Checks for temporal metadata 
		 * around the current ITemporal.position and dispatches a TemporalFacetEvent
		 * if found. 
		 */
   		private function checkForTemporalMetadata(e:TimerEvent):void 
   		{
			var now:Number = _temporal.position;
			
			// Start looking one index past the last one we found
			var index:int = findTemporalMetadata(_lastFiredTemporalMetadataIndex + 1, _temporalValueCollection.length - 1, now);
			
			// A negative index value means it doesn't exist in the collection and the absolute value is the
			// index where it should be inserted.  Therefore, to get the closest match, we'll look at the index
			// before this one.  A positive index means an exact match was found.
			if (index <= 0) 
			{
				index *= -1;
				index = (index > 0) ? (index - 1) : 0;
			}
			
			// See if the value at this index is within our tolerance
			if ( !checkTemporalMetadata(index, now) && ((index + 1) < _temporalValueCollection.length)) 
			{
				// Look at the next one, see if it is close enough to fire
				checkTemporalMetadata(index+1, now);
			}
   		}
   		
   		private function setupTraitEventListener(traitType:MediaTraitType, add:Boolean=true):void
   		{
   			if (add)
   			{
	   			if (traitType == MediaTraitType.SEEKABLE && _seekable != null)
	   			{
					_seekable.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeekingChange);
	   			}
	   			
	   			else if (traitType == MediaTraitType.PAUSABLE && _pausable != null)
	   			{
	   				_pausable.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChange);
	   			}
	   			
	   			else if (traitType == MediaTraitType.PLAYABLE && _playable != null)
	   			{
	   				_playable.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChange);
	   			}
	   		}
	   		else
	   		{
	   			if (traitType == MediaTraitType.SEEKABLE && _seekable != null)
	   			{
					_seekable.removeEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeekingChange);
	   			}
	   			
	   			else if (traitType == MediaTraitType.PAUSABLE && _pausable != null)
	   			{
	   				_pausable.removeEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChange);
	   			}

	   			else if (traitType == MediaTraitType.PLAYABLE && _playable != null)
	   			{
	   				_playable.removeEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChange);
	   			}
	   			
	   		}
   		}
   		
   		private function onSeekingChange(event:SeekingChangeEvent):void
   		{
   			if (event.seeking)
   			{
   				reset(true);
   			}
   		}
   		
   		private function onPausedChange(event:PausedChangeEvent):void
   		{
   			if (event.paused)
   			{
   				startTimer(false);
   			}
   		}
   		
   		private function onPlayingChange(event:PlayingChangeEvent):void
   		{
   			if (event.playing)
   			{
   				startTimer();
   			}	
   		}
   		
		/**
		 * Returns the index of the temporal metadata object matching the time. If no match is found, returns
		 * the index where the value should be inserted as a negative number.
		 */
		private function findTemporalMetadata(firstIndex:int, lastIndex:int, time:Number):int 
		{
			if (firstIndex <= lastIndex) 
			{
				var mid:int = (firstIndex + lastIndex) / 2;	// divide and conquer
				if (time == _temporalValueCollection[mid].time) 
				{
					return mid;
				}
				else if (time < _temporalValueCollection[mid].time) 
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
		 */
		private function dispatchTemporalEvents(index:int):void
		{
			var valueObj:TemporalIdentifier = _temporalValueCollection[index];
			dispatchEvent(new TemporalFacetEvent(TemporalFacetEvent.POSITION_REACHED, valueObj));
			
			if (valueObj.duration > 0)
			{
				var timer:Timer = new Timer(valueObj.duration*1000, 1);
				timer.addEventListener(TimerEvent.TIMER, onDurationTimer);
				timer.start();
				
				function onDurationTimer(event:TimerEvent):void
				{
					timer.removeEventListener(TimerEvent.TIMER, onDurationTimer);
					dispatchEvent(new TemporalFacetEvent(TemporalFacetEvent.DURATION_REACHED, valueObj));
				}
			}
		}
		
   		/**
   		 * Checks the item at the index passed in with the time passed in.
   		 * If the item time is within the class' tolerance, a 
   		 * TemporalFacetEvent is dispatched.
   		 * 
   		 * Returns True if a match was found, otherwise False.
   		 */
   		private function checkTemporalMetadata(index:int, now:Number):Boolean 
   		{ 		
			if (!_temporalValueCollection || !_temporalValueCollection.length) 
			{
				return false;
			}
			
			var nextTime:Number = _temporalValueCollection[((index + 1) < _temporalValueCollection.length) ? (index + 1) : 
																				(_temporalValueCollection.length - 1)].time;
		
			if ( (_temporalValueCollection[index].time >= (now - _tolerance)) && 
					(_temporalValueCollection[index].time <= (now + _tolerance)) && 
					(index != _lastFiredTemporalMetadataIndex)) 
			{
				_lastFiredTemporalMetadataIndex = index;
				
				dispatchTemporalEvents(index);
				
				// Adjust the timer interval if necessary
				var thisTime:Number = _temporalValueCollection[index].time;
				var newDelay:Number = ((nextTime - thisTime)*1000)/4;
				newDelay = (newDelay > _checkInterval) ? newDelay : _checkInterval;
								
				// If no more data, stop the timer
				if (thisTime == nextTime) 
				{
					startTimer(false);
					_restartTimer = false;
				}
				else if (newDelay != _intervalTimer.delay) 
				{
					_intervalTimer.reset();
					_intervalTimer.delay = newDelay;
					startTimer();
				}
				return true;
			}
			
			// If we've optimized the interval time by reseting the delay, we could miss a data point
			//    if it happens to fall between this check and next one.
			// See if we are going to miss a data point (meaning there is one between now and the 
			//    next interval timer event).  If so, drop back down to the default check interval.
			if ((_intervalTimer.delay != _checkInterval) && ((now + (_intervalTimer.delay/1000)) > nextTime)) 
			{
				this._intervalTimer.reset();
				this._intervalTimer.delay = _checkInterval;
				startTimer();
			}
			return false;				
   		}		

		/**
		 * The interval timer event handler.
		 */
		private function onIntervalTimer(event:TimerEvent):void 
		{
			checkForTemporalMetadata(event);
		}
		
		/**
		 * Called when traits are added to the owner media element.
		 */
		private function onTraitAdd(event:TraitsChangeEvent):void
		{
			switch (event.traitType)
			{
				case MediaTraitType.TEMPORAL:
					_temporal = _owner.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
					break;
				case MediaTraitType.SEEKABLE:
					_seekable = _owner.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
					break;
				case MediaTraitType.PAUSABLE:
					_pausable = _owner.getTrait(MediaTraitType.PAUSABLE) as IPausable;
					break;
				case MediaTraitType.PLAYABLE:
					_playable = _owner.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
					break;
			}
			
			setupTraitEventListener(event.traitType);
		}
		
		/**
		 * Called when traits are removed from the owner media element.
		 */
		private function onTraitRemove(event:TraitsChangeEvent):void
		{
			switch (event.traitType)
			{
				case MediaTraitType.TEMPORAL:
					_temporal = null;
					startTimer(false);
					break;
				case MediaTraitType.SEEKABLE:
					_seekable = null;
					break;
				case MediaTraitType.PAUSABLE:
					_pausable = null;
					break;
				case MediaTraitType.PLAYABLE:
					_playable = null;
					break;
			}
			
			setupTraitEventListener(event.traitType, false);
		}
			
		private static const _DEFAULT_INTERVAL_:Number = 100;	// The default interval (in milliseconds) at which 
																// the class will check for cue points
		private var _namespace:URL;				
		private var _temporalValueCollection:Vector.<TemporalIdentifier>;
		private var _owner:MediaElement;
		private var _temporal:ITemporal;
		private var _seekable:ISeekable;
		private var _pausable:IPausable;
		private var _playable:IPlayable;
		private var _tolerance:Number;
		private var _lastFiredTemporalMetadataIndex:int;
		private var _intervalTimer:Timer;
		private var _checkInterval:Number;		
		private var _restartTimer:Boolean;
		private var _enabled:Boolean;

	}
}
