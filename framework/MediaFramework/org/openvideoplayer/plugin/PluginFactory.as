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
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.MediaInfo;
	
	/**
	 * PluginFactory is a MediaFactory that creates static and dynamic plugins.
	 * <p>A dynamic plugin is loaded at runtime from a SWF or SWC.
	 * A static plugin is compiled as part of the Strobe application.
	 * </p>
	 * <p>Through its <code>createMediaElement()</code> method, 
	 * PluginFactory creates MediaElements
	 * to represent plugins. These MediaElements are created with the ILoadable trait.</p>
	 * <p>The following code illustrates how a PluginFactory is used to create
	 * and load a MediaElement for a plugin.</p>
	 * <listing>
	 * private function loadPluginFromResource(pluginResource:IMediaResource):void
	 * {
	 * 	// Create a plugin factory.
	 * 	var pluginFactory:PluginFactory = new PluginFactory(mediaFactory);
	 * 
	 * 	// Create a MediaElement for the plugin using the specified resource.
	 * 	var pluginElement:MediaElement = pluginFactory.createMediaElement(pluginResource);
	 * 
	 * 	if (pluginElement != null &amp;&amp; pluginElement.hasTrait(MediaTraitType.LOADABLE))
	 * 	{
	 * 		// Get the element's ILoadable trait.
	 * 		var loadable:IMediaTrait = pluginElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
	 * 
	 * 		// Set up listener for the plugin's LOADABLE_STATE_CHANGE event.
	 * 		loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE,
	 * 			onLoadableStateChange);
	 * 
	 * 		// Load the plugin.
	 * 		loadable.load();
	 * 	}
	 * }
	 * </listing>
	 * It is important to distinguish between loading a plugin and loading its media.
	 * Loading a plugin, as in the above example, involves 
	 * downloading the SWF or SWC (for a dynamic plugin) or locating 
	 * the PluginClassResource (for a static plugin).
	 * It also includes registering the plugin's MediaInfo objects with the PluginFactory.
	 * Later, when the media described by one of these MediaInfo objects is needed,
	 * the media player application will load the appropriate media using the <code>load()</code>
	 * method of the ILoadable of the MediaElement that represents that piece of media. 
	 * 
	 * @see org.openvideoplayer.media.MediaFactory
	 */
	public class PluginFactory extends MediaFactory
	{
		/**
		 * Constructor.
		 * @param mediaFactory Media factory object. All loaded plugins 
		 * will register their <code>MediaInfo</code> objects 
		 * with this MediaFactory instance.
		 * @see org.openvideoplayer.media.MediaFactory#addMediaInfo()
		 */
		public function PluginFactory(mediaFactory:MediaFactory)
		{
			super();
			this.mediaFactory = mediaFactory;
			initialize();
		}
		
		private function initialize():void
		{
			// add MediaInfo objects for the static and dynamic plugin loaders
			
			// Static
			var staticPluginLoader:StaticPluginLoader = new StaticPluginLoader(mediaFactory);
			var staticPluginElementInitArgs:Array = new Array(staticPluginLoader);
			
			var staticPluginMediaInfo:MediaInfo = new MediaInfo(STATIC_PLUGIN_MEDIA_INFO_ID, 
																	new StaticPluginLoader(mediaFactory),
																	PluginElement,
																	staticPluginElementInitArgs);
			addMediaInfo(staticPluginMediaInfo);
			
			// Dynamic
			var dynamicPluginLoader:DynamicPluginLoader = new DynamicPluginLoader(mediaFactory);
			var dynamicPluginElementInitArgs:Array = new Array(dynamicPluginLoader);
			
			var dynamicPluginMediaInfo:MediaInfo = new MediaInfo(DYNAMIC_PLUGIN_MEDIA_INFO_ID, 
																	new DynamicPluginLoader(mediaFactory),
																	PluginElement,
																	dynamicPluginElementInitArgs);
			
			
			addMediaInfo(dynamicPluginMediaInfo);
			
		}

		private static const STATIC_PLUGIN_MEDIA_INFO_ID:String = "org.openvideoplayer.plugins.StaticPluginLoader";
		private static const DYNAMIC_PLUGIN_MEDIA_INFO_ID:String = "org.openvideoplayer.plugins.DynamicPluginLoader";
		// Actual mediaFactory reference for loading plugins. When a plugin is loaded, it will 
		// register the MediaInfos with this MediaFactory
		private var mediaFactory:MediaFactory;

	}
}