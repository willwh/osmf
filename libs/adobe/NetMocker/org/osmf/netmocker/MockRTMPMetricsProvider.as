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
*  Contributor: Adobe Systems Inc.
* 
*****************************************************/
package org.osmf.netmocker
{
	import flash.net.NetStream;
	
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.net.rtmpstreaming.RTMPMetricsProvider;

	public class MockRTMPMetricsProvider extends RTMPMetricsProvider
	{
		public function MockRTMPMetricsProvider(netStream:NetStream)
		{
			super(netStream);
			
			_droppedFPS = 0;
			_targetBufferTimeReached = false;
			_lastFrameDropCounter = 0;
			_lastFrameDropValue = 0;
			_maxFPS = 0;
			_isLive = false;
			_averageMaxBandwidthArray = new Array();
			_averageDroppedFPSArray = new Array();
			_enabled = true;
			_targetBufferTime = 0;
			_currentIndex = 0;
			_averageMaxBandwidth = 0;
			_netStream = netStream;
		}

		override public function get targetBufferTimeReached():Boolean
		{
			return _targetBufferTimeReached;
		}
		
		public function set targetBufferTimeReached(value:Boolean):void
		{
			_targetBufferTimeReached = value;
		}
		
		override public function get targetBufferTime():Number
		{
			return _targetBufferTime;
		}
		
		override public function set targetBufferTime(value:Number):void
		{
			_targetBufferTime = value;
		}
			
		override public function get maxFPS():Number
		{
			return _maxFPS;
		}
		
		public function set maxFPS(value:Number):void
		{
			_maxFPS = value;
		}
		
		override public function get droppedFPS():Number
		{
			return _droppedFPS;
		}
		
		public function set droppedFPS(value:Number):void
		{
			_droppedFPS = value;
		}
		
		override public function get averageDroppedFPS():Number
		{
			return _averageDroppedFPS;
		}
		
		public function set averageDroppedFPS(value:Number):void
		{
			_averageDroppedFPS = value;
		}
		
		override public function get maxBandwidth():Number
		{
			return _maxBandwidth;
		}
		
		public function set maxBandwidth(value:Number):void
		{
			_maxBandwidth = value;
		}
		
		override public function get averageMaxBandwidth():Number
		{
			return _averageMaxBandwidth;
		}
		
		public function set averageMaxBandwidth(value:Number):void
		{
			_averageMaxBandwidth = value;
		}
		
		override public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		override public function set currentIndex(value:int):void
		{
			_currentIndex = value;
		}
		
		override public function get maxAllowedIndex():int
		{
			return _dsResource.streamItems.length - 1;
		}
		
		override public function get resource():DynamicStreamingResource
		{
			return _dsResource;
		}
		
		override public function set resource(value:DynamicStreamingResource):void
		{
			_dsResource = value;
		}
		
		override public function get netStream():NetStream
		{
			return _netStream;
		}
		
		override public function get isLive():Boolean
		{
			return _isLive;
		}
		
		override public function set isLive(value:Boolean):void
		{
			_isLive = value;
		}
		
		private var _targetBufferTimeReached:Boolean;
		private var _maxBandwidth:Number;
		private var _averageMaxBandwidthArray:Array;
		private var _averageMaxBandwidth:Number;
		private var _averageDroppedFPSArray:Array;
		private var _averageDroppedFPS:Number;
		private var _droppedFPS:Number;
		private var _lastFrameDropValue:Number;
		private var _lastFrameDropCounter:Number;
		private var _maxFPS:Number;
		private var _currentIndex:int;
		private var _dsResource:DynamicStreamingResource;
		private var _targetBufferTime:Number;
		private var _enabled:Boolean;
		private var _isLive:Boolean;
		private var _netStream:NetStream;
	}
}
