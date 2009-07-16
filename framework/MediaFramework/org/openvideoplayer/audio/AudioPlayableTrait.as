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
	
	import org.openvideoplayer.traits.PlayableTrait;
			
	internal class AudioPlayableTrait extends PlayableTrait
	{
		public function AudioPlayableTrait(soundAdapter:SoundAdapter)
		{			
			this.soundAdapter = soundAdapter;				
			soundAdapter.addEventListener("playingChange", onPlayingChange, false, 0, true);
			soundAdapter.addEventListener("playbackError", onPlaybackError, false, 0, true); 			
		}
		
		override protected function processPlayingChange(newPlaying:Boolean):void
		{	
			if (newPlaying)
			{		
				soundAdapter.play();			
			}									
		}

		private function onPlayingChange(event:Event):void
		{
			if (playing != soundAdapter.playing)
			{
				resetPlaying();
			}
		}

		private function onPlaybackError(event:Event):void
		{
			resetPlaying();
		}
							
		private var soundAdapter:SoundAdapter;			
	}
}