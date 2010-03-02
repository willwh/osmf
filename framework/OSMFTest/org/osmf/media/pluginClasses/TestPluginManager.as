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
package org.osmf.media.pluginClasses
{
	import __AS3__.vec.Vector;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.*;
	import org.osmf.media.*;
	import org.osmf.net.DynamicStreamingResource;
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

		public function testCheckLoadStatusOfStaticPluginWithValidClassResource():void
		{
			var pluginResource:PluginInfoResource = new PluginInfoResource(new SimpleVideoPluginInfo);
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, addAsync(onPluginManagerEvent, 500));
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, onPluginManagerEvent);
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginManagerEvent(event:PluginManagerEvent):void
			{	
				assertTrue(event.type == PluginManagerEvent.PLUGIN_LOAD);
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
				assertTrue(event.type == PluginManagerEvent.PLUGIN_LOAD_ERROR);
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
			var pluginResource:URLResource = new URLResource("http://myinvalidurl.com/foo.swf");
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
			var pluginResource:URLResource = new URLResource("http://myinvalidurl.com/foo.swf");
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, onPluginManagerEvent);
			pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, addAsync(onPluginManagerEvent, 500));
			pluginManager.loadPlugin(pluginResource);
			
			function onPluginManagerEvent(event:PluginManagerEvent):void
			{
				assertTrue(event.type == PluginManagerEvent.PLUGIN_LOAD_ERROR)
			}
		}
		
		public function testLoadPluginWithInvalidParameters():void
		{
			assertTrue(doLoadPluginWithInvalidParameter(null));
			assertTrue(doLoadPluginWithInvalidParameter(new DynamicStreamingResource("rtmp://example.com/vod")));
		}
		
		public function testLoadPluginWithCustomMetadata():void
		{
			var metadataNS:String = "http://sentinel/namespace";
			var pluginInfo:CreateOnLoadPluginInfo = new CreateOnLoadPluginInfo();
			
			assertNull(pluginInfo.pluginResource);
			
			var resource:PluginInfoResource = new PluginInfoResource(pluginInfo);
			resource.addMetadataValue(metadataNS, "foo");
			
			pluginManager.loadPlugin(resource);
			
			assertNotNull(pluginInfo.pluginResource);
			assertNotNull(pluginInfo.pluginResource.getMetadataValue(metadataNS));
		}
		
		public function testLoadPluginWithDefaultMetadata():void
		{
			var pluginInfo:CreateOnLoadPluginInfo = new CreateOnLoadPluginInfo();
			
			assertNull(pluginInfo.pluginResource);
			
			var resource:PluginInfoResource = new PluginInfoResource(pluginInfo);
			
			pluginManager.loadPlugin(resource);
			
			assertNotNull(pluginInfo.pluginResource);
			var injectedFactory:MediaFactory = pluginInfo.pluginResource.getMetadataValue(PluginInfo.PLUGIN_MEDIAFACTORY_NAMESPACE) as MediaFactory;
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
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource("http://example.com/video.flv"));
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
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource("http://example.com/image1.jpg"));
			assertTrue(mediaElement != null);
			assertEquals(0, pluginInfo.createCount);
			assertEquals(1, pluginInfo.callbackCount);

			mediaElement = mediaFactory.createMediaElement(new URLResource("http://example.com/image2.jpg"));
			assertTrue(mediaElement != null);
			assertEquals(0, pluginInfo.createCount);
			assertEquals(2, pluginInfo.callbackCount);
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
		
class OldPluginInfo extends org.osmf.media.PluginInfo
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

