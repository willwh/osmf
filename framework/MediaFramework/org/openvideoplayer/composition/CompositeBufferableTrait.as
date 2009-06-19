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
package org.openvideoplayer.composition
{
	import org.openvideoplayer.events.BufferTimeChangeEvent;
	import org.openvideoplayer.events.BufferingChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.IBufferable;
	import org.openvideoplayer.traits.MediaTraitType;

	/**
	 * Dispatched when the trait's <code>buffering</code> property has changed.
	 * 
	 * @eventType org.openvideoplayer.events.BufferingChangeEvent.BUFFERING_CHANGE
	 */
	[Event(name="bufferingChange",type="org.openvideoplayer.events.BufferingChangeEvent")]
	
	/**
	 * Dispatched when the trait's <code>bufferTime</code> property has changed.
	 * 
	 * @eventType org.openvideoplayer.events.BufferTimeChangeEvent.BUFFER_TIME_CHANGE
	 */
	[Event(name="bufferTimeChange",type="org.openvideoplayer.events.BufferTimeChangeEvent")]

	/**
	 * Implementation of IBufferable which can be a composite media trait.
	 * 
	 * For both parallel and serial media elements, a composite bufferable trait
	 * keeps all bufferable properties in sync for the composite element and its
	 * children.
	 **/
	public class CompositeBufferableTrait extends CompositeMediaTraitBase implements IBufferable
	{
		public function CompositeBufferableTrait(traitAggregator:TraitAggregator, mode:CompositionMode)
		{
			_bufferTime = 0;
			_buffering = false;
			_settingBufferTime = false;
			this.mode = mode;
			
			super(MediaTraitType.BUFFERABLE, traitAggregator);			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get buffering():Boolean
		{
			return _buffering;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bufferLength():Number
		{
			var length:Number;
			
			if (mode == CompositionMode.PARALLEL)
			{
				// In parallel,
				//
				// When none of the child trait is in the condition of bufferLength < bufferTime, 
				// the bufferLength of the trait is the average of the bufferLength values of its 
				// children. 
				// 
				// When at least one of the children is in the condition of bufferLength < bufferTime, 
				// the composite trait calculates its bufferLength as follows. For each child trait 
				// with bufferLength < bufferTime, the composite trait takes the actual bufferLength. 
				// For the rest of the children, the composite trait takes its bufferTime as its 
				// current bufferLength. Then the composite trait takes the average of the current 
				// bufferLength of the children (as described) as its bufferLength.
				var totalUnadjustedBufferLength:Number = 0;
				var totalAdjustedBufferLength:Number = 0;
				var needAdjusted:Boolean = false;
				
				traitAggregator.forEachChildTrait
					(
					  function(mediaTrait:IMediaTrait):void
					  {
					  	var bufferable:IBufferable = IBufferable(mediaTrait);
					  	if (bufferable.bufferLength < bufferable.bufferTime)
					  	{
					  		totalUnadjustedBufferLength += bufferable.bufferLength;
					  		totalAdjustedBufferLength += bufferable.bufferLength;
					  		needAdjusted = true;
					  	}
					  	else
					  	{
					  		totalUnadjustedBufferLength += bufferable.bufferLength;
					  		totalAdjustedBufferLength += bufferable.bufferTime;
					  	}
					  }
					, MediaTraitType.BUFFERABLE
					);
					
				length = (needAdjusted? totalAdjustedBufferLength : totalUnadjustedBufferLength)
						/ traitAggregator.getNumTraits(MediaTraitType.BUFFERABLE);
			}
			else
			{
				// In serial, the values of bufferLength of the composite trait is taken from the curent 
				// child trait.
				length =  (traitOfCurrentChild != null)? traitOfCurrentChild.bufferLength : 0;
			}
			
			return length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bufferTime():Number
		{
			return _bufferTime;
		}
		
		public function set bufferTime(value:Number):void
		{
			if (_bufferTime == value)
			{
				return;
			}
			
			_settingBufferTime = true;
			
			var oldBufferTime:Number = _bufferTime;
			_bufferTime = value;
			
			// Set new bufferTime to each child who supports bufferable 
			traitAggregator.forEachChildTrait
				(
				  function(mediaTrait:IMediaTrait):void
				  {
				     IBufferable(mediaTrait).bufferTime = value;
				  }
				, MediaTraitType.BUFFERABLE
				);
			
			_settingBufferTime = false;
			dispatchEvent(new BufferTimeChangeEvent(oldBufferTime, _bufferTime));
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			onBufferingChanged(null);
			onBufferTimeChanged(null);

			child.addEventListener(BufferingChangeEvent.BUFFERING_CHANGE,		onBufferingChanged,		false, 0, true);
			child.addEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE,	onBufferTimeChanged,	false, 0, true);
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			
			onBufferingChanged(null);
			onBufferTimeChanged(null);

			child.removeEventListener(BufferingChangeEvent.BUFFERING_CHANGE,	onBufferingChanged);
			child.removeEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE,	onBufferTimeChanged);
		}
		
		// Internals
		//
		
		private function onBufferingChanged(event:BufferingChangeEvent):void
		{
			var newBufferingState:Boolean = checkBuffering();
			if (newBufferingState != buffering)
			{
				_buffering = newBufferingState;
				dispatchEvent(new BufferingChangeEvent(buffering));
			}
		}
		
		private function onBufferTimeChanged(event:BufferTimeChangeEvent):void
		{
			var oldBufferTime:Number = _bufferTime;
			_bufferTime = calculateBufferTime();
			if (oldBufferTime != _bufferTime && _settingBufferTime == false)
			{
				dispatchEvent(new BufferTimeChangeEvent(oldBufferTime, _bufferTime));
			}
		}
		
		private function calculateBufferTime():Number
		{
			var time:Number = 0;
			
			if (mode == CompositionMode.PARALLEL)
			{
				// In parallel case, the bufferTime is the average of the bufferTime of the children.
				traitAggregator.forEachChildTrait
					(
					  function(mediaTrait:IMediaTrait):void
					  {
					     time += IBufferable(mediaTrait).bufferTime;
					  }
					, MediaTraitType.BUFFERABLE
					);
				if (time > 0)
				{
					time = time / traitAggregator.getNumTraits(MediaTraitType.BUFFERABLE);
				}
			}
			else
			{
				// In serial case, the bufferTime is taken from the current child.
				// If the current child does not support bufferable, return zero.
				time = traitOfCurrentChild != null? traitOfCurrentChild.bufferTime : 0;
			}
			
			return time;
		}
		
		private function checkBuffering():Boolean
		{
			var isBuffering:Boolean = false;
			if (mode == CompositionMode.PARALLEL)
			{
				// In parallel case, buffering is true when at least one child is buffering.
				traitAggregator.forEachChildTrait
					(
					  function(mediaTrait:IMediaTrait):void
					  {
					     isBuffering ||= IBufferable(mediaTrait).buffering;
					  }
					, MediaTraitType.BUFFERABLE
					);
			}
			else
			{
				// In serial case, buffering state is taken from that of the current child.
				// If the current child does not support bufferable, return false.
				isBuffering = traitOfCurrentChild != null? traitOfCurrentChild.buffering : false;
			}	
			
			return isBuffering;
		}
		
		private function get traitOfCurrentChild():IBufferable
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.BUFFERABLE) as IBufferable
				   : null;			
		}

		private var mode:CompositionMode;		
		private var _bufferTime:Number;
		private var _buffering:Boolean;
		private var _settingBufferTime:Boolean;
	}
}