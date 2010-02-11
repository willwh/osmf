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
package org.osmf.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.NetConnectionFactoryEvent;
	import org.osmf.media.URLResource;
	import org.osmf.netmocker.DefaultNetConnectionFactory;
	import org.osmf.netmocker.MockNetNegotiator;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.TestConstants;

	public class TestNetConnectionFactory extends TestCase
	{
		override public function setUp():void
		{
			eventDispatcher = new EventDispatcher();

			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			eventDispatcher = null;
		}
		
		public function testCreateWithSharingEnabled():void
		{
			testCreateMethod(true);
		}
		
		public function testCreateWithSharingDisabled():void
		{
			testCreateMethod(false);
		}

		public function testCreateMultipleWithSharingEnabled():void
		{
			testCreateMethod(true, true);
		}
		
		public function testCloseNetConnectionByResource():void
		{
			doTestCloseNetConnectionByResource(true);
		}
		
		/////////////////////////////////////////
		
		private function testCreateMethod(sharing:Boolean, createMultiple:Boolean=false):void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var factory:NetConnectionFactory = createNetConnectionFactory(sharing);
			factory.addEventListener(NetConnectionFactoryEvent.CREATED,onCreated);
			var resource:URLResource = SUCCESSFUL_RESOURCE;
			factory.createNetConnection(resource);
			function onCreated(event:NetConnectionFactoryEvent):void
			{
				assertTrue(event.type == NetConnectionFactoryEvent.CREATED);
				assertStrictlyEquals(event.shareable,sharing);
				assertTrue(event.netConnection.connected);
				assertStrictlyEquals(event.resource,resource);
				
				if (createMultiple)
				{
					factory.removeEventListener(NetConnectionFactoryEvent.CREATED,onCreated);
					factory.addEventListener(NetConnectionFactoryEvent.CREATED,onCreated2);
					
					var resource2:URLResource = SUCCESSFUL_RESOURCE2;
					factory.createNetConnection(resource2);
					
					function onCreated2(event2:NetConnectionFactoryEvent):void
					{
						assertTrue(event2.type == NetConnectionFactoryEvent.CREATED);
						assertStrictlyEquals(event2.shareable,sharing);
						assertTrue(event2.netConnection.connected);
						assertStrictlyEquals(event2.resource,resource2);
						
						// As long as both resources have the same app instance, they
						// should use the same NetConnection.
						assertStrictlyEquals(event.netConnection,event2.netConnection);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
				else
				{
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
		}
		
		private function doTestCloseNetConnectionByResource(sharing:Boolean):void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var factory:NetConnectionFactory = createNetConnectionFactory(sharing);
			factory.addEventListener(NetConnectionFactoryEvent.CREATED,onCreated);
			var resource:URLResource = SUCCESSFUL_RESOURCE;
			factory.createNetConnection(resource);
			function onCreated(event:NetConnectionFactoryEvent):void
			{
				assertTrue(event.type == NetConnectionFactoryEvent.CREATED);
				assertStrictlyEquals(event.shareable,sharing);
				assertTrue(event.netConnection.connected);
				assertStrictlyEquals(event.resource,resource);
				var nc:NetConnection = event.netConnection;
				factory.closeNetConnectionByResource(SUCCESSFUL_RESOURCE);
				assertFalse(nc.connected);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		private function createNetConnectionFactory(allowNetConnectionSharing:Boolean):NetConnectionFactory
		{
			return new DefaultNetConnectionFactory(createNetNegotiator, allowNetConnectionSharing);
		}
		
		private function createNetNegotiator():NetNegotiator
		{
			return new MockNetNegotiator();
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
		
		private var eventDispatcher:EventDispatcher;
		
		private static const TEST_TIME:int = 4000;
		
		private static const SUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO));
		private static const SUCCESSFUL_RESOURCE2:URLResource = new URLResource(new FMSURL(TestConstants.STREAMING_AUDIO_FILE));
	}
}