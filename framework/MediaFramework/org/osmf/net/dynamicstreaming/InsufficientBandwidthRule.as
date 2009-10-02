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
	import flash.events.Event;
	
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;

	/**
	 * Switching rule for Bandwidth detection. This rule switches down when
	 * bandwidth is insufficient for the current stream.  When comparing stream bitrates 
	 * to available bandwidth, the class uses a "safety multiple", the stream bitrate
	 * is mulitplied by this number. The default is 1.15, but can be overriden in the
	 * class constructor.
	 */
	public class InsufficientBandwidthRule extends SwitchingRuleBase
	{
		/**
		 * When comparing stream bitrates to available bandwidth, the stream bitrate
		 * is mulitplied by this number:
		 */		
		private const BANDWIDTH_SAFETY_MULTIPLE:Number = 1.15;
		
		/**
		 * Constructor
		 * 
		 * @param nsMetrics A metrics provider which implements the INetStreamMetrics interface
		 * @param safteyMultiple A multiplier that is used when the stream bitrate is compared against available
		 * bandwidth. The stream bitrate is multiplied by this amount. The default is 1.15.
		 */		
		public function InsufficientBandwidthRule(nsMetrics:INetStreamMetrics, safetyMultiple:Number=BANDWIDTH_SAFETY_MULTIPLE)
		{
			super(nsMetrics)
			_safetyMultiple = safetyMultiple;
		}

		/**
		 * The new bitrate index to which this rule recommends switching. If the rule has no change request it will
		 * return a value of -1. 
		 */
		override public function getNewIndex():int
		{
        	var newIndex:int = -1;
        	var moreDetail:String;
        	
        	// Wait until the metrics class can calculate a stable average bandwidth
        	if (metrics.averageMaxBandwidth != 0) 
        	{
				// See if we need to switch down based on average max bandwidth
				for (var i:int = metrics.currentIndex; i >= 0; i--) 
				{
					if (metrics.averageMaxBandwidth > (metrics.dynamicStreamingResource.getItemAt(i).bitrate * _safetyMultiple)) 
					{
						newIndex = i;
						break;
					}
				}
				
				newIndex = (newIndex == metrics.currentIndex) ? -1 : newIndex;
				
				if ((newIndex != -1) && (newIndex < metrics.currentIndex))
				{
					moreDetail = "Average bandwidth of " + Math.round(metrics.averageMaxBandwidth) + " < " + _safetyMultiple + " * rendition bitrate";
					updateDetail(SwitchingDetailCodes.SWITCHING_DOWN_BANDWIDTH_INSUFFICIENT, moreDetail);
	        	}
        	} 
        	
        	if (newIndex != -1)
        	{
        		debug("getNewIndex() - about to return: " + newIndex + ", detail=" + moreDetail);
        	}
        	 
        	return newIndex;
		}
		
				
		private function debug(...args):void
		{
			CONFIG::LOGGING
			{
				if (_logger == null)
				{
					_logger = Log.getLogger("org.osmf.net.dynamicstreaming.InsufficientBandwidthRule");
				}
				_logger.debug(">>> BandwidthRule."+args);
			}
		}

		private var _safetyMultiple:Number;
			
		CONFIG::LOGGING
		{
			private var _logger:ILogger;
		}
	}
}
