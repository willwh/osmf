package org.openvideoplayer.composition
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	import org.openvideoplayer.events.TraitEvent;
	import org.openvideoplayer.media.IMediaTrait;
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
			if(value != _autoSwitch)
			{
				_autoSwitch = value;
				var switching:Boolean = false;
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
			_maxIndex = value;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get switchUnderway():Boolean
		{
			var switching:Boolean = false;
			traitAggregator.forEachChildTrait(
					function(mediaTrait:ISwitchable):void
					{
						switching = mediaTrait.autoSwitch || switching;
					}
				,   MediaTraitType.SWITCHABLE
				);
			return switching;
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
					debug("switchTo() - manually switching to index: " + index);
					traitAggregator.forEachChildTrait(
						function(mediaTrait:ISwitchable):void
						{
							if (mediaTrait.getBitrateForIndex(0) > bitRates[index])
							{
								mediaTrait.switchTo(0);
								return;
							}
							for (var itr:Number  = 0; itr < mediaTrait.maxIndex; itr++)
							{							
								if (mediaTrait.getBitrateForIndex(mediaTrait.currentIndex) == bitRates[index])
								{
									mediaTrait.switchTo(itr);
									return;
								}
								else if (itr > 0 &&
										mediaTrait.getBitrateForIndex(itr-1) < bitRates[index] &&
										mediaTrait.getBitrateForIndex(itr) > bitRates[index])
								{
									
									mediaTrait.switchTo(itr-1);
									return;
								}								
							}	
							//If we made it here, the last item is the correct stream
							mediaTrait.switchTo(mediaTrait.maxIndex);													
						}
					    , MediaTraitType.SWITCHABLE);
				}
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE);
			}	
			_currentIndex = index;		
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function processAggregatedChild(child:IMediaTrait):void
		{			
			var aggregatedBR:int = 0;
			var childTrait:ISwitchable = ISwitchable(child);
			mergeChildRates(childTrait);
			childTrait.autoSwitch = _autoSwitch;
			child.addEventListener(TraitEvent.INDICES_CHANGE, redispatch);	
			child.addEventListener(TraitEvent.INDICES_CHANGE, recomputeIndicies);				
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{		
			rebuildBitRateTable();
			child.removeEventListener(TraitEvent.INDICES_CHANGE, redispatch);		
			child.removeEventListener(TraitEvent.INDICES_CHANGE, recomputeIndicies);	
		}
		
		private function rebuildBitRateTable():void
		{
			//Rebuild bitRate table
			bitRates = new Vector.<Number>;
						
			traitAggregator.forEachChildTrait(
				function(mediaTrait:ISwitchable):void
				{	
					mergeChildRates(mediaTrait);			
				}
			,   MediaTraitType.SWITCHABLE
			);
		}
		
		private function mergeChildRates(child:ISwitchable):void
		{	
			var aggregatedBR:int = 0;
						
			for (var childBR:int = 0; childBR < child.maxIndex; ++childBR)
			{
				var rate:Number = child.getBitrateForIndex(childBR);
				
				if (bitRates.length <= aggregatedBR) //Add it to the end
				{
					bitRates.push(rate);
					aggregatedBR++;					
				} 
				else if (bitRates[aggregatedBR] == rate)
				{
					continue;  //NO operation for rates that already are in the list. 
				}			
				else if (bitRates[aggregatedBR] < rate)
				{
				 	aggregatedBR++;			
				 	childBR--;  //backup one, we need to keep going through the aggregatedBR's until we find a spot.	 	
				}
				else  //bitrate is smaller than the current bitrate.
				{
					bitRates.splice(aggregatedBR, 0, rate);
				}
			}	
		}
		
		private function recomputeIndicies(event:TraitEvent):void
		{
			var oldBitRate:Number = bitRates[currentIndex];
			rebuildBitRateTable();
			var newB:Number = bitRates[0];
			var newBIndex:Number = 0;
			while(newBIndex < bitRates.length)
			{
				if(bitRates[newBIndex] > oldBitRate)
				{
					break;
				}	
				newBIndex++;			
			}
			switchTo(newBIndex-1 < 0 ? 0 : newBIndex-1);			
		}
		
		/**
		 * If DEBUG is true, traces out debug messages.
		 */
		private function debug(...args):void
		{
			trace(">>> CompositeSwitchable."+args);			
		}
		
		protected function redispatch(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		
		private var _autoSwitch:Boolean = false;
		private var _maxIndex:int = int.MAX_VALUE;
		private var _currentIndex:int = -1;
		private var bitRates:Vector.<Number> = new Vector.<Number>;
		
		
		
	}
}