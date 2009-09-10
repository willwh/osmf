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
	import org.openvideoplayer.events.SwitchingChangeEvent;
	
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
		public function SwitchableTrait()
		{
			super();			
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
			if (_autoSwitch != value)
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
			if (_maxIndex != value)
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
			return false;
		}
				
		public function switchTo(index:int):void
		{
			if (index != _currentIndex)
			{
				if (canProcessSwitchTo(index))
				{
					_currentIndex = index;
					processSwitchTo(index);
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
		protected function canProcessSwitchTo(value:int):Boolean
		{
			return true; 
		}
		
		/**
		 * Does the acutal switching of indices.
		 */ 
		protected function processSwitchTo(value:int):void
		{			
			// switchTo is proccessed here
		}
		
		/**
		 * Returns if this trait can change the max index to specified value
		 */ 
		protected function canProcessMaxIndexChange(value:int):Boolean
		{
			return true; 
		}
		
		/**
		 * Does the setting of the max index.
		 */ 
		protected function processMaxIndexChange(value:int):void
		{			
			// MaxIndex is proccessed here
		}
			
		private var _autoSwitch:Boolean = false;
		private var _currentIndex:int = 0;
		private var _maxIndex:int = 0;
		
	}
}
