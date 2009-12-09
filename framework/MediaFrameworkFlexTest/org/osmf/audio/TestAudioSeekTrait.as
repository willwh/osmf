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
package org.osmf.audio
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	
	import org.osmf.events.SeekEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.TimeTrait;
	import org.osmf.traits.TestSeekTrait;
	import org.osmf.utils.TestConstants;
	
	public class TestAudioSeekTrait extends TestSeekTrait
	{
		override protected function createInterfaceObject(... args):Object
		{
			var sound:Sound = new Sound(new URLRequest(TestConstants.LOCAL_SOUND_FILE));
			soundAdapter = new SoundAdapter(new MediaElement(), sound);

			timeTrait = new AudioTimeTrait(soundAdapter);
			return new AudioSeekTrait(timeTrait, soundAdapter);
		}

		override protected function get maxSeekValue():Number
		{
			return timeTrait.duration;
		}
		
		override protected function get processesSeekCompletion():Boolean
		{
			return true;
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			// Kill all sounds.
			SoundMixer.stopAll();
			
			soundAdapter = null;
			timeTrait = null;
		}

		public function testSeekTrait():void
		{
			assertFalse(seekTrait.seeking);
			
			soundAdapter.soundTransform.volume = 0;
			soundAdapter.play();
			
			soundAdapter.addEventListener("downloadComplete", onDownloadComplete);
			
			seekTrait.addEventListener(SeekEvent.SEEK_BEGIN, onTestSeekTrait1);
			seekTrait.addEventListener(SeekEvent.SEEK_END, addAsync(onTestSeekTrait2, 3000));
		}
		
		private function onDownloadComplete(event:Event):void
		{
			assertFalse(seekTrait.seeking);
			
			assertTrue(seekTrait.canSeekTo(3));
				
			seekTrait.seek(3);
		}

		private function onTestSeekTrait1(event:SeekEvent):void
		{
			assertTrue(event.type == SeekEvent.SEEK_BEGIN);
		}
		
		private function onTestSeekTrait2(event:SeekEvent):void
		{
			assertTrue(event.type == SeekEvent.SEEK_END);
		}
		
		private var soundAdapter:SoundAdapter;
		private var timeTrait:TimeTrait;
	}
}