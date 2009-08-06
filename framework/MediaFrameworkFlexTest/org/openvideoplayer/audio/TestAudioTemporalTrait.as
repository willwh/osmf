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
package org.openvideoplayer.audio
{
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	
	import org.openvideoplayer.events.TraitEvent;
	import org.openvideoplayer.traits.TestITemporal;
	import org.openvideoplayer.utils.TestConstants;

	public class TestAudioTemporalTrait extends TestITemporal
	{
		override protected function createInterfaceObject(... args):Object
		{
			var sound:URLRequest = new URLRequest(TestConstants.LOCAL_SOUND_FILE);
			soundAdapter = new SoundAdapter(sound);
			return new AudioTemporalTrait(soundAdapter);
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			// Kill all sounds.
			SoundMixer.stopAll();
		}
		
		public function testTemporal():void
		{
			assertTrue(isNaN(temporal.duration));
			assertTrue(temporal.position == 0);
			
			soundAdapter.addEventListener("playbackError", onPlaybackError);
			soundAdapter.soundTransform.volume = 0;
			soundAdapter.play();
			
			temporal.addEventListener(TraitEvent.DURATION_REACHED, onDurationReached);			
		}
		
		private function onDurationReached(event:TraitEvent):void
		{
			//SoundAdapter should clear the channel, and start at 0 when done.
			assertEquals(temporal.position, 0);			
		}
		
		private function onPlaybackError(event:Event):void
		{
			assertTrue("Sound.play returned null, all sound channels are full", false);
		}
		
		private static const EXPECTED_DURATION:int = 5;
		
		private var soundAdapter:SoundAdapter;
	}
}