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
	 * A trait that implements the ISeekable interface dispatches
	 * this event when its <code>seeking</code> property has changed.
	 */	
	public class SeekingChangeEvent extends TraitEvent
	{
		/**
		 * The SeekingChangeEvent.SEEKING_CHANGE constant defines the value
		 * of the type property of the event object for a seekingChange
		 * event.
		 * 
		 * @eventType SEEKING_CHANGE  
		 */	
		public static const SEEKING_CHANGE:String = "seekingChange";
		
		/**
		 * 
		 * @param seeking New seeking value.
		 * @param time The seek's target time, in seconds. If <code>seeking</code> is 
		 * <code>false</code>, the <code>time</code> parameter is
		 * the position that the playhead reached as a result of the prior seeking action.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */	
		public function SeekingChangeEvent(seeking:Boolean, time:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_seeking = seeking;
			_time = time;
			
			super(SEEKING_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * New <code>seeking</code> value resulting from this change.
		 */		
		public function get seeking():Boolean
		{
			return _seeking;
		}
		
		/**
		 * The seek's target time in seconds.
		 */		
		public function get time():Number
		{
			return _time;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new SeekingChangeEvent(_seeking,_time,bubbles,cancelable);
		}
		
		// Internals
		//
		
		private var _seeking:Boolean;
		private var _time:Number;
		
	}
}