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
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.events.PluginLoadEvent;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.utils.IntegrationTestUtils;
	import org.openvideoplayer.utils.URL;

	public class TestPluginManagerIntegration extends TestCase
	{
		public function TestPluginManagerIntegration(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			mediaFactory  = new MediaFactory();
			pluginManager = new PluginManager(mediaFactory);

			super.setUp();
		}
		
		public function testLoadDynamicPluginWithValidURLResource():void
		{
			var pluginResource:URLResource 
				= new URLResource(new URL(IntegrationTestUtils.REMOTE_VALID_PLUGIN_SWF_URL));
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, addAsync(onPluginLoadEvent, 500));
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOAD_FAILED, onPluginLoadEvent);
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginLoadEvent(event:PluginLoadEvent):void
			{	
				if (event.type == PluginLoadEvent.PLUGIN_LOADED)
				{
					// expected
					assertTrue(pluginManager.numLoadedPlugins == 1);
					assertTrue(pluginManager.getLoadedPluginAt(0) == pluginResource);
				}
				else
				{
					assertTrue(false);
				}
			}
		}
		
		public function testLoadTwiceDynamicPluginWithValidURLResource():void
		{
			var pluginResource:URLResource 
				= new URLResource(new URL(IntegrationTestUtils.REMOTE_VALID_PLUGIN_SWF_URL));
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, addAsync(onPluginLoadEvent, 500));
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOAD_FAILED, onPluginLoadEvent);
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginLoadEvent(event:PluginLoadEvent):void
			{	
				if (event.type == PluginLoadEvent.PLUGIN_LOADED)
				{
					// expected
					assertTrue(pluginManager.numLoadedPlugins == 1);
					assertTrue(pluginManager.getLoadedPluginAt(0) == pluginResource);
					pluginManager.removeEventListener(PluginLoadEvent.PLUGIN_LOADED, onPluginLoadEvent);
					pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, onPluginLoadEvent2);
					pluginManager.loadPlugin(pluginResource);
				}
				else
				{
					assertTrue(false);
				}
			}
			
			function onPluginLoadEvent2(event:PluginLoadEvent):void
			{	
				if (event.type == PluginLoadEvent.PLUGIN_LOADED)
				{
					// expected
					assertTrue(pluginManager.numLoadedPlugins == 1);
					assertTrue(pluginManager.getLoadedPluginAt(0) == pluginResource);
				}
				else
				{
					assertTrue(false);
				}
			}
		}

		public function testLoadDynamicPluginWithInvalidURLResource():void
		{
			var pluginResource:URLResource 
				= new URLResource(new URL(IntegrationTestUtils.REMOTE_INVALID_PLUGIN_SWF_URL));
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, onPluginLoadEvent);
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOAD_FAILED, addAsync(onPluginLoadEvent, 500));
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginLoadEvent(event:PluginLoadEvent):void
			{	
				if (event.type == PluginLoadEvent.PLUGIN_LOADED)
				{
					assertTrue(false);
				}
				else
				{
					// expected
					assertTrue(pluginManager.numLoadedPlugins == 0);
				}
			}
		}

		private var mediaFactory:MediaFactory;
		private var pluginManager:PluginManager;
	}
}