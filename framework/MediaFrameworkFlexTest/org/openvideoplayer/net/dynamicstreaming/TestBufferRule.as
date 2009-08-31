/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.openvideoplayer.net.dynamicstreaming
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.events.*;
	import org.openvideoplayer.media.*;
	import org.openvideoplayer.net.*;
	import org.openvideoplayer.netmocker.*;
	import org.openvideoplayer.traits.*;
	import org.openvideoplayer.utils.*;

	public class TestBufferRule extends TestCase
	{
		override public function setUp():void
		{
			super.setUp();

			_eventDispatcher = new EventDispatcher();
			_netFactory = new DynamicNetFactory();
			_loader = _netFactory.createNetLoader();
			
			if (_loader is MockDynamicStreamingNetLoader)
			{
				(_loader as MockDynamicStreamingNetLoader).netStreamExpectedEvents = [ 	new EventInfo(NetStreamCodes.NETSTREAM_BUFFER_EMPTY, "status", 5),
																						new EventInfo(NetStreamCodes.NETSTREAM_PLAY_INSUFFICIENTBW, "status", 10) ];
				(_loader as MockDynamicStreamingNetLoader).netStreamExpectedDuration = 12;
			}			
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			_loader.unload(_loadable);
			_loader = null;
			_loadable = null;
			_eventDispatcher = null;	
		}
		
		public function testGetNewIndex():void
		{
			_loadable =  new LoadableTrait(_loader, new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO)));
			_loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoaded);
			
			_eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 20000));
			
			_loadable.load();	
		}
		
		private function onLoaded(event:LoadableStateChangeEvent):void
		{
			switch (event.newState)
			{
				case LoadState.LOADED:
					_loadable.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoaded);
					var loadedContext:ILoadedContext = event.loadable.loadedContext;
					assertTrue(loadedContext != null);
					assertTrue(loadedContext is NetLoadedContext);
					
					var stream:NetStream = (loadedContext as NetLoadedContext).stream;
					assertNotNull(stream);
					
					var metrics:MockNetStreamMetrics = new MockNetStreamMetrics(stream);
					_bufferRule = new InsufficientBufferRule(metrics);
			
					stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					
					var dsResource:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL("myhost.com"));
					dsResource.addItem(new DynamicStreamingItem("stream1_300kbps", 300));
					dsResource.addItem(new DynamicStreamingItem("stream2_500kbps", 500));
					dsResource.addItem(new DynamicStreamingItem("stream3_1000kbps", 1000));
					dsResource.addItem(new DynamicStreamingItem("stream4_3000kpbs", 3000));
							
					stream.play(dsResource);
					break;
				case LoadState.LOAD_FAILED:
					fail("Load FAILED");
					break;				
			}
		}
		
		private function onNetStatus(e:NetStatusEvent):void
		{
			var result:int = -1;
			
			switch (e.info.code)
			{
				case NetStreamCodes.NETSTREAM_BUFFER_FULL:
					result = _bufferRule.getNewIndex();
					assertEquals(-1, result);
					break;
				case NetStreamCodes.NETSTREAM_BUFFER_EMPTY:
					result = _bufferRule.getNewIndex();
					assertEquals(0, result);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_INSUFFICIENTBW:
					result = _bufferRule.getNewIndex();
					assertEquals(0, result);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
					_eventDispatcher.dispatchEvent(new Event("testComplete"));
					break;
			}
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
		
		
		private var _eventDispatcher:EventDispatcher;
		private var _netFactory:DynamicNetFactory;
		private var _loader:NetLoader;
		private var _loadable:ILoadable;
		private var _bufferRule:InsufficientBufferRule;	
	}
}
