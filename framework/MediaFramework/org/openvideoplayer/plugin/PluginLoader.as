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
	import flash.display.Loader;
	
	import org.openvideoplayer.loaders.LoaderBase;
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	
	/**
	 * The PluginLoader class implements ILoader to provide
	 * loading support for plugins.
	 * It is the base class
	 * for creating static and dynamic plugin loaders.
	 */
	internal class PluginLoader extends LoaderBase
	{
		/**
		 * Constructor.
		 */
		public function PluginLoader(mediaFactory:MediaFactory)
		{
			this.mediaFactory = mediaFactory;
		}

		/**
		 * Unloads the plugin from the ILoadable.
		 * Sets the LoadState of the ILoadable to CONSTRUCTED.
		 * @param loadable ILoadable from which to unload the plugin.
		 */
		override public function unload(loadable:ILoadable):void
		{
			super.unload(loadable);
			var loadedContext:PluginLoadedContext = loadable.loadedContext as PluginLoadedContext;
			var pluginInfo:IPluginInfo = loadedContext.pluginInfo;
			for (var i:int = 0; i < pluginInfo.numMediaInfos; i++)
			{
				var mediaInfo:IMediaInfo = pluginInfo.getMediaInfoAt(i);
				mediaFactory.removeMediaInfo(mediaInfo);
			}
			updateLoadable(loadable, LoadState.CONSTRUCTED);
		}

		/**
		 * Loads the plugin into the ILoadable.
		 * On success sets the LoadState of the ILOadable to LOADING, 
		 * on failure to LOAD_FAILED.
		 * @param pluginInfo IPluginInfo instance to use for this load operation.
		 */
		protected function loadFromPluginInfo(loadable:ILoadable, pluginInfo:IPluginInfo, loader:Loader = null):void
		{
			// TODO: Integrate Strobe versioning support
			// When Strobe versioning support is implemented, get the real version
			// and use that here. For now, using dummy text.
			if (pluginInfo.isFrameworkVersionSupported("Dummy Version"))
			{
				for (var i:int = 0; i < pluginInfo.numMediaInfos; i++)
				{
					var mediaInfo:IMediaInfo = pluginInfo.getMediaInfoAt(i);
					mediaFactory.addMediaInfo(mediaInfo);
				}
				
				var loadedContext:PluginLoadedContext = new PluginLoadedContext(pluginInfo, loader); 
				
				updateLoadable(loadable, LoadState.LOADED, loadedContext);
				
			}
			else
			{
				// version not supported by plugin
				updateLoadable(loadable, LoadState.LOAD_FAILED);
			}
		}
		/**
		 * The plugin factory that this loader uses to obtain an IPluginInfo.
		 */		
		protected var mediaFactory:MediaFactory;
	}
}