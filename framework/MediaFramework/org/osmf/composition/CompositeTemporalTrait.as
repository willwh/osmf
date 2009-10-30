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
	import org.osmf.events.DurationChangeEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.ITemporal;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * Dispatched when the duration of the trait changed
	 * 
	 * @eventType org.osmf.events.DurationChangeEvent.DURATION_CHANGE
	 */
	[Event(name="durationChange", type="org.osmf.events.DurationChangeEvent")]
	
	/**
	 * Dispatched when the currentTime of the trait changed to a value
	 * that is equal to the duration of the ITemporal.
	 * 
	 * @eventType org.osmf.events.TraitEvent.DURATION_REACHED
	 */
	[Event(name="durationReached",type="org.osmf.events.TraitEvent")]

	/**
	 * Implementation of ITemporal which can be a composite media trait.
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
	internal class CompositeTemporalTrait extends CompositeMediaTraitBase implements ITemporal
	{
		/**
		 * Constructor.
		 * 
		 * @param traitAggregator The object which is aggregating all instances
		 * of the ITemporal trait within this composite trait.
		 * @param mode The composition mode to which this composite trait
		 * should adhere.  See CompositionMode for valid values.
		 **/
		public function CompositeTemporalTrait(traitAggregator:TraitAggregator, mode:CompositionMode, owner:MediaElement)
		{
			this.mode = mode;
			this.owner = owner;
			
			super(MediaTraitType.TEMPORAL, traitAggregator);
		}

		/**
		 * @inheritDoc 
		 */		
		public function get duration():Number
		{
			return _duration;
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function get currentTime():Number
		{
			updateCurrentTime();
			
			return _currentTime;
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			child.addEventListener(DurationChangeEvent.DURATION_CHANGE, onDurationChanged, 	false, 0, true);
			child.addEventListener(TraitEvent.DURATION_REACHED, 		onDurationReached, 	false, 0, true);
			
			updateDuration();
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			child.removeEventListener(DurationChangeEvent.DURATION_CHANGE, 	onDurationChanged);
			child.removeEventListener(TraitEvent.DURATION_REACHED, 			onDurationReached);
			
			updateDuration();
		}

		// Internals
		//
		
		private function onDurationChanged(event:DurationChangeEvent):void
		{
			updateDuration();
		}

		private function onDurationReached(event:TraitEvent):void
		{
			var temporal:ITemporal = event.target as ITemporal;
			
			if (mode == CompositionMode.PARALLEL)
			{
				// If every child has reached their duration, then we should
				// dispatch the durationReached event.
				var allHaveReachedDuration:Boolean = true;
				traitAggregator.forEachChildTrait
					(
						function(mediaTrait:IMediaTrait):void
						{
							var iterTemporal:ITemporal = ITemporal(mediaTrait);
							
							// Assume that the child that fired the event has
							// finished.
							if (iterTemporal != temporal &&
								iterTemporal.currentTime < iterTemporal.duration)
							{
								allHaveReachedDuration = false;
							}
						}
						, MediaTraitType.TEMPORAL
					);
				
				if (allHaveReachedDuration)
				{
					dispatchEvent(new TraitEvent(TraitEvent.DURATION_REACHED));
				}
			}
			else // SERIAL
			{
				if (temporal == traitOfCurrentChild)
				{
					// If the composite element is playable and the current
					// child has another sibling ahead of it, then the next
					// playable sibling should be played.
					var playable:IPlayable = owner.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
					if (playable)
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
					, MediaTraitType.TEMPORAL
					);
			
			if (nextChild == null)
			{
				dispatchEvent(new TraitEvent(TraitEvent.DURATION_REACHED));
			}
		}
		
		private function updateDuration():void
		{
			var newDuration:Number = 0;
			
			traitAggregator.forEachChildTrait
				(
					function(mediaTrait:IMediaTrait):void
				  	{
				  		var duration:Number = ITemporal(mediaTrait).duration;
				  		if (!isNaN(duration))
				  		{
					  		if (mode == CompositionMode.PARALLEL)
					  	 	{ 
					  	 		// The duration is the max of all child durations.
					     	 	newDuration = Math.max(newDuration, duration);
					     	}
					     	else // SERIAL
					     	{
					     	 	// The duration is the sum of all child durations.
					     	 	newDuration += duration;
					     	}
					   }
				  	}
					, MediaTraitType.TEMPORAL
				);

			setDuration(newDuration);
		}
		
		private function setDuration(value:Number):void
		{
			if (_duration != value)
			{
				var oldDuration:Number = _duration;
				_duration = value;
					
				dispatchEvent(new DurationChangeEvent(oldDuration, _duration));
				
				// Current time cannot exceed duration.
				if (currentTime > duration)
				{
					updateCurrentTime();
				}
			}
		}
		
		private function updateCurrentTime():void
		{
			var newCurrentTime:Number = 0;
			var currentTimeCalculated:Boolean = false;
			
			traitAggregator.forEachChildTrait
				(
					function(mediaTrait:IMediaTrait):void
				  	{
				  		var currentTime:Number = ITemporal(mediaTrait).currentTime;
				  		currentTime = isNaN(currentTime) ? 0 : currentTime;
				  		
				  		if (mode == CompositionMode.PARALLEL)
				  	 	{
			  	 	 		// The currentTime is the max of all child currentTimes.
			     	 		newCurrentTime = Math.max(newCurrentTime, currentTime);
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
						  	 	 	newCurrentTime += currentTime;
						  	 	
						  	 	 	currentTimeCalculated = true;
						  	 	}
						  	 	else
						  	 	{
						  	 		var duration:Number = ITemporal(mediaTrait).duration;
						  	 		if (!isNaN(duration))
						  	 		{
						  	 	 		newCurrentTime += duration;
						  	 	 	}
						  	 	}
						 	}
					 	}
				  	}
					, MediaTraitType.TEMPORAL
				);

			setCurrentTime(newCurrentTime);
		}
		
		private function setCurrentTime(value:Number):void
		{
			// Don't ever let the currentTime exceed the duration.
			value = Math.min(value, isNaN(duration) ? 0 : duration);

			if (_currentTime != value)
			{
				var oldCurrentTime:Number = _currentTime;
				_currentTime = value;
			}
		}

		private function get traitOfCurrentChild():ITemporal
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.TEMPORAL) as ITemporal
				   : null;
		}
		
		private var mode:CompositionMode;
		private var owner:MediaElement;
		private var _duration:Number;
		private var _currentTime:Number;
	}
}