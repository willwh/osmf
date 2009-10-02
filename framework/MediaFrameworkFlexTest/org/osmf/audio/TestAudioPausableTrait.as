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
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	
	import org.osmf.traits.PlayableTrait;
	import org.osmf.traits.TestPausableTrait;
	import org.osmf.utils.TestConstants;

	public class TestAudioPausableTrait extends TestPausableTrait
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new AudioPausableTrait(mediaElement, soundAdapter);
		}
		
		override protected function createPlayableTrait():PlayableTrait
		{
			return new AudioPlayableTrait(mediaElement, soundAdapter);
		}
		
		override public function setUp():void
		{
			var sound:Sound = new Sound(new URLRequest(TestConstants.LOCAL_SOUND_FILE));
			soundAdapter = new SoundAdapter(mediaElement, sound);
			
			// Mute our test file.
			soundAdapter.soundTransform.volume = 0;

			super.setUp();
		}

		override public function tearDown():void
		{
			super.tearDown();
			
			// Kill all sounds.
			SoundMixer.stopAll();

			soundAdapter = null;
		}
		
		private var soundAdapter:SoundAdapter;
	}
}