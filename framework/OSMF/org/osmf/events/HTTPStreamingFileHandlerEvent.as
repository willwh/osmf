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

	[ExcludeClass]
	
	/**
	 * @private
	 */
	public class HTTPStreamingFileHandlerEvent extends Event
	{
		public static const NOTIFY_SEGMENT_DURATION:String = "notifySegmentDuration";
		public static const NOTIFY_TIME_BIAS:String = "notifyTimeBias";

		public function HTTPStreamingFileHandlerEvent(
			type:String, bubbles:Boolean=false, cancelable:Boolean=false, timeBias:Number=0, segmentDuration:Number=0)
		{
			super(type, bubbles, cancelable);
			
			_timeBias = timeBias;
			_segmentDuration = segmentDuration;
		}
		
		public function get timeBias():Number
		{
			return _timeBias;
		}

		public function get segmentDuration():Number
		{
			return _segmentDuration;
		}

		override public function clone():Event
		{
			return new HTTPStreamingFileHandlerEvent(type, bubbles, cancelable, timeBias, segmentDuration);
		}
		
		// Internal
		//
		
		private var _timeBias:Number;
		private var _segmentDuration:Number;
	}
}