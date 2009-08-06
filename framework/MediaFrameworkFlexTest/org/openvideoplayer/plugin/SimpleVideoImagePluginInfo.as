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
package org.openvideoplayer.plugin
{
	import org.openvideoplayer.image.ImageElement;
	import org.openvideoplayer.image.ImageLoader;
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaInfo;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.video.VideoElement;
	
	public class SimpleVideoImagePluginInfo implements IPluginInfo
	{
		public function SimpleVideoImagePluginInfo()
		{
		}

		public static const VIDEO_MEDIA_INFO_ID:String = "org.openvideoplayer.video.Video2";
		public static const IMAGE_MEDIA_INFO_ID:String = "org.openvideoplayer.video.Image2";
		


		/**
		 * Returns the number of <code>MediaInfo</code> objects the plugin wants
		 * to register
		 */
		public function get numMediaInfos():int
		{
			return 2;
		}

		/**
		 * Returns a <code>MediaInfo</code> object at the supplied index position
		 */
		public function getMediaInfoAt(index:int):IMediaInfo
		{
			
			var netLoader:NetLoader = new NetLoader();
			var imageLoader:ImageLoader = new ImageLoader();
			var mediaInfo:MediaInfo;
			
			switch(index)
			{
				case 0:
					mediaInfo = new MediaInfo(VIDEO_MEDIA_INFO_ID, netLoader, VideoElement, new Array(netLoader));
					break;
				case 1:
					mediaInfo = new MediaInfo(IMAGE_MEDIA_INFO_ID, imageLoader, ImageElement, new Array(imageLoader));
					break;
			}
			return mediaInfo;
			
		}
		
		/**
		 * Returns if the given version of the framework is supported by the plugin. If the 
		 * return value is <code>true</code>, the framework proceeds with loading the plugin. 
		 * If the value is <code>false</code>, the framework does not load the plugin.
		 */
		public function isFrameworkVersionSupported(version:String):Boolean
		{
			return true;
		}


	}
}