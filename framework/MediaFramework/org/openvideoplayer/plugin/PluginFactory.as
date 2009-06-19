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