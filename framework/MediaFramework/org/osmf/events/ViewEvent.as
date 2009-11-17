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
	 * A  ViewEvent is dispatched when the properties of an IViewable trait change.
	 */	
	public class ViewEvent extends Event
	{
		/**
		 * The ViewEvent.VIEW_CHANGE constant defines the value
		 * of the type property of the event object for a viewChange
		 * event.
		 * 
		 * @eventType VIEW_CHANGE 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const VIEW_CHANGE:String = "viewChange";
		
		/**
		 * Constructor.
		 *  
		 * @param type Event type.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 * @param oldView Previous view.
		 * @param newView New view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function ViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, oldView:DisplayObject=null, newView:DisplayObject=null)
		{
			super(type, bubbles, cancelable);

			_oldView = oldView;
			_newView = newView;
		}
		
		/**
		 * Old value of <code>view</code> before it was changed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get oldView():DisplayObject
		{
			return _oldView;
		}
		
		/**
		 * New value of <code>view</code> resulting from this change.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get newView():DisplayObject
		{
			return _newView;
		}
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new ViewEvent(type, bubbles, cancelable, _oldView, _newView);
		}
		
		// Internals
		//
		
		private var _oldView:DisplayObject;
		private var _newView:DisplayObject;
	}
}