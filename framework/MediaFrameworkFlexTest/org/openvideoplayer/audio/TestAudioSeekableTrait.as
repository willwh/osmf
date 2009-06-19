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
	
	import org.openvideoplayer.events.SeekingChangeEvent;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.TestISeekable;
	import org.openvideoplayer.utils.TestConstants;
	
	public class TestAudioSeekableTrait extends TestISeekable
	{
		override protected function createInterfaceObject(... args):Object
		{
			var remoteSound:URLRequest = new URLRequest(TestConstants.LOCAL_SOUND_FILE);
			soundAdapter = new SoundAdapter(remoteSound);
			temporal = new AudioTemporalTrait(soundAdapter);
			var seekable:AudioSeekableTrait = new AudioSeekableTrait(soundAdapter);
			seekable.temporal = temporal;
			return seekable;
		}

		override protected function get maxSeekValue():Number
		{
			return temporal.duration;
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			// Kill all sounds.
			SoundMixer.stopAll();
		}

		public function testSeekable():void
		{
			assertFalse(seekable.seeking);
			
			soundAdapter.soundTransform.volume = 0;
			soundAdapter.play();
			
			soundAdapter.addEventListener("downloadComplete", onDownloadComplete);
			
			seekable.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, addAsync(onTestSeekable, 3000));
		}
		
		private function onDownloadComplete(event:Event):void
		{
			assertFalse(seekable.seeking);
			
			assertTrue(seekable.canSeekTo(3));
				
			seekable.seek(3);
		}
		
		private function onTestSeekable(event:SeekingChangeEvent):void
		{
			assertTrue(event.seeking);
		}
		
		private var soundAdapter:SoundAdapter;
		private var temporal:ITemporal;
	}
}