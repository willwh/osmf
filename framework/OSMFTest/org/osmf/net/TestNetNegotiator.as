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
	import org.osmf.netmocker.MockNetConnection;
	import org.osmf.netmocker.NetConnectionExpectation;
	
	public class TestNetNegotiator extends TestCase
	{			
		
		override public function setUp():void
		{
			eventDispatcher = new EventDispatcher();
		}
		
		
		public function testFMTA():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			var resource:URLResource = new URLResource("rtmp://myserver.com/appname/resource?as=adobe&te=connect");
			var negotiator:NetNegotiator = new NetNegotiator();
			var netConnection:MockNetConnection = new MockNetConnection();
			netConnection.expectation = NetConnectionExpectation.CONNECT_WITH_FMTA;
			var connections:Vector.<NetConnection> = new Vector.<NetConnection>;
			var connectionURLs:Vector.<String> = new Vector.<String>;
			connectionURLs.push("rtmp://myserver.com/appname/");
			connections.push(netConnection);
			
			negotiator.addEventListener(NetConnectionFactoryEvent.CREATION_COMPLETE, onCreated);
			negotiator.addEventListener(NetConnectionFactoryEvent.CREATION_ERROR, onFail);
						
			negotiator.createNetConnection(resource, connectionURLs, connections);
			
			function onCreated(event:NetConnectionFactoryEvent):void
			{
				assertTrue(event.type == NetConnectionFactoryEvent.CREATION_COMPLETE);
				assertTrue(event.netConnection.connected);
				assertStrictlyEquals(event.resource,resource);
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
			function onFail(event:NetConnectionFactoryEvent):void
			{
				assertTrue(false);
			}
		}
		
		public function mustReceiveEvent(event:Event = null):void
		{
			
		}
		
		private var eventDispatcher:EventDispatcher;
		private static const TEST_TIME:Number = 1000;
	}
}