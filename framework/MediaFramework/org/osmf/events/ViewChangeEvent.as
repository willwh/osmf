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
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * A trait that implements the IViewable interface dispatches
	 * this event when its <code>view</code> property has changed.
	 * 
	 * Additionally, ILayoutTarget implementing classes are expected
	 * to emit a DimensionChangeEvent on their dimensions changing.
	 */	
	public class ViewChangeEvent extends Event
	{
		/**
		 * The ViewChangeEvent.VIEW_CHANGE constant defines the value
		 * of the type property of the event object for a viewChange
		 * event.
		 * 
		 * @eventType PAUSED_CHANGE 
		 */
		public static const VIEW_CHANGE:String = "viewChange";
		
		/**
		 * Constructor.
		 *  
		 * @param oldView Previous view.
		 * @param newView New view.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */		
		public function ViewChangeEvent(oldView:DisplayObject, newView:DisplayObject, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_oldView = oldView;
			_newView = newView;
			
			super(VIEW_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * Old value of <code>view</code> before it was changed.
		 */
		public function get oldView():DisplayObject
		{
			return _oldView;
		}
		
		/**
		 * New value of <code>view</code> resulting from this change.
		 */
		public function get newView():DisplayObject
		{
			return _newView;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new ViewChangeEvent(_oldView,_newView,bubbles,cancelable);
		}
		
		// Internals
		//
		
		private var _oldView:DisplayObject;
		private var _newView:DisplayObject;
	}
}