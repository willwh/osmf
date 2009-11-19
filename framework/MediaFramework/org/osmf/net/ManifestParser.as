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
package org.osmf.net
{
	import __AS3__.vec.Vector;
	
	import flash.utils.ByteArray;
	
	import org.osmf.media.IMediaResource;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MediaTypeFacet;
	import org.osmf.net.dynamicstreaming.DynamicStreamingItem;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.utils.Base64Decoder;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.URL;
	
	internal class ManifestParser
	{		
		private static const xmlns:String = "http://www.adobe.com/fmm/1.0";
				
		/**
		 * Parses a Manifest Object from a XML string.
		 * 
		 * @throws Error if the parse fails.
		 */ 
		public static function parse(value:String):Manifest
		{
			var manifest:Manifest = new Manifest();
			
			var root:XML = new XML(value);
			
			if (root.id.length() > 0)
			{
				manifest.id = root.id.text();
			}
			
			if (root.duration.length() > 0)
			{			
				manifest.duration = root.duration.text();
			}	
			
			if (root.mimeType.length() > 0)
			{			
				manifest.mimeType = root.mimeType.text();
			}	
			
			if (root.streamType.length() > 0)
			{			
				manifest.streamType = root.streamType.text();
			}
			
			//Media	
			
			for each (var media:XMLList in root.media)
			{
				manifest.media.push(parseMedia(media));
			}	
				
			//DRM Metadata	
			
			for each (var data:XMLList in root.drmMetadata)
			{
				parseDRMMetadata(data, manifest.media);
			}	
						
			return manifest;
		}
		
		private static function parseMedia(value:XMLList):Media
		{
			var media:Media = new Media();
			
			media.url = value.url.text();
			
			if (value.bitrate.length() > 0)
			{
				media.bitrate = value.bitrate.text();
			}
				
			if (value.drmMetadataId.length() > 0)
			{
				media.drmMetadataId = value.drmMetadataId.text();
			}
			
			if (value.height.length() > 0)
			{
				media.height = value.drmMetadataId.text();
			}
			
			if (value.width.length() > 0)
			{
				media.width = value.width.text();
			}
			
			return media;
		}
		
		private static function parseDRMMetadata(value:XMLList, allMedia:Vector.<Media>):void
		{
			var id:String = value.@id;
			var metadata:String = value.text();
			var decoder:Base64Decoder = new Base64Decoder();
			decoder.decode(metadata);
			var data:ByteArray = decoder.drain();
			var media:Media;
					
			for each (media in allMedia)
			{
				if (media.drmMetadataId == id)
				{
					media.drmMetadata = data;
				}						
			}							
		}		
				
		public static function createResource(value:Manifest):IMediaResource
		{			
			if(value.media.length == 1)  //Single Stream Resource
			{				
				var resource:URLResource = new URLResource(new URL(value.media[0].url));
				resource.metadata.addFacet(new MediaTypeFacet(null, value.mimeType));			
				return resource;
			}	
			else //Dynamic Streaming
			{
				var baseURL:FMSURL = new FMSURL(value.media[0].url);
				var dynResource:DynamicStreamingResource = new DynamicStreamingResource(baseURL, value.streamType);
				dynResource.metadata.addFacet(new MediaTypeFacet(null, value.mimeType));			
				dynResource.streamItems = new Vector.<DynamicStreamingItem>();
				
				for each (var media:Media in value.media)
				{
					var url:FMSURL = new FMSURL(media.url);
					var item:DynamicStreamingItem = new DynamicStreamingItem(url.streamName, media.bitrate, media.width, media.height);
					dynResource.streamItems.push(item);
				}
				return dynResource;
			}
			
			return null;
		}


	}
}