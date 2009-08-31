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
package org.openvideoplayer.plugin
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.events.LoaderEvent;
	import org.openvideoplayer.events.MediaError;
	import org.openvideoplayer.events.MediaErrorCodes;
	import org.openvideoplayer.loaders.TestILoader;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.URL;
	
	public class TestStaticPluginLoader extends TestILoader
	{
		override public function setUp():void
		{
			mediaFactory = new MediaFactory();
			eventDispatcher = new EventDispatcher();

			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			mediaFactory = null;
			eventDispatcher = null;
		}
				
		override protected function createInterfaceObject(... args):Object
		{
			return new StaticPluginLoader(mediaFactory);
		}

		override protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			return new LoadableTrait(loader, resource);
		}
		
		override protected function get successfulResource():IMediaResource
		{
			return new PluginClassResource(SimpleVideoPluginInfo);
		}

		override protected function get failedResource():IMediaResource
		{
			return new PluginClassResource(InvalidVersionPluginInfo);
		}

		override protected function get unhandledResource():IMediaResource
		{
			return new URLResource(new URL("http://example.com"));
		}
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
			assertTrue(error.errorCode == MediaErrorCodes.CONTENT_IO_LOAD_ERROR ||
					   error.errorCode == MediaErrorCodes.CONTENT_SECURITY_LOAD_ERROR ||
					   error.errorCode == MediaErrorCodes.INVALID_PLUGIN_VERSION ||
					   error.errorCode == MediaErrorCodes.INVALID_PLUGIN_IMPLEMENTATION);
		}

		public function testLoadOfPlugin():void
		{
			var loadable:ILoadable = createILoadable(new PluginClassResource(SimpleVideoPluginInfo));
			
			assertTrue(mediaFactory.numMediaInfos == 0);
			
			loader.load(loadable);

			// Ensure the MediaInfo object has been registered with the media factory.
			assertTrue(mediaFactory.getMediaInfoById(SimpleVideoPluginInfo.MEDIA_INFO_ID) != null);
			assertTrue(mediaFactory.numMediaInfos == 1);
		}

		public function testLoadOfPluginWithMultipleMediaInfos():void
		{
			var loadable:ILoadable = createILoadable(new PluginClassResource(SimpleVideoImagePluginInfo));
			
			assertTrue(mediaFactory.numMediaInfos == 0);
			
			loader.load(loadable);

			// Ensure the MediaInfo object has been registered with the media factory.
			assertTrue(mediaFactory.getMediaInfoById(SimpleVideoImagePluginInfo.IMAGE_MEDIA_INFO_ID) != null);
			assertTrue(mediaFactory.getMediaInfoById(SimpleVideoImagePluginInfo.VIDEO_MEDIA_INFO_ID) != null);
			assertTrue(mediaFactory.numMediaInfos == 2);
		}

		public function testUnloadOfPlugin():void
		{
			var loadable:ILoadable = createILoadable(new PluginClassResource(SimpleVideoPluginInfo));
			
			assertTrue(mediaFactory.numMediaInfos == 0);
			
			loader.load(loadable);
			assertTrue(mediaFactory.numMediaInfos > 0);
			
			loader.unload(loadable);
			assertTrue(mediaFactory.numMediaInfos == 0);
		}
		
		public function testLoadOfInvalidVersionPlugin():void
		{
			doTestLoadOfInvalidPlugin(new PluginClassResource(InvalidVersionPluginInfo));
		}

		public function testLoadOfInvalidImplementationPlugin():void
		{
			doTestLoadOfInvalidPlugin(new PluginClassResource(InvalidImplementationPluginInfo));
		}
		
		private function doTestLoadOfInvalidPlugin(pluginResource:PluginClassResource):void
		{
			var loadable:ILoadable = createILoadable(pluginResource);
			
			assertTrue(mediaFactory.numMediaInfos == 0);
			
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 1000));
			
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
			loader.load(loadable);
			
			function onLoadableStateChange(event:LoaderEvent):void
			{
				if (event.newState == LoadState.LOAD_FAILED)
				{
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder.
		}

		private var mediaFactory:MediaFactory;
		private var eventDispatcher:EventDispatcher;
	}
}