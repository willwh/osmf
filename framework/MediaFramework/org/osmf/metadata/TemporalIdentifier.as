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
	 * Base class for temporal metadata.
	 */
	public class TemporalIdentifier implements IIdentifier
	{
		// This constant can be used by classes extending this
		// class that wish to differentiate between a time value
		// of zero and undefined. For example, a duration of zero
		// could be interpreted a few different ways, where as
		// undefined clearly means the duration is not defined
		// and should be ignored.
		public static const UNDEFINED:Number = -1;
		
		/**
		 * Constructor.
		 * 
		 * @param time Time in seconds.
		 * @param duration The duration in seconds.
		 */
		public function TemporalIdentifier(time:Number, duration:Number):void
		{
			_time = time;
			_duration = duration;
		}
		
		/**
		 * The time in seconds.
		 */
		public function get time():Number
		{
			return _time;
		}
		
		/**
		 * The duration in seconds.
		 */
		public function get duration():Number
		{
			return _duration;
		}
		
		/**
		 * Compares the parameter's time property with this object's time property. Returns true
		 * if they are equal.
		 */
		public function equals(value:IIdentifier):Boolean
		{
			return value is TemporalIdentifier
				&& TemporalIdentifier(value).time == _time;
		}
		
		
		private var _time:Number;		// The time in seconds
		private var _duration:Number;	// The duration in seconds	
	}
}
