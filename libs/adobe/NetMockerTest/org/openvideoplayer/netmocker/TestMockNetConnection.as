/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.netmocker
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.net.NetConnectionCodes;

	public class TestMockNetConnection extends TestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			netConnection = new MockNetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusEventHandler);
			netStatusEvents = new Array();
			eventDispatcher = new EventDispatcher();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusEventHandler);
			netConnection = null;
			netStatusEvents = null;
			netStatusEventCallback = null;
			eventDispatcher = null;
		}
		
		public function testConstructor():void
		{
			assertTrue(netConnection.expectation == NetConnectionExpectation.VALID_CONNECTION);
		}
		
		public function testClose():void
		{
			startAsyncTest();
			
			netStatusEventCallback = function():void
			{
				assertTrue(netStatusEvents.length == 1)
				assertTrue(netStatusEvents[0].code == NetConnectionCodes.CONNECT_CLOSED);
				assertTrue(netStatusEvents[0].level == LEVEL_STATUS);
				
				endAsyncTest();
			}
			
			netConnection.close();
		}
		
		public function testConnectProgressive():void
		{
			startAsyncTest();

			netStatusEventCallback = function():void
			{
				assertTrue(netStatusEvents.length == 1)
				assertTrue(netStatusEvents[0].code == NetConnectionCodes.CONNECT_SUCCESS);
				assertTrue(netStatusEvents[0].level == LEVEL_STATUS);
				
				endAsyncTest();
			}
					
			netConnection.connect(null);
		}

		public function testConnectStreaming():void
		{
			startAsyncTest();

			netStatusEventCallback = function():void
			{
				assertTrue(netStatusEvents.length == 1)
				assertTrue(netStatusEvents[0].code == NetConnectionCodes.CONNECT_SUCCESS);
				assertTrue(netStatusEvents[0].level == LEVEL_STATUS);
				
				endAsyncTest();
			}
			
			netConnection.connect("rtmp://example.com/appName/streamName");
		}
		
		public function testConnectStreamingInvalidServer():void
		{
			startAsyncTest();
			
			netConnection.expectation = NetConnectionExpectation.INVALID_FMS_SERVER;

			netStatusEventCallback = function():void
			{
				if (netStatusEvents.length == 1)
				{
					assertTrue(netStatusEvents[0].code == NetConnectionCodes.CONNECT_FAILED);
					assertTrue(netStatusEvents[0].level == LEVEL_ERROR);
				
					endAsyncTest();
				}
				else fail();
			}
			
			netConnection.connect("rtmp://example.com/appName/streamName");
		}

		public function testConnectStreamingInvalidApplication():void
		{
			startAsyncTest();
			
			netConnection.expectation = NetConnectionExpectation.INVALID_FMS_APPLICATION;

			netStatusEventCallback = function():void
			{
				if (netStatusEvents.length == 1)
				{
					assertTrue(netStatusEvents[0].code == NetConnectionCodes.CONNECT_INVALIDAPP);
					assertTrue(netStatusEvents[0].level == LEVEL_ERROR);
				}
				else if (netStatusEvents.length == 2)
				{
					assertTrue(netStatusEvents[1].code == NetConnectionCodes.CONNECT_CLOSED);
					assertTrue(netStatusEvents[1].level == LEVEL_STATUS);

					endAsyncTest();
				}
				else fail();
			}
			
			netConnection.connect("rtmp://example.com/appName/streamName");
		}

		public function testConnectStreamingRejectedConnection():void
		{
			startAsyncTest();
			
			netConnection.expectation = NetConnectionExpectation.REJECTED_CONNECTION;

			netStatusEventCallback = function():void
			{
				if (netStatusEvents.length == 1)
				{
					assertTrue(netStatusEvents[0].code == NetConnectionCodes.CONNECT_REJECTED);
					assertTrue(netStatusEvents[0].level == LEVEL_ERROR);
				}
				else if (netStatusEvents.length == 2)
				{
					assertTrue(netStatusEvents[1].code == NetConnectionCodes.CONNECT_CLOSED);
					assertTrue(netStatusEvents[1].level == LEVEL_STATUS);

					endAsyncTest();
				}
				else fail();
			}
			
			netConnection.connect("rtmp://example.com/appName/streamName");
		}
		
		// Internals
		//
		
		private function netStatusEventHandler(event:NetStatusEvent):void
		{
			netStatusEvents.push(event.info);
			
			if (netStatusEventCallback != null)
			{
				netStatusEventCallback.call();
			}
		}
		
		private function startAsyncTest(timeout:Number=1000):void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, timeout));
		}

		private function endAsyncTest():void
		{
			eventDispatcher.dispatchEvent(new Event("testComplete"));
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder
		}

		
		private static const LEVEL_STATUS:String = "status";
		private static const LEVEL_ERROR:String = "error";

		private var netConnection:MockNetConnection;
		private var netStatusEvents:Array;
		private var netStatusEventCallback:Function;
		private var eventDispatcher:EventDispatcher;
	}
}