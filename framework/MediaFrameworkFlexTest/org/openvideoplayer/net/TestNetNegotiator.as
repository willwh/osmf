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
package org.openvideoplayer.net
{


	import flash.net.NetConnection;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.events.MediaErrorCodes;
	import org.openvideoplayer.events.NetNegotiatorEvent;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.netmocker.MockNetNegotiator;
	import org.openvideoplayer.netmocker.NetConnectionExpectation;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.utils.TestConstants;
	import org.openvideoplayer.utils.URL;



	public class TestNetNegotiator extends TestCase
	{
		
		public function testConnectMethodWithGoodResource():void
		{
			// test protocols
			doTestConnectMethodWithGoodResource(new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO_RTMP)));
			doTestConnectMethodWithGoodResource(new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO_RTMPE)));
			doTestConnectMethodWithGoodResource(new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO_RTMPTE)));
			doTestConnectMethodWithGoodResource(new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO_RTMPS)));
			doTestConnectMethodWithGoodResource(new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO_RTMPT)));
			
			// test ports
			doTestConnectMethodWithGoodResource(new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO_1935)));
			doTestConnectMethodWithGoodResource(new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO_443)));
			doTestConnectMethodWithGoodResource(new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO_80)));
			
			// Test URL instead of FMSURL
			doTestConnectMethodWithGoodResource(new URLResource(new URL(TestConstants.REMOTE_STREAMING_VIDEO_RTMP)));

		}
		public function testConnectMethodWithBadResource():void
		{
			doTestConnectMethodWithBadResource();
		}
		
		public function testDirectConnectMethodWithBadResource():void
		{
			// The purpose of this test is to ensure coverage of the createNetConnection class
			// which is otherwise overr-ridden by NetMocker. We test with an intentionally bad URL so that
			// the outcome of the test is not dependent on connectivity.
			doTestDirectConnectMethodWithBadResource();
		}
		
		public function testErrors():void
		{
			// test IO Error
			doTestError(NetConnectionExpectation.IO_ERROR,MediaErrorCodes.NETCONNECTION_IO_ERROR);
		
			// test Argument Error
			doTestError(NetConnectionExpectation.ARGUMENT_ERROR,MediaErrorCodes.NETCONNECTION_ARGUMENT_ERROR);
			
			// test Security Error
			doTestError(NetConnectionExpectation.SECURITY_ERROR,MediaErrorCodes.NETCONNECTION_SECURITY_ERROR);
		}
		
		/////////////////////////////////////////
		
		
		private function doTestConnectMethodWithGoodResource(resource:URLResource):void
		{
			var negotiator:NetNegotiator = createNetNegotiator(NetConnectionExpectation.VALID_CONNECTION);
			negotiator.addEventListener(NetNegotiatorEvent.CONNECTED,onConnected);
			negotiator.connect(resource);
			
			function onConnected(event:NetNegotiatorEvent):void
			{
				assertTrue(event.type == NetNegotiatorEvent.CONNECTED);
				assertTrue(event.netConnection is NetConnection);
				assertTrue(event.netConnection.connected);
				assertTrue(event.mediaError == null)
			}
		}
		
		private function doTestConnectMethodWithBadResource():void
		{
			var negotiator:NetNegotiator = createNetNegotiator(NetConnectionExpectation.REJECTED_CONNECTION);
			negotiator.addEventListener(NetNegotiatorEvent.CONNECTION_FAILED,onConnectionFailed);
			negotiator.connect(UNSUCCESSFUL_RESOURCE);
			function onConnectionFailed(event:NetNegotiatorEvent):void
			{
				assertTrue(event.type == NetNegotiatorEvent.CONNECTION_FAILED);
				assertTrue(event.netConnection == null);
				assertTrue(event.mediaError.errorCode == MediaErrorCodes.NETCONNECTION_REJECTED);
			}
		}
		
		private function doTestDirectConnectMethodWithBadResource():void
		{
			var negotiator:NetNegotiator = new NetNegotiator();
			negotiator.addEventListener(NetNegotiatorEvent.CONNECTION_FAILED,onConnectionFailed);
			negotiator.connect(UNSUCCESSFUL_RESOURCE);
			function onConnectionFailed(event:NetNegotiatorEvent):void
			{
				assertTrue(event.type == NetNegotiatorEvent.CONNECTION_FAILED);
				assertTrue(event.netConnection == null);
				assertTrue(event.mediaError.errorCode == MediaErrorCodes.NETCONNECTION_FAILED);
			}
		}
		
		private function doTestError(expectation:NetConnectionExpectation,errorCode:Number):void
		{
			var negotiator:NetNegotiator = createNetNegotiator(expectation);
			negotiator.addEventListener(NetNegotiatorEvent.CONNECTION_FAILED,onConnectionFailed);
			negotiator.connect(SUCCESSFUL_RESOURCE);
			
			function onConnectionFailed(event:NetNegotiatorEvent):void
			{
				assertTrue(event.type == NetNegotiatorEvent.CONNECTION_FAILED);
				assertTrue(event.netConnection == null);
				assertTrue(event.mediaError.errorCode == errorCode);
			}
		}
	
		
		private function createNetNegotiator(expectation:NetConnectionExpectation):NetNegotiator
		{
			var negotiator:MockNetNegotiator = new MockNetNegotiator();
			negotiator.netConnectionExpectation = expectation;
			return negotiator;
		}
		
		private static const SUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO));
		private static const UNSUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.INVALID_STREAMING_VIDEO));
		
		
	}
	
}