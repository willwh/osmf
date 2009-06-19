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
	import flash.events.ProgressEvent;
	
	import org.openvideoplayer.traits.TemporalTrait;
	
	internal class AudioTemporalTrait extends TemporalTrait
	{
		public function AudioTemporalTrait(soundAdapter:SoundAdapter)
		{
			this.soundAdapter = soundAdapter;
			
			// The sound object's length changes as the file downloads.
			// We update the duration accordingly with ever more accurate estimates.
			soundAdapter.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress, false, 0, true);	
			soundAdapter.addEventListener("downloadComplete", onDownloadComplete, false, 0, true);
			soundAdapter.addEventListener(Event.COMPLETE, onComplete, false, 0, true);	
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get position():Number
		{
			return soundAdapter.position;
		}		
		
		private function onDownloadProgress(event:Event):void
		{		
			// Take the first good update, and wait until the download finishes.
			if( !isNaN(soundAdapter.estimatedDuration) &&
				soundAdapter.estimatedDuration > 0) 
			{
				soundAdapter.removeEventListener(ProgressEvent.PROGRESS, onDownloadProgress);				
				duration = soundAdapter.estimatedDuration;
			}
		}

		private function onDownloadComplete(event:Event):void
		{				
			duration = soundAdapter.estimatedDuration;
		}
		
		private function onComplete(event:Event):void
		{
			processDurationReached();
		}
		
		private var soundAdapter:SoundAdapter;
	}
}