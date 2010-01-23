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
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	[ExcludeClass]
	
	/**
	 * @private
	 */
	public class HTTPStreamingIndexHandlerEvent extends Event
	{
		public static const NOTIFY_INDEX_READY:String = "notifyIndexReady";
		public static const NOTIFY_RATES:String = "notifyRates";
		public static const NOTIFY_TOTAL_DURATION:String = "notifyTotalDuration";
		public static const REQUEST_LOAD_INDEX:String = "requestLoadIndex";
		public static const NOTIFY_ERROR:String = "notifyError";
		public static const NOTIFY_ADDITIONAL_HEADER:String = "notifyAdditionalHeader";

		public function HTTPStreamingIndexHandlerEvent(
			type:String, 
			bubbles:Boolean=false, 
			cancelable:Boolean=false, 
			rates:Array = null, 
			totalDuration:Number = 0,
			request:URLRequest = null, 
			binaryData:Boolean = true,
			additionalHeader:ByteArray = null)
		{
			super(type, bubbles, cancelable);
			
			_rates = rates;
			_totalDuration = totalDuration;
			_request = request;
			_binaryData = binaryData;
			_additionalHeader = additionalHeader;
		}
		
		public function get rates():Array
		{
			return _rates;
		}

		public function get totalDuration():Number
		{
			return _totalDuration;
		}

		public function get request():URLRequest
		{
			return _request;
		}
		
		public function get binaryData():Boolean
		{
			return _binaryData;
		}
		
		public function get additionalHeader():ByteArray
		{
			return _additionalHeader;
		}

		override public function clone():Event
		{
			return new HTTPStreamingIndexHandlerEvent
				( type
				, bubbles
				, cancelable
				, rates
				, totalDuration
				, request
				, binaryData
				, additionalHeader
				);
		}
		
		// Internal
		//
		
		private var _rates:Array;
		private var _totalDuration:Number;
		private var _request:URLRequest;
		private var _binaryData:Boolean;
		private var _additionalHeader:ByteArray;	
	}
}