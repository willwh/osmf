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
	import flash.utils.Dictionary;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.LoadableStateChangeEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MediaType;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.MediaFrameworkStrings;
	import org.osmf.utils.URL;
	
	public class TestPluginLoader extends TestCase
	{
		public function TestPluginLoader()
		{
			mediaFactory = new MediaFactory();
			pluginFactory = new PluginFactory(mediaFactory);
		}
		
		public function testDynamicPluginLoaderCanHandleResource():void
		{
			var loader:DynamicPluginLoader = new DynamicPluginLoader(mediaFactory);

			// Verify some valid resources based on metadata information
			var dictionary:Dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] = MediaType.SWF;
			var metadata:KeyValueFacet = new KeyValueFacet(null, dictionary);
			var resource:URLResource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));
			
			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "application/x-shockwave-flash";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] =  MediaType.SWF;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "application/x-shockwave-flash";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			// Add some invalid cases based on metadata information
			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] =  MediaType.IMAGE;
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "Invalide MIME Type";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] =  MediaType.SWF;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "Invalide MIME Type";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] =  MediaType.IMAGE;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "application/x-shockwave-flash";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			dictionary = new Dictionary();
			dictionary[MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE] =  MediaType.IMAGE;
			dictionary[MediaFrameworkStrings.METADATA_KEY_MIME_TYPE] = "Invalide MIME Type";
			metadata = new KeyValueFacet(null, dictionary);
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));
		}
		
		public function testStaticPluginInfoRegistration():void
		{
			pluginResource = new PluginClassResource(SimpleVideoPluginInfo);
			pluginElement = pluginFactory.createMediaElement(pluginResource);
			
			// Ensure there's nothing in the media factory
			assertTrue(mediaFactory.getMediaInfoById(SimpleVideoPluginInfo.MEDIA_INFO_ID) == null);

			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					// Ensure the MediaInfo object has been registered with the media factory
					assertTrue(mediaFactory.getMediaInfoById(SimpleVideoPluginInfo.MEDIA_INFO_ID) != null);
					var loadedContext:ILoadedContext = event.loadable.loadedContext;
					assertTrue(loadedContext != null);
					assertTrue(loadedContext is PluginLoadedContext);
					var pluginLoadedContext:PluginLoadedContext = loadedContext as PluginLoadedContext;
					// null loader, since this loaded context is for static loading
					assertTrue(pluginLoadedContext.loader == null);
					assertTrue(pluginLoadedContext.pluginInfo.numMediaInfos == 1);
					
				}
				else if (event.newState == LoadState.LOAD_FAILED)
				{
					// This should indicate failure
					assertTrue(false);
				}
			}

			// now load the plugin
			if (pluginElement != null && pluginElement.hasTrait(MediaTraitType.LOADABLE))
			{
				loadable = pluginElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, addAsync(onLoadableStateChange, 500));
				loadable.load();
			}
		}
		
		public function testStaticPluginInfoRegistrationWithInvalidVersionPlugin():void
		{
			doTestStaticPluginInfoRegistrationWithInvalidPlugin(new PluginClassResource(InvalidVersionPluginInfo));
		}

		public function testStaticPluginInfoRegistrationWithInvalidImplementationPlugin():void
		{
			doTestStaticPluginInfoRegistrationWithInvalidPlugin(new PluginClassResource(InvalidImplementationPluginInfo));
		}
		
		private function doTestStaticPluginInfoRegistrationWithInvalidPlugin(pluginResource:PluginClassResource):void
		{
			pluginElement = pluginFactory.createMediaElement(pluginResource);
			
			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					// It shouldn't load.
					fail();
				}
				else if (event.newState == LoadState.LOAD_FAILED)
				{
					// Should get here.
				}
			}

			// Now load the plugin
			if (pluginElement != null && pluginElement.hasTrait(MediaTraitType.LOADABLE))
			{
				loadable = pluginElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, addAsync(onLoadableStateChange, 500));
				loadable.load();
			}
		}

		public function testMultipleMediaInfosRegistration():void
		{
			pluginResource = new PluginClassResource(SimpleVideoImagePluginInfo);
			pluginElement = pluginFactory.createMediaElement(pluginResource);
			
			assertTrue(mediaFactory.getMediaInfoById(SimpleVideoImagePluginInfo.VIDEO_MEDIA_INFO_ID) == null);
			assertTrue(mediaFactory.getMediaInfoById(SimpleVideoImagePluginInfo.IMAGE_MEDIA_INFO_ID) == null);

			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{

					var videoMediaInfo:MediaInfo = mediaFactory.getMediaInfoById(SimpleVideoImagePluginInfo.VIDEO_MEDIA_INFO_ID);
					var imageMediaInfo:MediaInfo = mediaFactory.getMediaInfoById(SimpleVideoImagePluginInfo.IMAGE_MEDIA_INFO_ID);

					// Ensure the MediaInfo object has been registered with the media factory
					assertTrue(videoMediaInfo != null);
					assertTrue(imageMediaInfo != null);

					var loadedContext:ILoadedContext = event.loadable.loadedContext;
					assertTrue(loadedContext != null);
					assertTrue(loadedContext is PluginLoadedContext);
					var pluginLoadedContext:PluginLoadedContext = loadedContext as PluginLoadedContext;
					// null loader, since this loaded context is for static loading
					assertTrue(pluginLoadedContext.loader == null);
					assertTrue(pluginLoadedContext.pluginInfo.numMediaInfos == 2);
					
					
				}
				else if (event.newState == LoadState.LOAD_FAILED)
				{
					// This should indicate failure
					assertTrue(false);
				}
			}

			
			// now load the plugin
			if (pluginElement != null && pluginElement.hasTrait(MediaTraitType.LOADABLE))
			{
				loadable = pluginElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, addAsync(onLoadableStateChange, 500));
				loadable.load();
			}
		}

		public function testDynamicPluginInfoRegistration():void
		{
			var pluginResource2:URLResource = new URLResource(new URL("http://www.adobe.com/foo.swf"));
			pluginElement2 = pluginFactory.createMediaElement(pluginResource2);
			
			// now load the plugin
			if (pluginElement2 != null && pluginElement2.hasTrait(MediaTraitType.LOADABLE))
			{
				loadable2 = pluginElement2.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				loadable2.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, addAsync(onLoadable2StateChange, 500));
				loadable2.load();
			}
		}

		private function onLoadable2StateChange(event:LoadableStateChangeEvent):void
		{
			if (event.newState == LoadState.LOADED)
			{
				// Plugin should not get loaded for invalid URL 
				fail();
			}
			else if (event.newState == LoadState.LOAD_FAILED)
			{
				assertTrue(event.loadable.loadedContext == null);
			}
		}

		private var loadable:ILoadable;
		private var loadable2:ILoadable;
		private var mediaFactory:MediaFactory;
		private var pluginFactory:PluginFactory;
		private var pluginResource:IMediaResource;
		private var pluginElement:MediaElement;
		private var pluginElement2:MediaElement;
	}
}