package org.openvideoplayer.composition
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	
	import org.openvideoplayer.events.SwitchingChangeEvent;
	import org.openvideoplayer.events.TraitEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.ISwitchable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.MediaFrameworkStrings;

	/**
	 * Dispatched when a stream switch is requested, completed, or failed.
	 * 
	 * @eventType org.openvideoplayer.events.SwitchingChangeEvent.SWITCHING_CHANGE
	 */
	[Event(name="switchingChange",type="org.openvideoplayer.events.SwitchingChangeEvent")]
	
	/**
	 * Dispatched when the number of indicies or associated bitrates have changed.
	 * 
	 * @eventType org.openvideoplayer.events.TraitEvent.INDICES_CHANGE
	 */
	[Event(name="indicesChange",type="org.openvideoplayer.events.TraitEvent")]
	
	/**
	 * CompositeSwitchableTrait brings mutiple bitrate switchable traits together into one
	 * trait that is an aggregation of the different bitrates of the chid traits.
	 * If a child doesn't have the same bitrate as an another, the closest match will be chosen
	 * when switching between bitrates.
	 */ 
	public class ParallelSwitchableTrait extends CompositeMediaTraitBase implements ISwitchable
	{
		/**
		 * Construcs a CompositeSwitchableTrait
		 */ 
		public function ParallelSwitchableTrait(traitAggregator:TraitAggregator)
		{
			super(MediaTraitType.SWITCHABLE, traitAggregator);
		}
			
		/**
		 * @inheritDoc
		 */ 	
		public function get autoSwitch():Boolean
		{
			return _autoSwitch;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set autoSwitch(value:Boolean):void
		{
			if (value != _autoSwitch)
			{
				_autoSwitch = value;
				traitAggregator.forEachChildTrait(
						function(mediaTrait:ISwitchable):void
						{
							 mediaTrait.autoSwitch = _autoSwitch;
						}
					,   MediaTraitType.SWITCHABLE
					);
			}		
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getBitrateForIndex(index:int):Number
		{
			if (index >= bitRates.length || index < 0)
			{
				throw new RangeError(MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
			}
			return bitRates[index];
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get maxIndex():int
		{
			return _maxIndex;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set maxIndex(value:int):void
		{		
			if (value >= bitRates.length || value < 0)
			{
				throw new RangeError(MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
			}	
			_maxIndex = value;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get switchUnderway():Boolean
		{				
			for( var itr:Number = 0; itr < traitAggregator.numChildren; ++itr)
			{
				var child:MediaElement = traitAggregator.getChildAt(itr);
				if (child.hasTrait(MediaTraitType.SWITCHABLE) &&
					(child.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).switchUnderway)
				{
					return true;
				}							
			}			
			return false;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function switchTo(index:int):void
		{		
			if (!_autoSwitch)
			{
				if ((index < 0) || (index > maxIndex))
				{
					throw new RangeError(MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
				}
				else
				{					
					traitAggregator.forEachChildTrait(
						function(mediaTrait:ISwitchable):void
						{	
							var desiredBitRate:Number = bitRates[index];	
							var childIndex:Number;		
							for (childIndex = 0; childIndex <= mediaTrait.maxIndex; childIndex++)
							{		
								var childBitRate:Number = mediaTrait.getBitrateForIndex(childIndex);
													
								if (childBitRate == desiredBitRate)								   
								{
									break;
								}									
								else if (childBitRate > desiredBitRate)
								{
									childBitRate--;
									break;
								}				
							}							
							//If we made it here, the last item is the correct stream
							mediaTrait.switchTo(Math.min(childIndex, mediaTrait.maxIndex));													
						}
					    , MediaTraitType.SWITCHABLE);
					    _currentIndex = index;
					    trace('new parallel index:' + _currentIndex);
				}
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE);
			}						
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function processAggregatedChild(child:IMediaTrait):void
		{			
			var aggregatedBR:int = 0;
			var childTrait:ISwitchable = ISwitchable(child);
			if (traitAggregator.getNumTraits(MediaTraitType.SWITCHABLE) == 1)
			{
				_autoSwitch = childTrait.autoSwitch;				
			}
			else
			{
				childTrait.autoSwitch = _autoSwitch;
			}
						
			if (mergeChildRates(childTrait))
			{
				dispatchEvent(new TraitEvent(TraitEvent.INDICES_CHANGE));
			}
			trace('adding SwitchingChangeEvent.SWITCHING_CHANGE listener');
			child.addEventListener(TraitEvent.INDICES_CHANGE, recomputeIndices);
			child.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, childSwitchingChange);
			_maxIndex = bitRates.length-1; 			
			
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{	
			trace('removing SwitchingChangeEvent.SWITCHING_CHANGE listener');
			child.removeEventListener(TraitEvent.INDICES_CHANGE, recomputeIndices);
			child.removeEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, childSwitchingChange);		
			recomputeIndices();	
		}
		
		/**
		 * Rebuilds the child bitrates from the children's switchable traits.
		 * updates the max index based on the children's max indices.
		 * 
		 * @returns if there were changes to the bitrate table.
		 */ 
		private function rebuildBitRateTable():Boolean
		{
			//Rebuild bitRate table
			var oldBitRates:Vector.<Number> = bitRates;
			bitRates = new Vector.<Number>;
								
			traitAggregator.forEachChildTrait(
				function(mediaTrait:ISwitchable):void
				{	
					mergeChildRates(mediaTrait);							
				}
			,   MediaTraitType.SWITCHABLE
			);
			_maxIndex = bitRates.length -1;
			
			//Currently doesn't detect in place changes.
			//since this is never called after an in place change, this check is good enough.
			return oldBitRates.length != bitRates.length;
		}
		
		/**
		 * Add a new child to the bitrate table.  Insertions are made in
		 * soted order.
		 * 
		 * @returns if the indices changed.
		 */ 
		private function mergeChildRates(child:ISwitchable):Boolean
		{	
			var aggregatedIndex:int = 0;
			var indicesChanged:Boolean = false;
						
			for (var childBR:int = 0; childBR <= child.maxIndex; ++childBR)
			{
				var rate:Number = child.getBitrateForIndex(childBR);
				
				if (bitRates.length <= aggregatedIndex) //Add it to the end
				{
					indicesChanged = true;
					bitRates.push(rate);
					aggregatedIndex++;					
				} 
				else if (bitRates[aggregatedIndex] == rate)
				{
					continue;  //NO operation for rates that already are in the list. 
				}			
				else if (bitRates[aggregatedIndex] < rate)
				{
				 	aggregatedIndex++;			
				 	childBR--;  //backup one, we need to keep going through the aggregatedBR's until we find a spot.	 	
				}
				else  //bitrate is smaller than the current bitrate.
				{
					indicesChanged = true;
					bitRates.splice(aggregatedIndex, 0, rate);
				}
			}	
			return indicesChanged;
		}
		
		/**
		 * Rebuilds the bitrate table and switches to the appropriate bit rate.
		 */ 
		private function recomputeIndices(event:TraitEvent = null):void
		{			
			trace('recomputeIndices');
			var oldBitRate:Number = bitRates[currentIndex];
			if(rebuildBitRateTable()) //Update current index, and dispatch event if indices changed.
			{
				if (!_autoSwitch)
				{			
					var highestBitRate:Number = 0;		
					traitAggregator.forEachChildTrait(
						function(mediaTrait:ISwitchable):void
						{	
							highestBitRate = Math.max(mediaTrait.getBitrateForIndex(mediaTrait.currentIndex), highestBitRate);							
						}
						,   MediaTraitType.SWITCHABLE);
					var newBIndex:Number = 0;
					while(highestBitRate != bitRates[newBIndex])
					{
						newBIndex++;								
					}	
					_currentIndex = newBIndex;					
				}
				dispatchEvent(new TraitEvent(TraitEvent.INDICES_CHANGE));
			}								
		}
				
		/**
		 * Handle the child switchable changing.  If collapse multiple events
		 * into a single event when switching muple children simultaneously.   
		 */ 
		private function childSwitchingChange(event:SwitchingChangeEvent):void
		{			
			trace('childSwitchingChange received, new state:' + event.newState + "  current state:" + _state);
		 
			if(event.newState != _state)
			{					
				if(event.newState == SwitchingChangeEvent.SWITCHSTATE_COMPLETE && switchUnderway)
				{
					trace('switchComplete received, current state:' + switchUnderway);
					return; //NO-OP if we have pending switches.				
				}			
				trace('changing parallel to new state:' + event.newState);
				var oldState:int = 	_state;											
				_state = event.newState;	
				dispatchEvent(new SwitchingChangeEvent(event.newState, oldState, event.detail));			
			}
		}
				
		private var _state:int = SwitchingChangeEvent.SWITCHSTATE_UNDEFINED;
		private var _autoSwitch:Boolean = false;
		private var _maxIndex:int = int.MAX_VALUE;
		private var _currentIndex:int = 0;
		private var bitRates:Vector.<Number> = new Vector.<Number>;
		
		
		
	}
}