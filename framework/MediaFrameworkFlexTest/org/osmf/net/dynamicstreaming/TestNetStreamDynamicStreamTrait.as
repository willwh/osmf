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
	import flash.events.*;
	import flash.net.*;
	
	import org.osmf.net.*;
	import org.osmf.netmocker.MockDynamicNetStream;
	import org.osmf.traits.TestDynamicStreamTrait;
	import org.osmf.utils.*;
	
	public class TestNetStreamDynamicStreamTrait extends TestDynamicStreamTrait
	{
		override public function setUp():void
		{			
			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			netFactory = null;
			stream.close();
			stream = null;
		}

		public function testMaxIndex():void
		{
			dynamicStreamTrait.maxAllowedIndex = 2;
			assertTrue(2, dynamicStreamTrait.maxAllowedIndex);
		}
		
		override public function testGetBitrateForIndex():void
		{
			assertEquals(500, dynamicStreamTrait.getBitrateForIndex(0));
			assertEquals(800, dynamicStreamTrait.getBitrateForIndex(1));
			assertEquals(1000, dynamicStreamTrait.getBitrateForIndex(2));
			assertEquals(3000, dynamicStreamTrait.getBitrateForIndex(3));		
		}
			
		override protected function createInterfaceObject(... args):Object
		{
			var dsr:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL("http://www.example.com/ondemand"));
			dsr.streamItems.push(new DynamicStreamingItem("stream_500kbps", 500));
			dsr.streamItems.push(new DynamicStreamingItem("stream_800kbps", 800));
			dsr.streamItems.push(new DynamicStreamingItem("stream_1000kbps", 1000));
			dsr.streamItems.push(new DynamicStreamingItem("stream_3000kbps", 3000));
			
			netFactory = new DynamicNetFactory();
			
			var connection:NetConnection = netFactory.createNetConnection();
			connection.connect(null);
			stream = netFactory.createNetStream(connection);
			stream.client = new NetClient();
			
			if (stream is MockDynamicNetStream)
			{
				(stream as MockDynamicNetStream).expectedDuration = 10;
			}
				
			stream.play(dsr);
			return new NetStreamDynamicStreamTrait(stream as DynamicNetStream, dsr);
		}
				
		private static const TIMEOUT:int = 12000;
		
		private var netFactory:DynamicNetFactory;
		private var stream:NetStream;
	}
}
