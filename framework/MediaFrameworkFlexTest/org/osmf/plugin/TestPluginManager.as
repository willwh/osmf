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
	import flexunit.framework.TestCase;
	
	import org.osmf.events.*;
	import org.osmf.media.*;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.net.dynamicstreaming.*;
	import org.osmf.utils.*;

	public class TestPluginManager extends TestCase
	{
		public function TestPluginManager(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			mediaFactory  = new MediaFactory();
			pluginManager = new PluginManager(mediaFactory);

			super.setUp();
		}
		
		public function testMediaFactoryAccess():void
		{
			assertTrue(pluginManager.mediaFactory == mediaFactory);
		}
		
		public function testLoadPluginWithValidClassResource():void
		{
			var pluginResource:PluginInfoResource = new PluginInfoResource(new SimpleVideoPluginInfo);
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, addAsync(onPluginLoadEvent, 500));
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOAD_FAILED, onPluginLoadEvent);
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginLoadEvent(event:PluginLoadEvent):void
			{	
				if (event.type == PluginLoadEvent.PLUGIN_LOADED)
				{
					// expected
					assertTrue(event.resource != null);
				}
				else
				{
					assertTrue(false);
				}
			}
		}

		public function testUnloadStaticPluginWithValidClassResource():void
		{
			var pluginResource:PluginInfoResource = new PluginInfoResource(new SimpleVideoPluginInfo);
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, onPluginLoadEvent);
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOAD_FAILED, onPluginLoadEvent);
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_UNLOADED, addAsync(onPluginUnloadedEvent, 500));
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginLoadEvent(event:PluginLoadEvent):void
			{	
				if (event.type == PluginLoadEvent.PLUGIN_LOADED)
				{
					// expected
					assertTrue(event.resource != null);
					pluginManager.unloadPlugin(pluginResource);
				}
				else
				{
					assertTrue(false);
				}
			}
			
			function onPluginUnloadedEvent(event:PluginLoadEvent):void
			{	
				if (event.type == PluginLoadEvent.PLUGIN_UNLOADED)
				{
					// expected
					assertTrue(pluginManager.numLoadedPlugins == 0);
				}
				else
				{
					assertTrue(false);
				}
			}			
		}

		public function testCheckLoadStatusOfStaticPluginWithValidClassResource():void
		{
			var pluginResource:PluginInfoResource = new PluginInfoResource(new SimpleVideoPluginInfo);
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, addAsync(onPluginLoadEvent, 500));
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOAD_FAILED, onPluginLoadEvent);
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginLoadEvent(event:PluginLoadEvent):void
			{	
				if (event.type == PluginLoadEvent.PLUGIN_LOADED)
				{
					// expected
					assertTrue(pluginManager.isPluginLoaded(pluginResource));
					assertTrue(pluginManager.numLoadedPlugins == 1);
					assertTrue(pluginManager.getLoadedPluginAt(0) == pluginResource);
				}
				else
				{
					assertTrue(false);
				}
			}
		}

		public function testLoadStatusOfStaticPluginWithInvalidClassResource():void
		{
			var pluginResource:PluginInfoResource = new PluginInfoResource(new InvalidVersionPluginInfo);
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
					assertTrue(pluginManager.isPluginLoaded(pluginResource) == false);
					assertTrue(pluginManager.numLoadedPlugins == 0);
				}
			}
		}
	
		public function testLoadStaticPluginWithInvalidClassResource():void
		{
			var pluginResource:PluginInfoResource = new PluginInfoResource(new InvalidVersionPluginInfo);
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
				}
			}
		}
	
		public function testLoadDynamicPluginWithInvalidURLResource():void
		{
			var pluginResource:URLResource = new URLResource(new URL("http://myinvalidurl.com/foo.swf"));
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
				}
			}
		}

		public function testCheckLoadStatusOfDynamicPluginWithInvalidURLResource():void
		{
			var pluginResource:URLResource = new URLResource(new URL("http://myinvalidurl.com/foo.swf"));
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
					assertTrue(pluginManager.isPluginLoaded(pluginResource) == false);
					assertTrue(pluginManager.numLoadedPlugins == 0);
				}
			}
		}
		
		public function testIsPluginLoaded():void
		{
			assertTrue(pluginManager.isPluginLoaded(null) == false);
			assertTrue(pluginManager.isPluginLoaded(new DynamicStreamingResource(new FMSURL("rtmp://example.com/vod"))) == false);
			
			assertTrue(pluginManager.isPluginLoaded(new URLResource(null)) == false);
			assertTrue(pluginManager.isPluginLoaded(new URLResource(new FMSURL(""))) == false);
			assertTrue(pluginManager.isPluginLoaded(new URLResource(new FMSURL("rtmp://example.com/vod"))) == false);			

			assertTrue(pluginManager.isPluginLoaded(new PluginInfoResource(new SimpleVideoPluginInfo)) == false);			
		}
		
		public function testLoadPluginWithInvalidParameters():void
		{
			assertTrue(doLoadPluginWithInvalidParameter(null));
			assertTrue(doLoadPluginWithInvalidParameter(new DynamicStreamingResource(new FMSURL("rtmp://example.com/vod"))));
		}
		
		public function testUnloadPluginWithInvalidParameters():void
		{
			assertTrue(doUnloadPluginWithInvalidParameter(null));
			
			// Unlike with load, the unload of an invalid resource should *not*
			// trigger an exception.  To do so would involve determining whether
			// the resource truly is a plugin resource or not (which probably
			// means loading it).
			assertFalse(doUnloadPluginWithInvalidParameter(new DynamicStreamingResource(new FMSURL("rtmp://example.com/vod"))));
		}
		
		public function testPluginMetadata():void
		{
			var metadataNS:String = "http://sentinel/namespace";
			var pluginInfo:CreateOnLoadPluginInfo = new CreateOnLoadPluginInfo();
			
			assertNull(pluginInfo.pluginMetadata);
			
			var resource:PluginInfoResource = new PluginInfoResource(pluginInfo);
			resource.metadata.addFacet(new KeyValueFacet(new URL(metadataNS)));
			
			pluginManager.loadPlugin(resource);
			
			assertNotNull(pluginInfo.pluginMetadata);
			assertNotNull(pluginInfo.pluginMetadata.getFacet(new URL(metadataNS)));
		}
		
		public function testPluginCreateOnLoad():void
		{
			var pluginInfo:CreateOnLoadPluginInfo = new CreateOnLoadPluginInfo();
			assertEquals(0, pluginInfo.createCount);
			var resource:PluginInfoResource = new PluginInfoResource(pluginInfo);
			
			pluginManager.loadPlugin(resource);
			assertEquals(1, pluginInfo.createCount);
			
			pluginManager.loadPlugin(resource); //No-op, plugin already loaded.
			assertEquals(1, pluginInfo.createCount);
			
			pluginManager.unloadPlugin(resource);
			pluginManager.loadPlugin(new PluginInfoResource(pluginInfo)); //Unloading and reloading will force recreation.
			assertEquals(2, pluginInfo.createCount);			
		}
		
		private function doUnloadPluginWithInvalidParameter(resource:IMediaResource):Boolean
		{
			try 
			{
				pluginManager.unloadPlugin(resource);
				return false;
			}
			catch(e:Error)
			{
				return true;
			}
			
			return false;
		}
		
		private function doLoadPluginWithInvalidParameter(resource:IMediaResource):Boolean
		{
			try 
			{
				pluginManager.loadPlugin(resource);
				return false;
			}
			catch(e:ArgumentError)
			{
				return true;
			}
			
			return false;
		}

		private var mediaFactory:MediaFactory;
		private var pluginManager:PluginManager;
	}
}