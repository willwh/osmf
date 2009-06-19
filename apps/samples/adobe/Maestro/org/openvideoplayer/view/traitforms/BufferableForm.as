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
	
	import org.openvideoplayer.events.BufferTimeChangeEvent;
	import org.openvideoplayer.events.BufferingChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.IBufferable;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class BufferableForm extends BufferableFormLayout
	{
		public function BufferableForm():void
		{
			traitType = MediaTraitType.BUFFERABLE;
			traitName = "IBufferable";
		}

		// Overrides
		//
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			bufferTimeButton.addEventListener(MouseEvent.CLICK, onBufferTimeButtonClick);
			bufferLengthPollIntervalButton.addEventListener(MouseEvent.CLICK, onPollIntervalButtonClick);
		}
				
		override protected function set description(value:String):void
		{
			formHeading.label = value;
		}

		override protected function processTraitAdded(trait:IMediaTrait):void
		{
			bufferingFormItem.visible
				= bufferLengthFormItem.visible
				= bufferTimeFormItem.visible
				= bufferTimeInputFormItem.visible
				= bufferLengthPollingFormItem.visible = true;
			
			var bufferable:IBufferable = trait as IBufferable;
			
			toggleBufferableEventListeners(bufferable, true);
			updateControls(bufferable);
		}
		
		override protected  function processTraitRemoved():void
		{
			bufferingFormItem.visible
				= bufferLengthFormItem.visible
				= bufferTimeFormItem.visible
				= bufferTimeInputFormItem.visible
				= bufferLengthPollingFormItem.visible = false;
			
			toggleBufferableEventListeners(trait as IBufferable, false);
			updateControls(null);
		}
		
		// Internals
		//
		
		private function toggleBufferableEventListeners(value:IBufferable, on:Boolean):void
		{
			if (on)
			{
				value.addEventListener(BufferingChangeEvent.BUFFERING_CHANGE, onBufferingChange);
				value.addEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE, onBufferTimeChange);
			}
			else
			{
				value.removeEventListener(BufferingChangeEvent.BUFFERING_CHANGE, onBufferingChange);
				value.removeEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE, onBufferTimeChange);
			}
		}
		
		private function onBufferingChange(event:BufferingChangeEvent):void
		{
			updateControls(trait as IBufferable);
		}

		private function onBufferTimeChange(event:BufferTimeChangeEvent):void
		{
			updateControls(trait as IBufferable);
		}
		
		private function onBufferTimeButtonClick(event:MouseEvent):void
		{
			var bufferable:IBufferable = trait as IBufferable;
			
			var newTime:Number = Number(bufferTimeInput.text);
			if (newTime >= 0)
			{
				bufferable.bufferTime = newTime;
				
				updateControls(bufferable);
			}
		}
		
		private function onPollIntervalButtonClick(event:MouseEvent):void
		{
			resetTimer();
			
			var interval:Number = Number(bufferLengthPollIntervalInput.text);
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
			updateControls(trait as IBufferable);
		}
		
		private function updateControls(bufferable:IBufferable):void
		{
			if (bufferable != null)
			{
				bufferingValue.text = bufferable.buffering ? "true" : "false";
				bufferLengthValue.text = "" + bufferable.bufferLength;
				bufferTimeValue.text = "" + bufferable.bufferTime;
			}
			else
			{
				bufferingValue.text = "false";
				bufferLengthValue.text = "";
				bufferTimeValue.text = "";
			}
		}
		
		private var timer:Timer;
	}
}