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
	 * A trait that implements the IBufferable interface dispatches
	 * this event when its <code>bufferTime</code> property has changed.
	 */	
	public class BufferTimeChangeEvent extends TraitEvent
	{
		/**
		 * The BufferTimeChangeEvent.BUFFERING_CHANGE constant defines the value
		 * of the type property of the event object for a bufferTimeChange
		 * event.
		 * 
		 * @eventType BUFFER_TIME_CHANGE
		 **/
		public static const BUFFER_TIME_CHANGE:String = "bufferTimeChange";

		/**
		 * Constructor.
		 * 
		 * @param oldSize Previous buffer time.
		 * @param newSize New buffer time.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 **/
		public function BufferTimeChangeEvent(oldTime:Number,newTime:Number,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_oldTime = oldTime;
			_newTime = newTime;
			
			super(BUFFER_TIME_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * New value of <code>bufferTime</code> resulting from this change.
		 */
		public function get newTime():Number
		{
			return _newTime;
		}
		
		/**
		 * Old value of <code>bufferTime</code> before it was changed.
		 */
		public function get oldTime():Number
		{
			return _oldTime;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new BufferTimeChangeEvent(_oldTime,_newTime,bubbles,cancelable);
		}  
		
		// Internals
		//
		
		private var _oldTime:Number;
		private var _newTime:Number;
	}
}