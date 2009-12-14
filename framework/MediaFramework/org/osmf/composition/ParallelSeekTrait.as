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
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;

	/**
	 * Implementation of SeekTrait which can be a composite media trait.
	 * 
	 * This is the parallel case in which all child media elements seek together.
	 **/
	internal class ParallelSeekTrait extends CompositeSeekTrait
	{
		public function ParallelSeekTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			super(traitAggregator, CompositionMode.PARALLEL, owner);
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function doSeek(seekOp:CompositeSeekOperationInfo):void
		{
			inSeek = true;
			
			// How to seek has been done by a call to the canSeekTo method. For parallel 
			// seekable trait, it needs to instruct each child to seek.
			var parallelSeek:ParallelSeekOperationInfo = seekOp as ParallelSeekOperationInfo;
			var childSeekOperations:Vector.<ChildSeekOperation> = parallelSeek.childSeekOperations;
			for (var i:int = 0; i < childSeekOperations.length; i++)
			{
				var childSeekOperation:ChildSeekOperation = childSeekOperations[i] as ChildSeekOperation;
				var childSeekTrait:SeekTrait = childSeekOperation.child.getTrait(MediaTraitType.SEEK) as SeekTrait;
				childSeekTrait.seek(childSeekOperation.time);
			}
			
			inSeek = false;
		}
		
		/**
		 * @inheritDoc
		 **/
		override protected function prepareSeekOperationInfo(time:Number):CompositeSeekOperationInfo
		{
			var seekToOp:ParallelSeekOperationInfo = new ParallelSeekOperationInfo();
			
			for (var i:int = 0; i < traitAggregator.numChildren; i++)
			{
				var childSeekTrait:SeekTrait = traitAggregator.getChildAt(i).getTrait(MediaTraitType.SEEK) as SeekTrait;
				var childTimeTrait:TimeTrait = traitAggregator.getChildAt(i).getTrait(MediaTraitType.TIME) as TimeTrait;
				if (childTimeTrait == null || isNaN(childTimeTrait.duration))
				{
					// If the child has no TimeTrait (such as an image element) or the duration is undefined, ignore it.
					continue;
				}
				if (childSeekTrait == null)
				{
					// This is the condition where TimeTrait is not null and duration is well defined while 
					// the SeekTrait is absent, so we cannot seek.
					seekToOp.canSeekTo = false;
					break;
				}
				
				var seekTime:Number = Math.min(time, childTimeTrait.duration);
				seekToOp.canSeekTo = childSeekTrait.canSeekTo(seekTime);
				
				if (seekToOp.canSeekTo) 
				{
					var childSeekOp:ChildSeekOperation = new ChildSeekOperation
															( traitAggregator.getChildAt(i)
															, seekTime
															);
					seekToOp.childSeekOperations.push(childSeekOp);
				}
				else
				{
					break;
				}
			}
			
			// If no seek operations were prepared, then we can't actually seek.
			if (seekToOp.childSeekOperations.length == 0)
			{
				seekToOp.canSeekTo = false;
			}
			
			return seekToOp;
		}

		/**
		 * @inheritDoc
		 **/
		override protected function checkSeeking():Boolean
		{
			// The parallel seek trait is in the seeking state if at least one
			// of the children is in the seeking state.
			var seekingState:Boolean = false;
			
			traitAggregator.forEachChildTrait
				(
				  function(mediaTrait:MediaTraitBase):void
				  {
				     seekingState ||= SeekTrait(mediaTrait).seeking;
				  }
				, MediaTraitType.SEEK
				);
			
			return seekingState;
		}

		/**
		 * @inheritDoc
		 **/
		override protected function onSeekingChanged(event:SeekEvent):void
		{
			if (event.type == SeekEvent.SEEK_BEGIN && !inSeek)
			{
				// In this case, the child seek causes its siblings (in
				// parallel) to seek.
				seek(event.time);
			}
			else if (event.type == SeekEvent.SEEK_END && checkSeeking() == false)
			{
				// The child is exiting the seeking state, so we just
				// update the composite seeking state.
				processSeekCompletion(event.time);
			}
		}
		
		private var inSeek:Boolean = false;
	}
}