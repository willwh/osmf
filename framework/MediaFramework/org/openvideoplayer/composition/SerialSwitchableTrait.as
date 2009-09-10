package org.openvideoplayer.composition
{
	import flash.events.Event;
	
	import org.openvideoplayer.events.SwitchingChangeEvent;
	import org.openvideoplayer.events.TraitEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.ISwitchable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SwitchableTrait;

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
	 * The Composite Serial switchable trait will aggregate switchable traits, acting as a single
	 * switchable trait.  This trait will match settinngs between child traits when switching between children.
	 */ 
	public class SerialSwitchableTrait extends CompositeMediaTraitBase implements ISwitchable, IReusable
	{
		/**
		 * Constructs a Composite Serial switchable trait.
		 */ 
		public function SerialSwitchableTrait(traitAggregator:TraitAggregator)
		{
			super(MediaTraitType.SWITCHABLE, traitAggregator);
		}
		
		/**
		 * @inheritDoc
		 */ 	
		public function get autoSwitch():Boolean
		{
			return currentChild.autoSwitch;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set autoSwitch(value:Boolean):void
		{
			currentChild.autoSwitch = value;;		
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get currentIndex():int
		{
			return currentChild.currentIndex;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getBitrateForIndex(index:int):Number
		{
			return currentChild.getBitrateForIndex(index);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get maxIndex():int
		{
			return currentChild.maxIndex;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set maxIndex(value:int):void
		{			
			currentChild.maxIndex = value;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get switchUnderway():Boolean
		{
			return currentChild.switchUnderway;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function switchTo(index:int):void
		{	
			currentChild.switchTo(index);		
		}	
		
		public function prepare():void
		{
			//nothing to do here, required for IReusable.
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			currentChild = SwitchableTrait(child);
			
			if (!isNaN(_lastBitrate)) //This isn't our first child, carry on properties
			{				
				currentChild.autoSwitch = _autoSwitch;
				if (!currentChild.autoSwitch)
				{
					for (var itr:Number = 0; itr <= currentChild.maxIndex; itr++)
					{
						if(currentChild.getBitrateForIndex(itr) == _lastBitrate ||
							itr == currentChild.maxIndex)
						{
							currentChild.switchTo(itr);	
							break;	
						}
						else if (currentChild.getBitrateForIndex(itr) >_lastBitrate)							
						{						
							currentChild.switchTo(itr-1);	
							break;	
						}				 
					}					
				}				
			}					
			child.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE,  redispatchEvent);	
			child.addEventListener(TraitEvent.INDICES_CHANGE, redispatchEvent);		
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			_autoSwitch = currentChild.autoSwitch;
			_lastBitrate = currentChild.getBitrateForIndex(currentChild.currentIndex);
			child.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE,  redispatchEvent);	
			child.removeEventListener(TraitEvent.INDICES_CHANGE, redispatchEvent);	
			currentChild = null;
		}	
		
		private function redispatchEvent(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		private var _lastBitrate:Number = NaN;
		private var _autoSwitch:Boolean;
		private var currentChild:SwitchableTrait;
		
	}
}