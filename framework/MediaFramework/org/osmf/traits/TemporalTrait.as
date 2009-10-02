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
	 * Dispatched when the position of the trait has changed to a value
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
		 * Invoking this setter will result in the trait's position
		 * value changing if it differs from position's  current value.
		 * 
		 * @see canProcessPositionChange
		 * @see processPositionChange
		 * @see postProcessPositionChange
		 */		
		final public function set position(value:Number):void
		{
			if (!isNaN(value))
			{
				// Don't ever let the position exceed the duration.
				if (!isNaN(_duration))
				{
					value = Math.min(value,_duration);
				}
				else
				{
					value = 0;
				}
			}
			
			if (_position != value && canProcessPositionChange(value))
			{
				processPositionChange(value);
					
				var oldPosition:Number = _position;
				_position = value;
				
				postProcessPositionChange(oldPosition);
				
				if (position == duration &&	position > 0)
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
				
				// Position cannot exceed duration.
				if (	!isNaN(_position)
					&&  !isNaN(_duration)
					&& _position > _duration
				   )
				{
					position = duration;
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
		public function get position():Number
		{
			return _position;
		}
		
		// Internals
		//
		
		private var _duration:Number;
		private var _position:Number;
		
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
		 * Called before the <code>position</code> property is changed.
		 * *
		 * @param newPosition Proposed new <code>position</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 */		
		protected function canProcessPositionChange(newPosition:Number):Boolean
		{
			return true;
		}

		/**
		 * Called immediately before the <code>position</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 * @param newPosition New <code>position</code> value.
		 */		
		protected function processPositionChange(newPosition:Number):void
		{
		}
		
		/**
		 * Called just after the <code>position</code> property has changed.
		 * @param oldPosition Previous <code>position</code> value.
		 * 
		 */		
		protected function postProcessPositionChange(oldPosition:Number):void
		{
		}
		
		/**
		 * Called when a subclass or a media element that has the temporal trait first detects
		 * that <code>position</code> equals <code>duration</code>.
		 * <p>Not called when both <code>position</code> and <code>duration</code> equal zero.</p>
		 * 
		 * <p>Dispatches the durationReached event.</p>
		 */		
		protected function processDurationReached():void
		{
			dispatchEvent(new TraitEvent(TraitEvent.DURATION_REACHED));
		}
		
	}
}