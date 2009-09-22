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
package org.openvideoplayer.tracking
{
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.events.BeaconEvent;
	import org.openvideoplayer.utils.HTTPLoader;
	import org.openvideoplayer.utils.MockHTTPLoader;
	import org.openvideoplayer.utils.TestConstants;
	import org.openvideoplayer.utils.NetFactory;
	import org.openvideoplayer.utils.URL;
	
	public class TestBeacon extends TestCase
	{
		private function createHTTPLoader():HTTPLoader
		{
			if (NetFactory.neverUseMockObjects)
			{
				return new HTTPLoader();
			}
			else
			{
				var loader:MockHTTPLoader = new MockHTTPLoader();
				loader.setExpectationForURL(SUCCESSFUL_URL.rawUrl, true, null);
				loader.setExpectationForURL(FAILED_URL.rawUrl, false, null);
				return loader;
			}
		}
		
		public function testConstructor():void
		{
			try
			{
				// Should throw when url is null.
				new Beacon(null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
			}
		}
		
		public function testPingWithSuccess():void
		{
			var loader:HTTPLoader = createHTTPLoader();
			
			var beacon:Beacon = new Beacon(SUCCESSFUL_URL, loader);
			beacon.addEventListener(BeaconEvent.PING_COMPLETE, addAsync(onTestPingWithSuccess, 4000));
			beacon.addEventListener(BeaconEvent.PING_FAILED, dontCall);
			beacon.ping();
		}
		
		private function onTestPingWithSuccess(event:BeaconEvent):void
		{
			assertTrue(event.type == BeaconEvent.PING_COMPLETE);
		}

		public function testPingWithFailure():void
		{
			var loader:HTTPLoader = createHTTPLoader();
			
			var beacon:Beacon = new Beacon(FAILED_URL, loader);
			beacon.addEventListener(BeaconEvent.PING_COMPLETE, dontCall);
			beacon.addEventListener(BeaconEvent.PING_FAILED, addAsync(onTestPingWithFailure, 4000));
			beacon.ping();
		}
		
		private function onTestPingWithFailure(event:BeaconEvent):void
		{
			assertTrue(event.type == BeaconEvent.PING_FAILED);
			assertTrue(event.errorText == null);
		}
		
		private function dontCall(event:Event):void
		{
			fail();
		}

		private var SUCCESSFUL_URL:URL = new URL(TestConstants.REMOTE_IMAGE_FILE);
		private var FAILED_URL:URL = new URL(TestConstants.REMOTE_INVALID_IMAGE_FILE);
	}
}