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
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.PluginInfo;
	import org.osmf.video.VideoElement;
	
	/**
	 * Implementation of PluginInfo for a plugin that exposes a MediaInfo
	 * which can only handle input resources that have a specific piece of
	 * metadata.
	 **/ 
	public class MetadataVideoPluginInfo extends PluginInfo
	{
		public function MetadataVideoPluginInfo()
		{		
			var mediaInfos:Vector.<MediaInfo> = new Vector.<MediaInfo>();
			
			// Here is the IMediaResourceHandler that checks for the presence
			// of the piece of metadata.  By passing it into the MediaInfo, we
			// ensure that when this plugin is loaded into a player app, and
			// the player app attempts to dynamically instantiate a MediaElement,
			// then this plugin will create the MediaElement if the input resource
			// has the specific piece of metadata.
			var metadataResourceHandler:MetadataResourceHandler = new MetadataResourceHandler();
			
			var mediaInfo:MediaInfo = new MediaInfo("my.example", metadataResourceHandler, createVideoElement);
			mediaInfos.push(mediaInfo);
			
			super(mediaInfos, "0.9.0");
		}
		
		private function createVideoElement():MediaElement
		{
			return new VideoElement();
		}
	}
}