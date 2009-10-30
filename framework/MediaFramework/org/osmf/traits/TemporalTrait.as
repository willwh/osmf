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
package org.osmf.traits
{
	import org.osmf.events.DurationChangeEvent;
	import org.osmf.events.TraitEvent;

	/**
	 * Dispatched when the duration of the trait changed.
	 * 
	 * @eventType org.osmf.events.DurationChangeEvent.DURATION_CHANGE
	 */
	[Event(name="durationChange", type="org.osmf.events.DurationChangeEvent")]
	
	/**
	 * Dispatched when the currentTime of the trait has changed to a value
	 * equal to its duration.
	 * 
	 * @eventType org.osmf.events.TraitEvent.DURATION_REACHED
	 */
	[Event(name="durationReached",type="org.osmf.events.TraitEvent")]
	
	/**
	 * The TemporalTrait class provides a base ITemporal implementation. 
	 * It can be used as the base class for a more specific temporal trait	
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 */	
	public class TemporalTrait extends MediaTraitBase implements ITemporal
	{
		// Public interface
		//
		
		/**
		 * Invoking this setter will result in the trait's currentTime
		 * value changing if it differs from currentTime's current value.
		 * 
		 * @see canProcessCurrentTimeChange
		 * @see processCurrentTimeChange
		 * @see postProcessCurrentTimeChange
		 */		
		final public function set currentTime(value:Number):void
		{
			if (!isNaN(value))
			{
				// Don't ever let the currentTime exceed the duration.
				if (!isNaN(_duration))
				{
					value = Math.min(value, _duration);
				}
				else
				{
					value = 0;
				}
			}
			
			if (_currentTime != value && canProcessCurrentTimeChange(value))
			{
				processCurrentTimeChange(value);
					
				var oldCurrentTime:Number = _currentTime;
				_currentTime = value;
				
				postProcessCurrentTimeChange(oldCurrentTime);
				
				if (currentTime == duration && currentTime > 0)
				{
					processDurationReached();
				} 
			}
		}
		
		/**
		 * Invoking this setter will result in the trait's duration
		 * value changing if it differs from duration's current value.
		 * 
		 * @see canProcessDurationChange
		 * @see processDurationChange
		 * @see postProcessDurationChange
		 */		
		final public function set duration(value:Number):void
		{
			if (_duration != value && canProcessDurationChange(value))
			{
				processDurationChange(value);
			
				var oldDuration:Number = _duration;
				_duration = value;
				
				postProcessDurationChange(oldDuration);
				
				// Current time cannot exceed duration.
				if (	!isNaN(_currentTime)
					&&  !isNaN(_duration)
					&& _currentTime > _duration
				   )
				{
					currentTime = duration;
				}
			}
		}
		
		// ITemporal
		//
		
		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return _duration;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get currentTime():Number
		{
			return _currentTime;
		}
		
		// Internals
		//
		
		private var _duration:Number;
		private var _currentTime:Number;
		
		/**
		 * Called before the <code>duration</code> property is changed.
		 *  
		 * @param newDuration Proposed new <code>duration</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 */		
		protected function canProcessDurationChange(newDuration:Number):Boolean
		{
			return true;
		}

		/**
		 * Called immediately before the <code>duration</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *  
		 * @param newDuration New <code>duration</code> value.
		 */		
		protected function processDurationChange(newDuration:Number):void
		{
		}
		
		/**
		 * Called just after the <code>duration</code> property has changed.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method to
		 * dispatch the durationChange event.</p>
		 *  
		 * @param oldDuration Previous <code>duration</code> value.
		 * 
		 */		
		protected function postProcessDurationChange(oldDuration:Number):void
		{
			dispatchEvent(new DurationChangeEvent(oldDuration,_duration));
		}
		
		/**
		 * Called before the <code>currentTime</code> property is changed.
		 * *
		 * @param newCurrentTime Proposed new <code>currentTime</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 */		
		protected function canProcessCurrentTimeChange(newCurrentTime:Number):Boolean
		{
			return true;
		}

		/**
		 * Called immediately before the <code>currentTime</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 * @param newCurrentTime New <code>currentTime</code> value.
		 */		
		protected function processCurrentTimeChange(newCurrentTime:Number):void
		{
		}
		
		/**
		 * Called just after the <code>currentTime</code> property has changed.
		 * @param oldCurrentTime Previous <code>currentTime</code> value.
		 * 
		 */		
		protected function postProcessCurrentTimeChange(oldCurrentTime:Number):void
		{
		}
		
		/**
		 * Called when a subclass or a media element that has the temporal trait first detects
		 * that <code>currentTime</code> equals <code>duration</code>.
		 * <p>Not called when both <code>currentTime</code> and <code>duration</code> equal zero.</p>
		 * 
		 * <p>Dispatches the durationReached event.</p>
		 */		
		protected function processDurationReached():void
		{
			dispatchEvent(new TraitEvent(TraitEvent.DURATION_REACHED));
		}
	}
}