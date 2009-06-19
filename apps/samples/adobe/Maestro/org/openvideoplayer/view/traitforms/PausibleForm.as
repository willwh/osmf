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
	
	import org.openvideoplayer.events.PausedChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.IPausible;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class PausibleForm extends PausibleFormLayout
	{
		public function PausibleForm():void
		{
			traitType = MediaTraitType.PAUSIBLE;
			traitName = "IPausible";
		}

		// Overrides
		//
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			pauseButton.addEventListener(MouseEvent.CLICK, onPauseButtonClick);
		}
		
		override protected function set description(value:String):void
		{
			formHeading.label = value;
		}

		override protected function processTraitAdded(trait:IMediaTrait):void
		{
			pausedFormItem.visible = pauseFormItem.visible = true;
			
			var pausible:IPausible = trait as IPausible;
			
			togglePausibleEventListeners(pausible, true);
			updateControls(pausible);
		}
		
		override protected  function processTraitRemoved():void
		{
			pausedFormItem.visible = pauseFormItem.visible = false;
			
			togglePausibleEventListeners(trait as IPausible, false);
			updateControls(null);
		}
		
		// Internals
		//
		
		private function togglePausibleEventListeners(value:IPausible, on:Boolean):void
		{
			if (on)
			{
				value.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChange);
			}
			else
			{
				value.removeEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChange);
			}
		}
		
		private function onPausedChange(event:PausedChangeEvent):void
		{
			updateControls(trait as IPausible);
		}
		
		private function updateControls(pausible:IPausible):void
		{
			pausedStateValue.text = pausible != null && pausible.paused
								 	? "paused"
								 	: "not paused";
			
			pauseButton.enabled =   pausible != null
								 && pausible.paused == false;
		}
		
		private function onPauseButtonClick(event:MouseEvent):void
		{
			var pausible:IPausible = trait as IPausible;
			pausible.pause();
		}
	}
}