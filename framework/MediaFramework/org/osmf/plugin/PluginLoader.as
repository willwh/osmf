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
	import flash.display.Loader;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaInfo;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoaderBase;
	import org.osmf.utils.Version;
	
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
		 * Unloads the given IPluginInfo.
		 **/ 
		protected function unloadFromPluginInfo(pluginInfo:IPluginInfo):void
		{
			if (pluginInfo != null)
			{
				for (var i:int = 0; i < pluginInfo.numMediaInfos; i++)
				{
					var mediaInfo:MediaInfo = pluginInfo.getMediaInfoAt(i);
					
					var actualMediaInfo:MediaInfo = mediaFactory.getMediaInfoById(mediaInfo.id);
					if (actualMediaInfo != null)
					{
						mediaFactory.removeMediaInfo(actualMediaInfo);
					}
				}
			}
		}

		/**
		 * Loads the plugin into the ILoadable.
		 * On success sets the LoadState of the ILOadable to LOADING, 
		 * on failure to LOAD_FAILED.
		 * @param pluginInfo IPluginInfo instance to use for this load operation.
		 */
		protected function loadFromPluginInfo(loadable:ILoadable, pluginInfo:IPluginInfo, loader:Loader = null):void
		{
			var invalidImplementation:Boolean = false;
			
			if (pluginInfo != null)
			{
				if (pluginInfo.isFrameworkVersionSupported(Version.version()))
				{
					try
					{
						for (var i:int = 0; i < pluginInfo.numMediaInfos; i++)
						{
							// Range error usually comes from this method call.  But
							// we generate an error if the returned value is null.
							var mediaInfo:MediaInfo = pluginInfo.getMediaInfoAt(i);
							if (mediaInfo == null)
							{
								throw new RangeError();
							}
							
							mediaFactory.addMediaInfo(mediaInfo);
						}
						
						var loadedContext:PluginLoadedContext = new PluginLoadedContext(pluginInfo, loader); 
						
						updateLoadable(loadable, LoadState.LOADED, loadedContext);
					}
					catch (error:RangeError)
					{
						// Range error when retrieving media infos.
						invalidImplementation = true;
					}
				}
				else
				{
					// Version not supported by plugin.
					updateLoadable(loadable, LoadState.LOAD_FAILED);
					loadable.dispatchEvent(new MediaErrorEvent(new MediaError(MediaErrorCodes.INVALID_PLUGIN_VERSION)));
				}
			}
			else
			{
				// No IPluginInfo on root.
				invalidImplementation = true;
			}
			
			if (invalidImplementation)
			{
				updateLoadable(loadable, LoadState.LOAD_FAILED);
				loadable.dispatchEvent(new MediaErrorEvent(new MediaError(MediaErrorCodes.INVALID_PLUGIN_IMPLEMENTATION)));
			}
		}
		
		private var mediaFactory:MediaFactory;
	}
}