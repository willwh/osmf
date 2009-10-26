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
	
	import org.osmf.events.*;
	import org.osmf.media.*;
	import org.osmf.netmocker.*;
	import org.osmf.traits.*;
	import org.osmf.utils.*;

	public class TestDynamicStreamingNetLoader extends TestILoader
	{
		override public function setUp():void
		{
			netFactory = new DynamicNetFactory();
			eventDispatcher = new EventDispatcher();
			super.setUp();
		}		
		
		override public function tearDown():void
		{
			super.tearDown();
			netFactory = null;
			eventDispatcher = null;
		}
		
		override public function testCanHandleResource():void
		{
			var dsr:DynamicStreamingResource = successfulResource as DynamicStreamingResource;
			var host:FMSURL = dsr.hostName;
			
			assertTrue(loader.canHandleResource(new URLResource(host)) == true);
			assertTrue(loader.canHandleResource(failedResource) == true);
			assertTrue(loader.canHandleResource(unhandledResource) == false);
		}
		
				
		//---------------------------------------------------------------------
		
				
		override protected function createInterfaceObject(... args):Object
		{
			return netFactory.createNetLoader();
		}
		
		override protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			var mockLoader:MockDynamicStreamingNetLoader = loader as MockDynamicStreamingNetLoader;
			if (mockLoader)
			{
				if (resource === successfulResource)
				{
					mockLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
				}
				else if (resource == failedResource)
				{
					mockLoader.netConnectionExpectation = NetConnectionExpectation.REJECTED_CONNECTION;
				}
				else if (resource == unhandledResource)
				{
					mockLoader.netConnectionExpectation = NetConnectionExpectation.REJECTED_CONNECTION;
				}
			}
			return new LoadableTrait(loader, resource);
		}
		
		override protected function get successfulResource():IMediaResource
		{
			if (_dsResource == null)
			{
				_dsResource = new DynamicStreamingResource(new FMSURL("rtmp://myhost.com/ondemand"));
				_dsResource.addItem(new DynamicStreamingItem("stream1_300kbps", 300));
				_dsResource.addItem(new DynamicStreamingItem("stream2_500kbps", 500));
				_dsResource.addItem(new DynamicStreamingItem("stream3_1000kbps", 1000));
				_dsResource.addItem(new DynamicStreamingItem("stream4_3000kpbs", 3000));
			}
			return _dsResource as IMediaResource;
		}

		override protected function get failedResource():IMediaResource
		{
			return UNSUCCESSFUL_RESOURCE;
		}

		override protected function get unhandledResource():IMediaResource
		{
			return UNHANDLED_RESOURCE;
		}
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
			assertTrue(error.errorCode == MediaErrorCodes.INVALID_URL_PROTOCOL ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_REJECTED ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_INVALID_APP ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_FAILED ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_TIMEOUT ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_SECURITY_ERROR ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_ASYNC_ERROR ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_IO_ERROR ||
					   error.errorCode == MediaErrorCodes.NETCONNECTION_ARGUMENT_ERROR);
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
		
		private var netFactory:NetFactory;
		private var eventDispatcher:EventDispatcher;
		private var _dsResource:DynamicStreamingResource;		
		
		private static const UNSUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.INVALID_STREAMING_VIDEO));
		private static const UNHANDLED_RESOURCE:NullResource = new NullResource();
	}
}
