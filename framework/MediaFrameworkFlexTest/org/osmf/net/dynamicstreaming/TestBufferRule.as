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
package org.osmf.net.dynamicstreaming
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.*;
	import org.osmf.media.*;
	import org.osmf.net.*;
	import org.osmf.netmocker.*;
	import org.osmf.traits.*;
	import org.osmf.utils.*;

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
				(_loader as MockDynamicStreamingNetLoader).netStreamExpectedDuration = 2;
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
			_loadable.addEventListener(LoadableStateChangeEvent.LOAD_STATE_CHANGE, onLoaded);
			
			_eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			_loadable.load();	
		}
		
		private function onLoaded(event:LoadableStateChangeEvent):void
		{
			switch (event.loadState)
			{
				case LoadState.READY:
					_loadable.removeEventListener(LoadableStateChangeEvent.LOAD_STATE_CHANGE, onLoaded);
					var loadedContext:ILoadedContext = _loadable.loadedContext;
					assertTrue(loadedContext != null);
					assertTrue(loadedContext is NetLoadedContext);
					
					var stream:NetStream = (loadedContext as NetLoadedContext).stream;
					assertNotNull(stream);
					
					var metrics:MockNetStreamMetrics = new MockNetStreamMetrics(stream);
					_bufferRule = new InsufficientBufferRule(metrics);
			
					stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					
					var dsResource:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL(TestConstants.REMOTE_DYNAMIC_STREAMING_VIDEO_HOST));
					for each (var item:Object in TestConstants.REMOTE_DYNAMIC_STREAMING_VIDEO_STREAMS)
					{
						dsResource.streamItems.push(new DynamicStreamingItem(item["stream"], item["bitrate"]));
					}
										
					stream.client.addHandler(NetStreamCodes.ON_PLAY_STATUS, onPlayStatus);
					stream.play(dsResource);
					break;
				case LoadState.LOAD_ERROR:
					fail("Load ERROR");
					break;				
			}
		}
		
		private function onPlayStatus(event:Object):void
		{
			if (event["code"] == NetStreamCodes.NETSTREAM_PLAY_COMPLETE)
			{
				_eventDispatcher.dispatchEvent(new Event("testComplete"));
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
			}
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
		
		// Really long to enable non-mock testing.
		private static const ASYNC_DELAY:int = 60000;
		
		private var _eventDispatcher:EventDispatcher;
		private var _netFactory:DynamicNetFactory;
		private var _loader:NetLoader;
		private var _loadable:ILoadable;
		private var _bufferRule:InsufficientBufferRule;	
	}
}
