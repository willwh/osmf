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
package org.osmf.media
{
	import flash.media.SoundMixer;
	
	import org.osmf.audio.AudioElement;
	import org.osmf.audio.SoundLoader;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.TestConstants;
	import org.osmf.utils.URL;
	
	public class TestMediaPlayerWithAudioElementWithSoundLoader extends TestMediaPlayer
	{
		// Overrides
		//
				
		override public function tearDown():void
		{
			super.tearDown();
			
			// Kill all sounds.
			SoundMixer.stopAll();
		}

		override protected function createMediaElement(resource:IMediaResource):MediaElement
		{
			return new AudioElement(new SoundLoader(), resource as IURLResource);
		}
		
		override protected function get loadable():Boolean
		{
			return true;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return new URLResource(new URL(TestConstants.LOCAL_SOUND_FILE));
		}

		override protected function get invalidResourceForMediaElement():IMediaResource
		{
			return INVALID_RESOURCE;
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [MediaTraitType.LOADABLE];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [ MediaTraitType.AUDIBLE
				   , MediaTraitType.LOADABLE
				   , MediaTraitType.PAUSABLE
				   , MediaTraitType.PLAYABLE
				   , MediaTraitType.SEEKABLE
				   , MediaTraitType.TEMPORAL
				   ];
		}
		
		// Internals
		//

		private static const INVALID_RESOURCE:URLResource = new URLResource(new URL(TestConstants.LOCAL_INVALID_SOUND_FILE));
	}
}
