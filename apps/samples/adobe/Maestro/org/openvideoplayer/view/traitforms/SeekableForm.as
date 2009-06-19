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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openvideoplayer.events.SeekingChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.ISeekable;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class SeekableForm extends SeekableFormLayout
	{
		public function SeekableForm():void
		{
			traitType = MediaTraitType.SEEKABLE;
			traitName = "ISeekable";
		}

		// Overrides
		//
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			seekButton.addEventListener(MouseEvent.CLICK, onSeekButtonClick);
			canSeekButton.addEventListener(MouseEvent.CLICK, onCanSeekButtonClick);
		}
				
		override protected function set description(value:String):void
		{
			formHeading.label = value;
		}

		override protected function processTraitAdded(trait:IMediaTrait):void
		{
			seekingFormItem.visible
				= seekFormItem.visible
				= canSeekFormItem.visible = true;
			
			var seekable:ISeekable = trait as ISeekable;
			
			toggleSeekableEventListeners(seekable, true);
			updateControls(seekable);
		}
		
		override protected  function processTraitRemoved():void
		{
			seekingFormItem.visible
				= seekFormItem.visible
				= canSeekFormItem.visible = false;
			
			toggleSeekableEventListeners(trait as ISeekable, false);
			updateControls(null);
		}
		
		// Internals
		//
		
		private function toggleSeekableEventListeners(value:ISeekable, on:Boolean):void
		{
			if (on)
			{
				value.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeekingChange);
			}
			else
			{
				value.removeEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeekingChange);
			}
		}
		
		private function onSeekingChange(event:SeekingChangeEvent):void
		{
			updateControls(trait as ISeekable);
		}

		private function onSeekButtonClick(event:MouseEvent):void
		{
			var seekable:ISeekable = trait as ISeekable;
			
			var seekTime:Number = Number(seekTimeInput.text);
			if (seekTime >= 0)
			{
				seekable.seek(seekTime);
			}
		}

		private function onCanSeekButtonClick(event:MouseEvent):void
		{
			var seekable:ISeekable = trait as ISeekable;
			
			var seekTime:Number = Number(canSeekTimeInput.text);
			if (seekTime >= 0)
			{
				canSeekResultValue.text = seekable.canSeekTo(seekTime) ? "true" : "false";
			}
		}
		
		private function updateControls(seekable:ISeekable):void
		{
			if (seekable != null)
			{
				seekingValue.text = seekable.seeking ? "true" : "false";
			}
			else
			{
				seekingValue.text = "false";
			}
		}
	}
}