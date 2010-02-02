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
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.PluginManagerEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.Version;
	
	/**
	 * Dispatched when the PluginManager has successfully loaded a plugin.
	 *
	 * @eventType org.osmf.events.PluginManagerEvent.PLUGIN_LOAD
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="pluginLoad", type="org.osmf.events.PluginManagerEvent")]

	/**
	 * Dispatched when the PluginManager has failed to load a plugin due to an error.
	 *
	 * @eventType org.osmf.events.PluginManagerEvent.PLUGIN_LOAD_ERROR
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="pluginLoadError", type="org.osmf.events.PluginManagerEvent")]

	/**
	 * Dispatched when the PluginManager has successfully unloaded a plugin.
	 *
	 * @eventType org.osmf.events.PluginManagerEvent.PLUGIN_UNLOAD
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="pluginUnload", type="org.osmf.events.PluginManagerEvent")]

	/**
	 * <p>
	 * This class, as indicated by its name, is a manager that provide access to plugin related
	 * features, including:
	 * <ul>
	 * <li>Load a plugin</li>
	 * <li>Unload a plugin</li>
	 * <li>Check whether a plugin has been loaded</li>
	 * <li>Get access to the media factory</li>
	 * <li>Get the number of plugins that have been loaded</li>
	 * <li>Get the plugin specified by the index</li>
	 * </ul>
	 * </p> 
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class PluginManager extends EventDispatcher
	{
		/**
		 * Constructor
		 *
		 * @param mediaFactory MediaFactory within which the PluginManager will place the
		 * information from loaded plugins.  If null, the PluginManager will create a
		 * DefaultMediaFactory.
		 * @param minimumSupportedFrameworkVersion  The minimum version number of the
		 * framework that a loaded plugin must be compiled against in order to load.
		 * Version numbers are defined in the org.osmf.utils.Version class.  The default
		 * (null) indicates that the PluginManager should use Version.lastAPICompatibleVersion.
		 *
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function PluginManager(mediaFactory:MediaFactory=null, minimumSupportedFrameworkVersion:String=null)
		{
			_mediaFactory = mediaFactory != null ? mediaFactory : new DefaultMediaFactory();
			this.minimumSupportedFrameworkVersion = minimumSupportedFrameworkVersion != null ? minimumSupportedFrameworkVersion : Version.lastAPICompatibleVersion ;
			initPluginFactory();
			_pluginMap = new Dictionary();
			_pluginList = new Vector.<PluginEntry>();
		}
		
		/**
		 * Load a plugin identified by resource. The PluginManager will not reload the plugin
		 * if it has been loaded. Upon successful loading, a PluginManagerEvent.PLUGIN_LOAD
		 * event will be dispatched. Otherwise, a PluginManagerEvent.PLUGIN_LOAD_ERROR
		 * event will be dispatched.
		 *
		 * @param resource MediaResourceBase at which the plugin (swf file or class) is hosted. It is assumed that 
		 * it is sufficient to identify a plugin using the MediaResourceBase.  
		 *
		 * @throws ArgumentError If resource is null or resource is not URLResource or PluginInfoResource 
		 *
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function loadPlugin(resource:MediaResourceBase):void
		{
			if (resource == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			var identifier:Object = getPluginIdentifier(resource);
			var pluginEntry:PluginEntry = _pluginMap[identifier] as PluginEntry;
			if (pluginEntry != null)
			{
				dispatchEvent
					( new PluginManagerEvent
						( PluginManagerEvent.PLUGIN_LOAD
						, false
						, false
						, resource
						)
					);
			}
			else
			{
				var pluginElement:MediaElement = _pluginFactory.createMediaElement(resource);
				
				if (pluginElement != null)
				{
					pluginEntry = new PluginEntry(pluginElement, PluginLoadingState.LOADING);
					_pluginMap[identifier] = pluginEntry;
					
					var loadTrait:LoadTrait = pluginElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
					if (loadTrait != null)
					{
						loadTrait.addEventListener(
							LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
						loadTrait.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
						loadTrait.load();
					}
					else
					{
						dispatchEvent(new PluginManagerEvent(PluginManagerEvent.PLUGIN_LOAD_ERROR));
					}
				}
				else
				{
					throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
				}
			}
			
			function onLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					pluginEntry.state = PluginLoadingState.LOADED;
					_pluginList.push(pluginEntry);
					
					dispatchEvent
						( new PluginManagerEvent
							( PluginManagerEvent.PLUGIN_LOAD
							, false
							, false
							, resource
							)
						);
				}
				else if (event.loadState == LoadState.LOAD_ERROR)
				{
					// Remove from the pluginMap when the load failed!!!!
					delete _pluginMap[identifier];
					dispatchEvent(new PluginManagerEvent(PluginManagerEvent.PLUGIN_LOAD_ERROR));
				}
			}
			function onMediaError(event:MediaErrorEvent):void
			{
				dispatchEvent(event.clone());
			}
		}

		/**
		 * Unload a plugin identified by url.
		 * 
		 * @param url URL that is used to identify the plugin.Upon successful loading,
		 * a PluginManagerEvent.PLUGIN_UNLOAD event will be dispatched. 
		 * 
		 * @throws ArgumentError If resource is null or resource is not URLResource or PluginInfoResource 
		 *
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function unloadPlugin(resource:MediaResourceBase):void
		{
			if (resource == null) 
	
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			var identifier:Object = getPluginIdentifier(resource);
			var pluginEntry:PluginEntry = _pluginMap[identifier] as PluginEntry;
			if (pluginEntry != null)
			{
				var loadTrait:LoadTrait = pluginEntry.pluginElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
				if (loadTrait != null)
				{
					loadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
					loadTrait.unload();
				}
			}
			else
			{
				dispatchEvent(new PluginManagerEvent(PluginManagerEvent.PLUGIN_UNLOAD));
			}
			
			function onLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.UNINITIALIZED)
				{
					// When the LoadTrait's state is back to UNINITIALIZED, the unload process 
					// is finished.
					removePluginEntry(pluginEntry);
					delete _pluginMap[identifier];
					dispatchEvent(new PluginManagerEvent(PluginManagerEvent.PLUGIN_UNLOAD));
				}
			}
		}


		/**
		 * Check whether a plugin has been loaded.
		 * 
		 * @param resource MediaResourceBase that is used to identify the plugin.
		 * 
		 * @return Returns true or false accordingly.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function isPluginLoaded(resource:MediaResourceBase):Boolean
		{
			if (resource == null)
			{
				return false;
			}
			
			var identifier:Object = getPluginIdentifier(resource);
			if (identifier == null)
			{
				return false;
			}
			
			var pluginEntry:PluginEntry = _pluginMap[identifier] as PluginEntry;
			
			return ((pluginEntry != null) && (pluginEntry.state == PluginLoadingState.LOADED));
		}

		/**
		 * Get access to the media factory that is used for plugin loading and 
		 * MediaInfo registering. Plugins can use this MediaFactory to create
		 * other types of MediaElement.
		 *
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get mediaFactory():MediaFactory
		{
			return _mediaFactory;
		}

		/**
		 * Get the number of plugins that have been loaded
		 *
		 * @return Returns the number of plugins that have been loaded
		 *
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get numLoadedPlugins():int
		{
			return _pluginList.length;
		}

		/**
		 * Get the plugin specified by the index
		 *
		 * @param index The index identifies the slot at which the plugin is stored
		 *
		 * @return Returns the MediaResourceBase that represents the plugin
		 *
		 * @throws RangeError if the index is out of the range
		 *
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function getLoadedPluginAt(index:int):MediaResourceBase
		{
			var pluginEntry:PluginEntry = _pluginList[index];
			return pluginEntry.pluginElement.resource;
		}
		
		// Internals
		//
		
		private function getPluginIdentifier(resource:MediaResourceBase):Object
		{
			var identifier:Object = null;
			
			if (resource is URLResource)
			{
				identifier = (resource as URLResource).url.rawUrl;
			}
			else if (resource is PluginInfoResource)
			{
				identifier = (resource as PluginInfoResource).pluginInfoRef;
			}
					
			return identifier;
		}
		
		private function removePluginEntry(pluginEntry:PluginEntry):void
		{
			for (var i:int = 0; i < _pluginList.length; i++)
			{
				if (_pluginList[i] == pluginEntry)
				{
					_pluginList.splice(i, 1);
				}
			}
		}
		
		private function initPluginFactory():void
		{
			_pluginFactory = new MediaFactory();
			staticPluginLoader = new StaticPluginLoader(mediaFactory, minimumSupportedFrameworkVersion);
			dynamicPluginLoader = new DynamicPluginLoader(mediaFactory, minimumSupportedFrameworkVersion);
			
			// Add MediaInfo objects for the static and dynamic plugin loaders.
			//
			
			var staticPluginItem:MediaFactoryItem = new MediaFactoryItem
					( STATIC_PLUGIN_MEDIA_INFO_ID
					, staticPluginLoader.canHandleResource
					, createStaticPluginElement
					);
			_pluginFactory.addItem(staticPluginItem);
			
			var dynamicPluginItem:MediaFactoryItem = new MediaFactoryItem
					( DYNAMIC_PLUGIN_MEDIA_INFO_ID
					, dynamicPluginLoader.canHandleResource
					, createDynamicPluginElement
					);
			_pluginFactory.addItem(dynamicPluginItem);
		}
		
		private function createStaticPluginElement():MediaElement
		{
			return new PluginElement(staticPluginLoader);
		}

		private function createDynamicPluginElement():MediaElement
		{
			return new PluginElement(dynamicPluginLoader);
		}

		private var _mediaFactory:MediaFactory;	
		private var _pluginFactory:MediaFactory;	
		private var _pluginMap:Dictionary;
		private var _pluginList:Vector.<PluginEntry>;
		
		private var minimumSupportedFrameworkVersion:String;
		private var staticPluginLoader:StaticPluginLoader;
		private var dynamicPluginLoader:DynamicPluginLoader;

		private static const STATIC_PLUGIN_MEDIA_INFO_ID:String = "org.osmf.plugins.StaticPluginLoader";
		private static const DYNAMIC_PLUGIN_MEDIA_INFO_ID:String = "org.osmf.plugins.DynamicPluginLoader";
	}
}