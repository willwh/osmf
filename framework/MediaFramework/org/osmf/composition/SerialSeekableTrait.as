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
	import org.osmf.traits.IPausable;
	import org.osmf.traits.IPlayable;
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
	 * This is the serial case which the seek may:
	 * <ul> seek within the current child
	 * <ul> seek out of the current child and seek backward
	 * <ul> seek out of the current child and seek forward
	 **/
	internal class SerialSeekableTrait extends CompositeSeekableTrait
	{
		public function SerialSeekableTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			crossChildrenSeeking = false;
			
			super(traitAggregator, owner);
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			// If the composite trait is no longer in commission with the composition element,
			// cease to conduct any operation.
			if (detached)
			{
				return; 
			}

			var seekable:ISeekable = child as ISeekable;
			var childTemporal:ITemporal = getChildTemporal(seekable);
			
			if (child == traitOfCurrentChild)
			{
				// If this is the current child of the composition, the composite trait derives its seeking
				// state from the current child.
				setSeeking(seekable.seeking, seekable.seeking ? childTemporal.currentTime : 0);
			}
			
			super.processAggregatedChild(child);
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			// If the composite trait is no longer in commission with the composition element,
			// cease to conduct any operation.
			if (detached)
			{
				return; 
			}
			
			super.processAggregatedChild(child);
		}
		
		/**
		 * @inheritDoc
		 **/
		override protected function doSeek(seekOp:CompositeSeekOperationInfo):void
		{
			var serialSeek:SerialSeekOperationInfo = seekOp as SerialSeekOperationInfo;
			var childSeekable:ISeekable = serialSeek.fromChild.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			
			if (serialSeek.fromChild == serialSeek.toChild)
			{
				// This is the case where the seek is within the current child.
				childSeekable.seek(serialSeek.toChildTime);
				
				return;
			}

			// Now, the composite is going to do a seek that crosses multiple children.
			crossChildrenSeeking = true;
			var wasPlaying:Boolean = isCompositePlaying();
						
			// Since the playhead seeks out of the child, the child needs to be paused.
			var childPausable:IPausable = serialSeek.fromChild.getTrait(MediaTraitType.PAUSABLE) as IPausable;
			if (childPausable != null)
			{
				childPausable.pause();
			}
			
			// Do the seek out of the current child first.
			if (serialSeek.seekForward)
			{
				// Seeking forward means to move the playhead to the end of the temporal.
				var childTemporal:ITemporal = serialSeek.fromChild.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
				childSeekable.seek(childTemporal.duration);
			}
			else
			{
				// Seeking backward means to move the playhead to the beginning of the temporal.
				childSeekable.seek(0);
			}
			
			// Now the composite does the seek into another child, where the destiny of the seek is.
			childSeekable = serialSeek.toChild.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			
			detached = true;
			
			traitAggregator.listenedChild = serialSeek.toChild;
			var playable:IPlayable = owner.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			if (playable != null)
			{
				playable.play();
			}
			childSeekable.seek(serialSeek.toChildTime);
		}
		
		/**
		 * @inheritDoc
		 **/
		override protected function prepareSeekOperationInfo(time:Number):CompositeSeekOperationInfo
		{
			var serialSegments:Vector.<SerialElementSegment> = prepareSerialSegments();

			var seekToOp:SerialSeekOperationInfo;
			var curChildIndex:int = traitAggregator.getChildIndex(traitAggregator.listenedChild);
			if (curChildIndex < serialSegments.length)
			{
				var curChildSeekOperation:SerialElementSegment = serialSegments[curChildIndex];
				
				// Check whether this is a seek within the current child
				if (curChildSeekOperation.relativeStart <= time && time < curChildSeekOperation.relativeEnd)
				{
					seekToOp = new SerialSeekOperationInfo();
					seekToOp.canSeekTo = true;
					seekToOp.fromChild = curChildSeekOperation.mediaElement;
					seekToOp.toChild = curChildSeekOperation.mediaElement;
					
					// Convert from the composite playhead position to child playhead position
					seekToOp.toChildTime = time - curChildSeekOperation.relativeStart;
				}
				else if (time < curChildSeekOperation.relativeStart)
				{
					seekToOp = canSeekBackward(time, serialSegments, curChildIndex);
				}
				else
				{
					seekToOp = canSeekForward(time, serialSegments, curChildIndex);
				}
			}
			else
			{
				// Seeking is not possible within the current child.
				seekToOp = new SerialSeekOperationInfo();
				seekToOp.canSeekTo = false;
			}

			return seekToOp;
		}
		
		/**
		 * @inheritDoc
		 **/
		override protected function checkSeeking():Boolean
		{
			// Serail composite seekable is only in seeking state when the current child is in
			// seeking state.
			return (traitOfCurrentChild != null)? traitOfCurrentChild.seeking : false;
		}

		// Internals
		//

		private function prepareSerialSegments():Vector.<SerialElementSegment>
		{
			var serialSegments:Vector.<SerialElementSegment> = new Vector.<SerialElementSegment>();
			
			var curTime:Number = 0;
			for (var index:int = 0; index < traitAggregator.numChildren; index++)
			{
				var mediaElement:MediaElement = traitAggregator.getChildAt(index);
				var temporal:ITemporal = mediaElement.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
				var seekable:ISeekable = mediaElement.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
				
				if (temporal == null || isNaN(temporal.duration))
				{
					// If a child has no temporal or duration of the temporal is undefined, it will
					// be skipped. Therefore, there is no need to include this child.
					continue;
				}
				
				serialSegments.push(
					new SerialElementSegment
						( mediaElement
						, curTime
						, curTime + temporal.duration
						, seekable != null));

				curTime += temporal.duration;
			}
			
			return serialSegments;
		}

		override protected function onSeekingChanged(event:SeekEvent):void
		{
			// If the composite trait is no longer in commission with the composition element,
			// cease to conduct any operation.
			// 
			// Also, if the composite is in the middle of a seeking that crosses multiple children,
			// the composite trait will expect to receive SeekingChangeEvents from its children.
			// However, it should ignore these events since these events are "initiated" by the
			// composite trait itself.
			if (crossChildrenSeeking || detached)
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
				// In serial seek, do nothing.
			}
		}

		private function canSeekBackward
			( time:Number
			, serialSegments:Vector.<SerialElementSegment>
			, curChildIndex:int):SerialSeekOperationInfo
		{
			var seekToOp:SerialSeekOperationInfo = new SerialSeekOperationInfo();
			seekToOp.seekForward = false;
			seekToOp.canSeekTo = false;
			
			// If the current child is the first child of the serial element, and the
			// composite trait still needs to seek to the left of the current child,
			// it is definitely unseekable.
			var index:int = curChildIndex - 1;
			if (index < 0)
			{
				return seekToOp;
			}

			seekToOp.fromChild = serialSegments[curChildIndex].mediaElement;
					
			var curSegment:SerialElementSegment = serialSegments[index];
			while (curSegment != null)
			{
				var childSeekable:ISeekable = curSegment.mediaElement.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
				if (time >= curSegment.relativeStart)
				{
					if (childSeekable == null)
					{
						curSegment = serialSegments[index+1];
						seekToOp.toChild = curSegment.mediaElement;
						seekToOp.toChildTime = 0;
					}
					else
					{
						seekToOp.toChild = curSegment.mediaElement;
						seekToOp.toChildTime = time - curSegment.relativeStart;
					}
					
					seekToOp.canSeekTo = true;
					break;
				}
				
				index--;
				if (index < 0)
				{
					break;
				}	
				else
				{
					curSegment = serialSegments[index];
				}
			}
			
			return seekToOp;
		}

		private function canSeekForward
			( time:Number
			, serialSegments:Vector.<SerialElementSegment>
			, curChildIndex:int):SerialSeekOperationInfo
		{
			var seekToOp:SerialSeekOperationInfo = new SerialSeekOperationInfo();
			seekToOp.seekForward = true;
			seekToOp.canSeekTo = false;

			// If the current child is the last child of the serial element, and the
			// composite trait still needs to seek to the right of the current child,
			// it is definitely unseekable.
			var index:int = curChildIndex + 1;
			if (index >= serialSegments.length)
			{
				return seekToOp;
			}

			seekToOp.fromChild = serialSegments[curChildIndex].mediaElement;

			var curSegment:SerialElementSegment = serialSegments[index];
			while (curSegment != null)
			{
				var childSeekable:ISeekable = curSegment.mediaElement.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
				if (time < curSegment.relativeEnd)
				{
					if (childSeekable == null)
					{
						curSegment = serialSegments[index-1];
						seekToOp.toChild = curSegment.mediaElement;
						var childTemporal:ITemporal = curSegment.mediaElement.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
						seekToOp.toChildTime = childTemporal.duration;
					}
					else
					{
						seekToOp.toChild = curSegment.mediaElement;
						seekToOp.toChildTime = time - curSegment.relativeStart;
					}
					
					seekToOp.canSeekTo = true;
					break;
				}
				
				index++;
				if (index >= serialSegments.length)
				{
					break;
				}	
				else
				{
					curSegment = serialSegments[index];
				}
			}
			
			return seekToOp;
		}

		private function get traitOfCurrentChild():ISeekable
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.SEEKABLE) as ISeekable
				   : null;			
		}
		
		private function isCompositePlaying():Boolean
		{
			var playable:IPlayable = owner.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			return (playable == null)? false : playable.playing;
		}

		private var crossChildrenSeeking:Boolean;
	}
}