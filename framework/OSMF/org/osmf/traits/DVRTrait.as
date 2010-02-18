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
	[Event(name="isRecordingChange", type="org.osmf.events.DVREvent")]
	
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
		 * Defines if the recording is ongoing.
		 * 
		 * It is mandatory for subclasses to provide an override for this
		 * method.
		 *  
		 * @return true if the recording is ongoing.
		 */		
		public final function get isRecording():Boolean
		{
			throw new IllegalOperationError
				(OSMFStrings.getString(OSMFStrings.FUNCTION_MUST_BE_OVERRIDDEN));
		}
		protected final function set isRecording(value:Boolean):void
		{
			if (value != _isRecording)
			{
				isRecordingChangeStart(value);
				
				_isRecording = value;
				
				isRecordingChangeEnd();
			}
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
		
		// Subclass stubs
		//
		
		/**
		 * Subclasses may override this method to do processing when the
		 * isRecording property is about to change.
		 * 
		 * @param value The value that isRecording is about to be set to.
		 */		
		protected function isRecordingChangeStart(value:Boolean):void
		{	
		}
		
		/**
		 * Subclasses may override this method to do processing when the
		 * isRecording property has just been changed.
		 * 
		 * <p>Subclasses that override should call this method 
		 * to dispatch the isRecordingChange event.</p> 
		 * 
		 * @param value The value that isRecording has been set to.
		 */
		protected function isRecordingChangeEnd():void
		{
			dispatchEvent(new DVREvent(DVREvent.IS_RECORDING_CHANGE));
		}
		
		// Internals
		//
		
		private var _isRecording:Boolean;
	}
}