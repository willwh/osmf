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