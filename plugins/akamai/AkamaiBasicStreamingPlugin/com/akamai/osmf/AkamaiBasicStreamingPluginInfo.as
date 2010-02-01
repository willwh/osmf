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
	
	import org.osmf.audio.AudioElement;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.PluginInfo;
	import org.osmf.video.VideoElement;
	
	/**
	 * The PlugInfo class required by the OSMF plugin API.
	 */
	public class AkamaiBasicStreamingPluginInfo extends PluginInfo
	{	
		/**
		 * Constructor. Creates custom objects required for the plugin's functionality and any <code>MediaInfo</code> objects
		 * supported by the plugin.
		 */	
		public function AkamaiBasicStreamingPluginInfo()
		{		
			var mediaInfos:Vector.<MediaInfo> = new Vector.<MediaInfo>();
			netLoader = new AkamaiNetLoader(true, new AkamaiNetConnectionFactory());
			
			var mediaInfo:MediaInfo = new MediaInfo("com.akamai.osmf.BasicStreamingVideoElement", netLoader, createVideoElement);
			mediaInfos.push(mediaInfo);

			mediaInfo = new MediaInfo("com.akamai.osmf.BasicStreamingAudioElement", netLoader, createAudioElement);
			mediaInfos.push(mediaInfo);
			
			super(mediaInfos);
		}
		
		private function createVideoElement():MediaElement
		{
			return new VideoElement(null, netLoader);
		}
		
		private function createAudioElement():MediaElement
		{
			return new AudioElement(null, netLoader);
		}
		
		private var netLoader:NetLoader;
	}
}
