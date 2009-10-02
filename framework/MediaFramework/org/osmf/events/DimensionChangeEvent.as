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
	 * A trait that implements the ISpatial interface dispatches
	 * this event when its <code>width</code> and/or <code> height</code> 
	 * properties have changed.
	 * 
	 * Additionally, ILayoutTarget implementing classes are expected
	 * to emit a DimensionChangeEvent on their dimensions changing.
	 */	
	public class DimensionChangeEvent extends Event
	{
		/**
		 * The DimensionChangeEvent.DIMENSION_CHANGE constant defines the value
		 * of the type property of the event object for a dimensionChange
		 * event.
		 * 
		 * @eventType DIMENSION_CHANGE
		 **/
		public static const DIMENSION_CHANGE:String = "dimensionChange";

		/**
		 * Constructor.
		 * 
		 * @param oldWidth Previous width.
		 * @param oldHeight Previous height.
		 * @param newWidth New width.
		 * @param newHeight New height.
 		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 **/		
		public function DimensionChangeEvent
							( oldWidth:int, oldHeight:int
							, newWidth:int, newHeight:int
							, bubbles:Boolean=false
							, cancelable:Boolean=false
							)
		{
			_oldWidth = oldWidth;
			_oldHeight = oldHeight;
			_newWidth = newWidth;
			_newHeight = newHeight;
			
			super(DIMENSION_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * Old value of <code>width</code> before it was changed.
		 */		
		public function get oldWidth():int
		{
			return _oldWidth;
		}
		
		/**
		 * Old value of <code>height</code> before it was changed.
		 */
		public function get oldHeight():int
		{
			return _oldHeight;
		}
		
		/**
		 * New value of <code>width</code> resulting from this change.
		 */
		public function get newWidth():int
		{
			return _newWidth;
		}
		
		/**
		 * New value of <code>height</code> resulting from this change.
		 */
		public function get newHeight():int
		{
			return _newHeight;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new DimensionChangeEvent
				( _oldWidth, _oldHeight
				, _newWidth, _newHeight
				, bubbles, cancelable
				);
		}
		
		// Internals
		//
		
		private var _oldWidth:int;
		private var _oldHeight:int;
		private var _newWidth:int;
		private var _newHeight:int;
	}
}