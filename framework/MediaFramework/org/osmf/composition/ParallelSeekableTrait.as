/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.composition
{
	import __AS3__.vec.Vector;
	
	import org.osmf.events.SeekEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.ISeekable;
	import org.osmf.traits.ITemporal;
	import org.osmf.traits.MediaTraitType;

	/**
	 * Dispatched when this trait begins a seek operation.
	 * 
	 * @eventType org.osmf.events.SeekEvent.SEEK_BEGIN
	 */
	[Event(name="seekBegin",type="org.osmf.events.SeekEvent")]

	/**
	 * Dispatched when this trait ends a seek operation.
	 * 
	 * @eventType org.osmf.events.SeekEvent.SEEK_END
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	[Event(name="seekEnd",type="org.osmf.events.SeekEvent")]

	/**
	 * Implementation of ISeekable which can be a composite media trait.
	 * 
	 * This is the parallel case in which all child media elements seek together.
	 **/
	internal class ParallelSeekableTrait extends CompositeSeekableTrait
	{
		public function ParallelSeekableTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			super(traitAggregator, owner);
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			if (detached)
			{
				return;
			}
			
			var seekable:ISeekable = child as ISeekable;
			var childTemporal:ITemporal = getChildTemporal(seekable);
			
			if (traitAggregator.getNumTraits(MediaTraitType.SEEKABLE) == 1)
			{
				// The first added child's properties are applied to the
				// composite trait.
				setSeeking(seekable.seeking, seekable.seeking ? childTemporal.currentTime : 0);
			}
			else
			{
				if (seeking)
				{
					var childTemporalDuration:Number
						= childTemporal 
							? childTemporal.duration
							: 0;
							 
					// If the composite trait is currently seeking, ask the child trait to seek as well.
					// The seek to value is the child duration if the duration is shorter than that of 
					// the composite. Otherwise, it is the composite duration.
					seekable.seek
						( seekToTime < childTemporalDuration 
							? seekToTime
							: childTemporalDuration
						);
				}
			}

			super.processAggregatedChild(child);
		}
		
		/**
		 * @inheritDoc
		 **/
		override protected function doSeek(seekOp:CompositeSeekOperationInfo):void
		{
			// How to seek has been done by a call to the canSeekTo method. For parallel 
			// seekable trait, it needs to instruct each child to seek.
			var parallelSeek:ParallelSeekOperationInfo = seekOp as ParallelSeekOperationInfo;
			var childSeekOperations:Vector.<ChildSeekOperation> = parallelSeek.childSeekOperations;
			for (var index:int = 0; index < childSeekOperations.length; index++)
			{
				var childSeekOperation:ChildSeekOperation = childSeekOperations[index] as ChildSeekOperation;
				var childSeekable:ISeekable = childSeekOperation.child.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
				childSeekable.seek(childSeekOperation.time);
			}
		}
		
		/**
		 * @inheritDoc
		 **/
		override protected function prepareSeekOperationInfo(time:Number):CompositeSeekOperationInfo
		{
			var seekToOp:ParallelSeekOperationInfo = new ParallelSeekOperationInfo();
			
			if (time > temporal.duration)
			{
				// If the seek to time is greater than the duration of the composition, the parallel composite cannot seek.
				seekToOp.canSeekTo = false;
			}
			else
			{
				for (var index:int = 0; index < traitAggregator.numChildren; index++)
				{
					var childSeekable:ISeekable = traitAggregator.getChildAt(index).getTrait(MediaTraitType.SEEKABLE) as ISeekable;
					var childTemporal:ITemporal = traitAggregator.getChildAt(index).getTrait(MediaTraitType.TEMPORAL) as ITemporal;
					if (childTemporal == null || isNaN(childTemporal.duration))
					{
						// if the child has no ITemporal (such as an image element) or the duration is undefined, ignore it.
						continue;
					}
					if (childSeekable == null)
					{
						// This is the condition where ITemporal is not null and duration is well defined while 
						// ISeekable is absernt, cannot seek.
						seekToOp.canSeekTo = false;
						break;
					}
					
					var seekTime:Number = (time <= childTemporal.duration)? time : childTemporal.duration;
					seekToOp.canSeekTo = childSeekable.canSeekTo(seekTime);
					
					if (seekToOp.canSeekTo) 
					{
						var childSeekOp:ChildSeekOperation = new ChildSeekOperation
																(
																   traitAggregator.getChildAt(index)
																 , seekTime
																 );
						seekToOp.childSeekOperations.push(childSeekOp);
					}
					else
					{
						break;
					}
				}
			}
			
			return seekToOp;
		}

		/**
		 * @inheritDoc
		 **/
		override protected function checkSeeking():Boolean
		{
			// The parallel seekable trait is in seeking state if at least one
			// of the children is in seeking state.
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

		/**
		 * @inheritDoc
		 **/
		override protected function onSeekingChanged(event:SeekEvent):void
		{
			if (detached)
			{
				return;
			}
			
			var newSeekingState:Boolean = checkSeeking();
			
			// If a child change of seeking state does not cause the change of the composite seeking 
			// state, we can safely ignore it.
			if (newSeekingState == seeking)
			{
				return;
			}
			
			// At this point, we know that the change of the child seeking state will cause the composite
			// seeking state to change. There are two possibilities for the change of the composite
			// seeking state:
			//		previous state = true, new state = false
			//		previous state = false, new state = true
			
			// Handle the case where previous state = true, new state = false 
			if (!newSeekingState && seeking)
			{
				// The new state is out of seeking, so we just update the composite seeking state. 
				// Since switching from seeking to not seeking, the seekTo value does not matter.
				setSeeking(newSeekingState);
			}
			else
			// handle the case where previous state = false, new state = true
			{
				// In this case, the child seek causes its siblings (in parallel) to seek.
				seek(event.time);
			}
		}
	}
}