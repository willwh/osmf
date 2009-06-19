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