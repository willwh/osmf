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
package org.osmf.media
{
	/**
	 * Enumeration of different types of MediaInfos.
	 * 
	 * <p>Most MediaInfos encapsulate media with a standard creation policy,
	 * but in some cases a MediaInfo needs some additional, custom setup.
	 * This class enables the distinction between these types.</p> 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class MediaInfoType
	{
		/**
		 * The default type.  Represents MediaInfos for standard, creatable
		 * MediaElements.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const STANDARD:String = "standard";
		
		/**
		 * Represents MediaInfos for ProxyElements that should wrap created
		 * MediaElements.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const PROXY:String = "proxy";
		
		/**
		 * A create on load plugin is created once it is added to a media factory. 
		 * No resource will be set when the plugin's element is created after loaded.
		 * This type of plugin is meant to be used as a reference plugin without 
		 * the need to create the plugin's MediaElement explicitly.  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const CREATE_ON_LOAD:String = "createOnLoad";

		/**
		 * @private
		 * 
		 * All available types should be included in this array.
		 */
		internal static const ALL_TYPES:Array = [STANDARD, PROXY, CREATE_ON_LOAD];
	}
}