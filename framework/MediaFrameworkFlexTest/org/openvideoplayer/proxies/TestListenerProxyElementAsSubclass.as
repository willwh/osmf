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
package org.openvideoplayer.proxies
{
	import org.openvideoplayer.traits.IAudible;
	import org.openvideoplayer.traits.BufferableTrait;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.DynamicListenerProxyElement;
	import org.openvideoplayer.utils.DynamicMediaElement;
	
	public class TestListenerProxyElementAsSubclass extends TestListenerProxyElement
	{
		// Overrides
		//
		
		override public function setUp():void
		{
			super.setUp();
			
			events = new Array();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			events = null;
		}
		
		override protected function createProxyElement():ProxyElement
		{
			return new DynamicListenerProxyElement([]);
		}
		
		public function testProcessAudibleChanges():void
		{
			var proxyElement:ProxyElement = createProxyWithTrait(MediaTraitType.AUDIBLE);
			
			assertTrue(events.length == 0);
			
			// Changing properties should result in events.
			//
			
			var audible:IAudible = proxyElement.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			
			audible.volume = 0.57;
			assertTrue(events.length == 1);
			assertTrue(events[0]["oldVolume"] == 1.0);
			assertTrue(events[0]["newVolume"] == 0.57);

			audible.muted = true;
			assertTrue(events.length == 2);
			assertTrue(events[1]["muted"] == true);

			audible.pan = -0.5;
			assertTrue(events.length == 3);
			assertTrue(events[2]["oldPan"] == 0.0);
			assertTrue(events[2]["newPan"] == -0.5);

			// We shouldn't get any events when we're no longer proxying the
			// wrapped element.
			//
			
			proxyElement.wrappedElement = null;
			
			audible.volume = 0.27;
			audible.muted = false;
			audible.pan = 0.7;
			
			assertTrue(events.length == 3);
		}

		public function testProcessBufferableChanges():void
		{
			var proxyElement:ProxyElement = createProxyWithTrait(MediaTraitType.BUFFERABLE);
			
			assertTrue(events.length == 0);
			
			// Changing properties should result in events.
			//
			
			var bufferable:BufferableTrait = proxyElement.getTrait(MediaTraitType.BUFFERABLE) as BufferableTrait;
			
			// No event for bufferLength changes.
			bufferable.bufferLength = 5;
			assertTrue(events.length == 0);

			bufferable.bufferTime = 15;
			assertTrue(events.length == 1);
			assertTrue(events[0]["oldBufferTime"] == 0.0);
			assertTrue(events[0]["newBufferTime"] == 15.0);

			bufferable.buffering = true;
			assertTrue(events.length == 2);
			assertTrue(events[1]["buffering"] == true);

			// We shouldn't get any events when we're no longer proxying the
			// wrapped element.
			//
			
			proxyElement.wrappedElement = null;
			
			bufferable.bufferLength = 1;
			bufferable.bufferTime = 1;
			bufferable.buffering = false;
			
			assertTrue(events.length == 2);
		}
		
		private function createProxyWithTrait(traitType:MediaTraitType):ProxyElement
		{
			var proxyElement:DynamicListenerProxyElement = new DynamicListenerProxyElement(events);
			var wrappedElement:DynamicMediaElement = new DynamicMediaElement([traitType]);
			proxyElement.wrappedElement = wrappedElement;
			return proxyElement;
		}
		
		private var events:Array;
	}
}