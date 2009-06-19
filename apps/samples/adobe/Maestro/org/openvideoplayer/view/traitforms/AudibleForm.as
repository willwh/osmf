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
	import flash.events.Event;
	
	import mx.events.SliderEvent;
	
	import org.openvideoplayer.events.MutedChangeEvent;
	import org.openvideoplayer.events.PanChangeEvent;
	import org.openvideoplayer.events.VolumeChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.IAudible;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class AudibleForm extends AudibleFormLayout
	{
		public function AudibleForm():void
		{
			traitType = MediaTraitType.AUDIBLE;
			traitName = "IAudible";
		}
		
		// Overrides
		//
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			volumeSlider.addEventListener(SliderEvent.CHANGE, onVolumeSliderChange);
			mutedCheckBox.addEventListener(Event.CHANGE, onMutedButtonChange);
			panSlider.addEventListener(SliderEvent.CHANGE, onPanSliderChange);
		}

		override protected function set description(value:String):void
		{
			formHeading.label = value;
		}

		override protected function processTraitAdded(trait:IMediaTrait):void
		{
			volumeFormItem.visible = mutedFormItem.visible = panFormItem.visible = true;
			
			var audible:IAudible = trait as IAudible;
			
			toggleAudibleEventListeners(audible, true);
			
			if (audible)
			{
				setVolume(audible.volume);
				setMuted(audible.muted);
				setPan(audible.pan);
			}
		}
		
		override protected  function processTraitRemoved():void
		{
			volumeFormItem.visible = mutedFormItem.visible = panFormItem.visible = false;
			
			toggleAudibleEventListeners(trait as IAudible, false);
		}

		// Internals
		//
		
		private function toggleAudibleEventListeners(value:IAudible, on:Boolean):void
		{
			if (on)
			{
				value.addEventListener(VolumeChangeEvent.VOLUME_CHANGE, onVolumeChange);
				value.addEventListener(MutedChangeEvent.MUTED_CHANGE, onMutedChange);
				value.addEventListener(PanChangeEvent.PAN_CHANGE, onPanChange);
			}
			else
			{
				value.removeEventListener(VolumeChangeEvent.VOLUME_CHANGE, onVolumeChange);
				value.removeEventListener(MutedChangeEvent.MUTED_CHANGE, onMutedChange);
				value.removeEventListener(PanChangeEvent.PAN_CHANGE, onPanChange);
			}
		}
		
		private function onVolumeSliderChange(event:SliderEvent):void
		{
			setVolume(event.value);
		}

		private function onMutedButtonChange(event:Event):void
		{
			setMuted(event.currentTarget.selected);
		}

		private function onPanSliderChange(event:SliderEvent):void
		{
			setPan(event.value);
		}

		private function onVolumeChange(event:VolumeChangeEvent):void
		{
			setVolumeSlider(event.newVolume);
		}

		private function onMutedChange(event:MutedChangeEvent):void
		{
			setMutedButton(event.muted);
		}

		private function onPanChange(event:PanChangeEvent):void
		{
			setPanSlider(event.newPan);
		}
		
		private function setVolumeSlider(value:Number):void
		{
			volumeSlider.value = value;
		}

		private function setMutedButton(value:Boolean):void
		{
			mutedCheckBox.selected = value;
		}

		private function setPanSlider(value:Number):void
		{
			panSlider.value = value;
		}
		
		private function setVolume(value:Number):void
		{
			(trait as IAudible).volume = value;
		}

		private function setMuted(value:Boolean):void
		{
			(trait as IAudible).muted = value;
		}

		private function setPan(value:Number):void
		{
			(trait as IAudible).pan = value;
		}
	}
}