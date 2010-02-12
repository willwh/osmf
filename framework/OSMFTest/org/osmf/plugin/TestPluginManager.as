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
	import __AS3__.vec.Vector;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.*;
	import org.osmf.media.*;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
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
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, addAsync(onPluginManagerEvent, 500));
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, onPluginManagerEvent);
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginManagerEvent(event:PluginManagerEvent):void
			{	
				if (event.type == PluginManagerEvent.PLUGIN_LOAD)
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
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, onPluginManagerEvent);
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, onPluginManagerEvent);
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_UNLOAD, addAsync(onPluginUnloadedEvent, 500));
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginManagerEvent(event:PluginManagerEvent):void
			{	
				if (event.type == PluginManagerEvent.PLUGIN_LOAD)
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
			
			function onPluginUnloadedEvent(event:PluginManagerEvent):void
			{	
				if (event.type == PluginManagerEvent.PLUGIN_UNLOAD)
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
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, addAsync(onPluginManagerEvent, 500));
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, onPluginManagerEvent);
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginManagerEvent(event:PluginManagerEvent):void
			{	
				if (event.type == PluginManagerEvent.PLUGIN_LOAD)
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
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, onPluginManagerEvent);
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, addAsync(onPluginManagerEvent, 500));
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginManagerEvent(event:PluginManagerEvent):void
			{	
				if (event.type == PluginManagerEvent.PLUGIN_LOAD)
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
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, onPluginManagerEvent);
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, addAsync(onPluginManagerEvent, 500));
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginManagerEvent(event:PluginManagerEvent):void
			{	
				if (event.type == PluginManagerEvent.PLUGIN_LOAD)
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
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, onPluginManagerEvent);
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, addAsync(onPluginManagerEvent, 500));
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginManagerEvent(event:PluginManagerEvent):void
			{	
				if (event.type == PluginManagerEvent.PLUGIN_LOAD)
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
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, onPluginManagerEvent);
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, addAsync(onPluginManagerEvent, 500));
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginManagerEvent(event:PluginManagerEvent):void
			{	
				if (event.type == PluginManagerEvent.PLUGIN_LOAD)
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
		
		public function testLoadPluginWithCustomMetadata():void
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
		
		public function testLoadPluginWithDefaultMetadata():void
		{
			var pluginInfo:CreateOnLoadPluginInfo = new CreateOnLoadPluginInfo();
			
			assertNull(pluginInfo.pluginMetadata);
			
			var resource:PluginInfoResource = new PluginInfoResource(pluginInfo);
			
			pluginManager.loadPlugin(resource);
			
			assertNotNull(pluginInfo.pluginMetadata);
			var defaultFacet:KeyValueFacet = pluginInfo.pluginMetadata.getFacet(MetadataNamespaces.PLUGIN_PARAMETERS) as KeyValueFacet;
			assertNotNull(defaultFacet);
			var injectedFactory:MediaFactory = defaultFacet.getValue(MetadataNamespaces.PLUGIN_METADATA_MEDIAFACTORY_KEY);
			assertNotNull(injectedFactory);
			assertEquals(injectedFactory, mediaFactory);
		}
		
		public function testLoadCreateOnLoadPlugin():void
		{
			var pluginInfo:CreateOnLoadPluginInfo = new CreateOnLoadPluginInfo();
			assertEquals(0, pluginInfo.createCount);
			var resource:PluginInfoResource = new PluginInfoResource(pluginInfo);
			
			pluginManager.loadPlugin(resource);
			assertEquals(0, pluginInfo.createCount);
			assertEquals(0, pluginInfo.callbackCount);
			
			pluginManager.loadPlugin(resource); // No-op, plugin already loaded.
			assertEquals(0, pluginInfo.createCount);
			assertEquals(0, pluginInfo.callbackCount);
			
			// Creating a MediaElement that the plugin can handle should trigger
			// the creation  function.
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://example.com/video.flv")));
			assertTrue(mediaElement == null);
			assertEquals(1, pluginInfo.createCount);
			assertEquals(0, pluginInfo.callbackCount);

		}
		
		public function testLoadCreateOnLoadPluginWithCallbacks():void
		{
			mediaFactory = new DefaultMediaFactory();
			pluginManager = new PluginManager(mediaFactory);
			
			var pluginInfo:CreateOnLoadPluginInfo = new CreateOnLoadPluginInfo();
			assertEquals(0, pluginInfo.createCount);
			var resource:PluginInfoResource = new PluginInfoResource(pluginInfo);
			
			pluginManager.loadPlugin(resource);
			assertEquals(0, pluginInfo.createCount);
			assertEquals(0, pluginInfo.callbackCount);

			// Creating a MediaElement that a default factory item can handle
			// should trigger the callback function.
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://example.com/image1.jpg")));
			assertTrue(mediaElement != null);
			assertEquals(0, pluginInfo.createCount);
			assertEquals(1, pluginInfo.callbackCount);

			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://example.com/image2.jpg")));
			assertTrue(mediaElement != null);
			assertEquals(0, pluginInfo.createCount);
			assertEquals(2, pluginInfo.callbackCount);
		}
		
		public function testMinimumVersionOverrride():void
		{
			var loaded:Boolean = false;
			var loadedFailed:Boolean = false;
			
			
			var pluginInfo:OldPluginInfo = new OldPluginInfo(new Vector.<MediaFactoryItem>);
			
			pluginManager = new PluginManager(mediaFactory, "0.5.0");
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, onLoaded);
			pluginManager.loadPlugin(new PluginInfoResource(pluginInfo)); 
			assertTrue(loaded);
			
			pluginManager = new PluginManager(mediaFactory, "0.6.0");
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, onFailed);
			pluginManager.loadPlugin(new PluginInfoResource(pluginInfo)); 
			assertTrue(loadedFailed);
			
			function onLoaded(event:PluginManagerEvent):void
			{
				loaded = true;
			}	
			function onFailed(event:PluginManagerEvent):void
			{
				loadedFailed = true;
			}			
		}
		
		private function doUnloadPluginWithInvalidParameter(resource:MediaResourceBase):Boolean
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
		
		private function doLoadPluginWithInvalidParameter(resource:MediaResourceBase):Boolean
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
	
import __AS3__.vec.Vector;
import org.osmf.media.MediaFactoryItem;
		
class OldPluginInfo extends org.osmf.plugin.PluginInfo
{
	public function OldPluginInfo(items:Vector.<MediaFactoryItem>)
	{
		super(items);
	}
	
	override public function get frameworkVersion():String
	{
		return "0.5.0";
	}
	
}

