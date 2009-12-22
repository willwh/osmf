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
	
	import flash.errors.IllegalOperationError;
	
	import org.osmf.captioning.media.CaptioningProxyElement;
	import org.osmf.media.IMediaResourceHandler;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.metadata.Metadata;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.IPluginInfo;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.URL;

	/**
	 * Encapsulation of a Captioning plugin.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class CaptioningPluginInfo implements IPluginInfo
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
			mediaInfos = new Vector.<MediaInfo>();
			
			var resourceHandler:IMediaResourceHandler = new NetLoader();
			var mediaInfo:MediaInfo = new MediaInfo("org.osmf.captioning.CaptioningPluginInfo",
													resourceHandler,
													createCaptioningProxyElement,
													MediaInfoType.PROXY);
			mediaInfos.push(mediaInfo);
		}

		/**
		 * Returns the number of <code>MediaInfo</code> objects the plugin wants
		 * to register.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get numMediaInfos():int
		{
			return mediaInfos.length;
		}
		
		/**
		 * Returns a <code>MediaInfo</code> object at the supplied index position.
		 * 
		 * @throws IllegalOperationError If index argument is out of range.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function isFrameworkVersionSupported(version:String):Boolean
		{
			if (version == null || version.length < 1)
			{
				return false;
			}
			
			var verInfo:Array = version.split(".");
			var major:int = 0;
			var minor:int = 0;
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
			
			// Framework version 0.8.0 is the minimum this plugin supports.
			return ((major > 0) || ((major == 0) && (minor >= 8) && (subMinor >= 0)));
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function initializePlugin(metadata:Metadata):void
		{
			
		}
		
		private function createCaptioningProxyElement():MediaElement
		{
			return new CaptioningProxyElement();
		}
	
		private var mediaInfos:Vector.<MediaInfo>;
	}
}
