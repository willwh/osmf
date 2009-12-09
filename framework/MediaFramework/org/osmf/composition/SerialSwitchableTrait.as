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
	
	import org.osmf.events.SwitchEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.traits.ISwitchable;
	import org.osmf.traits.MediaTraitType;

	/**
	 * Dispatched when a stream switch is requested, completed, or failed.
	 * 
	 * @eventType org.osmf.events.SwitchEvent.SWITCHING_CHANGE
	 */
	[Event(name="switchingChange",type="org.osmf.events.SwitchEvent")]
	
	/**
	 * Dispatched when the number of indicies or associated bitrates have changed.
	 * 
	 * @eventType org.osmf.events.SwitchEvent.INDICES_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	[Event(name="indicesChange",type="org.osmf.events.SwitchEvent")]
	
	/**
	 * The Composite Serial switchable trait will aggregate switchable traits, acting as a single
	 * switchable trait.  This trait will match settinngs between child traits when switching between children.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */ 
	internal class SerialSwitchableTrait extends CompositeMediaTraitBase implements ISwitchable, IReusable
	{
		/**
		 * Constructs a Composite Serial switchable trait.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function SerialSwitchableTrait(traitAggregator:TraitAggregator)
		{
			super(MediaTraitType.SWITCHABLE, traitAggregator);
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 	
		public function get autoSwitch():Boolean
		{
			return switchable.autoSwitch;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function set autoSwitch(value:Boolean):void
		{
			switchable.autoSwitch = value;;		
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get currentIndex():int
		{
			return switchable.currentIndex;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function getBitrateForIndex(index:int):Number
		{
			return switchable.getBitrateForIndex(index);
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get maxIndex():int
		{
			return switchable.maxIndex;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function set maxIndex(value:int):void
		{			
			switchable.maxIndex = value;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get switchUnderway():Boolean
		{
			return switchable.switchUnderway;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function switchTo(index:int):void
		{	
			switchable.switchTo(index);		
		}	
		
		public function prepare():void
		{
			attach();
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
						if (switchable.getBitrateForIndex(itr) > getBitrateForIndex(currentIndex))							
						{														
							switchable.switchTo(Math.max(itr-1, 0));	
							break;	
						}	
						else if (switchable.getBitrateForIndex(itr) == getBitrateForIndex(currentIndex) ||
							itr == switchable.maxIndex)
						{																								
							switchable.switchTo(itr);	
							break;	
						}									 
					}					
				}
				currentChild.removeEventListener(SwitchEvent.SWITCHING_CHANGE,  redispatchEvent);	
				currentChild.removeEventListener(SwitchEvent.INDICES_CHANGE, redispatchEvent);										
			}	
										
			currentChild = switchable;
			child.addEventListener(SwitchEvent.SWITCHING_CHANGE,  redispatchEvent);	
			child.addEventListener(SwitchEvent.INDICES_CHANGE, redispatchEvent);					
		}
			
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{				
			child.removeEventListener(SwitchEvent.SWITCHING_CHANGE,  redispatchEvent);	
			child.removeEventListener(SwitchEvent.INDICES_CHANGE, redispatchEvent);	
		}
		
		private function redispatchEvent(event:Event):void
		{
			dispatchEvent(event.clone());
		}
				
		private var currentChild:ISwitchable;
		
	}
}