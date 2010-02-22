/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.events
{
	import flash.events.Event;
	
	import org.osmf.metadata.TemporalFacetKey;

	/**
	 * A TemporalFacetEvent is dispatched when properties of the TemporalFacet
	 * class change.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class TemporalFacetEvent extends Event
	{
		/**
		 * The TemporalFacetEvent.POSITION_REACHED constant defines the value of the
		 * type property of the event object for a positionReached event. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public static const POSITION_REACHED:String = "positionReached";
		
		/**
		 * The TemporalFacetEvent.DURATION_REACHED constant defines the value
		 * of the type property of the event object for a durationReached
		 * event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public static const DURATION_REACHED:String = "durationReached";
		
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function TemporalFacetEvent(type:String, key:TemporalFacetKey, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_key = key;
		}
		
		/**
		 * The TemporalFacetKey associated with the event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get key():TemporalFacetKey
		{
			return _key;
		}
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new TemporalFacetEvent(type, _key, bubbles, cancelable);
		}
		
		private var _key:TemporalFacetKey;
	}
}
