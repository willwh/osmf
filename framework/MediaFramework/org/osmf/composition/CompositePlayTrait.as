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
	import org.osmf.events.PlayEvent;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	
	internal class CompositePlayTrait extends PlayTrait
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
			this.traitAggregator = traitAggregator;
			this.mode = mode;
			
			traitAggregationHelper = new TraitAggregationHelper
				( traitType
				, traitAggregator
				, processAggregatedChild
				, processUnaggregatedChild
				);
			
			super();
		}
		
		/**
		 * @private
		 **/
		override protected function processPlayStateChange(newPlayState:String):void
		{
			if (newPlayState != PlayState.PLAYING)
			{
				if (mode == CompositionMode.PARALLEL)
				{
					// Invoke the appropriate method on all children.
					if (newPlayState == PlayState.PLAYING)
					{
						traitAggregator.invokeOnEachChildTrait("play", [], MediaTraitType.PLAY);
					}
					else if (newPlayState == PlayState.PAUSED)
					{
						traitAggregator.invokeOnEachChildTrait("pause", [], MediaTraitType.PLAY);
					}
					else // STOPPED
					{
						traitAggregator.invokeOnEachChildTrait("stop", [], MediaTraitType.PLAY);
					}
				}
				else // SERIAL
				{
					// Invoke the appropriate method on the current child.
					setPlayState(traitOfCurrentChild, newPlayState);
				}
			}
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:MediaTraitBase):void
		{
			child.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange, false, 0, true);

			var playTrait:PlayTrait = child as PlayTrait;
			
			if (mode == CompositionMode.PARALLEL)
			{
				if (traitAggregator.getNumTraits(MediaTraitType.PLAY) == 1)
				{
					// The first added child's properties are applied to the
					// composite trait.
					setPlayState(this, playTrait.playState);
				}
				else
				{
					// All subsequently added children inherit their properties
					// from the composite trait.
					setPlayState(playTrait, this.playState);
				}
			}
			else if (child == traitOfCurrentChild)
			{
				// The first added child's properties are applied to the
				// composite trait.
				setPlayState(this, playTrait.playState);
			}
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			child.removeEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
		}
		
		// Internals
		//
		
		private function onPlayStateChange(event:PlayEvent):void
		{
			var playTrait:PlayTrait = event.target as PlayTrait;
			
			if (mode == CompositionMode.PARALLEL)
			{
				// The composition should reflect what its children do.
				setPlayState(this, playTrait.playState);
			}
			else if (playTrait == traitOfCurrentChild)
			{
				// The composition should reflect what its children do.
				setPlayState(this, playTrait.playState);
				
				// Typically, the CompositeTimeTrait will handle transitioning
				// from one child to the next based on the receipt of the
				// durationReached event.  However, if the current child
				// doesn't have the TimeTrait, then it obviously can't do so.
				// So we check here for that case.
				if (playTrait.playState == PlayState.STOPPED &&
					traitAggregator.listenedChild.hasTrait(MediaTraitType.TIME) == false)
				{
					// If the current child has another sibling ahead of it,
					// then the next sibling with a PlayTrait should be played.
					SerialElementTransitionManager.playNextPlayableChild
						( traitAggregator
						, null
						);
				}
			}
		}
		
		private function setPlayState(playTrait:PlayTrait, value:PlayState):void
		{
			if (value != playState)
			{
				if (value == PlayState.PLAYING)
				{
					play();
				}
				else if (value == PlayState.PAUSED)
				{
					pause();
				}
				else // STOPPED
				{
					stop();
				}
			}	
		}
		
		private function get traitOfCurrentChild():IPlayable
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.PLAYABLE) as IPlayable
				   : null;
		}

		private var mode:CompositionMode;
		private var traitAggregator:TraitAggregator;
		private var traitAggregationHelper:TraitAggregationHelper;
	}
}