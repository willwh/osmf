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
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.net.httpstreaming.HTTPStreamingUtils;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.URL;
	
	[ExcludeClass]
	
	/**
	 * @private
	 */
	public class NetStreamUtils
	{
		/**
		 * Returns the stream name to be passed to NetStream for a given URL,
		 * the empty string if no such stream name can be extracted.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function getStreamNameFromURL(url:URL):String
		{
			var streamName:String = "";
			
			// The stream name varies based on RTMP vs. progressive.
			if (url != null)
			{
				if (isRTMPStream(url))
				{
					var fmsURL:FMSURL = url as FMSURL;
					if (fmsURL == null)
					{
						fmsURL = new FMSURL(url.rawUrl);
					}
	
					streamName = fmsURL.streamName;
	
					// Add optional query parameters to the stream name.
					if (url.query != null && url.query != "")
					{
						 streamName += "?" + url.query;
					}
				}
				else
				{
					streamName = url.rawUrl;
				}
			}
			
			return streamName;
		}
		
		/**
		 * Returns true if the given resource represents a streaming resource, false otherwise.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function isStreamingResource(resource:MediaResourceBase):Boolean
		{
			var result:Boolean = false;
			
			if (resource != null)
			{
				var urlResource:URLResource = resource as URLResource;
				if (urlResource != null)
				{
					result = 		NetStreamUtils.isRTMPStream(urlResource.url)
								||	HTTPStreamingUtils.getHTTPStreamingMetadataFacet(urlResource) != null;
				}
			}
			
			return result;
		}

		/**
		 * Returns true if the given URL represents an RTMP stream, false otherwise.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function isRTMPStream(url:URL):Boolean
		{
			var result:Boolean = false;
			
			if (url != null)
			{			
				var protocol:String = url.protocol;
				if (protocol != null && protocol.length > 0)
				{
					result = (protocol.search(/^rtmp$|rtmp[tse]$|rtmpte$/i) != -1);
				}
			}
			
			return result;
		}
				
		/**
		 * Returns the stream type of the given resource.
		 * 
		 * @returns One of the stream types defined in org.osmf.net.StreamType
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function getStreamType(resource:MediaResourceBase):String
		{
			// Default to ANY.
			var streamType:String = StreamType.ANY;
			
			var streamingURLResource:StreamingURLResource = resource as StreamingURLResource;

			if (streamingURLResource != null)
			{
				streamType = streamingURLResource.streamType;
			}

			return streamType;
		}
		
		/**
		 * Returns the value of the "start" and "len" arguments for
		 * NetStream.play, based on the specified resource.  Checks for
		 * live vs. recorded, subclips, etc.  The results are returned
		 * in an untyped Object where the start value maps to "start"
		 * and the len value maps to "len".
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function getPlayArgsForResource(resource:MediaResourceBase):Object
		{
			var startArg:int = PLAY_START_ARG_ANY;
			var lenArg:int = PLAY_LEN_ARG_ALL;
			
			// Check for live vs. recorded.
			switch (getStreamType(resource))
			{
				case StreamType.ANY:
					startArg = PLAY_START_ARG_ANY;
					break;
				case StreamType.LIVE:
					startArg = PLAY_START_ARG_LIVE;
					break;
				case StreamType.RECORDED:
					startArg = PLAY_START_ARG_RECORDED;
					break;
			}
			
			// Check for subclip metadata (which is ignored for live).
			if (startArg != PLAY_START_ARG_LIVE &&
				resource != null)
			{
				var kvFacet:KeyValueFacet = resource.metadata.getFacet(MetadataNamespaces.SUBCLIP_METADATA) as KeyValueFacet;
				if (kvFacet != null)
				{
					startArg = kvFacet.getValue(MetadataNamespaces.SUBCLIP_START_ID);
					if (isNaN(startArg))
					{
						startArg = PLAY_START_ARG_RECORDED;
					}
					var subclipEndTime:Number = kvFacet.getValue(MetadataNamespaces.SUBCLIP_END_ID);
					if (!isNaN(subclipEndTime))
					{
						// Disallow negative durations.  And make sure we don't
						// subtract the startArg if it's ANY.
						lenArg = Math.max(0, subclipEndTime - Math.max(0, startArg));
					}
				}
			}
			
			return {start:startArg, len:lenArg};
		}
		
		// Consts for the NetStream.play() method
		public static const PLAY_START_ARG_ANY:int = -2;
		public static const PLAY_START_ARG_LIVE:int = -1;
		public static const PLAY_START_ARG_RECORDED:int = 0;
		public static const PLAY_LEN_ARG_ALL:int = -1;
	}
}