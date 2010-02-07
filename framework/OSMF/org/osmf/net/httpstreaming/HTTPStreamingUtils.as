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
package org.osmf.net.httpstreaming
{
	import __AS3__.vec.Vector;
	
	import flash.utils.ByteArray;
	
	import org.osmf.manifest.BootstrapInfo;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.Facet;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.net.dynamicstreaming.DynamicStreamingItem;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FIndexInfo;
	import org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FStreamInfo;
	
	/**
	 * Contains a set of HTTP streaming-related utility functions.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class HTTPStreamingUtils
	{
		/**
		 * This is a convenience function to create the metadata facet for HTTP streaming.
		 * Usually, either abstUrl or abstData is not null. 
		 * 
		 * @param abstUrl The URL that points to the bootstrap information.
		 * @param abstData The byte array that contains the bootstrap information
		 * @param serverBaseUrls The list of server base URLs.
		 * 
		 * @return The facet.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function createHTTPStreamingMetadataFacet(abstUrl:String, abstData:ByteArray, serverBaseUrls:Vector.<String>):Facet
		{
			var facet:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.HTTP_STREAMING_METADATA);
			if (abstUrl != null && abstUrl.length > 0)
			{
				facet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_ABST_URL_KEY), abstUrl);
			}
			if (abstData != null)
			{
				facet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_ABST_DATA_KEY), abstData);
			}
			if (serverBaseUrls != null && serverBaseUrls.length > 0)
			{
				facet.addValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_SERVER_BASE_URLS_KEY), serverBaseUrls);
			}
			return facet;
		}
		
		/**
		 * @private
		 * 
		 * Given a resource of type MediaResourceBase, it checks whether the resource is suitable for 
		 * HTTP streaming. The criteria is as follows:
		 * 
		 * 1. If the resource is of type URLResource
		 * 2. If the resource has a KeyValueFacet under the namespace MetadataNamespaces.HTTP_STREAMING_METADATA
		 * 3. If the KeyValueFacet contains a URL that points to the bootstrap information or if the KeyValueFacet
		 *    contains the bytes of the bootstrap information. Either is fine but cannot be absent at the same time.
		 * 
		 * If all three criteria are satisfied, the Facet will be returned. Otherwise, null.
		 * 
		 * @param resource The MediaResourceBase to be loaded
		 * 
		 * @return The Facet if the resource can be loaded for HTTP streaming, null otherwise.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function getHTTPStreamingMetadataFacet(resource:MediaResourceBase):Facet
		{
			// This is how we prevent HTTP streamed playback in pre-10.1 players.
			var httpStreamingSupported:Boolean = false;
			CONFIG::FLASH_10_1
			{
				httpStreamingSupported = true;
			}
			if (httpStreamingSupported == false)
			{
				return null;
			}
			
			var facet:Facet = null;
			
			var urlResource:URLResource = resource as URLResource;
			if (urlResource != null)
			{
				facet = urlResource.metadata.getFacet(MetadataNamespaces.HTTP_STREAMING_BOOTSTRAP) as KeyValueFacet;
			}
			
			return facet;
		}
		
		/**
		 * @private
		 **/
		public static function createF4FIndexInfo(resource:URLResource):HTTPStreamingF4FIndexInfo
		{
			var indexInfo:HTTPStreamingF4FIndexInfo = null;
			
			var httpFacet:Facet = getHTTPStreamingMetadataFacet(resource);
			if (httpFacet != null)
			{
				var serverBaseURLs:Vector.<String>
					= httpFacet.getValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_SERVER_BASE_URLS_KEY)) as Vector.<String>;
				
				var streamInfos:Vector.<HTTPStreamingF4FStreamInfo> = generateStreamInfos(resource);
				
				indexInfo =
					new HTTPStreamingF4FIndexInfo
						( 
						serverBaseURLs != null && serverBaseURLs.length > 0 ? serverBaseURLs[0] : null
						, streamInfos
						);
			}
			
			return indexInfo;
		}
		
		private static function generateStreamInfos(resource:URLResource):Vector.<HTTPStreamingF4FStreamInfo>
		{
			var streamInfos:Vector.<HTTPStreamingF4FStreamInfo> = new Vector.<HTTPStreamingF4FStreamInfo>();
			
			var drmFacet:KeyValueFacet 
				= resource.metadata.getFacet(MetadataNamespaces.DRM_METADATA) as KeyValueFacet;
			var bootstrapFacet:KeyValueFacet
				= resource.metadata.getFacet(MetadataNamespaces.HTTP_STREAMING_BOOTSTRAP) as KeyValueFacet;
			var additionalHeader:ByteArray = null;
			var bootstrap:BootstrapInfo = null;
			var dsResource:DynamicStreamingResource = resource as DynamicStreamingResource;
			if (dsResource != null)
			{
				for each (var streamItem:DynamicStreamingItem in dsResource.streamItems)
				{
					if (drmFacet != null)
					{
						additionalHeader = drmFacet.getValue(
							new ObjectIdentifier(MetadataNamespaces.DRM_ADDITIONAL_HEADER_KEY + streamItem.streamName)) as ByteArray;
					}
					if (bootstrapFacet != null)
					{
						bootstrap = bootstrapFacet.getValue(
							new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_BOOTSTRAP_KEY + streamItem.streamName)) as BootstrapInfo;
					}
					streamInfos.push(new HTTPStreamingF4FStreamInfo(bootstrap, streamItem.streamName, streamItem.bitrate, additionalHeader));
				}
			}
			else
			{
				if (drmFacet != null)
				{
					additionalHeader 
						= drmFacet.getValue(new ObjectIdentifier(MetadataNamespaces.DRM_ADDITIONAL_HEADER_KEY)) as ByteArray;
				}
				if (bootstrapFacet != null)
				{
					bootstrap = bootstrapFacet.getValue(
						new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_BOOTSTRAP_KEY)) as BootstrapInfo;
				}
				
				var streamName:String = resource.url.rawUrl.substr(resource.url.rawUrl.lastIndexOf("/")+1);
				streamInfos.push(new HTTPStreamingF4FStreamInfo(bootstrap, streamName, NaN, additionalHeader));
			}

			return streamInfos;
		}
	}
}