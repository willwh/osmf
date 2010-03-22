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
	 * Class that contains Open Source Media Framework version information. There are two fields:
	 * major and minor. The version comparison rules are as follows, assuming there are v1 and v2:
	 * <listing>
	 * v1 &#62; v2, if ((v1.major &#62; v2.major) || 
	 *              (v1.major == v2.major &#38;&#38; v1.minor &#62; v2.minor)
	 * 
	 * v1 == v2, if (v1.major == v2.major &#38;&#38; 
	 *              v1.minor == v2.minor) 
	 * 
	 * v1 &#60; v2 //otherwise
	 * </listing>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class Version
	{
		/**
		 * returns the version string in the format of 
		 * 	[major][FIELD_SEPARATOR][minor]
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function get version():String
		{
			return _major + FIELD_SEPARATOR + _minor;
		}
		
		/**
		 * @private
		 * 
		 * The most recent OSMF version which is API compatible with the current version.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function get lastAPICompatibleVersion():String
		{
			// TODO: This should probably be set to "1.0" for final release. 
			return Version.version;
		}
		
		/**
		 * @private
		 * 
		 * Defines the value of the FLASH_10_1 configuration constant.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function get FLASH_10_1():Boolean
		{
			CONFIG::FLASH_10_1
			{
				return true;
			}
			return false;
		}
				
		private static const _major:String = "0";
		private static const _minor:String = "93";
		
		private static const FIELD_SEPARATOR:String = ".";	
	}
}