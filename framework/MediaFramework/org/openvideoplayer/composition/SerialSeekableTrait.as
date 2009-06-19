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
	import __AS3__.vec.Vector;
	
	import org.openvideoplayer.events.SeekingChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.IPausible;
	import org.openvideoplayer.traits.IPlayable;
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
	public class SerialSeekableTrait extends CompositeSeekableTrait
	{
		public function SerialSeekableTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			detached = false;
			crossChildrenSeeking = false;
			
			super(traitAggregator, null, owner);
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			if (detached == true)
			{
				return; 
			}

			var seekable:ISeekable = child as ISeekable;
			var childTemporal:ITemporal = getChildTemporal(seekable);
			
			if (child == traitOfCurrentChild)
			{
				setSeeking(seekable.seeking, seekable.seeking? childTemporal.position : 0);
			}
			
			super.processAggregatedChild(child);
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			if (detached == true)
			{
				return; 
			}
			
			super.processAggregatedChild(child);
		}
		
		override protected function onSeekingChanged(event:SeekingChangeEvent):void
		{
			if (detached == true || crossChildrenSeeking == true)
			{
				return; 
			}
			
			super.onSeekingChanged(event);
		}
		
		override protected function doSeek(seekOp:CompositeSeekOperation):void
		{
			var serialSeek:SerialSeekOperation = seekOp as SerialSeekOperation;
			var childSeekable:ISeekable = serialSeek.fromChild.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			if (serialSeek.fromChild == serialSeek.toChild)
			{
				childSeekable.seek(serialSeek.toChildTime);
			}
			else
			{
				crossChildrenSeeking = true;
				if (serialSeek.seekForward == true)
				{
					var childTemporal:ITemporal = serialSeek.fromChild.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
					childSeekable.seek(childTemporal.duration);
				}
				else
				{
					childSeekable.seek(0);
				}
				var childPausible:IPausible = serialSeek.fromChild.getTrait(MediaTraitType.PAUSIBLE) as IPausible;
				if (childPausible != null)
				{
					childPausible.pause();
				}
			}
			
			childSeekable = serialSeek.toChild.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			childSeekable.seek(serialSeek.toChildTime);
			crossChildrenSeeking = false;
			
			if (isCompositePlaying() == true)
			{
				(serialSeek.toChild.getTrait(MediaTraitType.PLAYABLE) as IPlayable).play();
			}
			
			if (traitAggregator.listenedChild != serialSeek.toChild)
			{
				detached = true;
				traitAggregator.listenedChild = serialSeek.toChild;
			}
		}
		
		override protected function prepareSeekOperation(time:Number):CompositeSeekOperation
		{
			var serialSeekList:Vector.<SerialChildSeekOperation> = prepareSerialSeekList();

			var seekToOp:SerialSeekOperation;
			var curChildIndex:int = traitAggregator.getChildIndex(traitAggregator.listenedChild);
			var curChildSeekOperation:SerialChildSeekOperation = serialSeekList[curChildIndex];
			if (curChildSeekOperation.relativeStart <= time && time < curChildSeekOperation.relativeEnd)
			{
				seekToOp = new SerialSeekOperation(time);
				seekToOp.canSeekTo = true;
				seekToOp.fromChild = curChildSeekOperation.child;
				seekToOp.toChild = curChildSeekOperation.child;
				seekToOp.toChildTime = time - curChildSeekOperation.relativeStart;
			}
			else if (time < curChildSeekOperation.relativeStart)
			{
				seekToOp = canSeekBackward(time, serialSeekList, curChildIndex);
			}
			else
			{
				seekToOp = canSeekForward(time, serialSeekList, curChildIndex);
			}

			return seekToOp;
		}
		
		override protected function checkSeeking():Boolean
		{
			return (traitOfCurrentChild != null)? traitOfCurrentChild.seeking : false;
		}

		// Internals
		//

		private function prepareSerialSeekList():Vector.<SerialChildSeekOperation>
		{
			var serialSeekList:Vector.<SerialChildSeekOperation> = new Vector.<SerialChildSeekOperation>();
			
			var curTime:Number = 0;
			for (var index:int = 0; index < traitAggregator.numChildren; index++)
			{
				var mediaElement:MediaElement = traitAggregator.getChildAt(index);
				var temporal:ITemporal = mediaElement.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
				var seekable:ISeekable = mediaElement.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
				
				if (temporal == null || seekable == null || isNaN(temporal.duration))
				{
					serialSeekList.push(
						new SerialChildSeekOperation(mediaElement, 0, index, curTime, curTime + temporal.duration, true));
				}
				else
				{
					serialSeekList.push(
						new SerialChildSeekOperation(mediaElement, 0, index, curTime, curTime + temporal.duration));
				}
				
				curTime += temporal.duration;
			}
			
			return serialSeekList;
		}
		
		private function canSeekBackward
			( time:Number
			, serialSeekList:Vector.<SerialChildSeekOperation>
			, curChildIndex:int):SerialSeekOperation
		{
			var seekToOp:SerialSeekOperation = new SerialSeekOperation(time);
			var index:int = curChildIndex - 1;
			if (index < 0)
			{
				seekToOp.canSeekTo = false;
				return seekToOp;
			}

			seekToOp.seekForward = false;
			seekToOp.canSeekTo = false;
			seekToOp.fromChild = serialSeekList[curChildIndex].child;
			
			var childSeekOp:SerialChildSeekOperation = serialSeekList[index];
			while (childSeekOp != null)
			{
				if (childSeekOp.unseekable == true)
				{
					break;
				}
				else if (time >= childSeekOp.relativeStart)
				{
					seekToOp.toChild = childSeekOp.child;
					seekToOp.toChildTime = time - childSeekOp.relativeStart;
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
					childSeekOp = serialSeekList[index];
				}
			}
			
			return seekToOp;
		}

		private function canSeekForward
			( time:Number
			, serialSeekList:Vector.<SerialChildSeekOperation>
			, curChildIndex:int):SerialSeekOperation
		{
			var seekToOp:SerialSeekOperation = new SerialSeekOperation(time);
			var index:int = curChildIndex + 1;
			if (index >= serialSeekList.length)
			{
				seekToOp.canSeekTo = false;
				return seekToOp;
			}

			seekToOp.seekForward = true;
			seekToOp.canSeekTo = false;
			seekToOp.fromChild = serialSeekList[curChildIndex].child;

			var childSeekOp:SerialChildSeekOperation = serialSeekList[index];
			while (childSeekOp != null)
			{
				if (childSeekOp.unseekable == true)
				{
					break;
				}
				else if (time < childSeekOp.relativeEnd)
				{
					seekToOp.toChild = childSeekOp.child;
					seekToOp.toChildTime = time - childSeekOp.relativeStart;
					seekToOp.canSeekTo = true;
					break;
				}
				
				index++;
				if (index >= serialSeekList.length)
				{
					break;
				}	
				else
				{
					childSeekOp = serialSeekList[index];
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

		private var detached:Boolean;
		private var crossChildrenSeeking:Boolean;
	}
}