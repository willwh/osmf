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
package org.openvideoplayer.netmocker
{
	import __AS3__.vec.Vector;
	
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStreamPlayOptions;
	import flash.utils.Timer;
	
	import org.openvideoplayer.net.NetStreamCodes;
	import org.openvideoplayer.net.dynamicstreaming.DynamicNetStream;

	public class MockDynamicNetStream extends DynamicNetStream implements IMockNetStream
	{
		public function MockDynamicNetStream(connection:NetConnection)
		{
			super(connection);
			_connection = connection;
			// Intercept all NetStatusEvents dispatched from the base class.
			eventInterceptor = new NetStatusEventInterceptor(this);
			
			playheadTimer = new Timer(TIMER_DELAY);
			playheadTimer.addEventListener(TimerEvent.TIMER, onPlayheadTimer);
		}
		
		/**
		 * @inheritDoc
		 **/
		public function set expectedDuration(value:Number):void
		{
			this._expectedDuration = value;
		}
		
		public function get expectedDuration():Number
		{
			return _expectedDuration;
		}

		/**
		 * @inheritDoc
		 **/
		public function set expectedWidth(value:Number):void
		{
			this._expectedWidth = value;
		}
		
		public function get expectedWidth():Number
		{
			return _expectedWidth;
		}

		/**
		 * @inheritDoc
		 **/
		public function set expectedHeight(value:Number):void
		{
			this._expectedHeight = value;
		}
		
		public function get expectedHeight():Number
		{
			return _expectedHeight;
		}
		
		/**
		 * @inheritDoc
		 **/
		public function set expectedEvents(value:Array):void
		{
			this._expectedEvents = value;
		}
		
		public function get expectedEvents():Array
		{
			return _expectedEvents;
		}

		// Overrides
		//
		
		override public function get bytesTotal():uint
		{
			return  _connection.uri != "null" ? 0 : 100;  //We need more than zero, if this is progressive, so the Temporal and Playable trait can detect this situation.
		}
		
		
		override public function get time():Number
		{
			// Return value is in seconds.
			return playing
						? (elapsedTime + (flash.utils.getTimer() - absoluteTimeAtLastPlay))/1000
						: elapsedTime;
		}
		
		override public function close():void
		{
			playing = false;
			elapsedTime = 0;

			playheadTimer.stop();
		}

		override protected function switchToIndex(targetIndex:uint, firstPlay:Boolean=false):void
		{
			if (firstPlay)
			{
				handleFirstPlay();
			}
			else
			{				
				trace(new Date().toTimeString() + " -Creating new timer for switch complete");
				var newTimer:Timer = new Timer(350, 1);
				switchCompleteTimers.push(newTimer);
				newTimer.addEventListener(TimerEvent.TIMER_COMPLETE, sendSwitchCompleteMsg);
				newTimer.start();				
			}
			
			super.switchToIndex(targetIndex, firstPlay);
		}

		override protected function playStream(nso:NetStreamPlayOptions):void
		{	
			var infos:Array = [ {"code":NetStreamCodes.NETSTREAM_PLAY_TRANSITION, "details":nso.streamName, "level":LEVEL_STATUS} ];
			eventInterceptor.dispatchNetStatusEvents(infos, EVENT_DELAY);
		}
		
		override protected function get clearFailedCountsInterval():int
		{
			var desired:int = 1000;
			var base:int = super.clearFailedCountsInterval;
			return (base < desired) ? base : desired;
		}
		
		override protected function get allowedFailuresPerItem():int
		{
			var desired:int = 0;
			var base:int = super.allowedFailuresPerItem;
			return (base < desired) ? base : desired;
		}
		
		override protected function get failedItemWaitPeriod():int
		{
			var desired:int = 1000;
			var base:int = super.failedItemWaitPeriod;
			return (base < desired) ? base : desired;
		}
		
		private function sendSwitchCompleteMsg(e:TimerEvent):void
		{
			trace('sendSwitchCompleteMsg'  );
			switchUnderway = false;
			//dispatchEvent(new SwitchingChangeEvent(SwitchingChangeEvent.SWITCHSTATE_COMPLETE));
			var oldtimer:Timer = switchCompleteTimers.shift();
			oldtimer.removeEventListener(TimerEvent.TIMER, sendSwitchCompleteMsg);
			
			this.client.onPlayStatus({code:NetStreamCodes.NETSTREAM_PLAY_TRANSITION_COMPLETE});
			this.client.onPlayStatus({code:"Anything"});
		}		
		
		private function handleFirstPlay():void
		{
			if (expectedDuration > 0)
			{
				var info:Object = {};
				if (expectedDuration > 0)
				{
					info["duration"] = expectedDuration;
				}
				if (expectedWidth > 0)
				{
					info["width"] = expectedWidth;
				}
				if (expectedHeight > 0)
				{
					info["height"] = expectedHeight;
				}
				
				try
				{
					client.onMetaData(info);
				}
				catch (e:ReferenceError)
				{
					// Swallow, there's no such property on the client
					// and that's OK.
				}
			}
			// The flash player sets the bufferTime to a 0.1 minimum for VOD (http://).
			if (arguments != null && arguments.length > 0 && arguments[0].toString().substr(0,4) == "http")
			{
				bufferTime = bufferTime < .1 ? .1 : bufferTime; 
			}
			
			
			absoluteTimeAtLastPlay = flash.utils.getTimer();
			playing = true;
			
			playheadTimer.start();

			var infos:Array =
					[ {"code":NetStreamCodes.NETSTREAM_PLAY_RESET, 	"level":LEVEL_STATUS}
					, {"code":NetStreamCodes.NETSTREAM_PLAY_START, 	"level":LEVEL_STATUS}
					, {"code":NetStreamCodes.NETSTREAM_BUFFER_FULL,	"level":LEVEL_STATUS}
					];
			eventInterceptor.dispatchNetStatusEvents(infos, 2*EVENT_DELAY);
		}
		
		private function onPlayheadTimer(event:TimerEvent):void
		{
			var infos:Array;
			if (time >= expectedDuration)
			{
				elapsedTime = expectedDuration;
				playing = false;
				
				playheadTimer.stop();
				
				infos =
					[ {"code":NetStreamCodes.NETSTREAM_PLAY_STOP, 		"level":LEVEL_STATUS}
					, {"code":NetStreamCodes.NETSTREAM_BUFFER_FLUSH,	"level":LEVEL_STATUS}
					, {"code":NetStreamCodes.NETSTREAM_BUFFER_EMPTY,	"level":LEVEL_STATUS}
					];
				eventInterceptor.dispatchNetStatusEvents(infos);
			}
			else
			{
				infos = getInfosForPosition(time);
				if (infos.length > 0)
				{
					eventInterceptor.dispatchNetStatusEvents(infos);
				}
			}
		}
		
		private function getInfosForPosition(position:Number):Array
		{
			var infos:Array = [];
			
			for (var i:int = _expectedEvents.length; i > 0; i--)
			{
				var eventInfo:EventInfo = _expectedEvents[i-1];
				
				if (position >= eventInfo.position)
				{
					infos.push( {"code":eventInfo.code, "level":eventInfo.level} );
					
					// Remove the eventInfo, we don't want to dispatch
					// it twice.
					_expectedEvents.splice(i-1, 1);
				}
			}
			
			return infos;
		}

		
		private var _connection:NetConnection;
		private var eventInterceptor:NetStatusEventInterceptor;
		private var _expectedDuration:Number = 0;
		private var _expectedWidth:Number = 0;
		private var _expectedHeight:Number = 0;
		private var _expectedEvents:Array = [];
		
		private var playheadTimer:Timer;
		private var switchCompleteTimers:Vector.<Timer> = new Vector.<Timer>;
				
		private var playing:Boolean = false;
		private var elapsedTime:Number = 0; // seconds

		private var absoluteTimeAtLastPlay:Number = 0; // milliseconds
		
		private static const TIMER_DELAY:int = 100;
		
		private static const EVENT_DELAY:int = 100;
		
		private static const LEVEL_STATUS:String = "status";
		private static const LEVEL_ERROR:String = "error";
		
	}
}
