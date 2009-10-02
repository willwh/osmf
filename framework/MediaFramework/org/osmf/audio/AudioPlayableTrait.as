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
	
	import org.osmf.media.MediaElement;
	import org.osmf.traits.PlayableTrait;
			
	internal class AudioPlayableTrait extends PlayableTrait
	{
		public function AudioPlayableTrait(owner:MediaElement, soundAdapter:SoundAdapter)
		{
			super(owner);
			
			this.soundAdapter = soundAdapter;				
		}
		
		// This is hacked to allow the errors to bubble up to the Playable trait, and allow the 
		// playstate to not update to true is an exception was thrown while attempting to play.
		// A possible refactor to the Playable trait is in order here.
		// ROC
		override protected function processPlayingChange(newPlaying:Boolean):void
		{	
			if (newPlaying)
			{		
				lastPlayFailed = !soundAdapter.play();			
			}									
		}
				
		override protected function postProcessPlayingChange(oldPlaying:Boolean):void
		{
			if (lastPlayFailed)
			{
				resetPlaying();
				lastPlayFailed = false;
			}
			else
			{
				super.postProcessPlayingChange(oldPlaying);
			}
		}
			
		private var lastPlayFailed:Boolean = false;					
		private var soundAdapter:SoundAdapter;			
	}
}