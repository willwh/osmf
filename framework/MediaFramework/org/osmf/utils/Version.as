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
package org.osmf.utils
{
	/**
	 * Class that contains Open Source Media Framework version information. There are three fields:
	 * major, minor and changelist. The version comparison rules are
	 * as follows, assume there are v1 and v2:
	 * <listing>
	 * v1 &#62; v2, if ((v1.major &#62; v2.major) || 
	 *              (v1.major == v2.major &#38;&#38; v1.minor &#62; v2.minor) || 
	 *              (v1.major == v2.major &#38;&#38; v1.minor == v2.minor &#38;&#38; 
	 *               v1.changelist &#62; v2.changelist)) 
	 * 
	 * v1 = v2, if (v1.major == v2.major &#38;&#38; 
	 *              v1.minor == v2.minor &#38;&#38; 
	 *              v1.changelist == v2.changelist) 
	 * 
	 * v1 &#60; v2 //otherwise
	 * </listing>
	 **/
	public class Version
	{
		/**
		 * returns the version string in the format of 
		 * 	[major][FIELD_SEPARATOR][minor][FIELD_SEPARATOR][changelist]
		 **/
		public static function version():String
		{
			return _major + FIELD_SEPARATOR + _minor + FIELD_SEPARATOR + _changelist;
		}
				
		/**
		 * The actual string values of major, minor and changelist will be
		 * dynamically generated at build time.
		 **/
		private static const _major:String = "0";
		private static const _minor:String = "7";
		private static const _changelist:String = "0";	
		
		private static const FIELD_SEPARATOR:String = ".";	
	}
}