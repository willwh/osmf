/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
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