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
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.PlayState;
			
	internal class AudioPlayTrait extends PlayTrait
	{
		public function AudioPlayTrait(soundAdapter:SoundAdapter)
		{
			super();
			
			this.soundAdapter = soundAdapter;				
		}
		
		override protected function processPlayStateChange(newPlayState:String):void
		{	
			if (newPlayState == PlayState.PLAYING)
			{
				lastPlayFailed = !soundAdapter.play();			
			}
			else if (newPlayState == PlayState.PAUSED)
			{
				soundAdapter.pause();
			}				
			else if (newPlayState == PlayState.STOPPED)
			{
				soundAdapter.stop();
			}				
		}

		override protected function postProcessPlayStateChange():void
		{
			if (lastPlayFailed)
			{
				stop();
				
				lastPlayFailed = false;
			}
			else
			{
				super.postProcessPlayStateChange();
			}
		}
			
		private var lastPlayFailed:Boolean = false;					
		private var soundAdapter:SoundAdapter;			
	}
}