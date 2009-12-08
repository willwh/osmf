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
			
			var bitrateSeen:Boolean = false;
			
			for each (var media:XML in root.xmlns::media)
			{
				var newMedia:Media = parseMedia(media);
				manifest.media.push(newMedia);
				bitrateSeen ||= !isNaN(newMedia.bitrate);
			}	
			
			if (manifest.media.length > 1 && !bitrateSeen)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.F4M_PARSE_BITRATE_MISSING));
			}
								
			//DRM Metadata	
			
			for each (var data:XML in root.xmlns::drmMetadata)
			{
				parseDRMMetadata(data, manifest.media);
			}	
			
			//Bootstrap	
			
			for each (var info:XML in root.xmlns::bootstrapInfo)
			{
				parseBootStrapInfo(info, manifest.media);
			}	
			
			//Required if base URL is omitted from Manifest
			generateRTMPBaseURL(manifest);
									
			return manifest;
		}
		
		private static function parseMedia(value:XML):Media
		{
			var media:Media = new Media();
			
			if (value.attribute('url').length() > 0)
			{
				media.url = value.@url;
			}
			else  //Raise parse error
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.F4M_PARSE_MEDIA_URL_MISSING));
			}
			
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
			var url:String = null;
			var data:ByteArray;
			var media:Media;	
			var profile:String;
			
			if (value.attribute('profile').length() > 0)
			{
				profile = value.@profile;
			}
			else  //Raise parse error
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.F4M_PARSE_PROFILE_MISSING));
			}
			
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
		
		/**
		 * @private
		 * Ensures that an RTMP based Manifest has the same server for all
		 * streaming items, and extracts the base URL from the streaming items
		 * if not specified. 
		 */ 
		private static function generateRTMPBaseURL(manifest:Manifest):void
		{
			if (manifest.baseURL == null)
			{						
				for each(var media:Media in manifest.media)
				{
					 if (media.url.substr(0,4) == "rtmp")
					 {
					 	var url:FMSURL = new FMSURL(media.url);
					 	var port:String = url.port != "" ? ":" + url.port : ""; 	
					 	manifest.baseURL = "rtmp://" + url.host + port + "/" + url.appName + "/" + (url.useInstance ?  url.instanceName : "");
					 	break; 
					 }
				}
			}
		}
				
		public static function createResource(value:Manifest, manifestLocation:URL):IMediaResource
		{			
			var drmFacet:KeyValueFacet;
			var resource:IMediaResource;
			var protocol:String
						
			if(value.media.length == 1)  //Single Stream Resource
			{									
				protocol =  value.media[0].url.substr(0,7);
				
				if (protocol == "http://" || protocol == "rtmp://")
				{
					resource = new URLResource(new FMSURL(value.media[0].url));
				}				
				else if (value.baseURL != null)	//Relative to Base URL					
				{
					resource = new URLResource(new FMSURL(value.baseURL + value.media[0].url));
				}
				else //Relative to f4m file  (no absolute or base urls).
				{					
					var cleanedPath:String = "/" + manifestLocation.path;
					cleanedPath = cleanedPath.substr(0, cleanedPath.lastIndexOf("/",0)+1);
					var base:String = manifestLocation.protocol + "://" +  manifestLocation.host + (manifestLocation.port != "" ? ":" + manifestLocation.port : "") + cleanedPath;
					resource = new URLResource(new URL(base + value.media[0].url));
				}
				
				if (Media(value.media[0]).drmMetadata != null)
				{
					drmFacet = new KeyValueFacet(MetadataNamespaces.DRM_METADATA);
					drmFacet.addValue(new ObjectIdentifier(MetadataNamespaces.DRM_CONTENT_METADATA_KEY), Media(value.media[0]).drmMetadata);
					resource.metadata.addFacet(drmFacet);
				}					
			}				
			else if(value.baseURL && value.baseURL.substr(0,4) == "rtmp")//Dynamic Streaming
			{	
									
				var baseURL:FMSURL = new FMSURL(value.baseURL);
								
				var dynResource:DynamicStreamingResource = new DynamicStreamingResource(baseURL, value.streamType);
				
				dynResource.streamItems = new Vector.<DynamicStreamingItem>();
								
				for each (var media:Media in value.media)
				{		
					var stream:String = media.url;
								
					if (stream.substr(0,4) == "rtmp")
					{
						var url:FMSURL = new FMSURL(stream);
						stream = (url.fileFormat ? url.fileFormat + ":" : "") + url.streamName
					}
					
					var item:DynamicStreamingItem = new DynamicStreamingItem(stream, media.bitrate, media.width, media.height);
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
				resource = dynResource;
			}
			else if (value.baseURL == null || value.baseURL == "")
			{	
				//This is a parse error, we need an rtmp url
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.F4M_PARSE_MEDIA_URL_MISSING));					
			}	
			
			if (value.mimeType != null)
			{
				resource.metadata.addFacet(new MediaTypeFacet(MediaType.VIDEO, value.mimeType));			
			}
			
			return resource;
		}


	}
}