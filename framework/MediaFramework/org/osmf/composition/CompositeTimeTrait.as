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
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.TimeTrait;

	/**
	 * Implementation of TimeTrait which can be a composite media trait.
	 * 
	 * For parallel media elements, the composite trait represents a timeline
	 * that encapsulates the timeline of all children.  Its duration is the
	 * maximum of the durations of all children.  Its currentTime is kept in sync
	 * for all children (with the obvious caveat that a child's currentTime will
	 * never be greater than its duration).
	 * 
	 * For serial elements, the composite trait represents a timeline that
	 * encapsulates the timeline of all children.  Its duration is the sum of
	 * the durations of all children.  Its currentTime is the sum of the currentTimes
	 * of the first N fully complete children, plus the currentTime of the next
	 * child.
	 **/
	internal class CompositeTimeTrait extends TimeTrait
	{
		/**
		 * Constructor.
		 * 
		 * @param traitAggregator The object which is aggregating all instances
		 * of the TimeTrait within this composite trait.
		 * @param mode The composition mode to which this composite trait
		 * should adhere.  See CompositionMode for valid values.
		 **/
		public function CompositeTimeTrait(traitAggregator:TraitAggregator, mode:CompositionMode, owner:MediaElement)
		{
			super();
			
			this.mode = mode;
			this.traitAggregator = traitAggregator;
			this.owner = owner;
			traitAggregationHelper = new TraitAggregationHelper
				( traitType
				, traitAggregator
				, processAggregatedChild
				, processUnaggregatedChild
				);
		}

		/**
		 * @private
		 */		
		override public function get currentTime():Number
		{
			updateCurrentTime();
			
			return super.currentTime;
		}
		
		override protected function processDurationReached():void
		{
			// The base class can cause this method to get called, sometimes
			// inappropriately (e.g. if currentTime == duration because we don't
			// have duration for the next child).  For serial, we should only let
			// the call pass through if we're truly at the end.
			// Also - Don't dispatch if the final trait doesn't have a time, wait until it either it gets it's
			// non-zero time or it dispatches durationReached.  -> FM-303.			
			if (	mode == CompositionMode.PARALLEL
				||  (traitAggregator.getChildIndex(traitAggregator.listenedChild) == traitAggregator.numChildren - 1 &&
					(traitAggregator.listenedChild.getTrait(MediaTraitType.TIME) as TimeTrait).duration > 0 &&
					!isNaN((traitAggregator.listenedChild.getTrait(MediaTraitType.TIME) as TimeTrait).duration))  
			   )
			{
				super.processDurationReached()
			}
				
		}
				
		// Internal
		//
		
		/**
		 * @private
		 **/
		private function processAggregatedChild(child:MediaTraitBase):void
		{
			child.addEventListener(TimeEvent.DURATION_CHANGE,  onDurationChanged, 	false, 0, true);
			child.addEventListener(TimeEvent.DURATION_REACHED, onDurationReached, 	false, 0, true);
			
			updateDuration();
			updateCurrentTime();
		}

		/**
		 * @private
		 **/
		private function processUnaggregatedChild(child:MediaTraitBase):void
		{
			child.removeEventListener(TimeEvent.DURATION_CHANGE, 	onDurationChanged);
			child.removeEventListener(TimeEvent.DURATION_REACHED, 	onDurationReached);
			
			updateDuration();
			updateCurrentTime();
		}

		private function onDurationChanged(event:TimeEvent):void
		{
			updateDuration();
		}

		private function onDurationReached(event:TimeEvent):void
		{
			var timeTrait:TimeTrait = event.target as TimeTrait;
			
			if (mode == CompositionMode.PARALLEL)
			{
				// If every child has reached their duration, then we should
				// dispatch the durationReached event.
				var allHaveReachedDuration:Boolean = true;
				traitAggregator.forEachChildTrait
					(
						function(mediaTrait:MediaTraitBase):void
						{
							var iterTimeTrait:TimeTrait = TimeTrait(mediaTrait);
							
							// Assume that the child that fired the event has
							// finished.
							if (iterTimeTrait != timeTrait &&
								iterTimeTrait.currentTime < iterTimeTrait.duration)
							{
								allHaveReachedDuration = false;
							}
						}
						, MediaTraitType.TIME
					);
				
				if (allHaveReachedDuration)
				{
					dispatchEvent(new TimeEvent(TimeEvent.DURATION_REACHED));
				}
			}
			else // SERIAL
			{
				if (timeTrait == traitOfCurrentChild)
				{
					// If the composite element has the PlayTrait and the
					// current child has another sibling ahead of it, then
					// the next sibling with a PlayTrait should be played.
					var playTrait:PlayTrait = owner.getTrait(MediaTraitType.PLAY) as PlayTrait;
					if (playTrait != null)
					{
						// Note that we don't check whether to dispatch the 
						// durationReached event until we determine that
						// there's no more playable children -- otherwise we'd
						// almost certainly dispatch it when it shouldn't be
						// dispatched since subsequent children are likely to
						// lack the temporal trait until they're loaded.
						SerialElementTransitionManager.playNextPlayableChild
							( traitAggregator
							, checkDispatchDurationReachedEvent
							);
					}
					else
					{
						checkDispatchDurationReachedEvent();
					}
				}
			}
		}
		
		private function checkDispatchDurationReachedEvent():void
		{
			// If the current child is the last temporal child, then we should
			// dispatch the durationReached event.
			var nextChild:MediaElement = 
				traitAggregator.getNextChildWithTrait
					( traitAggregator.listenedChild
					, MediaTraitType.TIME
					);
			
			if (nextChild == null)
			{				
				super.processDurationReached();
			}
		}
		
		private function updateDuration():void
		{
			var newDuration:Number = 0;
			
			traitAggregator.forEachChildTrait
				(
					function(mediaTrait:MediaTraitBase):void
				  	{
				  		var childDuration:Number = TimeTrait(mediaTrait).duration;
				  		if (!isNaN(childDuration))
				  		{
					  		if (mode == CompositionMode.PARALLEL)
					  	 	{ 
					  	 		// The duration is the max of all child durations.
					     	 	newDuration = Math.max(newDuration, childDuration);
					     	}
					     	else // SERIAL
					     	{
					     	 	// The duration is the sum of all child durations.
					     	 	newDuration += childDuration;
					     	}
					   }
				  	}
					, MediaTraitType.TIME
				);

			setDuration(newDuration);
		}
		
		private function updateCurrentTime():void
		{
			var newCurrentTime:Number = 0;
			var currentTimeCalculated:Boolean = false;
			
			traitAggregator.forEachChildTrait
				(
					function(mediaTrait:MediaTraitBase):void
				  	{
				  		var childCurrentTime:Number = TimeTrait(mediaTrait).currentTime;
				  		childCurrentTime = isNaN(childCurrentTime) ? 0 : childCurrentTime;
				  		
				  		if (mode == CompositionMode.PARALLEL)
				  	 	{
			  	 	 		// The currentTime is the max of all child currentTimes.
			     	 		newCurrentTime = Math.max(newCurrentTime, childCurrentTime);
			     	 	}
			     	 	else // SERIAL
			     	 	{
							// The currentTime is the sum of all durations up to the
							// current child, plus the currentTime of the current
							// child.
					  	 	if (!currentTimeCalculated)
					  	 	{
						  	 	if (mediaTrait == traitOfCurrentChild)
						  	 	{
						  	 	 	newCurrentTime += childCurrentTime;
						  	 	
						  	 	 	currentTimeCalculated = true;
						  	 	}
						  	 	else
						  	 	{
						  	 		var duration:Number = TimeTrait(mediaTrait).duration;
						  	 		if (!isNaN(duration))
						  	 		{
						  	 	 		newCurrentTime += duration;
						  	 	 	}
						  	 	}
						 	}
					 	}
				  	}
					, MediaTraitType.TIME
				);

			setCurrentTime(newCurrentTime);
		}

		private function get traitOfCurrentChild():TimeTrait
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.TIME) as TimeTrait
				   : null;
		}
		
		private var traitAggregator:TraitAggregator;
		private var traitAggregationHelper:TraitAggregationHelper;
		private var mode:CompositionMode;
		private var owner:MediaElement;
	}
}