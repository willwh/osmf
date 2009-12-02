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
package org.osmf.gg
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.media.IMediaResourceHandler;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.IPluginInfo;
	import org.osmf.utils.OSMFStrings;

	/**
	 * Encapsulation of a GlanceGuide plugin.
	 **/
	public class GGPluginInfo implements IPluginInfo
	{	
		/**
		 * Constructor.
		 */	
		public function GGPluginInfo()
		{		
			mediaInfos = new Vector.<MediaInfo>();
			
			var resourceHandler:IMediaResourceHandler = new NetLoader();
			var mediaInfo:MediaInfo = new MediaInfo
				( "org.osmf.gg.GGPluginInfo"
				, resourceHandler
				, createGGVideoProxyElement
				, MediaInfoType.PROXY
				);
			mediaInfos.push(mediaInfo);
		}
		
		/**
		 * Returns the number of <code>MediaInfo</code> objects the plugin wants
		 * to register.
		 */
		public function get numMediaInfos():int
		{
			return mediaInfos.length;
		}
		
		/**
		 * Returns a <code>MediaInfo</code> object at the supplied index position.
		 */
		public function getMediaInfoAt(index:int):MediaInfo
		{
			if (index >= mediaInfos.length)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));				
			}
			
			return mediaInfos[index];
		}
		
		/**
		 * Returns if the given version of the framework is supported by the plugin. If the 
		 * return value is <code>true</code>, the framework proceeds with loading the plugin. 
		 * If the value is <code>false</code>, the framework does not load the plugin.
		 */
		public function isFrameworkVersionSupported(version:String):Boolean
		{
			if (version == null || version.length < 1)
			{
				return false;
			}
			
			var verInfo:Array = version.split(".");
			var major:int = 0
			var minor:int = 0
			var subMinor:int = 0;
			
			if (verInfo.length >= 1)
			{
				major = parseInt(verInfo[0]);
			}
			if (verInfo.length >= 2)
			{
				minor = parseInt(verInfo[1]);
			}
			if (verInfo.length >= 3)
			{
				subMinor = parseInt(verInfo[2]);
			}
			
			// Framework version 0.7.0 is the minimum this plugin supports.
			return ((major >= 0) && (minor >= 7) && (subMinor >= 0));
		}

		private function createGGVideoProxyElement():MediaElement
		{
			return new GGVideoProxyElement();
		}

		private var mediaInfos:Vector.<MediaInfo>;			
	}
}
