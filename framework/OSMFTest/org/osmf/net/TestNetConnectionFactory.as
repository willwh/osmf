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


	import flash.net.NetConnection;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.NetConnectionFactoryEvent;
	import org.osmf.media.URLResource;
	import org.osmf.netmocker.DefaultNetConnectionFactory;
	import org.osmf.netmocker.MockNetNegotiator;
	import org.osmf.traits.LoadTrait;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.TestConstants;



	public class TestNetConnectionFactory extends TestCase
	{
		
		public function testCreateWithSharingEnabled():void
		{
			testCreateMethod(true);
		}
		
		public function testCreateWithSharingDisabled():void
		{
			testCreateMethod(false);
		}
		
		public function testCloseNetConnectionByResource():void
		{
			doTestCloseNetConnectionByResource(true);
		}
		
		/////////////////////////////////////////
		
		
		private function testCreateMethod(sharing:Boolean):void
		{
			var factory:NetConnectionFactory = createNetConnectionFactory();
			factory.addEventListener(NetConnectionFactoryEvent.CREATED,onCreated);
			var loadTrait:LoadTrait = new NetStreamLoadTrait(null, SUCCESSFUL_RESOURCE);
			factory.create(loadTrait,sharing);
			function onCreated(event:NetConnectionFactoryEvent):void
			{
				assertTrue(event.type == NetConnectionFactoryEvent.CREATED);
				assertStrictlyEquals(event.shareable,sharing);
				assertTrue(event.netConnection.connected);
				assertStrictlyEquals(event.loadTrait,loadTrait);
			}
		}
		
		private function doTestCloseNetConnectionByResource(sharing:Boolean):void
		{
			var factory:NetConnectionFactory = createNetConnectionFactory();
			factory.addEventListener(NetConnectionFactoryEvent.CREATED,onCreated);
			var loadTrait:LoadTrait = new NetStreamLoadTrait(null, SUCCESSFUL_RESOURCE);
			factory.create(loadTrait,sharing);
			function onCreated(event:NetConnectionFactoryEvent):void
			{
				assertTrue(event.type == NetConnectionFactoryEvent.CREATED);
				assertStrictlyEquals(event.shareable,sharing);
				assertTrue(event.netConnection.connected);
				assertStrictlyEquals(event.loadTrait,loadTrait);
				var nc:NetConnection = event.netConnection;
				factory.closeNetConnectionByResource(SUCCESSFUL_RESOURCE);
				assertFalse(nc.connected);
			}
		}
	
		
		private function createNetConnectionFactory():NetConnectionFactory
		{
			var negotiator:MockNetNegotiator = new MockNetNegotiator()
			return new DefaultNetConnectionFactory(negotiator);
		}
		
		private static const SUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO));
		
		
	}
	
}