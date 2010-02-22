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
package org.osmf.metadata
{
	/**
	 * The FacetKey used by the TemporalFacet.  A TemporalFacetKey
	 * holds a time property and an optional duration.  When
	 * a MediaElement plays back, the TemporalFacetKey will trigger
	 * an event when the MediaElement's currentTime matches the
	 * time property of the TemporalFacetKey.  If the key
	 * also holds a duration, a second event will be fired when the
	 * MediaElement's currentTime reaches that offset.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class TemporalFacetKey extends FacetKey
	{
		/**
		 * Constant for an undefined <code>duration</code>.  Useful for
		 * distinguishing between a duration value of zero and an
		 * undefined duration.
		 **/
		public static const DURATION_UNDEFINED:Number = -1;
		
		/**
		 * Constructor.
		 * 
		 * @param time Time in seconds.
		 * @param duration The duration in seconds.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function TemporalFacetKey(time:Number, duration:Number):void
		{
			super(time);
			
			_time = time;
			_duration = duration;
		}
		
		/**
		 * The time in seconds.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get time():Number
		{
			return _time;
		}
		
		/**
		 * The duration in seconds.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get duration():Number
		{
			return _duration;
		}
		
		/**
		 * @private
		 * 
		 * Compares the parameter's time property with this object's time property. Returns true
		 * if they are equal.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function equals(value:FacetKey):Boolean
		{
			return value is TemporalFacetKey
				&& TemporalFacetKey(value).time == _time;
		}
		
		
		private var _time:Number;		// The time in seconds
		private var _duration:Number;	// The duration in seconds	
	}
}
