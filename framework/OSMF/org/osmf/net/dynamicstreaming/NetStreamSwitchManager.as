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
package org.osmf.net.dynamicstreaming
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamPlayOptions;
	import flash.net.NetStreamPlayTransitions;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.osmf.net.NetClient;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.NetStreamUtils;
	import org.osmf.net.StreamType;
	import org.osmf.utils.OSMFStrings;
	
	CONFIG::LOGGING
	{
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;
	}
	
	/**
	 * Class which manages transitions between multi-bitrate (MBR) streams.
	 * 
	 * The NetStreamSwitchManager can work in manual or auto mode.  For the
	 * former, it will execute the NetStream call that performs the switch
	 * upon request.  For the latter, it will execute the switch based on
	 * a set of configurable switching rules.
	 * 
	 * A NetStreamSwitchManager doesn't dispatch any events indicating state
	 * changes.  The assumption is that a client will already be listening
	 * to events on the NetStream, so there's no need for duplicative events
	 * here.  
	 **/
	public class NetStreamSwitchManager extends EventDispatcher
	{
		/**
		 * Constructor.
		 * 
		 * @param connection The NetConnection for the NetStream that will be managed.
		 * @param netStream The NetStream to manage.
		 * @param dsResource The DynamicStreamingResource that is playing in the NetStream.
		 * @param switchingRules The switching rules that this manager will use.  This
		 * class will set its own MetricsProvider on each switching rule in the list.
		 **/
		public function NetStreamSwitchManager
			( connection:NetConnection
			, netStream:NetStream
			, dsResource:DynamicStreamingResource
			, switchingRules:Vector.<SwitchingRuleBase>)
		{
			this.connection = connection;
			this.netStream = netStream;
			this.dsResource = dsResource;
			this.switchingRules = switchingRules || new Vector.<SwitchingRuleBase>();

			_autoSwitch = true;
			_maxAllowedIndex = int.MAX_VALUE;
			metricsProvider = createMetricsProvider();
			
			for each (var switchingRule:SwitchingRuleBase in switchingRules)
			{
				switchingRule.metrics = metricsProvider;
			}
			
			startingBuffer = BUFFER_START;
			checkRulesTimer = new Timer(RULE_CHECK_INTERVAL);
			checkRulesTimer.addEventListener(TimerEvent.TIMER, checkRules);
									
			failedDSI = new Dictionary();
			
			isLive = dsResource.streamType == StreamType.LIVE; 

			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			NetClient(netStream.client).addHandler(NetStreamCodes.ON_PLAY_STATUS, onPlayStatus);
		}
		
		/**
		 * Indicates whether the switching manager should automatically
		 * switch between streams.
		 */
		public function get autoSwitch():Boolean
		{
			return _autoSwitch;
		}
		
		public function set autoSwitch(value:Boolean):void
		{
			debug("autoSwitch() - setting to " + value);
			
			_autoSwitch = value;
			if (_autoSwitch)
			{
				debug("autoSwitch() - starting check rules timer.");
				checkRulesTimer.start();
			}
			else
			{
				debug("autoSwitch() - stopping check rules timer.");
				checkRulesTimer.stop();
			}
		}
		
		/**
		 * Returns the current stream index that is rendering on the client. Note this may 
		 * differ from the last index requested if this property is queried after a switch
		 * has begun but before it has completed.
		 */
		public function get currentIndex():uint
		{
			return _currentIndex;
		}

		/**
		 * The highest stream index that the switching manager is
		 * allowed to switch to.
		 */
		public function get maxAllowedIndex():int 
		{
			var count:int = dsResource.streamItems.length - 1;
			return (count < _maxAllowedIndex ? count : _maxAllowedIndex);
		}
		
		public function set maxAllowedIndex(value:int):void
		{
			if (value > dsResource.streamItems.length)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
			}
			_maxAllowedIndex = value;
		}
		
		/**
		 * Initiate a switch to the stream with the given index.
		 **/
		public function switchTo(index:int):void
		{
			if (!autoSwitch)
			{
				if (index < 0 || index > maxAllowedIndex)
				{
					throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
				}
				else
				{
					debug("switchTo() - manually switching to index: " + index);
					
					var moreDetail:String = "manually switching to index: " + index;
					detail = new SwitchingDetail
								( index < currentIndex ? SwitchingDetailCodes.SWITCHING_DOWN_OTHER : SwitchingDetailCodes.SWITCHING_UP_OTHER
								, moreDetail
								);
					if (actualIndex == -1)
					{
						prepareForSwitching()
					}

					executeSwitch(index);
				}
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE));
			}
		}
		
		// Protected
		//
		
		protected function addSwitchingRule(rule:SwitchingRuleBase):void
		{
			switchingRules.push(rule);
		}

		/**
		 * Override this method to set your own interval for when to retry
		 * a failed stream.  The default is 30 seconds. This property returns
		 * a value in milliseconds.
		 * <p>
		 * When a switch down occurs, the stream being switched from has its
		 * failed count incremented. If, when the switching rules are evaluated
		 * again, a rule suggests switching up, since the stream previously
		 * failed, it won't be tried again until this period elapses. This
		 * provides a better user experience by preventing a situation where
		 * the switch up is attempted but then fails almost immediately.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function get failedItemWaitPeriod():int
		{
			return DEFAULT_WAIT_PERIOD_FOR_FAILED_STREAM_RETRY;
		}
		
		/**
		 * Override this method to specify the interval for when the stream
		 * item failed counts should be cleared. This property returns a value
		 * in milliseconds.
		 * <p>
		 * When a stream item reaches the maximum allowed failures a timer 
		 * is started and when this interval expires, all failed counts are 
		 * reset to zero. The default is 5 minutes.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function get clearFailedCountsInterval():int
		{
			return DEFAULT_CLEAR_FAILED_COUNTS_INTERVAL;
		}
		
		/**
		 * Override this method to specify the allowed number of failures 
		 * for stream items. Once a stream item reaches this number
		 * of failed attempts, there will be no more attempts to 
		 * switch to it until the <code>clearFailedCountsInterval</code> has
		 * expired. The default is 3.
		 * 
		 * @see #clearFailedCountsInterval
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function get allowedFailuresPerItem():int
		{
			return DEFAULT_ALLOWED_FAILS_PER_ITEM;
		}
				
		/**
		 * Override this method to provide custom logic to set the 
		 * maximum bandwidth for the client from client to server, 
		 * server to client, or both. Default behavior for this
		 * method is to set the bandwidth in both directions to 
		 * 140% of the highest bitrate level.
		 * 
		 * @param index The index of the stream which should be throttled. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function setThrottleLimits(index:int):void 
		{
			// We set the bandwidth in both directions to 140% of the bitrate level. 
			debug("setThrottleLimits() - Set rate limit to " + Math.round(dsResource.streamItems[index].bitrate*1.4) + " kbps");
			var rate:Number = dsResource.streamItems[index].bitrate * 1000/8;
			connection.call("setBandwidthLimit", null, rate * 1.40, rate * 1.40);
		}
		
		/**
		 * The MetricsProvider object which provides metrics to the switching rules.
		 * This class creates a MetricsProvider by default but it can be overridden
		 * by a subclass.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function createMetricsProvider():MetricsProvider
		{
			return new MetricsProvider(netStream);
		}
		
		// Internals
		//
		
		/**
		 * Executes the switch to the specified index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function executeSwitch(targetIndex:int):void 
		{
			var nso:NetStreamPlayOptions = new NetStreamPlayOptions();

			var playArgs:Object = NetStreamUtils.getPlayArgsForResource(dsResource);

			nso.start = playArgs.start;
			nso.len = playArgs.len;
			nso.streamName = dsResource.streamItems[targetIndex].streamName;
			nso.oldStreamName = oldStreamName;
			nso.transition = NetStreamPlayTransitions.SWITCH;
			
			debug("executeSwitch() - Switching to index " + (targetIndex) + " at " + Math.round(dsResource.streamItems[targetIndex].bitrate) + " kbps");
						
			switching = true;
		
			netStream.play2(nso);
			
			oldStreamName = dsResource.streamItems[targetIndex].streamName;
			
			if (targetIndex < actualIndex && autoSwitch) 
			{
				// This is a failure for the current stream, so let's tag it as such.
				incrementDSIFailedCount(actualIndex);
				
				// Keep track of when it failed so we don't try it again for 
				// another failedItemWaitPeriod milliseconds to improve the
				// user experience.
				failedDSI[actualIndex] = getTimer();
			}
		}

		/**
		 * Checks all the switching rules. If a switching rule returns -1, it is 
		 * recommending no change.  If a switching rule returns a number greater than
		 * -1 it is recommending a switch to that index. This method uses the lesser of 
		 * all the recommended indices that are greater than -1.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function checkRules(event:TimerEvent):void 
		{
			if (switchingRules == null || switching)
			{
				return;
			}
			
			var newIndex:int = int.MAX_VALUE;
			
			for (var i:int = 0; i < switchingRules.length; i++) 
			{
				var n:int =  switchingRules[i].getNewIndex();

				if (n != -1 && n < newIndex) 
				{
					newIndex = n;
					detail = switchingRules[i].detail;
				} 
			}
			
			if (	newIndex != -1
				&& 	newIndex != int.MAX_VALUE
				&&	newIndex != actualIndex
				&&	!switching
				&&	isDSIAvailable(newIndex)
				&&	newIndex <= maxAllowedIndex
			   ) 
			{
				debug("checkRules() - Calling for switch to " + newIndex + " at " + dsResource.streamItems[newIndex].bitrate + " kbps, detail: " + (detail != null ? detail.description + " " + detail.moreInfo : "none"));

				// If this stream has failed, we don't want to try it again until 
				// failedItemWaitPeriod has elapsed
				if (dsiFailedCounts[newIndex] >= 1)
				{
					var current:int = getTimer();
					if (current - failedDSI[newIndex] < failedItemWaitPeriod)
					{
						debug("executeSwitch() - ignoring switch request because index has " + dsiFailedCounts[newIndex]+" failure(s) and only "+ (current - failedDSI[newIndex])/1000 + " seconds have passed since the last failure.");
						return;
					}
				}
				
				executeSwitch(newIndex);
			}  
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			debug("onNetStatus() - event.info.code=" + event.info.code);
			
			switch (event.info.code) 
			{
				case NetStreamCodes.NETSTREAM_BUFFER_FULL:
					netStream.bufferTime = maxBufferLength;
					break;
				case NetStreamCodes.NETSTREAM_PLAY_START:
					prepareForSwitching();
					break;
				case NetStreamCodes.NETSTREAM_PLAY_TRANSITION:
					switching  = false;
					actualIndex = dsResource.indexFromName(event.info.details);
					metricsProvider.currentIndex = actualIndex;
					pendingTransitionsArray.push(actualIndex);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_FAILED:
					switching  = false;
					break;
				case NetStreamCodes.NETSTREAM_SEEK_NOTIFY:
					netStream.bufferTime = isLive ? maxBufferLength : startingBuffer;
					switching  = false;
					if (pendingTransitionsArray.length > 0) 
					{
						_currentIndex = pendingTransitionsArray[0];
						pendingTransitionsArray.shift();
					}			
					break;
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
					checkRulesTimer.stop();
					debug("onNetStatus() - Stopping rules since server has stopped sending data");
					break;
			}			
		}
				
		private function onPlayStatus(info:Object):void
		{
			debug("onPlayStatus() - info.code=" + info.code);
			
			switch (info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_TRANSITION_COMPLETE:
					_currentIndex = pendingTransitionsArray[0];
					
					debug("onPlayStatus() - Transition complete to index: " + currentIndex + " at " + Math.round(dsResource.streamItems[currentIndex].bitrate) + " kbps");
					pendingTransitionsArray.shift();

					detail = null;
					break;
			}
		}
		
		/**
		 * Prepare the manager for switching.  Note that this doesn't necessarily
		 * mean a switch is imminent.
		 **/
		private function prepareForSwitching():void
		{
			initDSIFailedCounts();
			
			maxBufferLength = isLive ? BUFFER_STABLE_LIVE : BUFFER_STABLE_ONDEMAND;
			metricsProvider.targetBufferTime = maxBufferLength;
			metricsProvider.enable();
			metricsProvider.optimizeForLiveBandwidthEstimate = isLive;
			
			debug("prepareForSwitching() - max buffer=" + maxBufferLength+", isLive=" + isLive);
			
			metricsProvider.dynamicStreamingResource = dsResource;
			
			netStream.bufferTime = isLive ? maxBufferLength : startingBuffer;
			actualIndex = 0;
			pendingTransitionsArray = new Array();
			
			if ((dsResource.initialIndex >= 0) && (dsResource.initialIndex < dsResource.streamItems.length))
			{
				actualIndex = dsResource.initialIndex;
			}

			if (autoSwitch)
			{
				checkRulesTimer.start();
			}
			
			setThrottleLimits(dsResource.streamItems.length - 1);
			debug("prepareForSwitching() - Starting with stream index " + actualIndex + " at " + Math.round(dsResource.streamItems[actualIndex].bitrate) + " kbps");
			metricsProvider.currentIndex = actualIndex;
		}
		
		private function initDSIFailedCounts():void
		{
			if (dsiFailedCounts != null)
			{
				dsiFailedCounts.length = 0;
				dsiFailedCounts = null;
			} 			
			
			dsiFailedCounts = new Vector.<int>();
			for (var i:int = 0; i < dsResource.streamItems.length; i++)
			{
				dsiFailedCounts.push(0);
			}
		}
		
		private function incrementDSIFailedCount(index:int):void
		{
			dsiFailedCounts[index]++;
			
			// Start the timer that clears the failed counts if one of them
			// just went over the max failed count
			if (dsiFailedCounts[index] > allowedFailuresPerItem)
			{
				if (clearFailedCountsTimer == null)
				{
					clearFailedCountsTimer = new Timer(clearFailedCountsInterval, 1);
					clearFailedCountsTimer.addEventListener(TimerEvent.TIMER, clearFailedCounts);
				}
				
				clearFailedCountsTimer.start();
			}
		}
		
		private function clearFailedCounts(event:TimerEvent):void
		{
			clearFailedCountsTimer.removeEventListener(TimerEvent.TIMER, clearFailedCounts);
			clearFailedCountsTimer = null;
			initDSIFailedCounts();
		}
		
		private function isDSIAvailable(index:int):Boolean
		{
			return (dsiFailedCounts[index] <= allowedFailuresPerItem);
		}

		/**
		 * If DEBUG is true, traces out debug messages.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function debug(...args):void
		{
			CONFIG::LOGGING
			{
				logger.debug(new Date().toTimeString() + ">>> NetStreamSwitchManager." + args);
			}
		}
				
		private var netStream:NetStream;
		private var dsResource:DynamicStreamingResource;
		private var switchingRules:Vector.<SwitchingRuleBase>;
		private var metricsProvider:MetricsProvider;
		private var checkRulesTimer:Timer;
		private var clearFailedCountsTimer:Timer;
		private var actualIndex:int = -1;
		private var oldStreamName:String;
		private var _autoSwitch:Boolean;
		private var switching:Boolean;
		private var _currentIndex:int;
		private var pendingTransitionsArray:Array;
		private var startingBuffer:Number;
		private var maxBufferLength:Number;
		private var isLive:Boolean;
		private var connection:NetConnection;
		private var detail:SwitchingDetail;
		private var _maxAllowedIndex:int;
		private var dsiFailedCounts:Vector.<int>;		// This vector keeps track of the number of failures 
														// for each DynamicStreamingItem in the DynamicStreamingResource
		private var failedDSI:Dictionary;
														
		private static const RULE_CHECK_INTERVAL:Number = 500;	// Switching rule check interval in milliseconds
		private static const BUFFER_STABLE_ONDEMAND:Number = 8;
		private static const BUFFER_STABLE_LIVE:Number = 10;
		private static const BUFFER_START:Number = 1;
		private static const DEFAULT_ALLOWED_FAILS_PER_ITEM:int = 3;
		private static const DEFAULT_WAIT_PERIOD_FOR_FAILED_STREAM_RETRY:int = 30000;
		private static const DEFAULT_CLEAR_FAILED_COUNTS_INTERVAL:Number = 300000;	// default of 5 minutes for clearing failed counts on stream items
		
		CONFIG::LOGGING
		{
			private static var logger:ILogger = Log.getLogger("org.osmf.net.dynamicstreaming.NetStreamSwitchManager");
		}
	}
}