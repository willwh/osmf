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
	 * A DimensionEvent is dispatched when properties of an ISpatial trait have changed.
	 */	
	public class DimensionEvent extends Event
	{
		/**
		 * The DimensionEvent.DIMENSION_CHANGE constant defines the value
		 * of the type property of the event object for a dimensionChange
		 * event.
		 * 
		 * @eventType DIMENSION_CHANGE
		 **/
		public static const DIMENSION_CHANGE:String = "dimensionChange";

		/**
		 * Constructor.
		 * 
		 * @param type Event type.
 		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 * @param oldWidth Previous width.
		 * @param oldHeight Previous height.
		 * @param newWidth New width.
		 * @param newHeight New height.
		 **/		
		public function DimensionEvent
							( type:String
							, bubbles:Boolean=false
							, cancelable:Boolean=false
							, oldWidth:Number=NaN
							, oldHeight:Number=NaN
							, newWidth:Number=NaN
							, newHeight:Number=NaN
							)
		{
			super(type, bubbles, cancelable);
			
			_oldWidth = oldWidth;
			_oldHeight = oldHeight;
			_newWidth = newWidth;
			_newHeight = newHeight;
		}
		
		/**
		 * Old value of <code>width</code> before it was changed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get oldWidth():Number
		{
			return _oldWidth;
		}
		
		/**
		 * Old value of <code>height</code> before it was changed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get oldHeight():Number
		{
			return _oldHeight;
		}
		
		/**
		 * New value of <code>width</code> resulting from this change.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get newWidth():Number
		{
			return _newWidth;
		}
		
		/**
		 * New value of <code>height</code> resulting from this change.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get newHeight():Number
		{
			return _newHeight;
		}
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new DimensionEvent(type, bubbles, cancelable, _oldWidth, _oldHeight, _newWidth, _newHeight);
		}
		
		// Internals
		//
		
		private var _oldWidth:Number;
		private var _oldHeight:Number;
		private var _newWidth:Number;
		private var _newHeight:Number;
	}
}