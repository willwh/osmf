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
package org.openvideoplayer.events
{
	import flash.events.Event;
	
	import org.openvideoplayer.regions.IRegion;

	/**
	 * RegionChangeEvent signals that a reference to an IRegion has changed.
	 */	
	public class RegionChangeEvent extends Event
	{
		public static const REGION_CHANGE:String = "regionChange";
		
		/**
		 * Constructor
		 *  
		 * @param oldValue Old IRegion reference.
		 * @param newValue New IRegion reference.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */		
		public function RegionChangeEvent(oldValue:IRegion, newValue:IRegion, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(REGION_CHANGE, bubbles, cancelable);
			
			_oldValue = oldValue;
			_newValue = newValue;
		}
		
		/**
		 * Defines the old region reference.
		 */		
		public function get oldValue():IRegion
		{
			return _oldValue;
		}
		
		/**
		 * Defines the new region reference.
		 */		
		public function get newValue():IRegion
		{
			return _newValue;
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new RegionChangeEvent(_oldValue, _newValue, bubbles, cancelable);
		}
		
		// Internals
		//
		
		private var _oldValue:IRegion;
		private var _newValue:IRegion;
	}
}