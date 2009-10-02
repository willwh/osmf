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
	 * A trait that implements the IAudible interface dispatches
	 * this event when its <code>muted</code> property has changed.
	 */	
	public class MutedChangeEvent extends TraitEvent
	{
		/**
		 * The MutedChangeEvent.MUTED_CHANGE constant defines the value
		 * of the type property of the event object for a mutedChange
		 * event.
		 * 
		 * @eventType MUTED_CHANGE
		 */
		public static const MUTED_CHANGE:String = "mutedChange";
		
		/**
		 * Constructor
		 *  
		 * @param muted New muted value.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */		
		public function MutedChangeEvent(muted:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_muted = muted;
			
			super(MUTED_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * New <code>muted</code> value resulting from this change. 
		 */		
		public function get muted():Boolean
		{
			return _muted;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new MutedChangeEvent(_muted,bubbles,cancelable);
		}
		
		// Internals
		//
		
		private var _muted:Boolean;
		
	}
}