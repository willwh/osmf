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

package org.osmf.net.dynamicstreaming
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamPlayOptions;
	import flash.net.NetStreamPlayTransitions;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.osmf.events.SwitchEvent;
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.net.NetClient;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.NetStreamUtils;
	import org.osmf.net.StreamType;
	import org.osmf.utils.MediaFrameworkStrings;
	
	/**
	 * Dispatched when a stream switch is requested, completed, or failed.
	 * 
	 * @eventType org.osmf.events.SwitchEvent
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	[Event(name="switchingChange",type="org.osmf.events.SwitchEvent")]
	
	/**
	 * DynamicNetStream extends NetStream to provide dynamic
	 * stream switching, the process of efficiently delivering 
	 * streaming video to users by dynamically switching among 
	 * different streams of varying quality and size during playback.
	 * <p>
	 * Note this class can also play a standard non-dynamic stream.
	 * </p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class DynamicNetStream extends NetStream
	{
		/**
		 * Constructor.
		 * 
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function DynamicNetStream(connection:NetConnection)
		{
			super(connection);
			
			_startingBuffer = BUFFER_START;
			_metricsProvider = new MetricsProvider(this);
			_checkRulesTimer = new Timer(RULE_CHECK_INTERVAL);
			_checkRulesTimer.addEventListener(TimerEvent.TIMER, checkRules);
									
			_useManualSwitchMode = false;
			addSwitchingRules();
			
			_nc = connection;
			_maxIndexAllowed = int.MAX_VALUE;
			
			_dsiLastLockTime = 0;
			_dsiLockLevel = int.MAX_VALUE;
			
			_failedDSI = new Dictionary();		
		}
		
		/**
		 * The stream resources to use for this netstream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function set resource(value:DynamicStreamingResource):void
		{
			_dsResource = value;
		}
	
		public function get resource():DynamicStreamingResource
		{
			return _dsResource;			
		}
		
		/**
		 * Plays either a standard non-dynamic stream or a dynamic stream.
		 * If the method does not receive a <code>DynamicStreamingResource</code>
		 * it assumes the caller is trying to play a regular stream and calls
		 * the <code>play</code> method on the base NetStream class.
		 * 
		 * @see DynamicStreamingResource
		 * @throws IllegalOperationError If args is <code>null</code>. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		override public function play(...args):void
		{
			if ((args == null) || (args.length == 0))
			{
				throw new IllegalOperationError(MediaFrameworkStrings.INVALID_PARAM);				
			}
			
			_dsResource = args[0] as DynamicStreamingResource;
			
			if (_dsResource == null)
			{
				super.play.apply(this, args);
			}
			else
			{				
								
				addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				NetClient(this.client).addHandler(NetStreamCodes.ON_PLAY_STATUS, onPlayStatus);
				
				initDSIFailedCounts();
				
				_isLive = (_dsResource.streamType == StreamType.LIVE); 
				
				_maxBufferLength = _isLive ? BUFFER_STABLE_LIVE : BUFFER_STABLE_ONDEMAND;
				_metricsProvider.targetBufferTime = _maxBufferLength;
				_metricsProvider.enable();
				_metricsProvider.optimizeForLivebandwidthEstimate = _isLive;
				
				debug("play() - max buffer="+_maxBufferLength+", isLive="+_isLive);
					
				_metricsProvider.dynamicStreamingResource = _dsResource;
				
				// Start playing the first stream			
				this.bufferTime = _isLive ? _maxBufferLength : _startingBuffer;
				_streamIndex = 0;
				_pendingTransitionsArray = new Array();
				
				if ((_dsResource.initialIndex >= 0) && (_dsResource.initialIndex < _dsResource.streamItems.length))
				{
					_streamIndex = _dsResource.initialIndex;
				}
	
				if (_streamIndex == 0)
				{
					_streamIndex = chooseDefaultInitialIndex();
				}
				
				makeFirstSwitch();
			}
		}
				
		/**
		 * @private
		 */
		override public function play2(param:NetStreamPlayOptions):void 
		{
			throw new IllegalOperationError("The play2() method is disabled for the DynamicNetStream class.");
		}		
		
		/**
		 * Override this method to provide your own switching rules. Switching
		 * rule classes must extend SwitchingRuleBase and take an 
		 * INetStreamMetrics object in the class constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function addSwitchingRules():void
		{
			addSwitchingRule(new SufficientBandwidthRule(_metricsProvider));
			addSwitchingRule(new InsufficientBandwidthRule(_metricsProvider));
			addSwitchingRule(new DroppedFramesRule(_metricsProvider));
			addSwitchingRule(new InsufficientBufferRule(_metricsProvider));
		}
		
		/**
		 * Override this method to set your own initial stream index.
		 * The default is zero.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function chooseDefaultInitialIndex():uint 
		{
			return 0;
		}
		
		/**
		 * Override this method to set your own interval for when to retry
		 * a failed stream.  The default is 30 seconds. This property returns
		 * a value in milliseconds.
		 * <p>
		 * When a switch down occurs, the stream being 
		 * switched from has it's failed count incremented. If, when the 
		 * switching rules are evaluated again, a rule suggests switching up,
		 * since the stream previously failed, it won't be tried again until
		 * this period elapses. This provides a better user experience by preventing
		 * a situation where the switch up is attempted but then fails almost 
		 * immediately.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
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
		 * reset to zero.The default is 5 minutes.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function get clearFailedCountsInterval():int
		{
			return DEFAULT_CLEAR_FAILED_COUNTS_INTERVAL;
		}
		
		/**
		 * Override this method to specify the allowed number of fails 
		 * for stream items. Once a stream item reaches this number
		 * of failed attempts, there will be no more attempts to 
		 * switch to it until the <code>clearFailedCountsInterval</code> has
		 * expired. The default is 3.
		 * 
		 * @see #clearFailedCountsInterval
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
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
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function setThrottleLimits(index:int):void 
		{
			// We set the bandwidth in both directions to 140% of the bitrate level. 
			debug("setThrottleLimits() - Set rate limit to " + Math.round(_dsResource.streamItems[index].bitrate*1.4) + " kbps");
			var rate:Number = _dsResource.streamItems[index].bitrate * 1000/8;
			_nc.call("setBandwidthLimit",null, rate * 1.40, rate * 1.40);
		}
		
		/**
		 * If DEBUG is true, traces out debug messages.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		private function debug(...args):void
		{
			CONFIG::LOGGING
			{
				if (_logger == null)
				{
					_logger = Log.getLogger("org.osmf.net.dynamicstreaming.DynamicNetStream");
				}
				_logger.debug(new Date().toTimeString() + ">>> DynamicNetStream."+args);
			}
		}
		
		/**
		 * Adds a switching rule to the collection of switching
		 * rules. Developers can override the default set of switching
		 * rules or add to them by overridding the <code>addSwitchingRules</code>
		 * method.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function addSwitchingRule(rule:ISwitchingRule):void
		{
			if (_switchingRules == null)
			{
				_switchingRules = new Vector.<ISwitchingRule>();			
			}
			_switchingRules.push(rule);
		}
				
		/**
		 * Begins playing the stream for the first time by initiating
		 * the first switch.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		private function makeFirstSwitch():void
		{
			if (!_useManualSwitchMode)
			{
				_checkRulesTimer.start();
			}
			
			setThrottleLimits(_dsResource.streamItems.length - 1);
			debug("makeFirstSwitch() - Starting with stream index " + _streamIndex + " at " + Math.round(_dsResource.streamItems[_streamIndex].bitrate) + " kbps");
			switchToIndex(_streamIndex, true);
			_metricsProvider.currentIndex = _streamIndex;
		}
		
		/**
		 * Switches to the specified index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function switchToIndex(targetIndex:uint, firstPlay:Boolean=false):void 
		{
			var nso:NetStreamPlayOptions = new NetStreamPlayOptions();

			var playArgs:Object = NetStreamUtils.getPlayArgsForResource(resource);

			nso.start = playArgs["start"];
			nso.len = playArgs["len"];
			nso.streamName = _dsResource.streamItems[targetIndex].streamName;
			nso.oldStreamName = _oldStreamName;
			nso.transition = firstPlay ? NetStreamPlayTransitions.RESET : NetStreamPlayTransitions.SWITCH;
			
			debug("switchToIndex() - Switching to index " + (targetIndex) + " at " + Math.round(_dsResource.streamItems[targetIndex].bitrate) + " kbps");
						
			_switchUnderway = true;	
			dispatchEvent(new SwitchEvent(SwitchEvent.SWITCHING_CHANGE, false, false, SwitchEvent.SWITCHSTATE_REQUESTED, SwitchEvent.SWITCHSTATE_UNDEFINED, _detail));
			
			this.playStream(nso);
			
			_oldStreamName = _dsResource.streamItems[targetIndex].streamName;
			
			if ((!firstPlay) && (targetIndex < _streamIndex) && (!_useManualSwitchMode)) 
			{
				// this is a failure for the current stream so lets tag it as such
				incrementDSIFailedCount(_streamIndex);
				
				// Keep track of when it failed so we don't try it again for 
				// another failedItemWaitPeriod milliseconds to improve the user experience
				_failedDSI[_streamIndex] = getTimer();
			}

			if (firstPlay) 
			{				
				this.client.onPlayStatus({code:NetStreamCodes.NETSTREAM_PLAY_TRANSITION})
				_switchUnderway  = false;
				_renderingIndex = targetIndex;
				_streamIndex = targetIndex;
				_pendingTransitionsArray.push(targetIndex);
				this.client.onPlayStatus({code:NetStreamCodes.NETSTREAM_PLAY_TRANSITION_COMPLETE})
			} 
		}
		
		/**
		 * Calls the base class implementation to play the stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function playStream(nso:NetStreamPlayOptions):void
		{
			super.play2(nso);
		}
		
		/**
		 * Checks all the switching rules. If a switching rule returns -1, it is 
		 * recommending no change.  If a switching rule returns a number greater than
		 * -1 it is recommending a switch to that index. This method uses the lesser of 
		 * all the recommended indices that are greater than -1.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		private function checkRules(e:TimerEvent):void 
		{
			if (_switchingRules == null || _switchUnderway)
			{
				return;
			}
			
			var newIndex:int = int.MAX_VALUE;
			
			for (var i:int = 0; i < _switchingRules.length; i++) 
			{
				var n:int =  _switchingRules[i].getNewIndex();

				if (n != -1 && n < newIndex) 
				{
					newIndex = n;
					_detail = _switchingRules[i].detail;
				} 
			}
			
			if ((newIndex != -1) && (newIndex != int.MAX_VALUE)  && (newIndex != _streamIndex) &&
					(!_switchUnderway) && isDSIAvailable(newIndex) && (newIndex <= this.maxIndex)) 
			{
				debug("checkRules() - Calling for switch to " + newIndex + " at " + _dsResource.streamItems[newIndex].bitrate + " kbps, detail: " + _detail.description + " " + _detail.moreInfo);

				// If this stream has failed, we don't want to try it again until 
				// failedItemWaitPeriod has elapsed
				if (_dsiFailedCounts[newIndex] >= 1)
				{
					var current:int = getTimer();
					if ((current - _failedDSI[newIndex]) < this.failedItemWaitPeriod)
					{
						debug("switchToIndex() - ignoring switch request because index has "+_dsiFailedCounts[newIndex]+" failure(s) and only "+ (current - _failedDSI[newIndex])/1000 + " seconds have passed since the last failure.");
						return;
					}
				}
				
				switchToIndex(newIndex);
			}  
		}
				
		private function onNetStatus(event:NetStatusEvent):void
		{
			debug("onNetStatus() - event.info.code="+event.info.code);
			
			switch (event.info.code) 
			{
				case NetStreamCodes.NETSTREAM_BUFFER_FULL:
					this.bufferTime = _maxBufferLength;
					break;
				case NetStreamCodes.NETSTREAM_PLAY_START:
					this.bufferTime = _isLive? _maxBufferLength : _startingBuffer;
					break;
				case NetStreamCodes.NETSTREAM_PLAY_TRANSITION:
					_switchUnderway  = false;
					_streamIndex = _dsResource.indexFromName(event.info.details);
					_metricsProvider.currentIndex = _streamIndex;
					_pendingTransitionsArray.push(_streamIndex);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_FAILED:
					_switchUnderway  = false;
					break;
				case NetStreamCodes.NETSTREAM_SEEK_NOTIFY:
					this.bufferTime = _isLive? _maxBufferLength:_startingBuffer;
					_switchUnderway  = false;
					if (_pendingTransitionsArray.length > 0) 
					{
						_renderingIndex  = _pendingTransitionsArray[0];
						_pendingTransitionsArray.shift();
					}			
					break;
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
					_checkRulesTimer.stop();
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
					_renderingIndex = _pendingTransitionsArray[0];
					
					debug("onPlayStatus() - Transition complete to index: " + _renderingIndex + " at " + Math.round(_dsResource.streamItems[_renderingIndex].bitrate) + " kbps");
					_pendingTransitionsArray.shift();
					dispatchEvent(new SwitchEvent(SwitchEvent.SWITCHING_CHANGE, false, false, SwitchEvent.SWITCHSTATE_COMPLETE, SwitchEvent.SWITCHSTATE_REQUESTED));
					_detail = null;
					break;
			}
		}
				
		private function initDSIFailedCounts():void
		{
			if (_dsiFailedCounts != null)
			{
				_dsiFailedCounts.length = 0;
				_dsiFailedCounts = null;
			} 			
			
			_dsiFailedCounts = new Vector.<uint>();
			for (var i:int = 0; i < _dsResource.streamItems.length; i++)
			{
				_dsiFailedCounts.push(0);
			}
		}
		
		private function incrementDSIFailedCount(index:uint):void
		{
			_dsiFailedCounts[index]++;
			
			// Start the timer that clears the failed counts if one of them
			// just went over the max failed count
			if (_dsiFailedCounts[index] > allowedFailuresPerItem)
			{
				if (_clearFailedCountsTimer == null)
				{
					_clearFailedCountsTimer = new Timer(clearFailedCountsInterval, 1);
					_clearFailedCountsTimer.addEventListener(TimerEvent.TIMER, clearFailedCounts);
				}
				
				_clearFailedCountsTimer.start();
			}
		}
		
		private function clearFailedCounts(event:TimerEvent):void
		{
			_clearFailedCountsTimer.removeEventListener(TimerEvent.TIMER, clearFailedCounts);
			initDSIFailedCounts();
		}
		
		private function isDSIAvailable(index:uint):Boolean
		{
			return (!isDSILocked(index) && (_dsiFailedCounts[index] <= allowedFailuresPerItem));
		}
		
		/**
		 * @private
		 */
		internal function get useManualSwitchMode():Boolean
		{
			return _useManualSwitchMode;
		}
		
		/**
		 * @private
		 */
		internal function set useManualSwitchMode(value:Boolean):void
		{
			debug("useManualSwitchMode() - setting to "+value);
			
			_useManualSwitchMode = value;
			if (_useManualSwitchMode)
			{
				debug("useManualSwitchMode() - stopping check rules timer.");
				_checkRulesTimer.stop();
			}
			else
			{
				debug("useManualSwitchMode() - starting check rules timer.");
				_checkRulesTimer.start();
			}
		}
		
		/**
		 * @private
		 */
		internal function get maxIndex():int 
		{
			if (_dsResource)
			{
				var count:int = _dsResource.streamItems.length - 1;
				return ((count < _maxIndexAllowed) ? count : _maxIndexAllowed);
			}
			return -1;
		}
		
		/**
		 * @private
		 */
		internal function set maxIndex(value:int):void
		{
			if (value > _dsResource.streamItems.length)
			{
				throw new RangeError(MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
			}
			_maxIndexAllowed = value;
		}
		
		/**
		 * Returns the current stream index that is rendering on the client. Note this may 
		 * differ from the last index requested if this property is called between the
		 * NetStream.Play.Transition and the NetStream.Play.TransitionComplete events.
		 * 
		 * @private
		 */
		internal function get renderingIndex():uint
		{
			return _renderingIndex;
		}

		/**
		 * @private
		 */
		internal function switchTo(index:int):void
		{
			if (_useManualSwitchMode)
			{
				if ((index < 0) || (index > maxIndex))
				{
					throw new RangeError(MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
				}
				else
				{
					debug("switchTo() - manually switching to index: " + index);
					
					var moreDetail:String = "manually switching to index: " + index;
					_detail = new SwitchingDetail((index < this._renderingIndex) ? SwitchingDetailCodes.SWITCHING_DOWN_OTHER : SwitchingDetailCodes.SWITCHING_UP_OTHER, 
													moreDetail);
					if(_streamIndex == -1)
					{
						_dsResource.initialIndex = index;
					}
					else
					{
						switchToIndex(index, false);
					}
					
				}
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE);
			}
		}
				
		/**
		 * Returns <code>true</code> if a switch has been requested but has
		 * not been accepted by the server (via a <code>NetStream.Play.Transition</code> 
		 * code in the NetStatusEvent handler.
		 * 
		 * @private
		 */
		internal function get switchUnderway():Boolean
		{
			return _switchUnderway;
		}
							
		protected function set switchUnderway(value:Boolean):void
		{
			_switchUnderway = value;
		}
		
		/**
		 * The object implementing the INetStreamMetrics interface which 
		 * provides metrics to the switching rules. This class
		 * creates a metrics class by default but it can be overridden by a class
		 * extending this class. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function get metricsProvider():INetStreamMetrics
		{
			return _metricsProvider;
		}
		
		protected function set metricsProvider(value:INetStreamMetrics):void
		{
			_metricsProvider = value;
		}
		 
		/**
		 * Sets the lock level at the provided index. Any item at this index or higher will be unavailable until the LOCK_INTERVAL
		 * has passed.
		 * 
		 * @private
		 */	
		internal function lockDSI(index:int):void 
		{
			_dsiLockLevel= index;
			_dsiLastLockTime = getTimer();
		}
							
		/**
		 * Returns true if this index level is currently locked.
		 * 
		 * @private
		 */	
		internal function isDSILocked(index:int):Boolean 
		{
			return (index >= _dsiLockLevel) && (getTimer() - _dsiLastLockTime) < DSI_LOCK_INTERVAL;
		}
				
		private var _checkRulesTimer:Timer;
		private var _clearFailedCountsTimer:Timer;
		private var _switchingRules:Vector.<ISwitchingRule>;
		private var _metricsProvider:INetStreamMetrics;
		private var _streamIndex:int = -1;
		private var _oldStreamName:String;
		private var _dsResource:DynamicStreamingResource;
		private var _useManualSwitchMode:Boolean;
		private var _switchUnderway:Boolean;
		private var _renderingIndex:int;
		private var _pendingTransitionsArray:Array;
		private var _switchingReason:String;
		private var _startingBuffer:Number;
		private var _maxBufferLength:uint;
		private var _isLive:Boolean;
		private var _nc:NetConnection;
		private var _detail:SwitchingDetail;
		private var _maxIndexAllowed:int;
		private var _dsiFailedCounts:Vector.<uint>;		// This vector keeps track of the number of failures 
														// for each DynamicStreamingItem in the DynamicStreamingResource
		private var _dsiLockLevel:Number;
		private var _dsiLastLockTime:Number;
		private var _failedDSI:Dictionary;
														
		private const DSI_LOCK_INTERVAL:Number = 30000;	// Index levels can be locked for 30 seconds
		private const RULE_CHECK_INTERVAL:Number = 500;	// Switching rule check interval in milliseconds
		private const BUFFER_STABLE_ONDEMAND:Number = 8;
		private const BUFFER_STABLE_LIVE:Number = 10;
		private const BUFFER_START:Number = 1;
		private const DEFAULT_ALLOWED_FAILS_PER_ITEM:int = 3;
		private const DEFAULT_WAIT_PERIOD_FOR_FAILED_STREAM_RETRY:int = 30000;
		private const DEFAULT_CLEAR_FAILED_COUNTS_INTERVAL:Number = 300000;	// default of 5 minutes for clearing failed counts on stream items
		
		CONFIG::LOGGING
		{
			private var _logger:ILogger;
		}
	}
}
