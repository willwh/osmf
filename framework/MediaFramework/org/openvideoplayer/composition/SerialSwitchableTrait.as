package org.openvideoplayer.composition
{
	import flash.events.Event;
	
	import org.openvideoplayer.events.SwitchingChangeEvent;
	import org.openvideoplayer.events.TraitEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.ISwitchable;
	import org.openvideoplayer.traits.MediaTraitType;

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
	internal class SerialSwitchableTrait extends CompositeMediaTraitBase implements ISwitchable, IReusable
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
			
			if (currentChild != null)
			{				
				ISwitchable(child).autoSwitch = currentChild.autoSwitch;
				if (!currentChild.autoSwitch)
				{
					for (var itr:Number = 0; itr <= ISwitchable(child).maxIndex; itr++)
					{
						if (ISwitchable(child).getBitrateForIndex(itr) == getBitrateForIndex(currentIndex) ||
							itr == maxIndex)
						{																
							ISwitchable(child).switchTo(itr);	
							break;	
						}
						else if (ISwitchable(child).getBitrateForIndex(itr) > getBitrateForIndex(currentIndex))							
						{										
							ISwitchable(child).switchTo(Math.max(itr-1, 0));	
							break;	
						}				 
					}					
				}
				currentChild.removeEventListener(SwitchingChangeEvent.SWITCHING_CHANGE,  redispatchEvent);	
				currentChild.removeEventListener(TraitEvent.INDICES_CHANGE, redispatchEvent);		
										
			}	
										
			currentChild = ISwitchable(child);
			child.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE,  redispatchEvent);	
			child.addEventListener(TraitEvent.INDICES_CHANGE, redispatchEvent);					
		}
			
		/**
		 * @inheritDoc
		 */ 
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{				
			child.removeEventListener(SwitchingChangeEvent.SWITCHING_CHANGE,  redispatchEvent);	
			child.removeEventListener(TraitEvent.INDICES_CHANGE, redispatchEvent);	
		}	
		
		private function redispatchEvent(event:Event):void
		{
			dispatchEvent(event.clone());
		}
				
		private var currentChild:ISwitchable;
		
	}
}