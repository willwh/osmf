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
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.utils.Version;
	
	/**
	 * The PluginLoader class extends LoaderBase to provide
	 * loading support for plugins.
	 * It is the base class
	 * for creating static and dynamic plugin loaders.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	internal class PluginLoader extends LoaderBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function PluginLoader(mediaFactory:MediaFactory, minimumSupportedFrameworkVersion:String)
		{			
			this.mediaFactory = mediaFactory;
			this.minimumSupportedFrameworkVersion = minimumSupportedFrameworkVersion;
		}
		
		/**
		 * Unloads the given PluginInfo.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		protected function unloadFromPluginInfo(pluginInfo:PluginInfo):void
		{
			if (pluginInfo != null)
			{
				for (var i:int = 0; i < pluginInfo.numMediaFactoryItems; i++)
				{
					var item:MediaFactoryItem = pluginInfo.getMediaFactoryItemAt(i);
					
					var actualItem:MediaFactoryItem = mediaFactory.getItemById(item.id);
					if (actualItem != null)
					{
						mediaFactory.removeItem(actualItem);
					}
				}
			}
		}
		
		/**
		 * Loads the plugin into the LoadTrait.
		 * On success sets the LoadState of the LoadTrait to LOADING, 
		 * on failure to LOAD_ERROR.
		 * @param pluginInfo PluginInfo instance to use for this load operation.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function loadFromPluginInfo(loadTrait:LoadTrait, pluginInfo:PluginInfo, loader:Loader = null):void
		{
			var invalidImplementation:Boolean = false;
			
			if (pluginInfo != null)
			{				
				if (pluginInfo.isFrameworkVersionSupported(Version.version) &&
					isPluginVersionSupported(pluginInfo.frameworkVersion))
				{
					try
					{
						// Make sure the plugin metadata has the expected default params
						// (such as MediaFactory). 
						var pluginFacet:KeyValueFacet = loadTrait.resource.metadata.getFacet(MetadataNamespaces.PLUGIN_PARAMETERS) as KeyValueFacet;
						if (pluginFacet == null)
						{
							pluginFacet = new KeyValueFacet(MetadataNamespaces.PLUGIN_PARAMETERS);
							loadTrait.resource.metadata.addFacet(pluginFacet);
						}
						pluginFacet.addValue(MetadataNamespaces.PLUGIN_METADATA_MEDIAFACTORY_KEY, mediaFactory);
						
						pluginInfo.initializePlugin(loadTrait.resource.metadata);
					
						for (var i:int = 0; i < pluginInfo.numMediaFactoryItems; i++)
						{
							// Range error usually comes from this method call.  But
							// we generate an error if the returned value is null.
							var item:MediaFactoryItem = pluginInfo.getMediaFactoryItemAt(i);
							if (item == null)
							{
								throw new RangeError();
							}
							
							mediaFactory.addItem(item);							
						}
						
						var loadedContext:PluginLoadedContext = new PluginLoadedContext(pluginInfo, loader); 
						
						updateLoadTrait(loadTrait, LoadState.READY, loadedContext);
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
					updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
					loadTrait.dispatchEvent
						( new MediaErrorEvent
							( MediaErrorEvent.MEDIA_ERROR
							, false
							, false
							, new MediaError(MediaErrorCodes.INVALID_PLUGIN_VERSION)
							)
						);
				}
			}
			else
			{
				// No PluginInfo on root.
				invalidImplementation = true;
			}
			
			if (invalidImplementation)
			{
				updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
				loadTrait.dispatchEvent
					( new MediaErrorEvent
						( MediaErrorEvent.MEDIA_ERROR
						, false
						, false
						, new MediaError(MediaErrorCodes.INVALID_PLUGIN_IMPLEMENTATION)
						)
					);
			}
		}
		
		private function isPluginVersionSupported(pluginVersion:String):Boolean
		{
			if (pluginVersion == null || pluginVersion.length == 0)
			{
				return false;
			}

			var minVersion:Object = parseVersionString(minimumSupportedFrameworkVersion);
			var pVersion:Object = parseVersionString(pluginVersion);
			
			return 		pVersion.major > minVersion.major
					||	(	pVersion.major == minVersion.major
						&&	( 	pVersion.minor > minVersion.minor
							||	(	pVersion.minor == minVersion.minor
								&&	pVersion.subMinor >= minVersion.subMinor
								)
							)
						);
		}
		
		private static function parseVersionString(version:String):Object
		{
			var versionInfo:Array = version.split(".");
			
			var major:int = 0;
			var minor:int = 0;
			var subMinor:int = 0;
			
			if (versionInfo.length >= 1)
			{
				major = parseInt(versionInfo[0]);
			}
			if (versionInfo.length >= 2)
			{
				minor = parseInt(versionInfo[1]);
			}
			if (versionInfo.length >= 3)
			{
				subMinor = parseInt(versionInfo[2]);
			}

			return {major:major, minor:minor, subMinor:subMinor};
		}
		
		private var minimumSupportedFrameworkVersion:String;
		private var mediaFactory:MediaFactory;
	}
}