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
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.TestConstants;
	
	public class TestDynamicPluginLoaderIntegration extends TestCase
	{
		
		private var mediaFactory:MediaFactory;
		private var pluginFactory:PluginFactory;
		private var pluginElement:PluginElement;
		private var dynamicPluginLoader:DynamicPluginLoader;
		private var loadable:ILoadable;
		
		public function TestDynamicPluginLoaderIntegration()
		{
			init();	
		}
		
		public function init():void
		{
			mediaFactory =  new MediaFactory();
			pluginFactory = new PluginFactory(mediaFactory);
			
			// pluginElement = new PluginElement();
			// pluginElement.resource = successfulResource;
			// pluginElement.initialize([dynamicPluginLoader]);
			// dynamicPluginLoader = new DynamicPluginLoader(mediaFactory);
			
		}
		
		public function testDynamicPluginLoading():void
		{
			loadPluginFromResource(new URLResource(TestConstants.REMOTE_VALID_PLUGIN_SWF_URL));
		}
		
		private function loadPluginFromResource(pluginResource:IMediaResource):void
		{
			// get the right plugin element from plugin factory
			pluginElement = pluginFactory.createMediaElement(pluginResource) as PluginElement;
			if (pluginElement != null && pluginElement.hasTrait(MediaTraitType.LOADABLE))
			{
				loadable = pluginElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, addAsync(onLoadableStateChange, 5000));
				loadable.load();
			}
		}		

		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			if (event.newState == LoadState.LOADED)
			{
				assertTrue(event.loadable.loadedContext is PluginLoadedContext);
			}
			else if (event.newState == LoadState.LOAD_FAILED)
			{
				fail();
			}
		}
		
		
		/*		
		override protected function createInterfaceObject(... args):Object
		{
			return new DynamicPluginLoader(mediaFactory);
		}
		
		override protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			// return pluginElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			return new LoadableTrait(loader, resource);
		}
		
		override protected function get successfulResource():IMediaResource
		{
			return new URLResource(TestConstants.REMOTE_VALID_PLUGIN_SWF_URL);
		}

		override protected function get failedResource():IMediaResource
		{
			return new URLResource(TestConstants.REMOTE_INVALID_PLUGIN_SWF_URL);
		}

		override protected function get unhandledResource():IMediaResource
		{
			return new URLResource(TestConstants.REMOTE_UNHANDLED_PLUGIN_RESOURCE_URL);
		}
		*/
	}
}