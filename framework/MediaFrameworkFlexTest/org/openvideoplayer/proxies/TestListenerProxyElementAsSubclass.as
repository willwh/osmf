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
	import org.openvideoplayer.events.SwitchingChangeEvent;
	import org.openvideoplayer.net.dynamicstreaming.SwitchingDetail;
	import org.openvideoplayer.net.dynamicstreaming.SwitchingDetailCodes;
	import org.openvideoplayer.traits.BufferableTrait;
	import org.openvideoplayer.traits.IAudible;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.PausableTrait;
	import org.openvideoplayer.traits.PlayableTrait;
	import org.openvideoplayer.traits.SeekableTrait;
	import org.openvideoplayer.traits.SpatialTrait;
	import org.openvideoplayer.traits.SwitchableTrait;
	import org.openvideoplayer.traits.TemporalTrait;
	import org.openvideoplayer.utils.DynamicListenerProxyElement;
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.SimpleLoader;
	
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
		
		public function testProcessLoadableChanges():void
		{
			var proxyElement:ProxyElement = createProxyWithTrait(MediaTraitType.LOADABLE);
			
			assertTrue(events.length == 0);
			
			// Changing properties should result in events.
			//
			
			var loadable:ILoadable = proxyElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			
			loadable.load();
			assertTrue(events.length == 1);
			assertTrue(events[0]["oldState"] == LoadState.CONSTRUCTED);
			assertTrue(events[0]["newState"] == LoadState.LOADED);
			
			loadable.unload();
			assertTrue(events.length == 2);
			assertTrue(events[1]["oldState"] == LoadState.LOADED);
			assertTrue(events[1]["newState"] == LoadState.CONSTRUCTED);

			// We shouldn't get any events when we're no longer proxying the
			// wrapped element.
			//
			
			proxyElement.wrappedElement = null;
			
			loadable.load();
			
			assertTrue(events.length == 2);
		}

		public function testProcessPausableChanges():void
		{
			var proxyElement:ProxyElement = createProxyWithTrait(MediaTraitType.PAUSABLE);
			
			assertTrue(events.length == 0);
			
			// Changing properties should result in events.
			//
			
			var pausable:PausableTrait = proxyElement.getTrait(MediaTraitType.PAUSABLE) as PausableTrait;
			
			pausable.pause();
			assertTrue(events.length == 1);
			assertTrue(events[0]["paused"] == true);
			
			pausable.resetPaused();
			assertTrue(events.length == 2);
			assertTrue(events[1]["paused"] == false);

			// We shouldn't get any events when we're no longer proxying the
			// wrapped element.
			//
			
			proxyElement.wrappedElement = null;
			
			pausable.pause();
			
			assertTrue(events.length == 2);
		}
		
		public function testProcessPlayableChanges():void
		{
			var proxyElement:ProxyElement = createProxyWithTrait(MediaTraitType.PLAYABLE);
			
			assertTrue(events.length == 0);
			
			// Changing properties should result in events.
			//
			
			var playable:PlayableTrait = proxyElement.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			
			playable.play();
			assertTrue(events.length == 1);
			assertTrue(events[0]["playing"] == true);
			
			playable.resetPlaying();
			assertTrue(events.length == 2);
			assertTrue(events[1]["playing"] == false);

			// We shouldn't get any events when we're no longer proxying the
			// wrapped element.
			//
			
			proxyElement.wrappedElement = null;
			
			playable.play();
			
			assertTrue(events.length == 2);
		}
		
		public function testProcessSeekingChanges():void
		{
			var proxyElement:ProxyElement = createProxyWithTrait(MediaTraitType.SEEKABLE);
			
			assertTrue(events.length == 0);
			
			// Changing properties should result in events.
			//
			
			var seekable:SeekableTrait = proxyElement.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			seekable.temporal = new TemporalTrait();
			TemporalTrait(seekable.temporal).duration = 3;
			
			assertTrue(events.length == 0);
			
			seekable.seek(1);
			assertTrue(events.length == 1);
			assertTrue(events[0]["seeking"] == true);
			assertTrue(events[0]["time"] == 1);
			
			// We shouldn't get any events when we're no longer proxying the
			// wrapped element.
			//
			
			proxyElement.wrappedElement = null;
			
			seekable.seek(0);
			
			assertTrue(events.length == 1);
		}
		
		public function testProcessTemporalChanges():void
		{
			var proxyElement:ProxyElement = createProxyWithTrait(MediaTraitType.TEMPORAL);
			
			assertTrue(events.length == 0);
			
			// Changing properties should result in events.
			//
			
			var temporal:TemporalTrait = proxyElement.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			
			assertTrue(events.length == 0);
			
			temporal.duration = 3;
			assertTrue(events.length == 1);
			assertTrue(isNaN(events[0]["oldDuration"]));
			assertTrue(events[0]["newDuration"] == 3);
			
			temporal.position = 3;
			assertTrue(events.length == 2);
			assertTrue(events[1]["durationReached"] == true);
			
			// We shouldn't get any events when we're no longer proxying the
			// wrapped element.
			//
			
			proxyElement.wrappedElement = null;
			
			temporal.position = 2;
			temporal.duration = 2;
			
			assertTrue(events.length == 2);
		}
		
		public function testProcessSwitchableChanges():void
		{
			var proxyElement:ProxyElement = createProxyWithTrait(MediaTraitType.SWITCHABLE);
			
			assertTrue(events.length == 0);
			
			// Changing properties should result in events.
			//
			
			var switchable:SwitchableTrait = proxyElement.getTrait(MediaTraitType.SWITCHABLE) as SwitchableTrait;
			switchable.autoSwitch = false;
			
			switchable.switchTo(3);
			assertTrue(events.length == 2);
			assertTrue(events[0]["oldState"] == SwitchingChangeEvent.SWITCHSTATE_UNDEFINED);
			assertTrue(events[0]["newState"] == SwitchingChangeEvent.SWITCHSTATE_REQUESTED);
			assertTrue((events[0]["detail"] as SwitchingDetail).detailCode == SwitchingDetailCodes.SWITCHING_MANUAL);
			assertTrue(events[1]["oldState"] == SwitchingChangeEvent.SWITCHSTATE_REQUESTED);
			assertTrue(events[1]["newState"] == SwitchingChangeEvent.SWITCHSTATE_COMPLETE);
			assertTrue((events[1]["detail"] as SwitchingDetail).detailCode == SwitchingDetailCodes.SWITCHING_MANUAL);
			
			switchable.numIndices = 7;
			
			assertTrue(events.length == 3);
			assertTrue(events[2]["indicesChange"] == true);
			
			// We shouldn't get any events when we're no longer proxying the
			// wrapped element.
			//
			
			proxyElement.wrappedElement = null;
			
			switchable.switchTo(1);
			switchable.numIndices = 3;
			
			assertTrue(events.length == 3);
		}
		
		public function testProcessSpatialChanges():void
		{
			var proxyElement:ProxyElement = createProxyWithTrait(MediaTraitType.SPATIAL);
			
			assertTrue(events.length == 0);
			
			// Changing properties should result in events.
			//
			
			var spatial:SpatialTrait = proxyElement.getTrait(MediaTraitType.SPATIAL) as SpatialTrait;
						
			spatial.setDimensions(20, 10);
			assertTrue(events.length == 1);
			assertTrue(events[0]["oldWidth"] == 0);
			assertTrue(events[0]["newWidth"] == 20);
			assertTrue(events[0]["oldHeight"] == 0);
			assertTrue(events[0]["newHeight"] == 10);
			
			// We shouldn't get any events when we're no longer proxying the
			// wrapped element.
			//
			
			proxyElement.wrappedElement = null;
			
			spatial.setDimensions(0, 0);
			
			assertTrue(events.length == 1);
		}
		
		private function createProxyWithTrait(traitType:MediaTraitType):ProxyElement
		{
			var proxyElement:DynamicListenerProxyElement = new DynamicListenerProxyElement(events);
			var wrappedElement:DynamicMediaElement = new DynamicMediaElement([traitType], new SimpleLoader());
			proxyElement.wrappedElement = wrappedElement;
			return proxyElement;
		}
		
		private var events:Array;
	}
}