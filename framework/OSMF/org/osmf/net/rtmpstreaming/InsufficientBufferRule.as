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
package org.osmf.net.rtmpstreaming
{
	import flash.events.NetStatusEvent;
	
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.SwitchingRuleBase;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * Switching rule for Buffer detection.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class InsufficientBufferRule extends SwitchingRuleBase
	{
		/**
		 * The default value used to detect a panic when the 
		 * buffer length falls below this amount.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private static const PANIC_BUFFER_LEVEL:int = 2;
		

		/**
		 * Constructor.
		 * 
		 * @param metrics Provider of runtime metrics.
		 * @param panicBufferLevel A Tunable parameter for this rule. The "panic" buffer level 
		 * in seconds. This rule watches for the buffer length to fall below this level. The default
		 * value is 2 seconds.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function InsufficientBufferRule(metrics:RTMPNetStreamMetrics, panicBufferLevel:int=PANIC_BUFFER_LEVEL)
		{
			super(metrics);
			
			_panic = false;
			_panicBufferLevel = panicBufferLevel;
			metrics.netStream.addEventListener(NetStatusEvent.NET_STATUS, monitorNetStatus, false, 0, true);
		}
				
		/**
		 * @private
		 * 
		 * The new bitrate index to which this rule recommends switching. If the rule has no change request it will
		 * return a value of -1. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function getNewIndex():int
		{
			var newIndex:int = -1;
			
			if (_panic || (rtmpMetrics.netStream.bufferLength < _panicBufferLevel && rtmpMetrics.netStream.bufferLength > rtmpMetrics.netStream.bufferTime))
			{
				if (!_panic)
				{
					debug("Buffer of " + Math.round(rtmpMetrics.netStream.bufferLength)  + " < " + _panicBufferLevel + " seconds");
				}
				
				newIndex = 0;
				setReason(OSMFStrings.getString(OSMFStrings.SWITCHING_DOWN_BUFFER_INSUFFICIENT));
			}
			
			if (newIndex != -1)
			{
				debug("getNewIndex() - about to return: " + newIndex + ", detail=" + _moreDetail);
			} 
			
			return newIndex;
		}
		
		private function monitorNetStatus(e:NetStatusEvent):void 
		{
			switch (e.info.code) 
			{
				case NetStreamCodes.NETSTREAM_BUFFER_FULL:
					_panic = false;
					break;
				case NetStreamCodes.NETSTREAM_BUFFER_EMPTY:
					if (Math.round(rtmpMetrics.netStream.time) != 0)
					{
						_panic = true;
						_moreDetail = "Buffer was empty";
					}
					break;
				case NetStreamCodes.NETSTREAM_PLAY_INSUFFICIENTBW:
					_panic = true;
					_moreDetail = "Stream had insufficient bandwidth";
					break;
			}
		}
		
		private function get rtmpMetrics():RTMPNetStreamMetrics
		{
			return metrics as RTMPNetStreamMetrics;
		}

		private function debug(...args):void
		{
			CONFIG::LOGGING
			{
				if (_logger == null)
				{
					_logger = Log.getLogger("org.osmf.net.InsufficientBufferRule");
				}
				_logger.debug(">>> BufferRule."+args);
			}
		}		
				
		private var _panic:Boolean;
		private var _moreDetail:String;
		private var _panicBufferLevel:int;
				
		CONFIG::LOGGING
		{
			private var _logger:ILogger;
		}
	}
}
