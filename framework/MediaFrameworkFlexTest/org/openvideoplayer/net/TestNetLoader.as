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
	import __AS3__.vec.Vector;
	
	import org.openvideoplayer.loaders.TestILoader;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.netmocker.MockNetLoader;
	import org.openvideoplayer.netmocker.NetConnectionExpectation;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.NetFactory;
	import org.openvideoplayer.utils.NullResource;
	import org.openvideoplayer.utils.TestConstants;

	public class TestNetLoader extends TestILoader
	{
		override public function setUp():void
		{
			netFactory = new NetFactory();

			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			netFactory = null;
		}

		override public function testCanHandleResource():void
		{
			super.testCanHandleResource();
			
			// Verify some valid resources.
	    	assertTrue(loader.canHandleResource(new URLResource("http://example.com/test")));	    	
		   	assertTrue(loader.canHandleResource(new URLResource("https://example.com/test")));
		   	assertTrue(loader.canHandleResource(new URLResource("http://example.com:8080")));
		   	assertTrue(loader.canHandleResource(new URLResource("file://example.com/test")))
		   	assertTrue(loader.canHandleResource(new URLResource("example.com/test.mp3")));		    	
	    	assertTrue(loader.canHandleResource(new URLResource("rtmp://example.com/test")));	    	
	    	assertTrue(loader.canHandleResource(new URLResource("rtmps://example.com/test")));	    	
	    	assertTrue(loader.canHandleResource(new URLResource("rtmpe://example.com/test")));	    	    	
	    	assertTrue(loader.canHandleResource(new URLResource("rtmpte://example.com/test")));
	    	assertTrue(loader.canHandleResource(new URLResource("rtmp://example.com:8080/appname/test")));
	    	assertTrue(loader.canHandleResource(new URLResource("rtmp://example.com/appname/filename.flv")));
	    	assertTrue(loader.canHandleResource(new URLResource("rtmpte://example.com:8080/appname/mp4:filename.mp4")));
	    	
	    	
			 
			// And some invalid ones.
	    	assertFalse(loader.canHandleResource(new URLResource("javascript://test.com/test.flv")) );
	    	assertFalse(loader.canHandleResource(new URLResource("rtmpet://example.com/test")));	    	
			assertFalse(loader.canHandleResource(new URLResource("httpt://example.com/video.foo")));
			assertFalse(loader.canHandleResource(new URLResource("foo")));
			assertFalse(loader.canHandleResource(new URLResource("example.com/test.flv")));
			assertFalse(loader.canHandleResource(new URLResource("")));
			assertFalse(loader.canHandleResource(new URLResource(null)));
			assertFalse(loader.canHandleResource(new NullResource()));
			assertFalse(loader.canHandleResource(null));
		}

		//---------------------------------------------------------------------
				
		override protected function createInterfaceObject(... args):Object
		{
			return netFactory.createNetLoader();
		}
		
		override protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			var mockLoader:MockNetLoader = loader as MockNetLoader;
			if (mockLoader)
			{
				if (resource == successfulResource)
				{
					mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
				}
				else if (resource == failedResource)
				{
					mockLoader.netConnectionExpectation = NetConnectionExpectation.REJECTED_CONNECTION;
				}
				else if (resource == unhandledResource)
				{
					mockLoader.netConnectionExpectation = NetConnectionExpectation.REJECTED_CONNECTION;
				}
			}
			return new LoadableTrait(loader, resource);
		}
		
		override protected function get successfulResource():IMediaResource
		{
			return SUCCESSFUL_RESOURCE;
		}

		override protected function get failedResource():IMediaResource
		{
			return UNSUCCESSFUL_RESOURCE;
		}

		override protected function get unhandledResource():IMediaResource
		{
			return UNHANDLED_RESOURCE;
		}
		
		public function testTimeout():void
		{
			(loader as NetLoader).timeout = TIMEOUT_VALUE;
			assertTrue((loader as NetLoader).timeout == TIMEOUT_VALUE);
		}
		
		public function testBuildPortprotocolSequence():void
		{
			doPortProtocolSequenceTest(SUCCESSFUL_RESOURCE,DEFAULT_PORT_PROTOCOL_RESULT);
			doPortProtocolSequenceTest(RESOURCE_WITH_PORT_PROTOCOL,RTMPTE_443_RESULT);
		}
		
		private function doPortProtocolSequenceTest(resource:URLResource,correctResult:String):void
		{
			var sequence:Vector.<NetConnectionAttempt> = (loader as MockNetLoader).testBuildPortProtocolSequence(resource);
			var result:String = "";
			for (var i:int = 0; i< sequence.length; i++)
			{
				result += sequence[i].port + sequence[i].protocol;
			}
			assertTrue(result == correctResult);
		}
		
		public function testBuildConnectionAddress():void
		{
			doBuildConnectionAddressTest(SUCCESSFUL_RESOURCE,RTMPTE,PORT_443,TestConstants.CONNECT_ADDRESS_REMOTE_WITH_RTMPTE_443);
		}
		
		private function doBuildConnectionAddressTest(resource:URLResource,protocol:String,port:String,correctResult:String):void
		{
			assertTrue((loader as MockNetLoader).testBuildConnectionAddress(resource,protocol,port) == correctResult);
		}
		
		private var netFactory:NetFactory;
		
		private static const SUCCESSFUL_RESOURCE:URLResource = new URLResource(TestConstants.REMOTE_STREAMING_VIDEO);
		private static const UNSUCCESSFUL_RESOURCE:URLResource = new URLResource(TestConstants.INVALID_STREAMING_VIDEO);
		private static const UNHANDLED_RESOURCE:NullResource = new NullResource();
		private static const TIMEOUT_VALUE:Number = 15000;
		private static const PORT_443:String = "443";
		private static const RTMPTE:String = "rtmpte";
		private static const DEFAULT_PORT_PROTOCOL_RESULT:String = TestConstants.DEFAULT_PORT_PROTOCOL_RESULT;
		private static const RTMPTE_443_RESULT:String = TestConstants.RESULT_FOR_RTMPTE_443;
		private static const RESOURCE_WITH_PORT_PROTOCOL:URLResource = new URLResource(TestConstants.REMOTE_STREAMING_VIDEO_WITH_PORT_PROTOCOL);
		
	}
}