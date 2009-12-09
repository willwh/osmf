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
*  Contributor(s): Adobe Systems Incorporated.
* 
*****************************************************/

package org.osmf.traits
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.events.SwitchEvent;
	import org.osmf.net.dynamicstreaming.SwitchingDetail;
	import org.osmf.net.dynamicstreaming.SwitchingDetailCodes;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * Dispatched when a stream switch is requested, completed, or failed.
	 * 
	 * @eventType org.osmf.events.SwitchEvent.SWITCHING_CHANGE
	 */
	[Event(name="switchingChange",type="org.osmf.events.SwitchEvent")]
	
	/**
	 * Dispatched when the number of indices or associated bitrates have changed.
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
	 * The SwitchableTrait class provides a base ISwitchable implementation.
	 * It can be used as the base class for a more specific Switchable trait
	 * subclass.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	public class SwitchableTrait extends MediaTraitBase implements ISwitchable
	{
		/**
		 * Creates a new SwitchableTrait with the ability to switch to.  The
		 * maxIndex is initially set to numIndices - 1.
		 * @param autoSwitch the initial autoSwitch state for the trait.
		 * @param currentIndex the start index for the swichable trait.
		 * @param numIndices the maximum value allow to be set on maxIndex 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function SwitchableTrait(autoSwitch:Boolean=true, currentIndex:int=0, numIndices:int=1)
		{
			super();
			
			_autoSwitch = autoSwitch;
			_currentIndex = currentIndex;		
			this.numIndices = numIndices;
		}
		
		/**
		 * The number of indices this trait can switch between.
		 **/
		public function get numIndices():int
		{
			return _numIndices;
		}
		
		public function set numIndices(value:int):void
		{
			if (value != _numIndices)
			{
				_numIndices = value;
				maxIndex = _numIndices - 1;
				
				dispatchEvent(new SwitchEvent(SwitchEvent.INDICES_CHANGE));
			}			
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
			return _autoSwitch;
		}
		
		/**
		 * @inheritDoc
		 * This property defaults to true.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		public function set currentIndex(value:int):void
		{
			_currentIndex = value;
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
			if (index > (numIndices-1) || index < 0)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
			}
			return -1;
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get switchUnderway():Boolean
		{			
			return (switchState == SwitchEvent.SWITCHSTATE_REQUESTED);
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
			if (autoSwitch)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE));
			}
			else if (index != currentIndex)
			{
				if (canProcessSwitchTo(index))
				{
					var detail:SwitchingDetail = new SwitchingDetail(SwitchingDetailCodes.SWITCHING_MANUAL);
					
					processSwitchState(SwitchEvent.SWITCHSTATE_REQUESTED, detail);
					processSwitchTo(index);
					_currentIndex = index;
					postProcessSwitchTo(detail);
				}
			}			
		}
		
		/**
		 * Returns if this trait can change autoSwitch mode.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		protected function canProcessAutoSwitchChange(value:Boolean):Boolean
		{
			return true; 
		}
		
		/**
		 * Does the actual processing of changes to the autoSwitch property
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		protected function processAutoSwitchChange(value:Boolean):void
		{			
			// Auto-switching is processed here.
		}
				
		/**
		 * Returns if this trait can switch to the specified stream index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		protected function canProcessSwitchTo(index:int):Boolean
		{
			validateIndex(index);
			return true; 
		}
		
		/**
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		protected function validateIndex(index:int):void
		{
			if (index < 0 || index > maxIndex)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
			}
		}
		
		/**
		 * Does the actual switching of indices.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		protected function processSwitchTo(value:int):void
		{			
			// switchTo is processed here.
		}
		
		/**
		 * Fires the SwitchState complete event
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		protected function postProcessSwitchTo(detail:SwitchingDetail = null):void
		{
			processSwitchState(SwitchEvent.SWITCHSTATE_COMPLETE, detail);
		}
		
		/**
		 * Does the acutal switching of indices.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		protected function processSwitchState(newState:int, detail:SwitchingDetail = null):void
		{			
			var oldState:int = switchState;
			switchState = newState;
			dispatchEvent(new SwitchEvent(SwitchEvent.SWITCHING_CHANGE, false, false, newState, oldState, detail));
		}
		
		/**
		 * Returns if this trait can change the max index to specified value
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		protected function canProcessMaxIndexChange(value:int):Boolean
		{
			if (value < 0 || value >= numIndices)
			{				
				throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
			}
			
			return true;
		}
		
		/**
		 * Does the setting of the max index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		protected function processMaxIndexChange(value:int):void
		{			
			// MaxIndex is proccessed here.
		}
					
		/**
		 * Backing variable for autoSwitch
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 	
		private var _autoSwitch:Boolean;
		
		/**
		 * Backing variable for currentIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		private var _currentIndex:int = 0;
	
		/**
		 * Backing variable for maxIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		private var _maxIndex:int = 0;
		
		/**
		 * tracks the number of possible indices
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		private var _numIndices:int;
		
		/**
		 * Tracks the current switching state of this trait.  
		 * See SwitchEvent for all possible states.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		private var switchState:int = SwitchEvent.SWITCHSTATE_UNDEFINED;
	}
}
