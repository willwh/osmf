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
package org.openvideoplayer.composition
{
	import org.openvideoplayer.events.PlayingChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.IPausible;
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
		public function CompositePlayableTrait(traitAggregator:TraitAggregator, mode:CompositionMode, owner:MediaElement)
		{
			this.mode = mode;
			this.owner = owner;
			
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
			var curPlayable:IPlayable = owner.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			if (curPlayable != this && curPlayable != null)
			{
				return;
			}
			
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
					// If the child playable stops playing due to the stopage of the composite pausible 
					// is paused, do nothing.
					var pausible:IPausible = owner.getTrait(MediaTraitType.PAUSIBLE) as IPausible;
					if (pausible != null && pausible.paused)
					{
						return;
					}
					else
					{
						// This is more sticky situation. The original implementation of searching for 
						// the next child with a playable is incorrect, considering the case that 
						// the next child an image.
						//
						// So, the new implementation switches to the next media element by setting the
						// the new current child, which lets the composition to handle the new child
						// media element. 
						// 
						// Caution: this is a temporary fix, intended to remove the road block for 
						// other test cases which depend on composite playble. We will need to address
						// the problem in a more foundamental way in the up coming sprint.
						setPlaying(false);

						var curChildIndex:int = traitAggregator.getChildIndex(traitAggregator.listenedChild);
						if ((curChildIndex + 1) < traitAggregator.numChildren)
						{
							traitAggregator.listenedChild = traitAggregator.getChildAt(curChildIndex + 1);
							var newPlayable:IPlayable = traitAggregator.listenedChild.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
							if (newPlayable != null && !newPlayable.playing)
							{
								newPlayable.play();
							}
						}						
						
						return;
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
		private var owner:MediaElement;
		private var _playing:Boolean = false;
	}
}