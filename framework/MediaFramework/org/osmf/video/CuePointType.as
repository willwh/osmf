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
	/**
	 * A utility class for cue point types.
	 */
	public class CuePointType
	{
		/**
		 * A Navigation cue point.
		 */
		public static const NAVIGATION:CuePointType		= new CuePointType("navigation");
		
		/**
		 * An Event cue point.
		 */
		public static const EVENT:CuePointType			= new CuePointType("event");
		
		/**
		 * An ActionScript cue point.
		 */
		public static const ACTIONSCRIPT:CuePointType	= new CuePointType("actionscript");
		
		/**
		 * @private
		 * 
		 * Constructor.
		 * 
		 * @param typeName The name of the cue point type.
		 */
		public function CuePointType(typeName:String)
		{
			_typeName = typeName;
		}
		
		/**
		 * Returns the cue point type constant that matches the given type name as a string,
		 * null if there is no match.
		 */
		public static function fromString(typeName:String):CuePointType
		{
			var lowerCaseTypeName:String = (typeName != null) ? typeName.toLowerCase() : typeName;
			
			for each (var cuePointType:CuePointType in ALL_CUEPOINT_TYPES)
			{
				if (lowerCaseTypeName == cuePointType._typeName)
				{
					return cuePointType;
				}
			}
			
			return null;
		}

		private static const ALL_CUEPOINT_TYPES:Array = [ EVENT, NAVIGATION, ACTIONSCRIPT ];
		private var _typeName:String;
	}
}
