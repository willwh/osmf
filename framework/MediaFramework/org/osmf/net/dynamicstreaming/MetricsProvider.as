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
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.net.NetStreamInfo;
	import flash.utils.Timer;
	
	import org.osmf.net.NetStreamCodes;
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;
		
	/**
	 * The purpose of the MetricsProvider class is to provide run-time metrics to the switching rules. It 
	 * makes use of the metrics offered by netstream.info, but more importantly it calculates running averages, which we feel
	 * are more robust metrics on which to make switching decisions. It's goal is to be the one-stop shop for all the info you
	 * need about the health of the stream.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class MetricsProvider extends EventDispatcher implements INetStreamMetrics
	{		
		/**
		 * Constructor
		 * 
		 * Note that for correct operation of this class, the caller must set the dynamicStreamingResource which
		 * the monitored stream is playing.
		 * 
		 * @param ns The NetStream instance the class will monitor.
		 * @see #dynamicStreamingResource
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function MetricsProvider(ns:NetStream)
		{
			super(null);
			_frameDropRate = 0;
			_reachedTargetBufferFull = false;
			_lastFrameDropCounter = 0;
			_lastFrameDropValue = 0;
			_maxFrameRate = 0;
			_optimizeForLivebandwidthEstimate = false;
			_avgMaxBitrateArray = new Array();
			_avgDroppedFrameRateArray = new Array();
			_enabled = true;
			_targetBufferTime = 0;
			
			_ns = ns;
			_ns.addEventListener(NetStatusEvent.NET_STATUS,netStatus);

			_timer = new Timer(DEFAULT_UPDATE_INTERVAL);
			_timer.addEventListener(TimerEvent.TIMER, update);
		}
		
		/**
		 * The update interval at which metrics and averages are recalculated
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get updateInterval():Number 
		{
			return _timer.delay
		}
		
		public function set updateInterval(intervalInMilliseconds:Number):void 
		{
			_timer.delay = intervalInMilliseconds;
		}
		
		/**
		 * The NetStream object supplied to the constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get netStream():NetStream
		{
			return _ns;
		}
				
		/**
		 * The current stream item index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		public function set currentIndex(i:int):void 
		{
			_currentIndex = i;
		}
		
		/**
		 * Returns the maximum index value 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get maxIndex():int 
		{
			return _dsResource.streamItems.length - 1;
		}
		
		/**
		 * Returns the DynamicStreamingResource which the class is referencing
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get dynamicStreamingResource():DynamicStreamingResource
		{
			return _dsResource;
		}
		
		public function set dynamicStreamingResource(dsr:DynamicStreamingResource):void 
		{
			_dsResource = dsr;
		}
		
		/**
		 * Returns true if the target buffer has been reached by the stream
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get reachedTargetBufferFull():Boolean
		{
			return _reachedTargetBufferFull;
		}
		
		/**
		 * Returns the current bufferlength of the NetStream
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get bufferLength():Number
		{
			return _ns.bufferLength;
		}
		
		/**
		 * Returns the current bufferTime of the NetStream
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get bufferTime():Number
		{
			return _ns.bufferTime;
		}
		
		/**
		 * Returns the target buffer time for the stream. This target is the buffer level at which the 
		 * stream is considered stable. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get targetBufferTime():Number
		{
			return _targetBufferTime;
		}
		
		public function set targetBufferTime(targetBufferTime:Number):void 
		{
			_targetBufferTime = targetBufferTime;
		}
		
		
		/**
		 * Flash player can have problems attempting to accurately estimate max bytes available with live streams. The server will buffer the 
		 * content and then dump it quickly to the client. The client sees this as an oscillating series of maxBytesPerSecond measurements, where
		 * the peak roughly corresponds to the true estimate of max bandwidth available. Setting this parameter to true will cause this class
		 * to optimize its estimate for averageMaxBandwidth. It should only be set true for live streams and should always be false for on demand streams. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get optimizeForLivebandwidthEstimate ():Boolean
		{
			return _optimizeForLivebandwidthEstimate 
		}
		
		public function set optimizeForLivebandwidthEstimate (optimizeForLivebandwidthEstimate :Boolean):void 
		{
			_optimizeForLivebandwidthEstimate  = optimizeForLivebandwidthEstimate ;
		}
		
		/**
		 * Returns the expected frame rate for this NetStream. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get expectedFPS():Number
		{
			return _maxFrameRate;
		}
		
		/**
		 * Returns the frame drop rate calculated over the last interval.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get droppedFPS():Number
		{
			return _frameDropRate;
		}
		
		/**
		 * Returns the average frame-drop rate
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get averageDroppedFPS():Number
		{
			return _avgDroppedFrameRate
		}
		
		
		/**
		 * Returns the last maximum bandwidth measurement, in kbps
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get maxBandwidth():Number
		{
			return _lastMaxBitrate;
		}
		
		/**
		 * Returns the average max bandwidth value, in kbps
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get averageMaxBandwidth():Number
		{
			return _avgMaxBitrate;
		}
		
		/**
		 * Returns a reference to the info property of the monitored NetStream
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get info():NetStreamInfo 
		{
			return _ns.info;
		}
		
		/**
		 * Enables this metrics engine.  The background processes will only resume on the next
		 * netStream.Play.Start event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function enable(): void 
		{
			_enabled = true;
		}
		
		/**
		 * Disables this metrics engine. The background averaging processes
		 * are stopped. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function disable(): void 
		{
			_enabled = false;
			_timer.stop();
		}
		
		private function netStatus(e:NetStatusEvent):void 
		{
			switch (e.info.code) 
			{
				case NetStreamCodes.NETSTREAM_BUFFER_FULL:
					_reachedTargetBufferFull = _ns.bufferLength >= _targetBufferTime;
					break;
				case NetStreamCodes.NETSTREAM_BUFFER_EMPTY:
					_reachedTargetBufferFull = false;
					break;
				case NetStreamCodes.NETSTREAM_PLAY_START:
					_reachedTargetBufferFull = false;
					if (!_timer.running && _enabled) 
					{
						_timer.start();
					}
					break;
				case NetStreamCodes.NETSTREAM_SEEK_NOTIFY:
					_reachedTargetBufferFull = false;
					break;
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
					_timer.stop();
					break;
			}
		}
		
		private function update(e:TimerEvent):void 
		{
			try 
			{
				if (isNaN(_ns.time))
				{
					this._timer.stop();
					return;
				}
			
				// Average max bandwdith
				_lastMaxBitrate = _ns.info.maxBytesPerSecond * 8 / 1024;
				_avgMaxBitrateArray.unshift(_lastMaxBitrate);
				if (_avgMaxBitrateArray.length > DEFAULT_AVG_BANDWIDTH_SAMPLE_SIZE) 
				{
					_avgMaxBitrateArray.pop();
				}
				var totalMaxBitrate:Number = 0;
				var peakMaxBitrate:Number = 0;
				
				for (var b:uint = 0; b < _avgMaxBitrateArray.length; b++) 
				{
					totalMaxBitrate += _avgMaxBitrateArray[b];
					peakMaxBitrate = _avgMaxBitrateArray[b] > peakMaxBitrate ? _avgMaxBitrateArray[b]: peakMaxBitrate;
				}
				
				_avgMaxBitrate = _avgMaxBitrateArray.length < DEFAULT_AVG_BANDWIDTH_SAMPLE_SIZE ? 0:_optimizeForLivebandwidthEstimate ? peakMaxBitrate:totalMaxBitrate/_avgMaxBitrateArray.length;
				
				// Estimate max (true) framerate
				_maxFrameRate = _ns.currentFPS > _maxFrameRate ? _ns.currentFPS:_maxFrameRate;
				
				// Frame drop rate, per second, calculated over last second.
				if (_timer.currentCount - _lastFrameDropCounter > 1000/_timer.delay) 
				{
					_frameDropRate = (_ns.info.droppedFrames - _lastFrameDropValue)/((_timer.currentCount - _lastFrameDropCounter)*_timer.delay/1000);
					_lastFrameDropCounter = _timer.currentCount;
					_lastFrameDropValue = _ns.info.droppedFrames;
				}
				_avgDroppedFrameRateArray.unshift(_frameDropRate);
				if (_avgDroppedFrameRateArray.length > DEFAULT_AVG_FRAMERATE_SAMPLE_SIZE) 
				{
					_avgDroppedFrameRateArray.pop();
				}
				var totalDroppedFrameRate:Number = 0;
				for (var f:uint=0;f<_avgDroppedFrameRateArray.length;f++) 
				{
					totalDroppedFrameRate +=_avgDroppedFrameRateArray[f];
				}
				
				_avgDroppedFrameRate = _avgDroppedFrameRateArray.length < DEFAULT_AVG_FRAMERATE_SAMPLE_SIZE? 0:totalDroppedFrameRate/_avgDroppedFrameRateArray.length;
				
			}
			catch (e:Error) 
			{
				debug(".update() - " + e);
				throw(e);	
			}
			
		}
		
		private function debug(...args):void
		{
			CONFIG::LOGGING
			{
				if (_logger == null)
				{
					_logger = Log.getLogger("org.osmf.net.dynamicstreaming.MetricsProvider");
				}
				_logger.debug(">>> MetricsProvider."+args);
			}
		}
		
		private var _ns:NetStream;
		private var _timer:Timer;
		private var _reachedTargetBufferFull:Boolean;
		private var _currentBufferSize:Number;
		private var _maxBufferSize:Number;
		private var _lastMaxBitrate:Number;
		private var _avgMaxBitrateArray:Array;
		private var _avgMaxBitrate:Number;
		private var _avgDroppedFrameRateArray:Array;
		private var _avgDroppedFrameRate:Number;
		private var _frameDropRate:Number;
		private var _lastFrameDropValue:Number;
		private var _lastFrameDropCounter:Number;
		private var _maxFrameRate:Number
		private var _currentIndex:uint;
		private var _dsResource:DynamicStreamingResource;
		private var _targetBufferTime:Number;
		private var _enabled:Boolean;
		private var _optimizeForLivebandwidthEstimate:Boolean;
		
		private var _qualityRating:Number;
		
		private const DEFAULT_UPDATE_INTERVAL:Number = 100;
		private const DEFAULT_AVG_BANDWIDTH_SAMPLE_SIZE:Number = 50;
		private const DEFAULT_AVG_FRAMERATE_SAMPLE_SIZE:Number = 50;		
		
		CONFIG::LOGGING
		{
			private var _logger:ILogger;
		}
	}
}
