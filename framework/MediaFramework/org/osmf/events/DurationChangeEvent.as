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
package org.osmf.events
{
	import flash.events.Event;
	
	/**
	 * A trait that implements the ITemporal interface dispatches
	 * this event when its <code>duration</code> property has changed.
	 * 
	 */	
	public class DurationChangeEvent extends TraitEvent
	{
		/**
		 * The DurationChangeEvent.DURATION_CHANGE constant defines the value
		 * of the type property of the event object for a durationChange
		 * event.
		 */		
		public static const DURATION_CHANGE:String = "durationChange";
		
		/**
		 * Constructor.
		 *  
		 * @param oldDuration Previous duration in seconds.
		 * @param newDuration New duration in seconds.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */		
		public function DurationChangeEvent(oldDuration:Number, newDuration:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_oldDuration = oldDuration;
			_newDuration = newDuration;
			
			super(DURATION_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * Old value of <code>duration</code> (in seconds) before it was changed.
		 */		
		public function get oldDuration():Number
		{
			return _oldDuration;
		}
		
		/**
		 * New value of <code>duration</code> (in seconds) resulting from this change.
		 */		
		public function get newDuration():Number
		{
			return _newDuration;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new DurationChangeEvent(_oldDuration,_newDuration,bubbles,cancelable);
		}
		
		// Internals
		//
		
		private var _oldDuration:Number;
		private var _newDuration:Number;
		
	}
}