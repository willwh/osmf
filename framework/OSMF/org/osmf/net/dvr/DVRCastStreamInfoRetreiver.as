/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.net.dvr
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.Timer;
	
	[ExcludeClass]
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * @internal
	 */
	internal class DVRCastStreamInfoRetreiver extends EventDispatcher
	{
		// Public Interface
		//
		
		public function DVRCastStreamInfoRetreiver(connection:NetConnection, streamName:String)
		{
			super();
			
			this.connection = connection;
			this.streamName = streamName;
		}
		
		public function get streamInfo():Object
		{
			return _streamInfo;
		}
		
		public function get error():Object
		{
			return _error;
		}
		
		public function retreive(retries:int = 5, timeOut:Number = 3):void
		{
			if (!isNaN(this.retries))
			{
				// Ignore the request: a retreival attempt is
				// ongoing..
			}
			else
			{
				retries ||= 1;
				
				_streamInfo = null;
				_error = _error 
					= { message
							: "Maximum DVRGetStreamInfo RPC attempts ("
							+ retries
							+ "reached."
						};
				this.retries = retries;
				
				var timer:Timer = new Timer(timeOut * 1000, 1);
				
				getStreamInfo();
			}
		}
		
		// Internals
		//
		
		private var connection:NetConnection;
		private var streamName:String;
		private var retries:Number;
		private var timer:Timer;
		
		private var _streamInfo:Object;
		private var _error:Object;
		
		private function getStreamInfo():void
		{
			var responder:Responder = new Responder(onGetStreamInfoResult, onServerCallError);
			
			retries--;
			
			connection.call("DVRGetStreamInfo", responder, streamName);
		}

		private function onGetStreamInfoResult(result:Object):void
		{
			if (result && result.code == "NetStream.DVRStreamInfo.Success")
			{ 
				_streamInfo = result.data;
				complete();
			}
			else if (result && result.code == "NetStream.DVRStreamInfo.Retry")
			{
				if (retries != 0)
				{
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
					timer.start();
				}
				else
				{
					complete();	
				}
			}
			else
			{
				_error = { message: "Unexpected server response:" + result.code};
				complete();
			}
		}
		
		private function onServerCallError(error:Object):void
		{
			_error = error;
			complete();
		}
		
		private function onTimerComplete(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			getStreamInfo();
		}
		
		private function complete():void
		{
			retries = NaN;
			timer = null;
			dispatchEvent(new Event(Event.COMPLETE));
		}		
	}
}