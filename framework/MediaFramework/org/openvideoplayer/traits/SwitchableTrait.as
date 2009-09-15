/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/

package org.openvideoplayer.traits
{
	import flash.errors.IllegalOperationError;
	
	import org.openvideoplayer.events.SwitchingChangeEvent;
	import org.openvideoplayer.net.dynamicstreaming.SwitchingDetail;
	import org.openvideoplayer.net.dynamicstreaming.SwitchingDetailCodes;
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
	 * The SwitchableTrait class provides a base ISwitchable implementation.
	 * It can be used as the base class for a more specific Switchable trait
	 * subclass.
	 */	
	public class SwitchableTrait extends MediaTraitBase implements ISwitchable
	{
		/**
		 * Creates a new SwitchableTrait with the ability to switch to 
		 */ 
		public function SwitchableTrait(numIndices:int)
		{
			super();			
			this.numIndices = numIndices;
			maxIndex = numIndices - 1;			
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
		 * This property defaults to true.
		 */
		public function set autoSwitch(value:Boolean):void
		{
			if (autoSwitch != value)
			{
				if (canProcessAutoSwitchChange(value))
				{
					_autoSwitch = value;
					processAutoSwitchChange(value);
				}
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
			if (index > (numIndices-1) || index < 0)
			{
				throw new RangeError(MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
			}
			return -1;
		}
			
		/**
		 * @inheritDoc
		 */	
		public function get maxIndex():int
		{
			return _maxIndex;
		}
		
		public function set maxIndex(value:int):void
		{
			if (maxIndex != value)
			{
				if (canProcessMaxIndexChange(value))
				{
					processMaxIndexChange(value);
					_maxIndex = value;
				}
			}		
		}
		
		/**
		 * @inheritDoc
		 */
		public function get switchUnderway():Boolean
		{			
			return (switchState == SwitchingChangeEvent.SWITCHSTATE_REQUESTED);
		}
		
		/**
		 * @inheritDoc
		 */ 		
		public function switchTo(index:int):void
		{
			if (index != currentIndex)
			{
				if(autoSwitch)
				{
					throw new IllegalOperationError(MediaFrameworkStrings.STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE);
				}
				else if (canProcessSwitchTo(index))
				{					
					if (!switchUnderway)
					{
						switchState = SwitchingChangeEvent.SWITCHSTATE_REQUESTED;
						dispatchEvent(new SwitchingChangeEvent(SwitchingChangeEvent.SWITCHSTATE_REQUESTED, switchState, new SwitchingDetail(SwitchingDetailCodes.SWITCHING_MANUAL)));
					}					
					_currentIndex = index;
					processSwitchTo(index);
					postProcessSwitchTo();
				}
			}			
		}
		
		/**
		 * Returns if this trait can change autoSwitch mode.
		 */ 
		protected function canProcessAutoSwitchChange(value:Boolean):Boolean
		{
			return true; 
		}
		
		/**
		 * Does the acutal processing of changes to the autoSwitch property
		 */ 
		protected function processAutoSwitchChange(value:Boolean):void
		{			
			// autoswitching is proccessed here
		}
				
		/**
		 * Returns if this trait can switch to the specified stream index.
		 */ 
		protected function canProcessSwitchTo(index:int):Boolean
		{
			if (index <= maxIndex && index >= 0)
			{
				return true; 
			}
			throw new RangeError(MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
			return false;
		
		}
		
		/**
		 * Does the acutal switching of indices.
		 */ 
		protected function processSwitchTo(value:int):void
		{			
			// switchTo is proccessed here
		}
		
		/**
		 * Fires the SwitchState complete event
		 */ 
		protected function postProcessSwitchTo():void
		{
			processSwitchState(SwitchingChangeEvent.SWITCHSTATE_COMPLETE, null);
		}
		
		/**
		 * Does the acutal switching of indices.
		 */ 
		protected function processSwitchState(newState:int, detail:SwitchingDetail = null):void
		{			
			var oldState:int = switchState;
			switchState = newState;
			dispatchEvent(new SwitchingChangeEvent(newState, oldState, detail));
		}
		
		/**
		 * Returns if this trait can change the max index to specified value
		 */ 
		protected function canProcessMaxIndexChange(value:int):Boolean
		{
			if (value < numIndices && value >= 0)
			{				
				return true;
			}
			throw new RangeError(MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
			return false;
		}
		
		/**
		 * Does the setting of the max index.
		 */ 
		protected function processMaxIndexChange(value:int):void
		{			
			// MaxIndex is proccessed here
		}
					
		/**
		 * Backing variable for autoSwitch
		 */ 	
		protected var _autoSwitch:Boolean = true;
		
		/**
		 * Backing variable for currentIndex
		 */ 
		protected var _currentIndex:int = 0;
	
		/**
		 * Backing variable for maxIndex
		 */ 
		protected var _maxIndex:int = 0;
		
		/**
		 * tracks the number of possible indices
		 */ 
		protected var numIndices:int;
		
		/**
		 * Tracks the current switching state of this trait.  
		 * See SwitchingChangeEvent for all possible states.
		 */ 
		protected var switchState:int = SwitchingChangeEvent.SWITCHSTATE_UNDEFINED;
	}
}
