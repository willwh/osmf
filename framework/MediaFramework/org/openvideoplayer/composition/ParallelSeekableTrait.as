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
	import org.openvideoplayer.events.SeekingChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.ISeekable;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.MediaTraitType;

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
	internal class ParallelSeekableTrait extends CompositeSeekableTrait
	{
		public function ParallelSeekableTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			super(traitAggregator, null, owner);
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			var seekable:ISeekable = child as ISeekable;
			var childTemporal:ITemporal = getChildTemporal(seekable);
			
			if (traitAggregator.getNumTraits(MediaTraitType.SEEKABLE) == 1)
			{
				// The first added child's properties are applied to the
				// composite trait.
				setSeeking(seekable.seeking, seekable.seeking? childTemporal.position : 0);
			}
			else
			{
				if (seeking)
				{
					seekable.seek(seekToTime < childTemporal.duration? seekToTime : childTemporal.duration);
				}
			}

			super.processAggregatedChild(child);
		}
		
		override protected function doSeek(seekOp:CompositeSeekOperation):void
		{
			var parallelSeek:ParallelSeekOperation = seekOp as ParallelSeekOperation;
			var childOps:Array = parallelSeek.childOps;
			for (var index:int = 0; index < childOps.length; index++)
			{
				var childOp:ChildSeekOperation = childOps[index] as ChildSeekOperation;
				var childSeekable:ISeekable = childOp.child.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
				childSeekable.seek(childOp.time);
			}
		}
		
		override protected function prepareSeekOperation(time:Number):CompositeSeekOperation
		{
			var seekToOp:CompositeSeekOperation = new ParallelSeekOperation(time);
			
			if (traitAggregator.getNumTraits(MediaTraitType.SEEKABLE) < traitAggregator.numChildren ||
				time > temporal.duration)
			{
				// If not all the child support seekable trait, the parallel composite cannot seek.
				seekToOp.canSeekTo = false;
			}
			else
			{
				for (var index:int = 0; index < traitAggregator.numChildren; index++)
				{
					var childSeekable:ISeekable = traitAggregator.getChildAt(index).getTrait(MediaTraitType.SEEKABLE) as ISeekable;
					var childTemporal:ITemporal = traitAggregator.getChildAt(index).getTrait(MediaTraitType.TEMPORAL) as ITemporal;
					var seekTime:Number = time <= childTemporal.duration? time : childTemporal.duration;
					
					seekToOp.canSeekTo = childSeekable.canSeekTo(seekTime);
					if (seekToOp.canSeekTo == true) 
					{
						var childSeekOp:ChildSeekOperation = new ChildSeekOperation
																(
																   traitAggregator.getChildAt(index)
																 , seekTime
																 );
						(seekToOp as ParallelSeekOperation).childOps.push(childSeekOp);
					}
					else
					{
						break;
					}
				}
			}
			
			return seekToOp;
		}

		override protected function checkSeeking():Boolean
		{
			var seekingState:Boolean = false;
			
			traitAggregator.forEachChildTrait
				(
				  function(mediaTrait:IMediaTrait):void
				  {
				     seekingState ||= ISeekable(mediaTrait).seeking;
				  }
				, MediaTraitType.SEEKABLE
				);
			
			return seekingState;
		}
	}
}