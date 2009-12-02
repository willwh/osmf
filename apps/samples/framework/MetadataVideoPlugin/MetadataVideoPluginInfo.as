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
package
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.IPluginInfo;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.video.VideoElement;
	
	/**
	 * Implementation of IPluginInfo for a plugin that exposes a MediaInfo
	 * which can only handle input resources that have a specific piece of
	 * metadata.
	 **/ 
	public class MetadataVideoPluginInfo implements IPluginInfo
	{
		public function MetadataVideoPluginInfo()
		{		
			mediaInfos = new Vector.<MediaInfo>();
			netLoader = new NetLoader();
			
			// Here is the IMediaResourceHandler that checks for the presence
			// of the piece of metadata.  By passing it into the MediaInfo, we
			// ensure that when this plugin is loaded into a player app, and
			// the player app attempts to dynamically instantiate a MediaElement,
			// then this plugin will create the MediaElement if the input resource
			// has the specific piece of metadata.
			metadataResourceHandler = new MetadataResourceHandler();
			
			var mediaInfo:MediaInfo = new MediaInfo("my.example", metadataResourceHandler, createVideoElement);
			mediaInfos.push(mediaInfo);
		}
		
		public function get numMediaInfos():int
		{
			return mediaInfos.length;
		}
		
		public function getMediaInfoAt(index:int):MediaInfo
		{
			if (index >= mediaInfos.length)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));				
			}
			
			return mediaInfos[index];
		}
		
		public function isFrameworkVersionSupported(version:String):Boolean
		{
			return true;
		}
		
		private function createVideoElement():MediaElement
		{
			return new VideoElement(netLoader);
		}

		private var netLoader:NetLoader;
		private var mediaInfos:Vector.<MediaInfo>;
		private var metadataResourceHandler:MetadataResourceHandler;
	}
}