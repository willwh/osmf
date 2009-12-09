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

package com.akamai.osmf.net
{
	import com.akamai.osmf.events.*;
	
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.net.NetClient;
	import org.osmf.traits.LoadTrait;

	/**
	 * The AkamaiNetStream class extends NetStream to provide
	 * Akamai CDN-specific streaming behavior such as stream-level
	 * auth tokens.
	 */
	public class AkamaiNetStream extends NetStream
	{
		/**
		 * Constructor.
		 * 
		 * @param connection The NetConnection object the stream will use.
 		 * @param loadable the ILoadable instance requesting this NetStream. Custom media 
 		 * errors are dispatched on this object.
 		 */
		public function AkamaiNetStream(connection:NetConnection, loadTrait:LoadTrait)
		{
			super(connection);
			_nc = connection as AkamaiNetConnection;
			_liveStreamMasterTimeout = LIVE_STREAM_MASTER_TIMOUT;
			_loadTrait = loadTrait;	
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function play(...arguments):void
		{
			if ((_nc != null) && (_nc.isLive))
			{
				_pendingLiveStreamName = arguments[0];
				_successfullySubscribed = false;
				
				// Master live stream timeout
				_liveStreamTimer = new Timer(_liveStreamMasterTimeout, 1);
				_liveStreamTimer.addEventListener(TimerEvent.TIMER_COMPLETE, liveStreamTimeout);
				
				// Timeout when waiting for a response from FCSubscribe
				_liveFCSubscribeTimer = new Timer(LIVE_ONFCSUBSCRIBE_TIMEOUT,1);
				_liveFCSubscribeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, liveFCSubscribeTimeout);
				
				// Retry interval when calling fcsubscribe
				_liveStreamRetryTimer = new Timer(LIVE_RETRY_INTERVAL,1);
				_liveStreamRetryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, retrySubscription);
				
				// Add a callback for the FCSubscribe call
				(_nc.client as NetClient).addHandler("onFCSubscribe", this.onFCSubscribe);
				
				startLiveStream();
			}
			else
			{
				super.play.apply(this, arguments);
			}
		}
				
		/**
		 * Starts a live stream by reseting timers and
		 * making the FCSubscribe call.
		 */
		private function startLiveStream():void 
		{
			resetAllLiveTimers();
			_liveStreamTimer.start();
			fcsubscribe();
		}
		
		/**
		 * Makes the FCSubscribe call to the server and 
		 * starts the timeout timers.
		 */
		private function fcsubscribe():void 
		{
			_nc.call("FCSubscribe", null, _pendingLiveStreamName);
			_liveFCSubscribeTimer.reset();
			_liveFCSubscribeTimer.start();
		}		
		
		/**
		 * Handles the case of never being able to successfully start
		 * the live stream. This is the master timeout.
		 */
		private function liveStreamTimeout(e:TimerEvent):void 
		{
			resetAllLiveTimers();
			if (_loadTrait)
			{
				_loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new AkamaiMediaError(AkamaiMediaErrorCodes.LIVE_SUBSCRIBE_TIMEOUT)));
			}
		}
		
		/**
		 * Handles the case of the server never calling the FCSubscribe 
		 * callback function <code>onFCSubscribe</code>.
		 */
		private function liveFCSubscribeTimeout(e:TimerEvent):void 
		{
			resetAllLiveTimers();
			if (_loadTrait)
			{
				_loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new AkamaiMediaError(AkamaiMediaErrorCodes.LIVE_FCSUBSCRIBE_NO_RESPONSE)));
			}
		}
				
		/**
		 * Retries the FCSubscribe call on the server.
		 */
		private function retrySubscription(e:TimerEvent):void 
		{
			fcsubscribe();
		}
			
		/**
		 * Resets all timers.
		 */			
		private function resetAllLiveTimers():void 
		{
			_liveStreamTimer.reset();
			_liveStreamRetryTimer.reset();
			_liveFCSubscribeTimer.reset();
		}

		/**
		 * The callback function from the FCSubscribe call.
		 * These are the only two info.codes available.
		 */
		private function onFCSubscribe(info:Object):void 
		{			
			switch (info.code) {
				case "NetStream.Play.Start" :
					resetAllLiveTimers();
					_successfullySubscribed = true;
					super.play(_pendingLiveStreamName,-1);
					break;
				case "NetStream.Play.StreamNotFound" :
					_liveStreamRetryTimer.reset();
					_liveStreamRetryTimer.start();
					break;
			} 			
		}
			
		private var _nc:AkamaiNetConnection;
		private var _pendingLiveStreamName:String;
		private var _successfullySubscribed:Boolean;		
		private var _liveStreamTimer:Timer;
		private var _liveStreamRetryTimer:Timer;
		private var _liveFCSubscribeTimer:Timer;		
		private var _liveStreamMasterTimeout:uint;
		private var _loadTrait:LoadTrait;
			
		private const LIVE_RETRY_INTERVAL:Number = 30000;	// 30 seconds
		private const LIVE_ONFCSUBSCRIBE_TIMEOUT:Number = 300000;	// 5 minutes
		private const LIVE_STREAM_MASTER_TIMOUT:Number = 3600000;	// 1 hour
	}
}
