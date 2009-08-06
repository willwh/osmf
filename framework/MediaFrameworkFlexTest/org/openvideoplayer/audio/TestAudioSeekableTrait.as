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