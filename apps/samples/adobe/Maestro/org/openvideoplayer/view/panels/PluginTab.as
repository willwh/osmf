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
package org.openvideoplayer.view.panels
{
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.model.Model;
	import org.openvideoplayer.plugin.PluginClassResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class PluginTab extends PluginLayout
	{
		public function PluginTab()
		{
			super();
			
			pluginsLoaded = new ArrayCollection();
		}
		
		override protected function childrenCreated():void
		{
			loadedPluginList.dataProvider = pluginsLoaded;
			loadPluginButton.addEventListener(MouseEvent.CLICK, onLoadClicked);
		}
		
		private function onLoadClicked(event:MouseEvent):void
		{
			pluginError.text = "";
			pluginError.visible = false;
			
			if (pluginAlreadyLoaded(pluginResource.text))
			{
				pluginError.text = "Plugin has already been loaded...";
				pluginError.visible = true;
				
				return;
			}
			
			loadPluginButton.enabled = false;
			loadPlugin(pluginResource.text);
		}
		
		private function loadPlugin(source:String):void
		{
			var pluginResource:IMediaResource;
			if (source.substr(0, HTTP.length) == HTTP || 
				source.substr(0, HTTPS.length) == HTTPS || 
				source.substr(0, FILE.length) == FILE)
			{
				pluginResource = new URLResource(source);
			}
			else
			{
				var pluginInfoRef:Class = flash.utils.getDefinitionByName(source) as Class;
				pluginResource = new PluginClassResource(pluginInfoRef);
			}
			loadPluginFromResource(pluginResource);
		}
		
		private function loadPluginFromResource(pluginResource:IMediaResource):void
		{
			var pluginElement:MediaElement = Model.getInstance().pluginFactory.createMediaElement(pluginResource);
			if (pluginElement != null && pluginElement.hasTrait(MediaTraitType.LOADABLE))
			{
				var loadable:ILoadable = pluginElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
				loadable.load();
			}
		}

		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			loadPluginButton.enabled = true;
			
			if (event.newState == LoadState.LOADED)
			{
				pluginsLoaded.addItem(pluginResource.text);
				loadedPluginList.dataProvider = pluginsLoaded;
			}
			else
			{
				pluginError.text = "Plugin Loading Failed...";
				pluginError.visible = true;
			}
		}
		
		private function pluginAlreadyLoaded(name:String):Boolean
		{
			for (var i:int; i < pluginsLoaded.length; i++)
			{
				if (pluginsLoaded[i] == name) 
				{
					return true;
				}
			}
			
			return false;
		}
		
		private var pluginsLoaded:ArrayCollection;
		
		private static const HTTP:String = "http";
		private static const HTTPS:String = "https";
		private static const FILE:String = "file";
	}
}