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
	import org.osmf.events.PlayingChangeEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * Dispatched when the trait's playing property has changed.
	 * 
	 * @eventType org.osmf.events.PausedChangedEvent.PLAYING_CHANGE
	 */
	[Event(name="playingChange",type="org.osmf.events.PlayingChangeEvent")]

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
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get playing():Boolean
		{
			return _playing;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
					
					setPlaying(true);
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
				// The composition should reflect what its children do.
				setPlaying(playable.playing);
				
				// Typically, the CompositeTemporalTrait will handle
				// transitioning from one child to the next based on the
				// receipt of the durationReached event.  However, if the
				// current child isn't temporal, then it obviously can't
				// do so.  So we check here for that case.
				if (playable.playing == false &&
					traitAggregator.listenedChild.hasTrait(MediaTraitType.TEMPORAL) == false)
				{
					// If the current child has another sibling ahead of it,
					// then the next playable sibling should be played.
					SerialElementTransitionManager.playNextPlayableChild
						( traitAggregator
						, null
						);
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