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
	import org.openvideoplayer.events.DurationChangeEvent;
	import org.openvideoplayer.events.TraitEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.MediaTraitType;
	
	/**
	 * Dispatched when the duration of the trait changed
	 * 
	 * @eventType org.openvideoplayer.events.DurationChangeEvent.DURATION_CHANGE
	 */
	[Event(name="durationChange", type="org.openvideoplayer.events.DurationChangeEvent")]
	
	/**
	 * Dispatched when the position of the trait changed to a value
	 * that is equal to the duration of the ITemporal.
	 * 
	 * @eventType org.openvideoplayer.events.TraitEvent.DURATION_REACHED
	 */
	[Event(name="durationReached",type="org.openvideoplayer.events.TraitEvent")]

	/**
	 * Implementation of ITemporal which can be a composite media trait.
	 * 
	 * For parallel media elements, the composite trait represents a timeline
	 * that encapsulates the timeline of all children.  Its duration is the
	 * maximum of the durations of all children.  Its position is kept in sync
	 * for all children (with the obvious caveat that a child's position will
	 * never be greater than its duration).
	 * 
	 * For serial elements, the composite trait represents a timeline that
	 * encapsulates the timeline of all children.  Its duration is the sum of
	 * the durations of all children.  Its position is the sum of the positions
	 * of the first N fully complete children, plus the position of the next
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
		public function CompositeTemporalTrait(traitAggregator:TraitAggregator, mode:CompositionMode)
		{
			this.mode = mode;
			
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
		public function get position():Number
		{
			updatePosition();
			
			return _position;
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
			
			var doDispatchEvent:Boolean = false;
			
			if (mode == CompositionMode.PARALLEL)
			{
				// If every child has reached their duration, then we should
				// dispatch the durationReached event.
				var allHaveReachedDuration:Boolean = true;
				traitAggregator.forEachChildTrait
					(
						function(mediaTrait:IMediaTrait):void
						{
							var temporal:ITemporal = ITemporal(mediaTrait);
							if (temporal.position < temporal.duration)
							{
								allHaveReachedDuration = false;
							}
						}
						, MediaTraitType.TEMPORAL
					);
				
				if (allHaveReachedDuration)
				{
					doDispatchEvent = true;
				}
			}
			else // SERIAL
			{
				// If the durationReached came from the current child, and
				// the current child is the last child, then we should dispatch the
				// durationReached event.
				if (temporal == traitOfCurrentChild)
				{
					var nextChild:MediaElement = 
						traitAggregator.getNextChildWithTrait
							( traitAggregator.listenedChild
							, MediaTraitType.TEMPORAL
							);
					
					if (nextChild == null)
					{
						doDispatchEvent = true;
					}
				}
			}
			
			if (doDispatchEvent)
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
				  		if (mode == CompositionMode.PARALLEL)
				  	 	{ 
				  	 		// The duration is the max of all child durations.
				     	 	newDuration = Math.max(newDuration, ITemporal(mediaTrait).duration);
				     	}
				     	else // SERIAL
				     	{
				     	 	// The duration is the sum of all child durations.
				     	 	newDuration += ITemporal(mediaTrait).duration;
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
				
				// Position cannot exceed duration.
				if (position > duration)
				{
					updatePosition();
				}
			}
		}
		
		private function updatePosition():void
		{
			var newPosition:Number = 0;
			var positionCalculated:Boolean = false;
			
			traitAggregator.forEachChildTrait
				(
					function(mediaTrait:IMediaTrait):void
				  	{
				  		if (mode == CompositionMode.PARALLEL)
				  	 	{
			  	 	 		// The position is the max of all child positions.
			     	 		newPosition = Math.max(newPosition, ITemporal(mediaTrait).position);
			     	 	}
			     	 	else // SERIAL
			     	 	{
							// The position is the sum of all durations up to the
							// current child, plus the position of the current
							// child.
					  	 	if (!positionCalculated)
					  	 	{
						  	 	if (mediaTrait == traitOfCurrentChild)
						  	 	{
						  	 	 	newPosition += ITemporal(mediaTrait).position;
						  	 	
						  	 	 	positionCalculated = true;
						  	 	}
						  	 	else
						  	 	{
						  	 	 	newPosition += ITemporal(mediaTrait).duration;
						  	 	}
						 	}
					 	}
				  	}
					, MediaTraitType.TEMPORAL
				);

			setPosition(newPosition);
		}
		
		private function setPosition(value:Number):void
		{
			// Don't ever let the position exceed the duration.
			value = Math.min(value, duration);

			if (_position != value)
			{
				var oldPosition:Number = _position;
				_position = value;
			}
		}

		private function get traitOfCurrentChild():ITemporal
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.TEMPORAL) as ITemporal
				   : null;
		}
		
		private var mode:CompositionMode;
		private var _duration:Number;
		private var _position:Number;
	}
}