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
	
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MediaTypeFacet;
	import org.osmf.netmocker.DefaultNetConnectionFactory;
	import org.osmf.netmocker.IMockNetLoader;
	import org.osmf.netmocker.MockNetLoader;
	import org.osmf.netmocker.MockNetNegotiator;
	import org.osmf.netmocker.NetConnectionExpectation;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.TestILoader;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.NetFactory;
	import org.osmf.utils.NullResource;
	import org.osmf.utils.TestConstants;
	import org.osmf.utils.URL;

	public class TestNetLoader extends TestILoader
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
		
		public function testConnectionSharing():void
		{
			doTestConnectionSharing();
		}
		
		public function testAllowConnectionSharing():void
		{
			doTestAllowConnectionSharing();
		}
		
		public function testUnloadWithSharedConnections():void
		{
			doTestUnloadWithSharedConnections();
		}
		
		public function testNetConnectionFactoryArgument():void
		{
			doTestNetConnectionFactoryArgument();
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
			
			var loadTrait1:LoadTrait = new LoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new LoadTrait(netLoader, successfulResource);
			loadTrait2.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait2.load();
			var loadTrait3:LoadTrait = new LoadTrait(netLoader, successfulResource);
			loadTrait3.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait3.load();
			var loadTrait4:LoadTrait = new LoadTrait(netLoader, successfulResource);
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
		
		private function doTestConnectionSharing():void
		{
			var netLoader:NetLoader = netFactory.createNetLoader();
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}

			var loadTrait1:LoadTrait = new LoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new LoadTrait(netLoader, successfulResource);
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
						var context1:NetLoadedContext = loadTrait1.loadedContext as NetLoadedContext;
						assertTrue(context1.shareable);
						var context2:NetLoadedContext = loadTrait2.loadedContext as NetLoadedContext;
						assertTrue(context2.shareable);
					}
				}
			}
			
		}
		
		private function doTestAllowConnectionSharing():void
		{
			var netLoader:NetLoader = netFactory.createNetLoader(false);
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}

			var loadTrait1:LoadTrait = new LoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new LoadTrait(netLoader, successfulResource);
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
						var context1:NetLoadedContext = loadTrait1.loadedContext as NetLoadedContext;
						assertFalse(context1.shareable);
						var context2:NetLoadedContext = loadTrait2.loadedContext as NetLoadedContext;
						assertFalse(context2.shareable);
					}
				}
			}
			
		}
		
		private function doTestUnloadWithSharedConnections():void
		{
			var netLoader:NetLoader = netFactory.createNetLoader();
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}

			var loadTrait1:LoadTrait = new LoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new LoadTrait(netLoader, successfulResource);
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
						var context1:NetLoadedContext = loadTrait1.loadedContext as NetLoadedContext;
						assertTrue(context1.shareable);
						var context2:NetLoadedContext = loadTrait2.loadedContext as NetLoadedContext;
						assertTrue(context2.shareable);

						loadTrait1.unload();
					}
				}
				if (event.loadState == LoadState.UNINITIALIZED)
				{
					if (responses == 2)
					{
						assertTrue((loadTrait2.loadedContext as NetLoadedContext).connection.connected);
					}
				}
			}
			
		}
		
		private function doTestNetConnectionFactoryArgument():void
		{
			var negotiator:NetNegotiator = new MockNetNegotiator();
			var factory:NetConnectionFactory = new DefaultNetConnectionFactory(negotiator);
			var netLoader:NetLoader = netFactory.createNetLoader(true, factory);
			var mockLoader:IMockNetLoader = netLoader as IMockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}

			
			var loadTrait1:LoadTrait = new LoadTrait(netLoader, successfulResource);
			loadTrait1.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMultiLoad);
			loadTrait1.load();
			var loadTrait2:LoadTrait = new LoadTrait(netLoader, successfulResource);
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
						var context1:NetLoadedContext = loadTrait1.loadedContext as NetLoadedContext;
						assertTrue(context1.shareable);
						var context2:NetLoadedContext = loadTrait2.loadedContext as NetLoadedContext;
						assertTrue(context2.shareable);
					}
				}
			}
			
		}
		
		//---------------------------------------------------------------------
				
		override protected function createInterfaceObject(... args):Object
		{
			return netFactory.createNetLoader();
		}
		
		override protected function createLoadTrait(loader:ILoader, resource:IMediaResource):LoadTrait
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
			return new LoadTrait(loader, resource);
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
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
			assertTrue(error.errorCode == MediaErrorCodes.INVALID_URL_PROTOCOL ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_REJECTED ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_INVALID_APP ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_FAILED ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_TIMEOUT ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_SECURITY_ERROR ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_ASYNC_ERROR ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_IO_ERROR ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_ARGUMENT_ERROR);
		}
		
		protected function createNetFactory():NetFactory
		{
			return new NetFactory();
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
		
		protected var netFactory:NetFactory;
		
		private var eventDispatcher:EventDispatcher;
		
		private static const SUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO));
		private static const UNSUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.INVALID_STREAMING_VIDEO));
		private static const UNHANDLED_RESOURCE:NullResource = new NullResource();
		private static const TEST_TIME:Number = 4000;
		private static const PORT_443:String = "443";
		private static const RTMPTE:String = "rtmpte";
		private static const DEFAULT_PORT_PROTOCOL_RESULT:String = TestConstants.DEFAULT_PORT_PROTOCOL_RESULT;
		private static const RTMPTE_443_RESULT:String = TestConstants.RESULT_FOR_RTMPTE_443;
		private static const RESOURCE_WITH_PORT_PROTOCOL:URLResource = new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO_WITH_PORT_PROTOCOL));
		
	}
}