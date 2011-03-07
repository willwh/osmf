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
package org.osmf.net.httpstreaming
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.*;
	import org.osmf.net.*;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.net.NetClient;
	import org.osmf.net.NetStreamMetricsBase;
	import org.osmf.net.NetStreamSwitchManager;
	import org.osmf.net.SwitchingRuleBase;
	import org.osmf.net.TestNetStreamSwitchManager;
	import org.osmf.netmocker.MockNetStream;
	import org.osmf.netmocker.MockRTMPNetStreamMetrics;
	import org.osmf.utils.DynamicSwitchingRule;
	import org.osmf.utils.NetFactory;
	
	public class TestHTTPStreamingSwitchManager extends TestCase
	{	
		override public function setUp():void
		{
			super.setUp();
			
			eventDispatcher = new EventDispatcher();
			
			dsResource = new DynamicStreamingResource("rtmp://www.example.com/ondemand");
			dsResource.streamItems.push(new DynamicStreamingItem("stream_500kbps", 500));
			dsResource.streamItems.push(new DynamicStreamingItem("stream_800kbps", 800));
			dsResource.streamItems.push(new DynamicStreamingItem("stream_1000kbps", 1000));
			dsResource.streamItems.push(new DynamicStreamingItem("stream_3000kbps", 3000));
			
			netFactory = new NetFactory();
			
			connection = netFactory.createNetConnection();
			connection.connect(null);
			stream = netFactory.createNetStream(connection);
			stream.client = new NetClient();
			
			if (stream is MockNetStream)
			{
				(stream as MockNetStream).expectedDuration = 2;
			}
			
			metrics = new MockRTMPNetStreamMetrics(stream);
			
			rules = new Vector.<SwitchingRuleBase>();
			switchingRule = new DynamicSwitchingRule(metrics);
			rules.push(switchingRule);
			
			switchManager = new NetStreamSwitchManager(connection, stream, dsResource, metrics, rules);
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			dsResource = null;
			metrics = null;
			switchingRule = null;
			switchManager = null;
			netFactory = null;
			eventDispatcher = null;
			stream.close();
			stream = null;
			rules = null;
			connection = null;
		}
		
		public function testAutoSwitchTrue():void
		{
			switchManager = new HTTPStreamingSwitchManager(connection, stream, dsResource, metrics, rules);
			
			assertFalse(switchManager.autoSwitch);
			
			assertEquals(0, switchManager.currentIndex);
			
			stream.dispatchEvent(new HTTPStreamingEvent(HTTPStreamingEvent.FRAGMENT_END));
			
			switchManager.autoSwitch = true;
			assertEquals(0, switchManager.currentIndex);
			
			switchingRule.newIndex = 1;
			expectedIndex = 1;
			eventDispatcher.addEventListener("testComplete", addAsync(expectEvent, 5000));
			stream.addEventListener(NetStatusEvent.NET_STATUS, 
				function(event:NetStatusEvent):void
				{
					assertEquals("stream_800kbps", event.info.details);					
				});
			
			NetClient(stream.client).addHandler(NetStreamCodes.ON_PLAY_STATUS, onTestAutoSwitchWithSwitchUp);
			stream.dispatchEvent(new HTTPStreamingEvent(HTTPStreamingEvent.FRAGMENT_END));
		}	
		
		public function testAutoSwitchFalse():void
		{
			switchManager = new HTTPStreamingSwitchManager(connection, stream, dsResource, metrics, rules);
			
			assertFalse(switchManager.autoSwitch);
			
			assertEquals(0, switchManager.currentIndex);
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, 
				function(event:NetStatusEvent):void
				{
					fail();				
				});
			
			stream.dispatchEvent(new HTTPStreamingEvent(HTTPStreamingEvent.FRAGMENT_END));
			
			assertEquals(0, switchManager.currentIndex);
			
			switchingRule.newIndex = 1;
			expectedIndex = 0;
			eventDispatcher.addEventListener("testComplete", addAsync(doNotExpectEvent, 5000, null, expectEvent));
			NetClient(stream.client).addHandler(NetStreamCodes.ON_PLAY_STATUS, onTestAutoSwitchWithSwitchUp);
			stream.dispatchEvent(new HTTPStreamingEvent(HTTPStreamingEvent.FRAGMENT_END))
		}
		
		private function onTestAutoSwitchWithSwitchUp(info:Object):void
		{
			if (info.code == NetStreamCodes.NETSTREAM_PLAY_TRANSITION_COMPLETE)
			{
				assertEquals(expectedIndex, switchManager.currentIndex);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		private function expectEvent(event:Event):void
		{
			assertTrue(true);
		}
		
		private function doNotExpectEvent(event:Event):void
		{
			fail();
		}
		
		private var expectedIndex:int = 0;
		private static const ASYNC_DELAY:Number = 90000;
		
		private var eventDispatcher:EventDispatcher;
		private var netFactory:NetFactory;
		private var switchingRule:DynamicSwitchingRule;
		private var switchManager:NetStreamSwitchManager;
		private var metrics:NetStreamMetricsBase;
		private var stream:NetStream;
		private var dsResource:DynamicStreamingResource;
		private var rules:Vector.<SwitchingRuleBase>;
		private var connection:NetConnection;
	}
}