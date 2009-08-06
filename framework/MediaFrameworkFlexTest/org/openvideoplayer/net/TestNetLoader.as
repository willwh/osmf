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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.events.LoaderEvent;
	import org.openvideoplayer.events.MediaError;
	import org.openvideoplayer.loaders.TestILoader;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.metadata.KeyValueFacet;
	import org.openvideoplayer.metadata.MediaType;
	import org.openvideoplayer.netmocker.DefaultNetConnectionFactory;
	import org.openvideoplayer.netmocker.MockNetLoader;
	import org.openvideoplayer.netmocker.MockNetNegotiator;
	import org.openvideoplayer.netmocker.NetConnectionExpectation;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.NetFactory;
	import org.openvideoplayer.utils.NullResource;
	import org.openvideoplayer.utils.TestConstants;
	import org.openvideoplayer.utils.URL;

	public class TestNetLoader extends TestILoader
	{
		override public function setUp():void
		{
			netFactory = new NetFactory();
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
			
			// Verify some valid resources.
	    	assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/test"))));	    	
		   	assertTrue(loader.canHandleResource(new URLResource(new URL("https://example.com/test"))));
		   	assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com:8080"))));
		   	assertTrue(loader.canHandleResource(new URLResource(new URL("file://example.com/test"))));
		   	assertTrue(loader.canHandleResource(new URLResource(new URL("example.com/test.mp3"))));		    	
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmp://example.com/test"))));	    	
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmps://example.com/test"))));	    	
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmpe://example.com/test"))));	    	    	
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmpte://example.com/test"))));
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmp://example.com:8080/appname/test"))));
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmp://example.com/appname/filename.flv"))));
	    	assertTrue(loader.canHandleResource(new URLResource(new FMSURL("rtmpte://example.com:8080/appname/mp4:filename.mp4"))));
	    				 
			// And some invalid ones.
	    	assertFalse(loader.canHandleResource(new URLResource(new URL("javascript://test.com/test.flv"))));
	    	assertFalse(loader.canHandleResource(new URLResource(new URL("rtmpet://example.com/test"))));	    	
			assertFalse(loader.canHandleResource(new URLResource(new URL("httpt://example.com/video.foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("example.com/test.flv"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL(""))));
			assertFalse(loader.canHandleResource(new URLResource(null)));
			assertFalse(loader.canHandleResource(new NullResource()));
			assertFalse(loader.canHandleResource(null));
			
			// Verify some valid resources based on metadata information
			var dictionary:Dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.VIDEO;
			var metadata:KeyValueFacet = new KeyValueFacet(null, dictionary);
			var resource:URLResource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));
			
			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/x-flv";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));
			
			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/x-f4v";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/mp4";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/mp4v-es";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/x-m4v";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/3gpp";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/3gpp2";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/quicktime";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.AUDIO;
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "audio/mpeg";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.VIDEO;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/x-flv";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.AUDIO;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "audio/mpeg";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			// Add some invalid cases based on metadata information
			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.SWF;
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "Invalid MIME Type";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.IMAGE;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "Invalid MIME Type";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.VIDEO;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "Invalid MIME Type";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.AUDIO;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "Invalid MIME Type";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.IMAGE;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/x-flv";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.IMAGE;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "audio/mpeg";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.VIDEO;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "audio/mpeg";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.AUDIO;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "video/x-flv";
			metadata = new KeyValueFacet(null, dictionary);
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
			
			var netLoader:MockNetLoader = new MockNetLoader();
			netLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			var loadable1:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable1.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable1.load();
			var loadable2:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable2.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable2.load();
			var loadable3:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable3.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable3.load();
			var loadable4:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable4.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable4.load();
			var responses:int = 0;
			function onMultiLoad(event:LoadableStateChangeEvent):void
			{
					assertTrue(event.loadable != null);
					assertTrue(event.type == LoaderEvent.LOADABLE_STATE_CHANGE);
					
				if (event.newState == LoadState.LOADED)
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
			var netLoader:MockNetLoader = new MockNetLoader();
			netLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			var loadable1:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable1.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable1.load();
			var loadable2:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable2.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable2.load();

			var responses:int = 0;
			function onMultiLoad(event:LoadableStateChangeEvent):void
			{
					assertTrue(event.loadable != null);
					assertTrue(event.type == LoaderEvent.LOADABLE_STATE_CHANGE);
					
				if (event.newState == LoadState.LOADED)
				{
					var context:NetLoadedContext = event.loadable.loadedContext as NetLoadedContext;
					assertTrue(context.shareable);
				}
			}
			
		}
		
		private function doTestAllowConnectionSharing():void
		{
			var netLoader:MockNetLoader = new MockNetLoader(false);
			netLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			var loadable1:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable1.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable1.load();
			var loadable2:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable2.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable2.load();

			var responses:int = 0;
			function onMultiLoad(event:LoadableStateChangeEvent):void
			{
					assertTrue(event.loadable != null);
					assertTrue(event.type == LoaderEvent.LOADABLE_STATE_CHANGE);
					
				if (event.newState == LoadState.LOADED)
				{
					var context:NetLoadedContext = event.loadable.loadedContext as NetLoadedContext;
					assertFalse(context.shareable);
				}
			}
			
		}
		
		private function doTestUnloadWithSharedConnections():void
		{
			var netLoader:MockNetLoader = new MockNetLoader();
			netLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			var loadable1:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable1.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable1.load();
			var loadable2:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable2.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable2.load();

			var responses:int = 0;
			function onMultiLoad(event:LoadableStateChangeEvent):void
			{
					assertTrue(event.loadable != null);
					assertTrue(event.type == LoaderEvent.LOADABLE_STATE_CHANGE);
					
				if (event.newState == LoadState.LOADED)
				{
					var context:NetLoadedContext = event.loadable.loadedContext as NetLoadedContext;
					assertTrue(context.shareable);
					responses++;
					if (responses == 2)
					{
						loadable1.unload();
						
					}
				}
				if (event.newState == LoadState.CONSTRUCTED)
				{
					if (responses == 2)
					{
						assertStrictlyEquals(event.loadable,loadable1);
						assertTrue((loadable2.loadedContext as NetLoadedContext).connection.connected);
					}
				}
			}
			
		}
		
		private function doTestNetConnectionFactoryArgument():void
		{
			var negotiator:MockNetNegotiator = new MockNetNegotiator();
			var factory:DefaultNetConnectionFactory = new DefaultNetConnectionFactory(negotiator);
			var netLoader:MockNetLoader = new MockNetLoader(true,factory,negotiator);
			netLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			var loadable1:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable1.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable1.load();
			var loadable2:LoadableTrait = new LoadableTrait(netLoader, successfulResource);
			loadable2.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onMultiLoad);
			loadable2.load();

			function onMultiLoad(event:LoadableStateChangeEvent):void
			{
					assertTrue(event.loadable != null);
					assertTrue(event.type == LoaderEvent.LOADABLE_STATE_CHANGE);
					
				if (event.newState == LoadState.LOADED)
				{
					var context:NetLoadedContext = event.loadable.loadedContext as NetLoadedContext;
					assertTrue(context.shareable);
				}
			}
			
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
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
			// May need to adjust these values if error codes move around.
			assertTrue(error.errorCode >= 120 && error.errorCode <= 130);
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
		
		private var netFactory:NetFactory;
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