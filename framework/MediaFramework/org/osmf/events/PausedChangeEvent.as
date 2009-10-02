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
	 * A trait that implements the IPausable interface dispatches
	 * this event when its <code>paused</code> property has changed.
	 */	
	public class PausedChangeEvent extends TraitEvent
	{
		/**
		 * The PausedChangeEvent.PAUSED_CHANGE constant defines the value
		 * of the type property of the event object for a pausedChange
		 * event.
		 * 
		 * @eventType PAUSED_CHANGE 
		 */	
		public static const PAUSED_CHANGE:String = "pausedChange";
		
		/**
		 * Constructor
		 * 
		 * @param paused New paused value.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */	
		public function PausedChangeEvent(paused:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_paused = paused;
			
			super(PAUSED_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * New value of <code>paused</code> resulting from this change.
		 */		
		public function get paused():Boolean
		{
			return _paused;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new PausedChangeEvent(_paused,bubbles,cancelable);
		}
		
		// Internals
		//
		
		private var _paused:Boolean;
		
	}
}