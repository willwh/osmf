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
package org.osmf.plugin
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.osmf.events.LoaderEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.TestILoader;
	import org.osmf.utils.URL;
	import org.osmf.utils.Version;
	
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
			return new StaticPluginLoader(mediaFactory, Version.version());
		}

		override protected function createLoadTrait(loader:ILoader, resource:MediaResourceBase):LoadTrait
		{
			return new LoadTrait(loader, resource);
		}
		
		override protected function get successfulResource():MediaResourceBase
		{
			return new PluginInfoResource(new SimpleVideoPluginInfo);
		}

		override protected function get failedResource():MediaResourceBase
		{
			return new PluginInfoResource(new InvalidVersionPluginInfo);
		}

		override protected function get unhandledResource():MediaResourceBase
		{
			return new URLResource(new URL("http://example.com"));
		}
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
			assertTrue(error.errorID == MediaErrorCodes.CONTENT_IO_LOAD_ERROR ||
					   error.errorID == MediaErrorCodes.CONTENT_SECURITY_LOAD_ERROR ||
					   error.errorID == MediaErrorCodes.INVALID_PLUGIN_VERSION ||
					   error.errorID == MediaErrorCodes.INVALID_PLUGIN_IMPLEMENTATION);
		}

		public function testLoadOfPlugin():void
		{
			var loadTrait:LoadTrait = createLoadTrait(loader, new PluginInfoResource(new SimpleVideoPluginInfo));
			
			assertTrue(mediaFactory.numMediaInfos == 0);
			
			loader.load(loadTrait);

			// Ensure the MediaInfo object has been registered with the media factory.
			assertTrue(mediaFactory.getMediaInfoById(SimpleVideoPluginInfo.MEDIA_INFO_ID) != null);
			assertTrue(mediaFactory.numMediaInfos == 1);
		}

		public function testLoadOfPluginWithMultipleMediaInfos():void
		{
			var loadTrait:LoadTrait = createLoadTrait(loader, new PluginInfoResource(new SimpleVideoImagePluginInfo));
			
			assertTrue(mediaFactory.numMediaInfos == 0);
			
			loader.load(loadTrait);

			// Ensure the MediaInfo object has been registered with the media factory.
			assertTrue(mediaFactory.getMediaInfoById(SimpleVideoImagePluginInfo.IMAGE_MEDIA_INFO_ID) != null);
			assertTrue(mediaFactory.getMediaInfoById(SimpleVideoImagePluginInfo.VIDEO_MEDIA_INFO_ID) != null);
			assertTrue(mediaFactory.numMediaInfos == 2);
		}

		public function testUnloadOfPlugin():void
		{
			var loadTrait:LoadTrait = createLoadTrait(loader, new PluginInfoResource(new SimpleVideoPluginInfo()));
			
			assertTrue(mediaFactory.numMediaInfos == 0);
			
			loader.load(loadTrait);
			assertTrue(mediaFactory.numMediaInfos > 0);
			
			loader.unload(loadTrait);
			assertTrue(mediaFactory.numMediaInfos == 0);
		}
		
		public function testLoadOfInvalidVersionPlugin():void
		{
			doTestLoadOfInvalidPlugin(new PluginInfoResource(new InvalidVersionPluginInfo));
		}

		public function testLoadOfInvalidImplementationPlugin():void
		{
			doTestLoadOfInvalidPlugin(new PluginInfoResource(new InvalidImplementationPluginInfo));
		}
		
		private function doTestLoadOfInvalidPlugin(pluginResource:PluginInfoResource):void
		{
			var loadTrait:LoadTrait = createLoadTrait(loader, pluginResource);
			
			assertTrue(mediaFactory.numMediaInfos == 0);
			
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 1000));
			
			loader.addEventListener(LoaderEvent.LOAD_STATE_CHANGE, onLoadStateChange);
			loader.load(loadTrait);
			
			function onLoadStateChange(event:LoaderEvent):void
			{
				if (event.newState == LoadState.LOAD_ERROR)
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