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
package org.openvideoplayer.swf
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.content.TestContentLoaderIntegration;
	import org.openvideoplayer.events.LoaderEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.utils.IntegrationTestUtils;
	import org.openvideoplayer.utils.TestConstants;
	import org.openvideoplayer.utils.URL;
	
	public class TestSWFLoaderIntegration extends TestContentLoaderIntegration
	{
		override public function setUp():void
		{
			super.setUp();
			
			eventDispatcher = new EventDispatcher();
			eventCount = 0;
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			eventDispatcher = null;
		}
		
		override protected function createInterfaceObject(... args):Object
		{
			return new SWFLoader();
		}
		
		override protected function get successfulResource():IMediaResource
		{
			return new URLResource(new URL(IntegrationTestUtils.REMOTE_VALID_PLUGIN_SWF_URL));
		}

		override protected function get failedResource():IMediaResource
		{
			return new URLResource(new URL(IntegrationTestUtils.REMOTE_INVALID_PLUGIN_SWF_URL));
		}
		
		public function testLoadAVM1SWF():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 1000));
						
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onTestLoadAVM1SWF);
			loader.load(createILoadable(new URLResource(new URL(IntegrationTestUtils.REMOTE_AVM1_SWF_FILE))));
		}
		
		private function onTestLoadAVM1SWF(event:LoaderEvent):void
		{
			eventCount++;
			switch (eventCount)
			{
				case 1:
					assertTrue(event.oldState == LoadState.CONSTRUCTED);
					assertTrue(event.newState == LoadState.LOADING);
					
					assertTrue(event.loadedContext == null);
					break;
				case 2:
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOAD_FAILED);
					
					assertTrue(event.loadedContext == null);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
					break;
				default:
					fail();
			}
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}

		private var eventDispatcher:EventDispatcher;
		private var eventCount:int = 0;
	}
}