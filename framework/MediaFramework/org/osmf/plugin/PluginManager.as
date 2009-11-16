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
	import org.osmf.events.PluginLoadEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.URLResource;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.MediaFrameworkStrings;
	
	/**
	 * Dispatched when the PluginManager has successfully loaded a plugin.
	 *
	 * @eventType org.osmf.events.PluginLoadEvent.PLUGIN_LOADED
	 **/
	[Event(name="pluginLoaded", type="org.osmf.events.PluginLoadEvent")]

	/**
	 * Dispatched when the PluginManager has failed to load a plugin.
	 *
	 * @eventType org.osmf.events.PluginLoadEvent.PLUGIN_LOAD_FAILED
	 **/
	[Event(name="pluginLoadFailed", type="org.osmf.events.PluginLoadEvent")]

	/**
	 * Dispatched when the PluginManager has successfully unloaded a plugin.
	 *
	 * @eventType org.osmf.events.PluginLoadEvent.PLUGIN_UNLOADED
	 **/
	[Event(name="pluginUnloaded", type="org.osmf.events.PluginLoadEvent")]

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
	 */
	public class PluginManager extends EventDispatcher
	{
		/**
		 * Constructor
		 *
		 * @param mediaFactory MediaFactory with which the plugins will register its
		 * supported MediaInfo objects. The best practice is to use a single instance of
		 * MediaFactory across the MediaPlayer application such that all MediaInfo can be 
		 * accessed from the same MediaFactory.
		 *
		 **/
		public function PluginManager(mediaFactory:MediaFactory)
		{
			_mediaFactory = mediaFactory;
			initPluginFactory();
			_pluginMap = new Dictionary();
			_pluginList = new Vector.<PluginEntry>();
		}
		
		/**
		 * Load a plugin identified by resource. The PluginManager will not reload the plugin
		 * if it has been loaded. Upon successful loading, a PluginLoadEvent.PLUGIN_LOADED 
		 * event will be dispatched. Otherwise, a PluginLoadEvent.PLUGIN_LOAD_FAILED
		 * event will be dispatched.
		 *
		 * @param resource IMediaResource at which the plugin (swf file or class) is hosted. It is assumed that 
		 * it is sufficient to identify a plugin using the IMediaResource.  
		 *
		 * @throws ArgumentError If resource is null or resource is not IURLResource or PluginClassResource
		 *
		 **/
		public function loadPlugin(resource:IMediaResource):void
		{
			if ((resource == null) || 
				(!(resource is URLResource) && !(resource is PluginClassResource)))
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			var identifier:String = getPluginIdentifier(resource);
			var pluginEntry:PluginEntry = _pluginMap[identifier] as PluginEntry;
			if (pluginEntry != null)
			{
				dispatchEvent
					( new PluginLoadEvent
						( PluginLoadEvent.PLUGIN_LOADED
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
					
					var loadable:ILoadable = pluginElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
					if (loadable != null)
					{
						loadable.addEventListener(
							LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
						loadable.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
						loadable.load();
					}
					else
					{
						dispatchEvent(new PluginLoadEvent(PluginLoadEvent.PLUGIN_LOAD_FAILED));
					}
				}
				else
				{
					throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
				}
			}
			
			function onLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					pluginEntry.state = PluginLoadingState.LOADED;
					_pluginList.push(pluginEntry);
					
					dispatchEvent
						( new PluginLoadEvent
							( PluginLoadEvent.PLUGIN_LOADED
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
					dispatchEvent(new PluginLoadEvent(PluginLoadEvent.PLUGIN_LOAD_FAILED));
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
		 * a PluginLoadEvent.PLUGIN_UNLOADED event will be dispatched. 
		 * 
		 * @throws ArgumentError If resource is null or resource is not IURLResource or PluginClassResource
		 *
		 **/
		public function unloadPlugin(resource:IMediaResource):void
		{
			if ((resource == null) || 
				(!(resource is URLResource) && !(resource is PluginClassResource)))
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			var identifier:String = getPluginIdentifier(resource);
			var pluginEntry:PluginEntry = _pluginMap[identifier] as PluginEntry;
			var loadable:ILoadable;
			if (pluginEntry != null)
			{
				loadable = pluginEntry.pluginElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				if (loadable != null)
				{
					loadable.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
					loadable.unload();
				}
			}
			else
			{
				dispatchEvent(new PluginLoadEvent(PluginLoadEvent.PLUGIN_UNLOADED));
			}
			
			function onLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.UNINITIALIZED)
				{
					// When the loadable's state is back to UNINITIALIZED, the unload process 
					// is finished.
					removePluginEntry(pluginEntry);
					delete _pluginMap[identifier];
					dispatchEvent(new PluginLoadEvent(PluginLoadEvent.PLUGIN_UNLOADED));
				}
			}
		}


		/**
		 * Check whether a plugin has been loaded.
		 * 
		 * @param resource IMediaResource that is used to identify the plugin.
		 * 
		 * @return Returns true or false accordingly.
		 **/
		public function isPluginLoaded(resource:IMediaResource):Boolean
		{
			if ((resource == null) || 
				(!(resource is URLResource) && !(resource is PluginClassResource)))
			{
				return false;
			}
			
			var identifier:String = getPluginIdentifier(resource);
			if (identifier == null || identifier.length <= 0)
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
		 **/
		public function get mediaFactory():MediaFactory
		{
			return _mediaFactory;
		}

		/**
		 * Get the number of plugins that have been loaded
		 *
		 * @return Returns the number of plugins that have been loaded
		 *
		 **/
		public function get numLoadedPlugins():int
		{
			return _pluginList.length;
		}

		/**
		 * Get the plugin specified by the index
		 *
		 * @param index The index identifies the slot at which the plugin is stored
		 *
		 * @return Returns the IMediaResource that represents the plugin
		 *
		 * @throws RangeError if the index is out of the range
		 *
		 **/
		public function getLoadedPluginAt(index:int):IMediaResource
		{
			var pluginEntry:PluginEntry = _pluginList[index];
			return pluginEntry.pluginElement.resource;
		}
		
		// Internals
		//
		
		private function getPluginIdentifier(resource:IMediaResource):String
		{
			var identifier:String = "";
			
			if (resource is URLResource)
			{
				identifier = (resource as URLResource).url.rawUrl;
			}
			else if (resource is PluginClassResource)
			{
				identifier = (resource as PluginClassResource).pluginInfoRef.toString();
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
			staticPluginLoader = new StaticPluginLoader(mediaFactory);
			dynamicPluginLoader = new DynamicPluginLoader(mediaFactory);
			
			// Add MediaInfo objects for the static and dynamic plugin loaders.
			//
			
			var staticPluginMediaInfo:MediaInfo = new MediaInfo
					( STATIC_PLUGIN_MEDIA_INFO_ID
					, staticPluginLoader
					, createStaticPluginElement
					);
			_pluginFactory.addMediaInfo(staticPluginMediaInfo);
			
			var dynamicPluginMediaInfo:MediaInfo = new MediaInfo
					( DYNAMIC_PLUGIN_MEDIA_INFO_ID
					, dynamicPluginLoader
					, createDynamicPluginElement
					);
			_pluginFactory.addMediaInfo(dynamicPluginMediaInfo);
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
		
		private var staticPluginLoader:StaticPluginLoader;
		private var dynamicPluginLoader:DynamicPluginLoader;

		private static const STATIC_PLUGIN_MEDIA_INFO_ID:String = "org.osmf.plugins.StaticPluginLoader";
		private static const DYNAMIC_PLUGIN_MEDIA_INFO_ID:String = "org.osmf.plugins.DynamicPluginLoader";
	}
}