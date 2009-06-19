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
	import org.openvideoplayer.events.PlayingChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.MediaTraitType;
	
	/**
	 * Dispatched when the trait's playing property has changed.
	 * 
	 * @eventType org.openvideoplayer.events.PausedChangedEvent.PLAYING_CHANGE
	 */
	[Event(name="playingChange",type="org.openvideoplayer.events.PlayingChangeEvent")]

	internal class CompositePlayableTrait extends CompositeMediaTraitBase implements IPlayable
	{
		/**
		 * Constructor.
		 * 
		 * @param traitAggregator The object which is aggregating all instances
		 * of the IPlayable trait within this composite trait.
		 * @param mode The composition mode to which this composite trait
		 * should adhere.  See CompositionMode for valid values.
		 **/
		public function CompositePlayableTrait(traitAggregator:TraitAggregator, mode:CompositionMode)
		{
			this.mode = mode;
			
			super(MediaTraitType.PLAYABLE, traitAggregator);
		}

		/**
		 * Resets the <code>playing</code> property of the trait.
		 * Changes <code>playing</code> from <code>true</code> to 
		 * <code>false</code>.
		 * <p>Used after <code>CompositePausibleTrait.pause()</code> is invoked.</p>
		 * 
		 */		
		final public function resetPlaying():void
		{
			if (playing == true)
			{
				setPlaying(false);
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get playing():Boolean
		{
			return _playing;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function play():void
		{
			if (playing == false)
			{
				if (mode == CompositionMode.PARALLEL)
				{
					// Invoke play on all children.
					traitAggregator.invokeOnEachChildTrait("play", [], MediaTraitType.PLAYABLE);
				}
				else // SERIAL
				{
					// Invoke play on the current child.
					traitOfCurrentChild.play();
				}
				
				setPlaying(true);
			}
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			child.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChanged, false, 0, true);

			var playable:IPlayable = child as IPlayable;
			
			if (mode == CompositionMode.PARALLEL)
			{
				if (traitAggregator.getNumTraits(MediaTraitType.PLAYABLE) == 1)
				{
					// The first added child's properties are applied to the
					// composite trait.
					setPlaying(playable.playing);
				}
				else
				{
					// All subsequently added children inherit their properties
					// from the composite trait.
					if (playing)
					{
						playable.play();
					}
				}
			}
			else if (child == traitOfCurrentChild)
			{
				// The first added child's properties are applied to the
				// composite trait.
				setPlaying(playable.playing);
			}
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			child.removeEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChanged);
		}
		
		// Internals
		//
		
		private function onPlayingChanged(event:PlayingChangeEvent):void
		{
			var playable:IPlayable = event.target as IPlayable;
			
			if (mode == CompositionMode.PARALLEL)
			{
				if (playable.playing)
				{
					// If a child is now playing, then the composition should
					// play too.
					play();
				}
				else
				{
					// If the child is no longer playing, we should check all
					// children to see if we need to update our own state.
					//
					
					var hasPlayingChild:Boolean = false;

					traitAggregator.forEachChildTrait
						(
							function(mediaTrait:IMediaTrait):void
							{
								if (!hasPlayingChild && 
									IPlayable(mediaTrait).playing)
								{
									hasPlayingChild = true;
								}
							}
							, MediaTraitType.PLAYABLE
						);
					
					if (hasPlayingChild == false)
					{
						setPlaying(false);
					}
				}
			}
			else if (playable == traitOfCurrentChild)
			{
				if (playable.playing)
				{
					// The composition should reflect what its children do.
					setPlaying(playable.playing);
				}
				else
				{
					// Make a list of all children that follow the current
					// child.
					var nextChildren:Array = [];
					var reachedCurrentChild:Boolean = false;
					for (var i:int = 0; i < traitAggregator.numChildren; i++)
					{
						var child:MediaElement = traitAggregator.getChildAt(i);
						var childPlayable:IPlayable = child.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
						if (childPlayable == playable)
						{
							reachedCurrentChild = true;
						}
						else if (reachedCurrentChild)
						{
							nextChildren.push(child);
						}
					}
					
					// Use a TraitLoader to find the next child that's
					// playable, loading along the way if necessary.
					var traitLoader:TraitLoader = new TraitLoader();
					traitLoader.addEventListener(TraitLoaderEvent.TRAIT_FOUND, onTraitFound);
					traitLoader.findOrLoadMediaElementWithTrait(nextChildren, MediaTraitType.PLAYABLE);
					
					function onTraitFound(event:TraitLoaderEvent):void
					{
						traitLoader.removeEventListener(TraitLoaderEvent.TRAIT_FOUND, onTraitFound);
						
						// If we do have a next playable child, then we play it.
						// Otherwise we're done playing.
						if (event.mediaElement)
						{
							var traitOfNextPlayableChild:IPlayable = event.mediaElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
							traitOfNextPlayableChild.play();
							
							traitAggregator.listenedChild = event.mediaElement;
						}
						else
						{
							setPlaying(false);
						}
					}
				}
			}
		}
		
		private function setPlaying(value:Boolean):void
		{
			if (value != _playing)
			{
				_playing = value;
				
				dispatchEvent(new PlayingChangeEvent(value));
			}	
		}
		
		private function get traitOfCurrentChild():IPlayable
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.PLAYABLE) as IPlayable
				   : null;
		}

		private var mode:CompositionMode;
		private var _playing:Boolean = false;
	}
}