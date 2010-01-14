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
package
{
	import mx.controls.Alert;
	
	import org.osmf.display.ScaleMode;
	import org.osmf.events.PluginLoadEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.PluginInfoResource;
	import org.osmf.plugin.PluginManager;
	import org.osmf.utils.FMSURL;
	
	public class MainWindow extends MainWindowLayout
	{
		// Overrides
		//
				
		override protected function childrenCreated():void
		{
			super.childrenCreated();
						
			mediaPlayerWrapper.scaleMode = ScaleMode.NONE;
			
			mediaFactory = new MediaFactory();
			netLoader = new NetLoader();
			
			loadPlugins
				(	[ new PluginInfoResource(new MetadataVideoPluginInfo)
				  	]
				);
		}
		
		private function loadPlugins(pluginResources:Array):void
		{
			var loadedCount:int = 0;
			
			pluginManager = new PluginManager(mediaFactory);
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, onPluginLoaded);
			
			for each (var pluginResource:MediaResourceBase in pluginResources)
			{
				pluginManager.loadPlugin(pluginResource);
			}
		
			function onPluginLoaded(event:PluginLoadEvent):void
			{
				loadedCount++;

				// Wait until the last one is loaded, then load the media.				
				if (loadedCount == pluginResources.length)
				{
					pluginManager.removeEventListener(PluginLoadEvent.PLUGIN_LOADED, onPluginLoaded);
					
					loadMedia();
				}
			}
		}
		
		// Internals
		//
				
		private function loadMedia():void
		{
			var resource:URLResource = new URLResource(new FMSURL(REMOTE_STREAM));
			
			// The plugin only handles input that has the following piece of metadata.
			// If you comment out the following line of code, then no MediaElement
			// will be returned.
			//resource.metadata.addFacet(new KeyValueFacet(new URL("http://example.com/myCustomNS")));
			
			var mediaElement:MediaElement = mediaFactory.createMediaElement(resource);

			mediaPlayerWrapper.element = mediaElement;
			
			if (mediaElement == null)
			{
				Alert.show("No MediaElement could be created for the input resource.");
			}
		}
		
		// Event Handlers
		//
		
		private var mediaFactory:MediaFactory;
		private var pluginManager:PluginManager;
		private var netLoader:NetLoader;

		private static const REMOTE_STREAM:String = "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
	}
}
