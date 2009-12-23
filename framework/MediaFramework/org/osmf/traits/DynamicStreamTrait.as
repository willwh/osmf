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
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="indicesChange",type="org.osmf.events.SwitchEvent")]
	
	/**
	 * Dispatched when the autoSwitch property changed.
	 * 
	 * @eventType org.osmf.events.SwitchEvent.AUTOS_WITCH_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="autoSwitchChange",type="org.osmf.events.SwitchEvent")]
		
	/**
	 * DynamicStreamTrait defines the trait interface for media supporting dynamic stream
	 * switching.  It can also be used as the base class for a more specific DynamicStreamTrait
	 * subclass.
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.DYNAMIC_STREAM)</code> method to query
	 * whether a media element has a trait of this type.
	 * If <code>hasTrait(MediaTraitType.DYNAMIC_STREAM)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.DYNAMIC_STREAM)</code> method
	 * to get an object of this type.</p>
	 * <p>Through its MediaElement, a DynamicStreamTrait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * 
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class DynamicStreamTrait extends MediaTraitBase
	{
		/**
		 * Constructor.
		 * 
		 * The maxIndex is initially set to numIndices - 1.
		 * 
		 * @param autoSwitch the initial autoSwitch state for the trait.
		 * @param currentIndex the start index for the swichable trait.
		 * @param numIndices the maximum value allow to be set on maxIndex 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function DynamicStreamTrait(autoSwitch:Boolean=true, currentIndex:int=0, numIndices:int=1)
		{
			super(MediaTraitType.DYNAMIC_STREAM);
			
			_autoSwitch = autoSwitch;
			_currentIndex = currentIndex;		
			this.numIndices = numIndices;
		}
		
		/**
		 * Defines whether or not the trait should be in manual 
		 * or auto-switch mode. If in manual mode the <code>switchTo</code>
		 * method can be used to manually switch to a specific stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get autoSwitch():Boolean
		{			
			return _autoSwitch;
		}
		
		public function set autoSwitch(value:Boolean):void
		{
			if (autoSwitch != value)
			{
				processAutoSwitchChange(value);

				_autoSwitch = value;
				
				dispatchEvent(new SwitchEvent(SwitchEvent.AUTO_SWITCH_CHANGE));
				
				postProcessAutoSwitchChange();
			}
		}
		
		/**
		 * The index of the stream currently rendering. Uses a zero-based index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		/**
		 * Gets the associated bitrate, in kilobits per second for the specified index.
		 * 
		 * @throws RangeError If the specified index is less than zero or
		 * greater than the highest index available.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
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
		 * The maximum available index. This can be set at run-time to 
		 * provide a ceiling for your switching profile. For example,
		 * to keep from switching up to a higher quality stream when 
		 * the current video is too small to realize the added value
		 * of a higher quality stream.
		 * 
		 * @throws RangeError If the specified index is less than zero or
		 * greater than the highest index available.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get maxIndex():int
		{
			return _maxIndex;
		}
		
		public function set maxIndex(value:int):void
		{
			if (value < 0 || value > _numIndices-1)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
			}

			if (maxIndex != value)
			{
				processMaxIndexChange(value);

				_maxIndex = value;
				
				postProcessMaxIndexChange();
			}		
		}
		
		/**
		 * Indicates whether or not a switch is currently in progress.
		 * This property will return <code>true</code> while a switch has been 
		 * requested and the switch has not yet been acknowledged and no switch failure 
		 * has occurred.  Once the switch request has been acknowledged or a 
		 * failure occurs, the property will return <code>false</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get switchUnderway():Boolean
		{			
			return (switchState == SwitchEvent.SWITCHSTATE_REQUESTED);
		}
		
		/**
		 * Switch to a specific index. To switch up, use the <code>currentIndex</code>
		 * property, such as:<p>
		 * <code>
		 * obj.switchTo(obj.currentIndex + 1);
		 * </code>
		 * </p>
		 * @throws RangeError If the specified index is less than zero or
		 * greater than <code>maxIndex</code>.
		 * @throws IllegalOperationError If the stream is not in manual switch mode.
		 * 
		 * @see maxIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
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
				if (index < 0 || index > maxIndex)
				{
					throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
				}

				var detail:SwitchingDetail = new SwitchingDetail(SwitchingDetailCodes.SWITCHING_MANUAL);
				
				processSwitchState(SwitchEvent.SWITCHSTATE_REQUESTED, detail);
				processSwitchTo(index);
				
				_currentIndex = index;
				
				postProcessSwitchTo(detail);
			}			
		}
		
		// Internals
		//
		
		/**
		 * Sets the currentIndex property
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected final function setCurrentIndex(value:int):void
		{
			_currentIndex = value;
		}
		
		/**
		 * Does the actual processing of changes to the autoSwitch property
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		protected function processAutoSwitchChange(value:Boolean):void
		{			
		}
				
		/**
		 * Called after the change to the autoSwitch property
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		protected function postProcessAutoSwitchChange():void
		{			
		}
		
		/**
		 * Does the actual switching of indices.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		protected function processSwitchTo(value:int):void
		{			
		}
		
		/**
		 * Fires the SwitchState complete event
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		protected function postProcessSwitchTo(detail:SwitchingDetail=null):void
		{
			processSwitchState(SwitchEvent.SWITCHSTATE_COMPLETE, detail);
		}
		
		/**
		 * Does the acutal switching of indices.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		protected function processSwitchState(newState:int, detail:SwitchingDetail=null):void
		{			
			var oldState:int = switchState;
			switchState = newState;
			dispatchEvent(new SwitchEvent(SwitchEvent.SWITCHING_CHANGE, false, false, newState, oldState, detail));
		}
		
		/**
		 * Does the setting of the max index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		protected function processMaxIndexChange(value:int):void
		{			
		}
		
		/**
		 * Called after the change to the maxIndex property
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		protected function postProcessMaxIndexChange():void
		{			
		}

		/**
		 * The number of indices this trait can switch between.
		 **/
		private function get numIndices():int
		{
			return _numIndices;
		}
		
		private function set numIndices(value:int):void
		{
			if (value != _numIndices)
			{
				_numIndices = value;
				maxIndex = _numIndices - 1;
				
				dispatchEvent(new SwitchEvent(SwitchEvent.INDICES_CHANGE));
			}			
		}
		
		/**
		 * Backing variable for autoSwitch
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 	
		private var _autoSwitch:Boolean;
		
		/**
		 * Backing variable for currentIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		private var _currentIndex:int = 0;
	
		/**
		 * Backing variable for maxIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		private var _maxIndex:int = 0;
		
		/**
		 * tracks the number of possible indices
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		private var _numIndices:int;
		
		/**
		 * Tracks the current switching state of this trait.  
		 * See SwitchEvent for all possible states.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		private var switchState:int = SwitchEvent.SWITCHSTATE_UNDEFINED;
	}
}
