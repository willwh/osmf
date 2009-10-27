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
package org.osmf.video
{
	import org.osmf.metadata.TemporalIdentifier;
	
	/**
	 * The CuePoint class represents a cue point in a media element.
	 */
	public class CuePoint extends TemporalIdentifier
	{
		/**
		 * Constructor.
		 * 
		 * @param type The type of cue point specified by one of the const values in CuePointType.
		 * @param time The time value of the cue point in seconds.
		 * @param name The name of the cue point.
		 * @param parameters Custom name/value data for the cue point.
		 * @param duration The duration value for the cue point in seconds.
		 */
		public function CuePoint(type:CuePointType, time:Number, name:String, parameters:Array, 
									duration:Number=TemporalIdentifier.UNDEFINED)
		{
			super(time, duration);
			_type = type;
			_name = name;
			_parameters = parameters;
		}
				
		/**
		 * The type of cue point. Returns one of the constant
		 * values defined in CuePointType.
		 */
		public function get type():CuePointType
		{
			return _type;
		}
				
		/**
		 * The name of the cue point.
		 */
		public function get name():String
		{
			return _name;
		}
			
		/**
		 * The parameters of the cue point.
		 */
		public function get parameters():Array
		{
			return _parameters;
		}
		
		private var _name:String;
		private var _type:CuePointType;
		private var _parameters:Array;	// Custom name/value data for the cue point
		
	}
}
