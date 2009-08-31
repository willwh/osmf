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
	import flash.media.SoundMixer;
	
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.TestMediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.TestConstants;
	import org.openvideoplayer.utils.URL;

	public class TestAudioElementWithSoundLoader extends TestMediaElement
	{
		override protected function createMediaElement():MediaElement
		{
			return new AudioElement(new SoundLoader());
		}
		
		override protected function get loadable():Boolean
		{
			return true;
		}

		override protected function get resourceForMediaElement():IMediaResource
		{
			return new URLResource(new URL(TestConstants.LOCAL_SOUND_FILE));
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			// Subclasses can override to specify the trait types which are
			// expected upon initialization.
			return [MediaTraitType.LOADABLE];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			// Subclasses can override to specify the trait types which are
			// expected after a load.  Ignored if the MediaElement
			// lacks the ILoadable trait.
			return [ MediaTraitType.AUDIBLE
				   , MediaTraitType.LOADABLE
				   , MediaTraitType.PAUSABLE
				   , MediaTraitType.PLAYABLE
				   , MediaTraitType.SEEKABLE
				   , MediaTraitType.TEMPORAL
				   ];
		}

		override public function tearDown():void
		{
			super.tearDown();
			
			// Kill all sounds.
			SoundMixer.stopAll();
		}
	}
}