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
	 * A MediaPlayer dispatches this event
	 * when its <code>currentTime</code> property has changed.
	 * This value is updated at the interval set by 
	 * the MediaPlayer's <code>currentTimeUpdateInterval</code> property.
	 * @see org.osmf.players.MediaPlayer#currentTime
	 */	     
	public class CurrentTimeChangeEvent extends TraitEvent
	{       	
		/**
		 * The CurrentTimeChangeEvent.CURRENT_TIME_CHANGE constant defines the value of the
		 * type property of the event object for a currentTimeChange event. 
		 */	
		public static const CURRENT_TIME_CHANGE:String = "currentTimeChange";
			
		/**
		 * Constructor
		 * 
		 * 
		 * @param newCurrentTime New currentTime value.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */		
		public function CurrentTimeChangeEvent(newCurrentTime:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{			
			_newCurrentTime = newCurrentTime;
			
			super(CURRENT_TIME_CHANGE, bubbles, cancelable);
		}
			
		/**
		 * New value of <code>currentTime</code> resulting from this change. 
		 */		
		public function get newCurrentTime():Number
		{
			return _newCurrentTime;
		}
					
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new CurrentTimeChangeEvent(_newCurrentTime, bubbles, cancelable);
		}
			
		// Internals
		//
				
		private var _newCurrentTime:Number;		    
	}
}
		
