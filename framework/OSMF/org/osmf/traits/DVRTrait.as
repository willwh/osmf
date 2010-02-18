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

package org.osmf.traits
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.events.DVREvent;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * Dispatched when the object's snapToLive property changed. 
	 */	
	[Event(name="snapToLiveChange", type="org.osmf.events.DVREvent")]
	
	/**
	 * Dispatched when the object's stream information was updated.
	 */
	[Event(name="updated", type="org.osmf.events.DVREvent")]
	
	/**
	 * The DVRTrait object defines a set of methods and properties to operate
	 * on media that might be in the process of being recorded.
	 */	
	public class DVRTrait extends MediaTraitBase
	{
		/**
		 * Constructor
		 */		
		public function DVRTrait()
		{
			super(MediaTraitType.DVR);
		}
		
		/**
		 * Defines if the recording is currently available.
		 * 
		 * False by default. Subclasses that support an offline state must
		 * override this function.
		 */
		public function get offline():Boolean
		{
			return false;
		}
		
		/**
		 * Defines whether initial playback of the media is to start at the
		 * beginning of the recording, or at the end of the recording, in
		 * case recording is still in progress.
		 * 
		 * By default the property is set to false.
		 * 
		 * Dispatches a DVREvent.SNAP_TO_LIVE_CHANGE event.
		 * 
		 * @param value true if initial playback should start at the end of
		 * the recording, in case recording is ongoing.
		 */		
		final public function set snapToLive(value:Boolean):void
		{
			if (value != _snapToLive)
			{
				_snapToLive = value;
				dispatchEvent(new DVREvent(DVREvent.SNAP_TO_LIVE_CHANGE));
			}
		}
		final public function get snapToLive():Boolean
		{
			return _snapToLive;
		}
		
		/**
		 * Defines if the recording is ongoing.
		 * 
		 * It is mandatory for subclasses to provide an override for this
		 * method.
		 *  
		 * @return true if the recording is ongoing.
		 */		
		public function get isRecording():Boolean
		{
			throw new IllegalOperationError
				(OSMFStrings.getString(OSMFStrings.FUNCTION_MUST_BE_OVERRIDDEN));
		}
		
		/**
		 * Defines the start time of the recording.
		 * 
		 * Subclasses that can provide this information must override this
		 * method.
		 * 
		 * @return null by default;
		 */		
		public function get recordingStartTime():Date
		{
			return null;
		}
		
		/**
		 * Defines the start time of the recording.
		 * 
		 * Subclasses that can provide this information must override this
		 * method.
		 * 
		 * @return null by default;
		 */
		public function get recordingStopTime():Date
		{
			return null;
		}
		
		/**
		 * Defines the position to seek to in order to reach the end
		 * of the recording, which resembles the live position in case
		 * the recording is ongoing.
		 * 
		 * It is mandatory for subclasses to provide an override for this
		 * method.
		 */		
		public function get livePosition():Number
		{
			throw new IllegalOperationError
				(OSMFStrings.getString(OSMFStrings.FUNCTION_MUST_BE_OVERRIDDEN));
		}
		
		/**
		 * Defines at what interval the object will refetch stream
		 * information from the server. 
		 */		
		public function set updateInterval(value:Number):void
		{
			if (value != _updateInterval)
			{
				_updateInterval = value;
				processUpdateIntervalChange(value);
			}
		}
		public function get updateInterval():Number
		{
			return _updateInterval;
		}
		
		// Subclass methods
		//
		
		/**
		 * To be invoked by subclasses after the stream information  
		 * was updated.
		 */		
		final protected function updated():void
		{
			dispatchEvent(new DVREvent(DVREvent.UPDATED));
		}
		
		/**
		 * To be overridden by subclasses to process the update interval
		 * being changed.
		 * 
		 * @param interval the new updateInterval value.
		 */		
		protected function processUpdateIntervalChange(interval:Number):void
		{	
		}
		
		// Internals
		//
		
		private var _snapToLive:Boolean;
		private var _updateInterval:Number;
	}
}