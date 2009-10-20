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
	 **/
	public class MediaInfoType
	{
		/**
		 * The default type.  Represents MediaInfos for standard, creatable
		 * MediaElements.
		 **/
		public static const STANDARD:MediaInfoType = new MediaInfoType("standard");
		
		/**
		 * Represents MediaInfos for ProxyElements that should wrap created
		 * MediaElements.
		 **/
		public static const PROXY:MediaInfoType = new MediaInfoType("proxy");
		
		/**
		 * @private
		 * 
		 * Constructor.  Shouldn't need to be called by clients.
		 **/
		public function MediaInfoType(name:String)
		{
			this.name = name;
		}
		
		/**
		 * @private
		 * 
		 * All available types should be included in this array.
		 **/
		internal static const ALL_TYPES:Array = [STANDARD, PROXY];

		private var name:String;
	}
}