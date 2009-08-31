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
	import flash.media.SoundTransform;
	
	import org.openvideoplayer.traits.AudibleTrait;

	internal class AudioAudibleTrait extends AudibleTrait
	{
		public function AudioAudibleTrait(soundAdapter:SoundAdapter)
		{
			super();
			
			this.soundAdapter = soundAdapter;
			soundAdapter.soundTransform.volume = volume;
			soundAdapter.soundTransform.pan = pan;
		}
		
		override protected function processVolumeChange(newVolume:Number):void
		{
			var soundTransform:SoundTransform = soundAdapter.soundTransform;				
			soundTransform.volume = muted ? 0 : newVolume;
			soundAdapter.soundTransform = soundTransform;
		}

		override protected function processMutedChange(newMuted:Boolean):void
		{
			var soundTransform:SoundTransform = soundAdapter.soundTransform;			
			soundTransform.volume = newMuted ? 0 : volume;
			soundAdapter.soundTransform = soundTransform;
		}
		
		override protected function processPanChange(newPan:Number):void
		{
			var soundTransform:SoundTransform = soundAdapter.soundTransform;					
			soundTransform.pan = newPan;
			soundAdapter.soundTransform = soundTransform;
		}
		
		private var soundAdapter:SoundAdapter;		
	}
}