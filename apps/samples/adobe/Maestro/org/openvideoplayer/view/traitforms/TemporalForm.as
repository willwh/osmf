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
	
	import org.openvideoplayer.events.DurationChangeEvent;
	import org.openvideoplayer.events.TraitEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class TemporalForm extends TemporalFormLayout
	{
		public function TemporalForm():void
		{
			traitType = MediaTraitType.TEMPORAL;
			traitName = "ITemporal";
		}

		// Overrides
		//
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			temporalPollIntervalButton.addEventListener(MouseEvent.CLICK, onPollIntervalButtonClick);
		}
				
		override protected function set description(value:String):void
		{
			formHeading.label = value;
		}

		override protected function processTraitAdded(trait:IMediaTrait):void
		{
			temporalPositionFormItem.visible = temporalDurationFormItem.visible
				= temporalPollingFormItem.visible = true;
			
			var temporal:ITemporal = trait as ITemporal;
			
			toggleTemporalEventListeners(temporal, true);
			updateControls(temporal);
		}
		
		override protected  function processTraitRemoved():void
		{
			temporalPositionFormItem.visible = temporalDurationFormItem.visible
				= temporalPollingFormItem.visible = false;
			
			toggleTemporalEventListeners(trait as ITemporal, false);
			updateControls(null);
		}
		
		// Internals
		//
		
		private function toggleTemporalEventListeners(value:ITemporal, on:Boolean):void
		{
			if (on)
			{
				value.addEventListener(DurationChangeEvent.DURATION_CHANGE, onDurationChange);
				value.addEventListener(TraitEvent.DURATION_REACHED, onDurationReached);
			}
			else
			{
				value.removeEventListener(DurationChangeEvent.DURATION_CHANGE, onDurationChange);
				value.removeEventListener(TraitEvent.DURATION_REACHED, onDurationReached);
			}
		}
		
		private function onDurationChange(event:DurationChangeEvent):void
		{
			updateControls(trait as ITemporal);
		}

		private function onDurationReached(event:TraitEvent):void
		{
			updateControls(trait as ITemporal);
		}
		
		private function onPollIntervalButtonClick(event:MouseEvent):void
		{
			resetTimer();
			
			var interval:Number = Number(temporalPollIntervalInput.text);
			if (interval > 0)
			{
				timer = new Timer(interval);
				timer.addEventListener(TimerEvent.TIMER, onPollingTimer);
				timer.start();
			}
		}
		
		private function resetTimer():void
		{
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER, onPollingTimer);
				timer.reset();
			}
		}
		
		private function onPollingTimer(event:TimerEvent):void
		{
			updateControls(trait as ITemporal);
		}
		
		private function updateControls(temporal:ITemporal):void
		{
			if (temporal != null)
			{
				temporalPositionValue.text = "" + temporal.position;
				temporalDurationValue.text = "" + temporal.duration;
			}
			else
			{
				temporalPositionValue.text = "";
				temporalDurationValue.text = "";
			}
		}
		
		private var timer:Timer;
	}
}