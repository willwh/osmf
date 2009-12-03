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
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MediaTypeFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.net.dynamicstreaming.DynamicStreamingItem;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.utils.Base64Decoder;
	import org.osmf.utils.DateUtil;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.URL;
	
	internal class ManifestParser
	{		
	
		namespace xmlns = "http://ns.adobe.com/f4m/1.0";
		/**
		 * Parses a Manifest Object from a XML string.
		 * 
		 * @throws Error if the parse fails.
		 */ 
		public static function parse(value:String):Manifest
		{
			var manifest:Manifest = new Manifest();
			
			var root:XML = new XML(value);
						
			if (root.xmlns::id.length() > 0)
			{
				manifest.id = root.xmlns::id.text();
			}
			
			if (root.xmlns::duration.length() > 0)
			{			
				manifest.duration = root.xmlns::duration.text();
			}	
			
			if (root.xmlns::startTime.length() > 0)
			{			
				manifest.startTime = DateUtil.parseW3CDTF(root.xmlns::startTime.text());
			}	
			
			if (root.xmlns::mimeType.length() > 0)
			{			
				manifest.mimeType = root.xmlns::mimeType.text();
			}	
			
			if (root.xmlns::streamType.length() > 0)
			{			
				manifest.streamType = root.xmlns::streamType.text();
			}
			
			if (root.xmlns::deliveryType.length() > 0)
			{			
				manifest.deliveryType = root.xmlns::deliveryType.text();
			}
			
			if (root.xmlns::baseURL.length() > 0)
			{			
				manifest.baseURL = root.xmlns::baseURL.text();
			}
			
			//Media	
			
			for each (var media:XML in root.xmlns::media)
			{
				manifest.media.push(parseMedia(media));
			}	
								
			//DRM Metadata	
			
			for each (var data:XML in root.xmlns::drmMetadata)
			{
				parseDRMMetadata(data, manifest.media);
			}	
						
			return manifest;
		}
		
		private static function parseMedia(value:XML):Media
		{
			var media:Media = new Media();
			
			media.url = value.@url;
			
			if (value.attribute('bitrate').length() > 0)
			{
				media.bitrate = value.@bitrate;
			}
				
			if (value.attribute('drmMetadataId').length() > 0)
			{
				media.drmMetadataId = value.@drmMetadataId;
			}
			
			if (value.attribute('bootstrapInfoId').length() > 0)
			{
				media.bootstrapInfoId = value.@bootstrapInfoId;
			}
			
			if (value.attribute('height').length() > 0)
			{
				media.height = value.@height;
			}
			
			if (value.attribute('width').length() > 0)
			{
				media.width = value.@width;
			}
			
			if (value.xmlns::moov.length() > 0)
			{		
				var decoder:Base64Decoder = new Base64Decoder();
				decoder.decode(value.xmlns::moov.text());
				media.moov = decoder.drain();	
			}
			
			return media;
		}
		
		private static function parseDRMMetadata(value:XML, allMedia:Vector.<Media>):void
		{
			
			var id:String = null;
			var url:String = null;
			var data:ByteArray;
			var media:Media;	
			
			if (value.attribute("id").length() > 0)
			{
				id = value.@id;
			}
			
			if (value.attribute("url").length() > 0)
			{
				url = value.@url;
			}
			else
			{			
				var metadata:String = value.text();
				var decoder:Base64Decoder = new Base64Decoder();
				decoder.decode(metadata);
				data = decoder.drain();
			}
								
			for each (media in allMedia)
			{
				if (media.drmMetadataId == id)
				{
					if (url != null)
					{
						media.drmMetadataURL = url;
					}
					else
					{
						media.drmMetadata = data;
					}					
				}						
			}	
									
		}		
		
		private static function parseBootStrapInfo(value:XML, allMedia:Vector.<Media>):void
		{			
			var id:String = null;
			var profile:String = value.@profile;
			var url:String = null;
			var data:ByteArray;
			var media:Media;	
			
			if (value.attribute("id").length() > 0)
			{
				id = value.@id;
			}
				
			if (value.attribute("url").length() > 0)
			{
				url = value.@url;
			}
			else
			{			
				var metadata:String = value.text();
				var decoder:Base64Decoder = new Base64Decoder();
				decoder.decode(metadata);
				data = decoder.drain();
			}
								
			for each (media in allMedia)
			{
				if (media.bootstrapInfoURL == id)
				{
					media.bootstrapProfile = profile; 
					if (url != null)
					{
						media.bootstrapInfoURL = url;
					}
					else
					{
						media.bootstrapInfo = data;
					}					
				}						
			}								
		}		
				
		public static function createResource(value:Manifest):IMediaResource
		{			
			var drmFacet:KeyValueFacet;
			if(value.media.length == 1)  //Single Stream Resource
			{				
				var resource:URLResource = new URLResource(new URL(value.media[0].url));
				if (value.mimeType != null)
				{
					resource.metadata.addFacet(new MediaTypeFacet(MediaType.VIDEO, value.mimeType));			
				}
				if (Media(value.media[0]).drmMetadata != null)
				{
					drmFacet = new KeyValueFacet(MetadataNamespaces.DRM_METADATA);
					drmFacet.addValue(new ObjectIdentifier(MetadataNamespaces.DRM_CONTENT_METADATA_KEY), Media(value.media[0]).drmMetadata);
					resource.metadata.addFacet(drmFacet);
				}
				return resource;
			}	
			else //Dynamic Streaming
			{
				var baseURL:FMSURL = new FMSURL(value.media[0].url);
				var dynResource:DynamicStreamingResource = new DynamicStreamingResource(baseURL, value.streamType);
				if (value.mimeType != null)
				{
					dynResource.metadata.addFacet(new MediaTypeFacet(MediaType.VIDEO, value.mimeType));			
				}
				dynResource.streamItems = new Vector.<DynamicStreamingItem>();
								
				for each (var media:Media in value.media)
				{
					var url:FMSURL = new FMSURL(media.url);
					var item:DynamicStreamingItem = new DynamicStreamingItem(url.streamName, media.bitrate, media.width, media.height);
					dynResource.streamItems.push(item);
					if (media.drmMetadata != null)
					{
						if (dynResource.metadata.getFacet(MetadataNamespaces.DRM_METADATA) == null)
						{
							drmFacet = new KeyValueFacet(MetadataNamespaces.DRM_METADATA);
							dynResource.metadata.addFacet(drmFacet);
						}						
						drmFacet.addValue(new ObjectIdentifier(item), media.drmMetadata);	
					}
				}
				return dynResource;
			}
			
			return null;
		}


	}
}