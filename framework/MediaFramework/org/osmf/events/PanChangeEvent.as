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
	 * this event when its <code>pan</code> property has changed.
	 */	
	public class PanChangeEvent extends TraitEvent
	{
		/**
		 * The PanChangeEvent.PAN_CHANGE constant defines the value
		 * of the type property of the event object for a panChange
		 * event.
		 * 
		 * @eventType PAN_CHANGE 
		 */	
		public static const PAN_CHANGE:String = "panChange";
		
		/**
		 * Constructor.
		 *  
		 * @param oldPan Previous pan value.
		 * @param newPan New pan value.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */		
		public function PanChangeEvent(oldPan:Number, newPan:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_oldPan = oldPan;
			_newPan = newPan;
			
			super(PAN_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * Old value of <code>pan</code> before it was changed.
		 */		
		public function get oldPan():Number
		{
			return _oldPan;
		}
		
		/**
		 * New value of <code>pan</code> resulting from this change.
		 */		
		public function get newPan():Number
		{
			return _newPan;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new PanChangeEvent(_oldPan,_newPan,bubbles,cancelable);
		}
		
		// Internals
		//
		
		private var _oldPan:Number;
		private var _newPan:Number;
		
	}
}