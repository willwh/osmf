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
package org.openvideoplayer.netmocker
{
	import org.openvideoplayer.loaders.TestILoader;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.utils.NullResource;
	import org.openvideoplayer.utils.TestConstants;
	
	public class TestMockNetLoader extends TestILoader
	{
		override public function setUp():void
		{
			netLoader = new MockNetLoader();

			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			netLoader = null;
		}
		
		public function testConstructor():void
		{
			assertTrue(netLoader.netConnectionExpectation == NetConnectionExpectation.VALID_CONNECTION);
			assertTrue(netLoader.netStreamExpectedDuration == 0);
			assertTrue(netLoader.netStreamExpectedHeight == 0);
			assertTrue(netLoader.netStreamExpectedWidth == 0);
			assertTrue(netLoader.netStreamExpectedEvents.length == 0);
		}
		
		override protected function createInterfaceObject(... args):Object
		{
			return netLoader;
		}
		
		override protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			if (resource == successfulResource)
			{
				netLoader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			}
			else if (resource == failedResource)
			{
				netLoader.netConnectionExpectation = NetConnectionExpectation.REJECTED_CONNECTION;
			}
			else if (resource == unhandledResource)
			{
				netLoader.netConnectionExpectation = NetConnectionExpectation.REJECTED_CONNECTION;
			}
			return new LoadableTrait(netLoader, resource);
		}
		
		override protected function get successfulResource():IMediaResource
		{
			return SUCCESSFUL_RESOURCE;
		}

		override protected function get failedResource():IMediaResource
		{
			return UNSUCCESSFUL_RESOURCE;
		}

		override protected function get unhandledResource():IMediaResource
		{
			return UNHANDLED_RESOURCE;
		}

		private static const SUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO));
		private static const UNSUCCESSFUL_RESOURCE:URLResource = new URLResource(new FMSURL(TestConstants.INVALID_STREAMING_VIDEO));
		private static const UNHANDLED_RESOURCE:NullResource = new NullResource();
		
		private var netLoader:MockNetLoader;
	}
}