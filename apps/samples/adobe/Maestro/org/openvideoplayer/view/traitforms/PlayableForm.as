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
package org.openvideoplayer.view.traitforms
{
	import flash.events.MouseEvent;
	
	import org.openvideoplayer.events.PlayingChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class PlayableForm extends PlayableFormLayout
	{
		public function PlayableForm():void
		{
			traitType = MediaTraitType.PLAYABLE;
			traitName = "IPlayable";
		}

		// Overrides
		//
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			playButton.addEventListener(MouseEvent.CLICK, onPlayButtonClick);
		}
		
		override protected function set description(value:String):void
		{
			formHeading.label = value;
		}

		override protected function processTraitAdded(trait:IMediaTrait):void
		{
			playingFormItem.visible = playFormItem.visible = true;
			
			var playable:IPlayable = trait as IPlayable;
			
			togglePlayableEventListeners(playable, true);
			updateControls(playable);
		}
		
		override protected  function processTraitRemoved():void
		{
			playingFormItem.visible = playFormItem.visible = false;
			
			togglePlayableEventListeners(trait as IPlayable, false);
			updateControls(null);
		}
		
		// Internals
		//
		
		private function togglePlayableEventListeners(value:IPlayable, on:Boolean):void
		{
			if (on)
			{
				value.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChange);
			}
			else
			{
				value.removeEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChange);
			}
		}
		
		private function onPlayingChange(event:PlayingChangeEvent):void
		{
			updateControls(trait as IPlayable);
		}
		
		private function updateControls(playable:IPlayable):void
		{
			playingStateValue.text =  playable != null && playable.playing
								 	? "playing"
								 	: "not playing";
			
			playButton.enabled =    playable != null
								 && playable.playing == false;
		}
		
		private function onPlayButtonClick(event:MouseEvent):void
		{
			var playable:IPlayable = trait as IPlayable;
			playable.play();
		}
	}
}