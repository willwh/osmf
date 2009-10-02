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
	import flash.events.Event;
	
	import org.osmf.events.SwitchingChangeEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.traits.ISwitchable;
	import org.osmf.traits.MediaTraitType;

	/**
	 * Dispatched when a stream switch is requested, completed, or failed.
	 * 
	 * @eventType org.osmf.events.SwitchingChangeEvent.SWITCHING_CHANGE
	 */
	[Event(name="switchingChange",type="org.osmf.events.SwitchingChangeEvent")]
	
	/**
	 * Dispatched when the number of indicies or associated bitrates have changed.
	 * 
	 * @eventType org.osmf.events.TraitEvent.INDICES_CHANGE
	 */
	[Event(name="indicesChange",type="org.osmf.events.TraitEvent")]
	
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
			return switchable.autoSwitch;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set autoSwitch(value:Boolean):void
		{
			switchable.autoSwitch = value;;		
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get currentIndex():int
		{
			return switchable.currentIndex;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getBitrateForIndex(index:int):Number
		{
			return switchable.getBitrateForIndex(index);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get maxIndex():int
		{
			return switchable.maxIndex;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set maxIndex(value:int):void
		{			
			switchable.maxIndex = value;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get switchUnderway():Boolean
		{
			return switchable.switchUnderway;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function switchTo(index:int):void
		{	
			switchable.switchTo(index);		
		}	
		
		public function prepare():void
		{
			//nothing to do here, required for IReusable.
		}
		
		private function get switchable():ISwitchable
		{
			return traitAggregator.listenedChild.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable;
		}
		
		/**
		 * @inheritDoc
		 * Adds the child as the current listened child.  Sets the autoswitch, property to 
		 * carry over from the previous child.  If autoswitch is false, attempts to match the bitrate
		 * for the next media element.
		 */ 
		override protected function processAggregatedChild(child:IMediaTrait):void
		{		
			var switchable:ISwitchable = ISwitchable(child);
			if (currentChild != null)
			{				
				switchable.autoSwitch = currentChild.autoSwitch;
				if (!currentChild.autoSwitch)
				{
					for (var itr:Number = 0; itr <= ISwitchable(child).maxIndex; itr++)
					{
						if (switchable.getBitrateForIndex(itr) == getBitrateForIndex(currentIndex) ||
							itr == maxIndex)
						{																
							switchable.switchTo(itr);	
							break;	
						}
						else if (switchable.getBitrateForIndex(itr) > getBitrateForIndex(currentIndex))							
						{										
							switchable.switchTo(Math.max(itr-1, 0));	
							break;	
						}				 
					}					
				}
				currentChild.removeEventListener(SwitchingChangeEvent.SWITCHING_CHANGE,  redispatchEvent);	
				currentChild.removeEventListener(TraitEvent.INDICES_CHANGE, redispatchEvent);										
			}	
										
			currentChild = switchable;
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