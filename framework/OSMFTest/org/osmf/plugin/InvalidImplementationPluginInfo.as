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
package org.osmf.plugin
{
	import __AS3__.vec.Vector;
	
	import org.osmf.media.MediaInfo;
	import org.osmf.utils.Version;
	
	public class InvalidImplementationPluginInfo extends PluginInfo
	{
		public static const MEDIA_INFO_ID:String = "InvalidImplementationPluginInfo";
		
		public function InvalidImplementationPluginInfo()
		{
			var mediaInfos:Vector.<MediaInfo> = new Vector.<MediaInfo>();
			super(mediaInfos);
		}
		
		/**
		 * Returns the number of <code>MediaInfo</code> objects the plugin wants
		 * to register
		 */
		override public function get numMediaInfos():int
		{
			return 1;
		}

		/**
		 * Returns a <code>MediaInfo</code> object at the supplied index position
		 */
		override public function getMediaInfoAt(index:int):MediaInfo
		{
			return null;
		}
	}
}