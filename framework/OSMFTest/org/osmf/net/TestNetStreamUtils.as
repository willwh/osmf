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
	
	import flexunit.framework.TestCase;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.net.httpstreaming.HTTPStreamingUtils;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.NullResource;
	import org.osmf.utils.URL;
	
	public class TestNetStreamUtils extends TestCase
	{
		public function testGetStreamType():void
		{
			assertTrue(NetStreamUtils.getStreamType(null) == StreamType.ANY);
			assertTrue(NetStreamUtils.getStreamType(new NullResource()) == StreamType.ANY);
			assertTrue(NetStreamUtils.getStreamType(new URLResource(new URL("rtmp://example.com"))) == StreamType.ANY);
			assertTrue(NetStreamUtils.getStreamType(new StreamingURLResource(new URL("rtmp://example.com"))) == StreamType.ANY);
			assertTrue(NetStreamUtils.getStreamType(new StreamingURLResource(new URL("rtmp://example.com"), StreamType.ANY)) == StreamType.ANY);
			assertTrue(NetStreamUtils.getStreamType(new StreamingURLResource(new URL("rtmp://example.com"), StreamType.LIVE)) == StreamType.LIVE);
			assertTrue(NetStreamUtils.getStreamType(new StreamingURLResource(new URL("rtmp://example.com"), StreamType.RECORDED)) == StreamType.RECORDED);
			assertTrue(NetStreamUtils.getStreamType(new DynamicStreamingResource(new URL("rtmp://example.com"))) == StreamType.ANY);
			assertTrue(NetStreamUtils.getStreamType(new DynamicStreamingResource(new URL("rtmp://example.com"), StreamType.ANY)) == StreamType.ANY);
			assertTrue(NetStreamUtils.getStreamType(new DynamicStreamingResource(new URL("rtmp://example.com"), StreamType.LIVE)) == StreamType.LIVE);
			assertTrue(NetStreamUtils.getStreamType(new DynamicStreamingResource(new URL("rtmp://example.com"), StreamType.RECORDED)) == StreamType.RECORDED);
		}

		public function testGetStreamNameFromURL():void
		{
			assertTrue(NetStreamUtils.getStreamNameFromURL(null) == "");
			assertTrue(NetStreamUtils.getStreamNameFromURL(new URL("")) == "");
			assertTrue(NetStreamUtils.getStreamNameFromURL(new URL("http://example.com/example")) == "http://example.com/example");
			assertTrue(NetStreamUtils.getStreamNameFromURL(new URL("rtmp://example.com/app")) == "");
			assertTrue(NetStreamUtils.getStreamNameFromURL(new URL("rtmp://example.com/app/stream")) == "stream");
			assertTrue(NetStreamUtils.getStreamNameFromURL(new URL("rtmp://example.com/app/stream?foo=bar")) == "stream?foo=bar");
			assertTrue(NetStreamUtils.getStreamNameFromURL(new URL("rtmp://example.com/app/stream1/stream2")) == "stream1/stream2");
			assertTrue(NetStreamUtils.getStreamNameFromURL(new FMSURL("rtmp://example.com/app/stream1/stream2/stream3")) == "stream1/stream2/stream3");
			assertTrue(NetStreamUtils.getStreamNameFromURL(new FMSURL("rtmp://example.com/app/stream1/stream2/stream3", true)) == "stream2/stream3");
		}
		
		public function testIsRTMPStream():void
		{
			assertTrue(NetStreamUtils.isRTMPStream(null) == false);
			assertTrue(NetStreamUtils.isRTMPStream(new URL("")) == false);
			assertTrue(NetStreamUtils.isRTMPStream(new URL("http://example.com")) == false);
			assertTrue(NetStreamUtils.isRTMPStream(new URL("rtmfp://example.com")) == false);
			assertTrue(NetStreamUtils.isRTMPStream(new URL("rtmp")) == false);

			assertTrue(NetStreamUtils.isRTMPStream(new URL("rtmp://example.com")) == true);
			assertTrue(NetStreamUtils.isRTMPStream(new URL("rtmpe://example.com")) == true);
			assertTrue(NetStreamUtils.isRTMPStream(new URL("rtmpt://example.com")) == true);
			assertTrue(NetStreamUtils.isRTMPStream(new URL("rtmpte://example.com")) == true);
			assertTrue(NetStreamUtils.isRTMPStream(new URL("rtmps://example.com")) == true);
		}

		public function testIsStreamingResource():void
		{
			assertTrue(NetStreamUtils.isStreamingResource(null) == false);
			assertTrue(NetStreamUtils.isStreamingResource(new NullResource()) == false);
			assertTrue(NetStreamUtils.isStreamingResource(new URLResource(new URL(""))) == false);
			assertTrue(NetStreamUtils.isStreamingResource(new URLResource(new URL("http://example.com"))) == false);
			assertTrue(NetStreamUtils.isStreamingResource(new URLResource(new URL("rtmfp://example.com"))) == false);
			assertTrue(NetStreamUtils.isStreamingResource(new URLResource(new URL("rtmp"))) == false);
			assertTrue(NetStreamUtils.isStreamingResource(new DynamicStreamingResource(new URL(""))) == false);
			assertTrue(NetStreamUtils.isStreamingResource(new DynamicStreamingResource(new URL("http://example.com"))) == false);
			assertTrue(NetStreamUtils.isStreamingResource(new DynamicStreamingResource(new URL("rtmfp://example.com"))) == false);
			assertTrue(NetStreamUtils.isStreamingResource(new DynamicStreamingResource(new URL("rtmp"))) == false);

			assertTrue(NetStreamUtils.isStreamingResource(new URLResource(new URL("rtmp://example.com"))) == true);
			assertTrue(NetStreamUtils.isStreamingResource(new URLResource(new URL("rtmpe://example.com"))) == true);
			assertTrue(NetStreamUtils.isStreamingResource(new URLResource(new URL("rtmpt://example.com"))) == true);
			assertTrue(NetStreamUtils.isStreamingResource(new URLResource(new URL("rtmpte://example.com"))) == true);
			assertTrue(NetStreamUtils.isStreamingResource(new URLResource(new URL("rtmps://example.com"))) == true);
			assertTrue(NetStreamUtils.isStreamingResource(new DynamicStreamingResource(new URL("rtmp://example.com"))) == true);
			assertTrue(NetStreamUtils.isStreamingResource(new DynamicStreamingResource(new URL("rtmpe://example.com"))) == true);
			assertTrue(NetStreamUtils.isStreamingResource(new DynamicStreamingResource(new URL("rtmpt://example.com"))) == true);
			assertTrue(NetStreamUtils.isStreamingResource(new DynamicStreamingResource(new URL("rtmpte://example.com"))) == true);
			assertTrue(NetStreamUtils.isStreamingResource(new DynamicStreamingResource(new URL("rtmps://example.com"))) == true);
			
			CONFIG::FLASH_10_1
			{
				var resource:URLResource = new URLResource(new URL("http://example.com"));
				var serverBaseURLs:Vector.<String> = new Vector.<String>();
				resource.metadata.addFacet(HTTPStreamingUtils.createHTTPStreamingMetadataFacet("http://example.com/abstURL", null, serverBaseURLs));
				assertTrue(NetStreamUtils.isStreamingResource(resource));
			}
		}
		
		public function testGetPlayArgsForResource():void
		{
			// First try some negative/default cases.
			//
			
			var resource:MediaResourceBase = null;
			var result:Object = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == NetStreamUtils.PLAY_START_ARG_ANY &&
					   result["len"] == NetStreamUtils.PLAY_LEN_ARG_ALL);

			resource = new NullResource();
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == NetStreamUtils.PLAY_START_ARG_ANY &&
					   result["len"] == NetStreamUtils.PLAY_LEN_ARG_ALL);

			resource = new URLResource(new URL("http://example.com"));
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == NetStreamUtils.PLAY_START_ARG_ANY &&
					   result["len"] == NetStreamUtils.PLAY_LEN_ARG_ALL);

			resource = new StreamingURLResource(new URL("rtmp://example.com"));
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == NetStreamUtils.PLAY_START_ARG_ANY &&
					   result["len"] == NetStreamUtils.PLAY_LEN_ARG_ALL);

			// Now try with positive/non-default cases.
			//
			
			resource = new StreamingURLResource(new URL("rtmp://example.com"), StreamType.RECORDED);
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == NetStreamUtils.PLAY_START_ARG_RECORDED &&
					   result["len"] == NetStreamUtils.PLAY_LEN_ARG_ALL);

			resource = new StreamingURLResource(new URL("rtmp://example.com"), StreamType.LIVE);
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == NetStreamUtils.PLAY_START_ARG_LIVE &&
					   result["len"] == NetStreamUtils.PLAY_LEN_ARG_ALL);

			resource = new DynamicStreamingResource(new URL("rtmp://example.com"), StreamType.RECORDED);
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == NetStreamUtils.PLAY_START_ARG_RECORDED &&
					   result["len"] == NetStreamUtils.PLAY_LEN_ARG_ALL);

			resource = new DynamicStreamingResource(new URL("rtmp://example.com"), StreamType.LIVE);
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == NetStreamUtils.PLAY_START_ARG_LIVE &&
					   result["len"] == NetStreamUtils.PLAY_LEN_ARG_ALL);
					   
			resource = new StreamingURLResource(new URL("rtmp://example.com"));
			var kvFacet:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.SUBCLIP_METADATA);
			resource.metadata.addFacet(kvFacet);
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == NetStreamUtils.PLAY_START_ARG_RECORDED &&
					   result["len"] == NetStreamUtils.PLAY_LEN_ARG_ALL);

			resource = new StreamingURLResource(new URL("rtmp://example.com"));
			kvFacet = new KeyValueFacet(MetadataNamespaces.SUBCLIP_METADATA);
			kvFacet.addValue(MetadataNamespaces.SUBCLIP_START_ID, 10);
			kvFacet.addValue(MetadataNamespaces.SUBCLIP_END_ID, 15);
			resource.metadata.addFacet(kvFacet);
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == 10 &&
					   result["len"] == 5);

			resource = new StreamingURLResource(new URL("rtmp://example.com"));
			kvFacet = new KeyValueFacet(MetadataNamespaces.SUBCLIP_METADATA);
			kvFacet.addValue(MetadataNamespaces.SUBCLIP_START_ID, 10);
			resource.metadata.addFacet(kvFacet);
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == 10 &&
					   result["len"] == NetStreamUtils.PLAY_LEN_ARG_ALL);

			resource = new StreamingURLResource(new URL("rtmp://example.com"));
			kvFacet = new KeyValueFacet(MetadataNamespaces.SUBCLIP_METADATA);
			kvFacet.addValue(MetadataNamespaces.SUBCLIP_END_ID, 15);
			resource.metadata.addFacet(kvFacet);
			result = NetStreamUtils.getPlayArgsForResource(resource);
			assertTrue(result["start"] == NetStreamUtils.PLAY_START_ARG_RECORDED &&
					   result["len"] == 15);
		}
	}
}