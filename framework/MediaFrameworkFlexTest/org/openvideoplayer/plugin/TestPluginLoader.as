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
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.ILoadedContext;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class TestPluginLoader extends TestCase
	{
		public function TestPluginLoader()
		{
			mediaFactory = new MediaFactory();
			pluginFactory = new PluginFactory(mediaFactory);
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

					var videoMediaInfo:IMediaInfo = mediaFactory.getMediaInfoById(SimpleVideoImagePluginInfo.VIDEO_MEDIA_INFO_ID);
					var imageMediaInfo:IMediaInfo = mediaFactory.getMediaInfoById(SimpleVideoImagePluginInfo.IMAGE_MEDIA_INFO_ID);

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



		public function testDynanmicPluginInfoRegistration():void
		{
			var pluginResource2:URLResource = new URLResource("http://www.adobe.com/foo.swf");
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
				assertTrue(false);
				
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