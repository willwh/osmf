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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MediaTypeFacet;
	import org.osmf.netmocker.DefaultNetConnectionFactory;
	import org.osmf.netmocker.IMockNetLoader;
	import org.osmf.netmocker.MockNetLoader;
	import org.osmf.netmocker.NetConnectionExpectation;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.TestLoaderBase;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.NetFactory;
	import org.osmf.utils.NullResource;
	import org.osmf.utils.TestConstants;
	import org.osmf.utils.URL;

	public class TestNetLoader extends TestLoaderBase
	{
		override public function setUp():void
		{
			netFactory = createNetFactory();
			eventDispatcher = new EventDispatcher();

			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			netFactory = null;
			eventDispatcher = null;
		}

		override public function testCanHandleResource():void
		{
			super.testCanHandleResource();
			
			// Verify some valid remote resources.
	    	assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/test"))));	    	
		   	assertTrue(loader.canHandleResource(new URLResource(new URL("https://example.com/test"))));
		   	assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com:8080"))));
		   	assertTrue(loader.canHandleResource(new URLResource(new URL("file://example.com/test"))));
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmp://example.com/test"))));	    	
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmps://example.com/test"))));	    	
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmpe://example.com/test"))));	    	    	
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmpte://example.com/test"))));
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmp://example.com:8080/appname/test"))));
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmp://example.com/appname/filename.flv"))));
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmpte://example.com:8080/appname/mp4:filename.mp4"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("example.com/test.flv"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/test.flv?param=value"))));
	    	
			// And some invalid ones.
	    	assertFalse(loader.canHandleResource(new URLResource(new URL("javascript://test.com/test.flv"))));
	    	assertFalse(loader.canHandleResource(new URLResource(new URL("rtmpet://example.com/test"))));	    	
			assertFalse(loader.canHandleResource(new URLResource(new URL("httpt://example.com/video.foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("example.com/test.mp3"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL(""))));
			assertFalse(loader.canHandleResource(new URLResource(null)));
			assertFalse(loader.canHandleResource(new NullResource()));
			assertFalse(loader.canHandleResource(null));
			
			// Verify some valid local resources.
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///video.flv"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///video.f4v"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///video.mov"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///video.mp4"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///video.mp4v"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///video.m4v"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///video.3gp"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///video.3gpp2"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///video.3g2"))));
			
			// And some invalid ones.
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.avi"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.mpeg"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.mpg"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.wmv"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("audio.mp3"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.flv1"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.f4v1"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.mov1"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.mp41"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.mp4v1"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.m4v1"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.3gp1"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.3gpp21"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("video.3g21"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("audio.mp31"))));
					
			// Verify some valid resources based on metadata information
			var metadata:MediaTypeFacet = new MediaTypeFacet( MediaType.VIDEO);
			var resource:URLResource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));
			
			metadata = new MediaTypeFacet(null, "video/x-flv");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));
			
			metadata = new MediaTypeFacet(null, "video/x-f4v");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null, "video/mp4");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null, "video/mp4v-es");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null, "video/x-m4v");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null, "video/3gpp");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null, "video/3gpp2");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null, "video/quicktime");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.VIDEO, "video/x-flv");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			// Add some invalid cases based on metadata information
			//
			
			metadata = new MediaTypeFacet(MediaType.AUDIO);			
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null, "audio/mpeg");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));
			
			metadata = new MediaTypeFacet( MediaType.AUDIO,  "audio/mpeg");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.SWF);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null, "Invalid MIME Type");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.IMAGE, "Invalid MIME Type");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet( MediaType.VIDEO, "Invalid MIME Type");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.AUDIO, "Invalid MIME Type");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.IMAGE, "video/x-flv");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.IMAGE, "audio/mpeg");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.VIDEO, "audio/mpeg");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet( MediaType.AUDIO, "video/x-flv");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));
		}

		public function testMultipleConcurrentLoads():void
		{
			doTestMultipleConcurrentLoads();
		}
		
		public function testAllowConnectionSharing():void
		{
			doTestAllowConnectionSharing();
		}
		
		public function testDisallowConnectionSharing():void
		{
			doTestDisallowConnectionSharing();
		}
		
		public function testUnloadWithSharedConnections():void
		{
			doTestUnloadWithSharedConnections();
		}

		public function testUnloadWithUnsharedConnections():void
		{
			doTestUnloadWithUnsharedConnections();
		}
		
		public function testNetConnectionFactoryArgument():void
		{
			doTestNetConnectionFactoryArgument();
		}
		
		public function testLoadHTTP():void
		{
			doTestLoadHTTP();
		}
		
		private function doTestMultipleConcurrentLoads():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var netLoader:NetLoader = netFactory.createNetLoader();
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}
			
			var loadTrait1:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait2.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait2.load();
			var loadTrait3:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait3.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait3.load();
			var loadTrait4:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait4.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait4.load();
			var responses:int = 0;
			function onMultiLoad(event:LoadEvent):void
			{
				assertTrue(event.type == LoadEvent.LOAD_STATE_CHANGE);
					
				if (event.loadState == LoadState.READY)
				{
					responses++;
					if (responses == 4)
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
			
		}
		
		private function doTestAllowConnectionSharing():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var netLoader:NetLoader = netFactory.createNetLoader();
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}

			var loadTrait1:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait2.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait2.load();

			var responses:int = 0;
			function onMultiLoad(event:LoadEvent):void
			{
				assertTrue(event.type == LoadEvent.LOAD_STATE_CHANGE);
					
				if (event.loadState == LoadState.READY)
				{
					responses++;
					if (responses == 2)
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
			
		}
		
		private function doTestDisallowConnectionSharing():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var netLoader:NetLoader = netFactory.createNetLoader(new DefaultNetConnectionFactory(false));
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}

			var loadTrait1:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait2.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait2.load();

			var responses:int = 0;
			function onMultiLoad(event:LoadEvent):void
			{
				assertTrue(event.type == LoadEvent.LOAD_STATE_CHANGE);
					
				if (event.loadState == LoadState.READY)
				{
					responses++;
					if (responses == 2)
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
			
		}
		
		private function doTestUnloadWithSharedConnections():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var netLoader:NetLoader = netFactory.createNetLoader();
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}

			var loadTrait1:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait2.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait2.load();

			var responses:int = 0;
			function onMultiLoad(event:LoadEvent):void
			{
				assertTrue(event.type == LoadEvent.LOAD_STATE_CHANGE);
					
				if (event.loadState == LoadState.READY)
				{
					responses++;
					if (responses == 2)
					{
						loadTrait1.unload();
					}
				}
				if (event.loadState == LoadState.UNINITIALIZED)
				{
					responses++;
					if (responses == 3)
					{
						assertTrue(NetStreamLoadTrait(loadTrait1).connection.connected);
						assertTrue(NetStreamLoadTrait(loadTrait2).connection.connected);
						
						loadTrait2.unload();
					}
					else if (responses == 4)
					{
						// For some reason, the connected property doesn't show up as
						// false when testing against Akamai, even though we're closing
						// the connection.
						assertTrue(NetStreamLoadTrait(loadTrait2).connection.connected == false || mockLoader == null);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
		}
		
		private function doTestUnloadWithUnsharedConnections():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var netLoader:NetLoader = netFactory.createNetLoader(new DefaultNetConnectionFactory(false));
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}

			var loadTrait1:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();

			var loadTrait2:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource2);
			loadTrait2.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);

			var responses:int = 0;
			function onMultiLoad(event:LoadEvent):void
			{
				assertTrue(event.type == LoadEvent.LOAD_STATE_CHANGE);
					
				if (event.loadState == LoadState.READY)
				{
					responses++;
					if (responses == 1)
					{
						loadTrait2.load();
					}
					else if (responses == 2)
					{
						loadTrait1.unload();
					}
				}
				if (event.loadState == LoadState.UNINITIALIZED)
				{
					responses++;
					if (responses == 3)
					{
						assertFalse(NetStreamLoadTrait(loadTrait1).connection.connected);
						assertTrue(NetStreamLoadTrait(loadTrait2).connection.connected);
						
						loadTrait2.unload();
					}
					else if (responses == 4)
					{
						// For some reason, the connected property doesn't show up as
						// false when testing against Akamai, even though we're closing
						// the connection.
						assertTrue(NetStreamLoadTrait(loadTrait2).connection.connected == false || mockLoader == null);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
		}
		
		private function doTestNetConnectionFactoryArgument():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var netLoader:NetLoader = netFactory.createNetLoader(new DefaultNetConnectionFactory(true));
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}
			
			var loadTrait1:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new NetStreamLoadTrait(netLoader, successfulResource);
			loadTrait2.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait2.load();
			
			var responses:int = 0;

			function onMultiLoad(event:LoadEvent):void
			{
				assertTrue(event.type == LoadEvent.LOAD_STATE_CHANGE);
					
				if (event.loadState == LoadState.READY)
				{
					responses++;
					if (responses == 2)
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
		}
		
		private function doTestLoadHTTP():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var netLoader:NetLoader = netFactory.createNetLoader(new DefaultNetConnectionFactory());
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}
			
			var loadTrait1:LoadTrait = new NetStreamLoadTrait(netLoader, SUCCESSFUL_HTTP_RESOURCE);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new NetStreamLoadTrait(netLoader, SUCCESSFUL_HTTP_RESOURCE);
			loadTrait2.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait2.load();
			
			var responses:int = 0;

			function onMultiLoad(event:LoadEvent):void
			{
				assertTrue(event.type == LoadEvent.LOAD_STATE_CHANGE);
					
				if (event.loadState == LoadState.READY)
				{
					responses++;
					if (responses == 2)
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
		}
		
		//---------------------------------------------------------------------
				
		override protected function createInterfaceObject(... args):Object
		{
			return netFactory.createNetLoader();
		}
		
		override protected function createLoadTrait(loader:LoaderBase, resource:MediaResourceBase):LoadTrait
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
			return new NetStreamLoadTrait(loader, resource);
		}
		
		override protected function get successfulResource():MediaResourceBase
		{
			return SUCCESSFUL_RESOURCE;
		}

		override protected function get failedResource():MediaResourceBase
		{
			return UNSUCCESSFUL_RESOURCE;
		}

		override protected function get unhandledResource():MediaResourceBase
		{
			return UNHANDLED_RESOURCE;
		}
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
			assertTrue(error.errorID == MediaErrorCodes.INVALID_URL_PROTOCOL ||
					   error.errorID == MediaErrorCodes.NETCONNECTION_REJECTED ||
					   error.errorID == MediaErrorCodes.NETCONNECTION_INVALID_APP ||
					   error.errorID == MediaErrorCodes.NETCONNECTION_FAILED ||
					   error.errorID == MediaErrorCodes.NETCONNECTION_TIMEOUT ||
					   error.errorID == MediaErrorCodes.NETCONNECTION_SECURITY_ERROR ||
					   error.errorID == MediaErrorCodes.NETCONNECTION_ASYNC_ERROR ||
					   error.errorID == MediaErrorCodes.NETCONNECTION_IO_ERROR ||
					   error.errorID == MediaErrorCodes.NETCONNECTION_ARGUMENT_ERROR);
		}
		
		protected function createNetFactory():NetFactory
		{
			return new NetFactory();
		}
		
		private function get successfulResource2():MediaResourceBase
		{
			return SUCCESSFUL_RESOURCE2;
		}

		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
		
		protected var netFactory:NetFactory;
		
		private var eventDispatcher:EventDispatcher;
		
		private static const SUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO));
		private static const SUCCESSFUL_RESOURCE2:URLResource = new URLResource(new FMSURL(TestConstants.STREAMING_AUDIO_FILE));
		private static const UNSUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.INVALID_STREAMING_VIDEO));
		private static const UNHANDLED_RESOURCE:NullResource = new NullResource();
		private static const SUCCESSFUL_HTTP_RESOURCE:URLResource = new URLResource(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO));
		private static const TEST_TIME:Number = 4000;
		private static const PORT_443:String = "443";
		private static const RTMPTE:String = "rtmpte";
		private static const DEFAULT_PORT_PROTOCOL_RESULT:String = TestConstants.DEFAULT_PORT_PROTOCOL_RESULT;
		private static const RTMPTE_443_RESULT:String = TestConstants.RESULT_FOR_RTMPTE_443;
		private static const RESOURCE_WITH_PORT_PROTOCOL:URLResource = new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO_WITH_PORT_PROTOCOL));
		
	}
}