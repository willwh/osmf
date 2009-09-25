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

package com.akamai.osmf
{
	import com.akamai.osmf.net.AkamaiNetConnectionFactory;
	import com.akamai.osmf.net.AkamaiNetLoader;
	
	import flash.errors.IllegalOperationError;
	
	import org.openvideoplayer.audio.AudioElement;
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaInfo;
	import org.openvideoplayer.plugin.IPluginInfo;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.video.VideoElement;
	
	/**
	 * The IPlugInfo class required by the OSMF plugin API.
	 */
	public class AkamaiBasicStreamingPluginInfo implements IPluginInfo
	{	
		/**
		 * Constructor. Creates custom objects required for the plugin's functionality and any <code>MediaInfo</code> objects
		 * supported by the plugin.
		 */	
		public function AkamaiBasicStreamingPluginInfo()
		{		
			mediaInfoObjects = new Vector.<MediaInfo>();
			
			var netLoader:AkamaiNetLoader = new AkamaiNetLoader(true, new AkamaiNetConnectionFactory());
			var mediaInfo:MediaInfo = new MediaInfo("com.akamai.osmf.BasicStreamingVideoElement", netLoader, VideoElement, new Array(netLoader));

			mediaInfoObjects.push(mediaInfo);

			mediaInfo = new MediaInfo("com.akamai.osmf.BasicStreamingAudioElement", netLoader, AudioElement, new Array(netLoader));
			mediaInfoObjects.push(mediaInfo);
		}

		/**
		 * Returns the number of <code>MediaInfo</code> objects the plugin wants
		 * to register.
		 */
		public function get numMediaInfos():int
		{
			return mediaInfoObjects.length;
		}
		
		/**
		 * Returns a <code>MediaInfo</code> object at the supplied index position.
		 */
		public function getMediaInfoAt(index:int):IMediaInfo
		{
			if (index >= mediaInfoObjects.length)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.INVALID_PARAM);				
			}
			
			return mediaInfoObjects[index];
		}
		
		/**
		 * Returns if the given version of the framework is supported by the plugin. If the 
		 * return value is <code>true</code>, the framework proceeds with loading the plugin. 
		 * If the value is <code>false</code>, the framework does not load the plugin.
		 */
		public function isFrameworkVersionSupported(version:String):Boolean
		{
			if ((version == null) || (version.length < 1))
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
			
			// Framework version 0.3.0 is the minimum this plugin supports
			return ((major >= 0) && (minor >=3) && (subMinor >= 0));
		}
		
		private var mediaInfoObjects:Vector.<MediaInfo>;			
	}
}