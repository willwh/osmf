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
package org.osmf.events
{
	import flash.events.Event;

	/*
	 * This event is dispatched by the MediaPlayer class when the value of 
	 * the property "bytesDownloaded" has changed, which indicates the progress of a download operation.
	 */
	public class BytesDownloadedChangeEvent extends Event
	{
		public static const BYTES_DOWNLOADED_CHANGE:String = "bytesDownloadedChange";

		/**
		 * Constructor
		 *
		 * @param oldValue The previous value of bytesDownloaded
		 * @param newValue The current value of bytesDownloaded
		 */
		public function BytesDownloadedChangeEvent
							( oldValue:Number
							, newValue:Number
							, bubbles:Boolean=false
							, cancelable:Boolean=false
							)
		{
			super(BYTES_DOWNLOADED_CHANGE, bubbles, cancelable);
			
			_oldValue = oldValue;
			_newValue = newValue;
		}
		
		/**
		 * The previous value of bytesDownloaded
		 */
		public function get oldValue():Number
		{
			return _oldValue;
		}
		
		/**
		 * The current value of bytesDownloaded
		 */
		public function get newValue():Number
		{
			return _newValue;
		}
		
		// Overrides
		//
		
		override public function clone():Event
		{
			return new BytesDownloadedChangeEvent(_oldValue, _newValue, bubbles, cancelable);
		}
		
		//
		// Internal
		//
		
		private var _oldValue:Number;
		private var _newValue:Number;
	}
}