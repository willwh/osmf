/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
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
	import flash.errors.IllegalOperationError;
	
	import org.openvideoplayer.events.SeekingChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.ISeekable;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.MediaFrameworkStrings;

	/**
	 * Dispatched when this trait's <code>seeking</code> property changes.
	 * 
	 * @eventType org.openvideoplayer.events.SeekingChangeEvent.SEEKING_CHANGE
	 */
	[Event(name="seekingChange",type="org.openvideoplayer.events.SeekingChangeEvent")]

	/**
	 * Implementation of ISeekable which can be a composite media trait.
	 * 
	 * For both parallel and serial media elements, a composite seekable trait
	 * keeps all seekable properties in sync for the composite element and its
	 * children.
	 **/
	internal class CompositeSeekableTrait extends CompositeMediaTraitBase implements ISeekable
	{
		public function CompositeSeekableTrait(traitAggregator:TraitAggregator, mode:CompositionMode, owner:MediaElement)
		{
			this.owner = owner;
			this.mode = mode;
			_seeking = false;
			seekToTime = 0;

			super(MediaTraitType.SEEKABLE, traitAggregator);			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get seeking():Boolean
		{
			return _seeking;
		}
		
		/**
		 * @inheritDoc
		 */
		public function seek(time:Number):void
		{
			if (seeking == false)
			{
				if (isNaN(time) || time < 0)
				{
					return;
				}

				var seekOp:CompositeSeekOperation = prepareSeekOperation(time);
				if (seekOp.canSeekTo == true)
				{
					setSeeking(true, time);
					doSeek(seekOp);
				}				
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function canSeekTo(time:Number):Boolean
		{
			if (isNaN(time) || time < 0)
			{
				return false;
			}
							
			return prepareSeekOperation(time).canSeekTo;
		}

		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			child.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeekingChanged, false, 0, true);
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			child.removeEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeekingChanged);
		}
		
		protected function onSeekingChanged(event:SeekingChangeEvent):void
		{
			var newSeekingState:Boolean = checkSeeking();
			
			// If a child change of seeking state does not cause the change of the composite seeking 
			// state, we can safely ignore it.
			if (newSeekingState == seeking)
			{
				return;
			}
			
			// At this point, we know that the change of the child seeking state causes the composite
			// seeking state to change. There are two possibilities for the change of the composite
			// seeking state:
			//		previous state = true, new state = false
			//		previous state = false, new state = true
			
			// Handle the case where previous state = true, new state = false 
			if (!newSeekingState && seeking)
			{
				// The new state is out of seeking, so we just update the composite seeking state. 
				setSeeking(newSeekingState);
			}
			else
			// handle the case where previous state = false, new state = true
			{
				// In this case, the child seek causes its siblings (in parallel) to seek.
				seek(event.time);
			}
		}
		
		protected function doSeek(seekOp:CompositeSeekOperation):void
		{
			throw new IllegalOperationError(MediaFrameworkStrings.FUNCTION_MUST_BE_OVERRIDDEN);
		}
		
		protected function prepareSeekOperation(time:Number):CompositeSeekOperation
		{
			throw new IllegalOperationError(MediaFrameworkStrings.FUNCTION_MUST_BE_OVERRIDDEN);

			return null;
		}
		
		protected function checkSeeking():Boolean
		{
			throw new IllegalOperationError(MediaFrameworkStrings.FUNCTION_MUST_BE_OVERRIDDEN);

			return false;
		}

		protected function get temporal():ITemporal
		{
			return owner.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
		}
		
		protected function setSeeking(value:Boolean, time:Number = 0):void
		{
			if (_seeking != value)
			{
				_seeking = value;
				seekToTime = time;
				
				dispatchEvent(new SeekingChangeEvent(_seeking, time));
			}
		}
		
		protected function getChildTemporal(childSeekable:ISeekable):ITemporal
		{
			for (var index:int = 0; index < traitAggregator.numChildren; index++)
			{
				var child:MediaElement = traitAggregator.getChildAt(index);
				if (child.getTrait(MediaTraitType.SEEKABLE) == childSeekable)
				{
					return child.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
				}
			}
			
			return null;
		}

		protected var seekToTime:Number;

		// Internals
		//
		
		protected var owner:MediaElement;
		private var mode:CompositionMode;
		private var _seeking:Boolean;
	}
}
