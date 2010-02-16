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
package org.osmf.elements.f4mClasses
{
	import __AS3__.vec.Vector;
	
	import flash.utils.ByteArray;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MediaTypeFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.net.NetStreamUtils;
	import org.osmf.net.dynamicstreaming.DynamicStreamingItem;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.URL;
	
	[ExcludeClass]
	
	/**
	 * @private
	 **/
	public class ManifestParser
	{
		namespace xmlns = "http://ns.adobe.com/f4m/1.0";
		
		/**
		 * Parses a Manifest Object from a XML string.
		 * 
		 * @throws Error if the parse fails.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function parse(value:String, rootUrl:URL=null):Manifest
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
				manifest.baseURL = new URL(root.xmlns::baseURL.text());
			}
			
			var baseUrl:URL = (manifest.baseURL != null)? manifest.baseURL :  rootUrl;
			
			// Media	
			
			var bitrateMissing:Boolean = false;
			
			for each (var media:XML in root.xmlns::media)
			{
				var newMedia:Media = parseMedia(media, baseUrl);
				manifest.media.push(newMedia);
				bitrateMissing ||= isNaN(newMedia.bitrate);
			}	
			
			if (manifest.media.length > 1 && bitrateMissing)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.F4M_PARSE_BITRATE_MISSING));
			}
								
			// DRM Metadata	
			
			for each (var data:XML in root.xmlns::drmAdditionalHeader)
			{
				parseDRMAdditionalHeader(data, manifest.media, baseUrl, manifest);
			}	
			
			// Bootstrap	
			
			for each (var info:XML in root.xmlns::bootstrapInfo)
			{
				parseBootstrapInfo(info, manifest.media, baseUrl, manifest);
			}	
			
			// Required if base URL is omitted from Manifest
			generateRTMPBaseURL(manifest);
									
			return manifest;
		}
		
		private function parseMedia(value:XML, baseUrl:URL):Media
		{
			var decoder:Base64Decoder;
			var media:Media = new Media();
			
			if (value.attribute('url').length() > 0)
			{
				media.url = new URL(value.@url);
			}
			else  // Raise parse error
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.F4M_PARSE_MEDIA_URL_MISSING));
			}
			
			if (value.attribute('bitrate').length() > 0)
			{
				media.bitrate = value.@bitrate;
			}
				
			if (value.attribute('drmAdditionalHeaderId').length() > 0)
			{
				media.drmAdditionalHeader.id = value.@drmAdditionalHeaderId;
			}
			
			if (value.attribute('bootstrapInfoId').length() > 0)
			{
				media.bootstrapInfo = new BootstrapInfo();
				media.bootstrapInfo.id = value.@bootstrapInfoId;
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
				decoder = new Base64Decoder();
				decoder.decode(value.xmlns::moov.text());
				media.moov = decoder.drain();	
			}
			
			if (value.xmlns::metadata.length() > 0)
			{
				decoder = new Base64Decoder();
				decoder.decode(value.xmlns::metadata.text());
				media.metadata = decoder.drain();	
			}
			
			if (value.xmlns::xmpMetadata.length() > 0)
			{
				decoder = new Base64Decoder();
				decoder.decode(value.xmlns::xmpMetadata.text());
				media.xmp = decoder.drain();	
			}

			return media;
		}
		
		private function parseDRMAdditionalHeader(value:XML, allMedia:Vector.<Media>, baseUrl:URL, manifest:Manifest):void
		{
			var url:URL = null;
			var media:Media;
			
			var drmAdditionalHeader:DRMAdditionalHeader = new DRMAdditionalHeader();	
			
			if (value.attribute("id").length() > 0)
			{
				drmAdditionalHeader.id = value.@id; 
			}
			
			if (value.attribute("url").length() > 0)
			{
				url = new URL(value.@url);
				if (!url.absolute)
				{
					url = new URL(baseUrl.rawUrl + "/" + url.rawUrl);
				}
				drmAdditionalHeader.url = url;
			}
			else
			{			
				var metadata:String = value.text();
				var decoder:Base64Decoder = new Base64Decoder();
				decoder.decode(metadata);
				drmAdditionalHeader.data = decoder.drain();
			}
			
			manifest.drmAdditionalHeaders.push(drmAdditionalHeader);
								
			for each (media in allMedia)
			{
				if (media.drmAdditionalHeader.id == drmAdditionalHeader.id)
				{
					media.drmAdditionalHeader = drmAdditionalHeader;					
				}
			}
		}		
		
		private function parseBootstrapInfo(value:XML, allMedia:Vector.<Media>, baseUrl:URL, manifest:Manifest):void
		{			
			var media:Media;	
			
			var url:URL = null;
			var bootstrapInfo:BootstrapInfo = new BootstrapInfo();
			
			if (value.attribute('profile').length() > 0)
			{
				bootstrapInfo.profile = value.@profile;
			}
			else  // Raise parse error
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.F4M_PARSE_PROFILE_MISSING));
			}
			
			if (value.attribute("id").length() > 0)
			{
				bootstrapInfo.id = value.@id; 
			}
				
			if (value.attribute("url").length() > 0)
			{
				url = new URL(value.@url);
				if (!url.absolute && baseUrl != null)
				{
					url = new URL(baseUrl.rawUrl + "/" + url.rawUrl);
				}
				bootstrapInfo.url = url;
			}
			else
			{			
				var metadata:String = value.text();
				var decoder:Base64Decoder = new Base64Decoder();
				decoder.decode(metadata);
				bootstrapInfo.data = decoder.drain();
			}
								
			for each (media in allMedia)
			{
				if (media.bootstrapInfo == null) //No per media bootstrap. Apply it to all items.
				{
					media.bootstrapInfo = bootstrapInfo;
				}
				else if (media.bootstrapInfo.id == bootstrapInfo.id)
				{
					media.bootstrapInfo = bootstrapInfo;
				}						
			}								
		}		
		
		/**
		 * @private
		 * Ensures that an RTMP based Manifest has the same server for all
		 * streaming items, and extracts the base URL from the streaming items
		 * if not specified. 
		 */ 
		private function generateRTMPBaseURL(manifest:Manifest):void
		{
			if (manifest.baseURL == null)
			{						
				for each(var media:Media in manifest.media)
				{
					 if (NetStreamUtils.isRTMPStream(media.url))
					 {					 	
					 	manifest.baseURL = media.url;
					 	break; 
					 }
				}
			}
		}
		
		/**
		 * Generates a MediaResourceBase for the given manifest. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 		
		public function createResource(value:Manifest, manifestResource:URLResource):MediaResourceBase
		{			
			var drmFacet:KeyValueFacet = null;
			var metadataFacet:KeyValueFacet = null;
			var resource:MediaResourceBase;
			var media:Media;
			var serverBaseURLs:Vector.<String>
			var url:URL;
			var bootstrapInfoURLString:String;
			
			var cleanedPath:String = "/" + manifestResource.url.path;
			cleanedPath = cleanedPath.substr(0, cleanedPath.lastIndexOf("/"));
			var manifestFolder:String = manifestResource.url.protocol + "://" +  manifestResource.url.host + (manifestResource.url.port != "" ? ":" + manifestResource.url.port : "") + cleanedPath;
			
			if (value.media.length == 1)  // Single Stream/Progressive Resource
			{
				media = value.media[0] as Media;
				url = media.url;
				
				var baseURLString:String = null;
				if (url.absolute)
				{
					// The server base URL needs to be extracted from the media's
					// URL.  Note that we assume it's the same for all media.
					baseURLString = media.url.rawUrl.substr(0, media.url.rawUrl.lastIndexOf("/"));
				}
				else if (value.baseURL != null)
				{
					baseURLString = value.baseURL.rawUrl;
				}
				else
				{
					baseURLString = manifestFolder;
				}
				
				if (url.absolute)
				{
					if (NetStreamUtils.isRTMPStream(url))
					{
						resource = new URLResource(new FMSURL(url.rawUrl));
					}
					else
					{
						resource = new URLResource(url);
					}					
				}				
				else if (value.baseURL != null)	// Relative to Base URL					
				{
					resource = new URLResource(new FMSURL(value.baseURL.rawUrl + "/" + url.rawUrl));
				}
				else // Relative to F4M file  (no absolute or base urls or rtmp urls).
				{
					resource = new URLResource(new URL(manifestFolder + "/" + url.rawUrl));
				}
				
				if (media.bootstrapInfo	!= null)
				{
					serverBaseURLs = new Vector.<String>();
					serverBaseURLs.push(baseURLString);
					
					bootstrapInfoURLString = media.bootstrapInfo.url ? media.bootstrapInfo.url.rawUrl : null;
					if (media.bootstrapInfo.url != null &&
						media.bootstrapInfo.url.absolute == false)
					{
						bootstrapInfoURLString = new URL(manifestFolder + "/" + bootstrapInfoURLString).rawUrl;
						media.bootstrapInfo.url = new URL(bootstrapInfoURLString);
					}
					metadataFacet = new KeyValueFacet(MetadataNamespaces.HTTP_STREAMING_METADATA);
					metadataFacet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_BOOTSTRAP_KEY), media.bootstrapInfo);
					if (serverBaseURLs.length > 0)
					{
						metadataFacet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_SERVER_BASE_URLS_KEY), serverBaseURLs);
					}
				}
				
				if (media.metadata != null)
				{
					if (metadataFacet == null)
					{
						metadataFacet = new KeyValueFacet(MetadataNamespaces.HTTP_STREAMING_METADATA);
					}
					metadataFacet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_STREAM_METADATA_KEY), media.metadata);					
				}
				
				if (media.xmp != null)
				{
					if (metadataFacet == null)
					{
						metadataFacet = new KeyValueFacet(MetadataNamespaces.HTTP_STREAMING_METADATA);
					}
					metadataFacet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_XMP_METADATA_KEY), media.xmp);					
				}

				if (media.drmAdditionalHeader != null)
				{					
					drmFacet = new KeyValueFacet(MetadataNamespaces.DRM_METADATA);
					if (Media(value.media[0]).drmAdditionalHeader != null && Media(value.media[0]).drmAdditionalHeader.data != null)
					{
						drmFacet.addValue(new ObjectIdentifier(MetadataNamespaces.DRM_ADDITIONAL_HEADER_KEY), Media(value.media[0]).drmAdditionalHeader.data);
						drmFacet.addValue(new ObjectIdentifier(MetadataNamespaces.DRM_CONTENT_METADATA_KEY), extractDRMMetadata(Media(value.media[0]).drmAdditionalHeader.data));
					}
				}
				
				if (metadataFacet != null)
				{
					resource.metadata.addFacet(metadataFacet);
				}
				if (drmFacet != null)
				{
					resource.metadata.addFacet(drmFacet);
				}				
			}
			else if (value.media.length > 1) // Dynamic Streaming
			{
				var baseURL:URL = value.baseURL != null ? new FMSURL(value.baseURL.rawUrl) : new URL(manifestFolder);
				serverBaseURLs = new Vector.<String>();
				serverBaseURLs.push(baseURL.rawUrl);
				
				// TODO: MBR streams can be absolute (with no baseURL) or relative (with a baseURL).
				// But we need to map them into the DynamicStreamingResource object model, which
				// assumes the latter.  For now, we only support the latter input, but we should
				// add support for the former (absolute URLs with no base URL).
				var dynResource:DynamicStreamingResource = new DynamicStreamingResource(baseURL, value.streamType);
				
				dynResource.streamItems = new Vector.<DynamicStreamingItem>();
				
				metadataFacet = new KeyValueFacet(MetadataNamespaces.HTTP_STREAMING_METADATA);
				dynResource.metadata.addFacet(metadataFacet);
				metadataFacet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_SERVER_BASE_URLS_KEY), serverBaseURLs);
				
				for each (media in value.media)
				{	
					var stream:String;
					
					if (media.url.absolute)
					{
						stream = NetStreamUtils.getStreamNameFromURL(media.url);
					}
					else
					{
						stream = media.url.rawUrl;
					}					
					var item:DynamicStreamingItem = new DynamicStreamingItem(stream, media.bitrate, media.width, media.height);
					dynResource.streamItems.push(item);
					if (media.drmAdditionalHeader != null)
					{						
						if (dynResource.metadata.getFacet(MetadataNamespaces.DRM_METADATA) == null)
						{
							drmFacet = new KeyValueFacet(MetadataNamespaces.DRM_METADATA);
							dynResource.metadata.addFacet(drmFacet);
						}						
						if (media.drmAdditionalHeader != null && media.drmAdditionalHeader.data != null)
						{
							drmFacet.addValue(new ObjectIdentifier(item), extractDRMMetadata(media.drmAdditionalHeader.data));	
							drmFacet.addValue(new ObjectIdentifier(MetadataNamespaces.DRM_ADDITIONAL_HEADER_KEY + item.streamName), media.drmAdditionalHeader.data);
						} 						
					}
					
					if (media.bootstrapInfo	!= null)
					{
						bootstrapInfoURLString = media.bootstrapInfo.url ? media.bootstrapInfo.url.rawUrl : null;
						if (media.bootstrapInfo.url != null &&
							media.bootstrapInfo.url.absolute == false)
						{
							bootstrapInfoURLString = new URL(manifestFolder + "/" + bootstrapInfoURLString).rawUrl;
							media.bootstrapInfo.url = new URL(bootstrapInfoURLString); 
						}
						metadataFacet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_BOOTSTRAP_KEY + item.streamName), media.bootstrapInfo);
					}
			
					if (media.metadata != null)
					{
						metadataFacet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_STREAM_METADATA_KEY + item.streamName), media.metadata);					
					}
					
					if (media.xmp != null)
					{
						metadataFacet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_XMP_METADATA_KEY + item.streamName), media.xmp);					
					}
				}
				resource = dynResource;
			}
			else if (value.baseURL == null)
			{	
				// This is a parse error, we need an rtmp url
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.F4M_PARSE_MEDIA_URL_MISSING));					
			}	
			
			if (value.mimeType != null)
			{
				resource.metadata.addFacet(new MediaTypeFacet(MediaType.VIDEO, value.mimeType));			
			}
			
			//Add subclip metadata from original resource
			if (manifestResource.metadata.getFacet(MetadataNamespaces.SUBCLIP_METADATA))
			{
				resource.metadata.addFacet(manifestResource.metadata.getFacet(MetadataNamespaces.SUBCLIP_METADATA));
			}		
			
			return resource;
		}
		
		private function extractDRMMetadata(data:ByteArray):ByteArray
		{
			var metadata:ByteArray = null;
			
			data.position = 0;
			data.objectEncoding = 0;
			
			try
			{
				var header:Object = data.readObject();
				var encryption:Object = data.readObject();
				var enc:Object = encryption["Encryption"];
				var params:Object = enc["Params"];
				var keyInfo:Object = params["KeyInfo"];
				var fmrmsMetadata:Object = keyInfo["FMRMS_METADATA"];
				var drmMetadata:String = fmrmsMetadata["Metadata"] as String;

				var decoder:Base64Decoder = new Base64Decoder();
				decoder.decode(drmMetadata);
				metadata = decoder.drain();
			}
			catch (e:Error)
			{
				metadata = null;	
			}
			
			return metadata;
		}
	}
}