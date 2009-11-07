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
	import flexunit.framework.TestCase;
	
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.URL;
	
	public class TestNetStreamUtils extends TestCase
	{
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
	}
}