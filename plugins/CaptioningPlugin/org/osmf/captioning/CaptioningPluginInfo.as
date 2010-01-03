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
package org.osmf.captioning
{
	import __AS3__.vec.Vector;
	
	import org.osmf.captioning.media.CaptioningProxyElement;
	import org.osmf.media.IMediaResourceHandler;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.PluginInfo;
	import org.osmf.utils.URL;

	/**
	 * Encapsulation of a Captioning plugin.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class CaptioningPluginInfo extends PluginInfo
	{
		// Constants for specifying the Timed Text document URL on the resource metadata
		public static const CAPTIONING_METADATA_NAMESPACE:URL = new URL("http://www.osmf.org/captioning/1.0");
		public static const CAPTIONING_METADATA_KEY_URI:String = "uri";
		
		// Constants for the temporal metadata (captions)
		public static const CAPTIONING_TEMPORAL_METADATA_NAMESPACE:URL = new URL("http://www.osmf.org/temporal/captioning");
		
		/**
		 * Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function CaptioningPluginInfo()
		{
			var mediaInfos:Vector.<MediaInfo> = new Vector.<MediaInfo>();
			
			var resourceHandler:IMediaResourceHandler = new NetLoader();
			var mediaInfo:MediaInfo = new MediaInfo("org.osmf.captioning.CaptioningPluginInfo",
													resourceHandler,
													createCaptioningProxyElement,
													MediaInfoType.PROXY);
			mediaInfos.push(mediaInfo);
			
			super(mediaInfos, "0.9.0");
		}
		
		private function createCaptioningProxyElement():MediaElement
		{
			return new CaptioningProxyElement();
		}
	}
}
