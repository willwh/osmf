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
	 * The only switching rule that switches up, all the others switch down.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class SufficientBandwidthRule extends SwitchingRuleBase
	{
		public function SufficientBandwidthRule(nsMetrics:INetStreamMetrics)
		{
			super(nsMetrics);
		}

		/**
		 * The new bitrate index to which this rule recommends switching. If the rule has no change request it will
		 * return a value of -1. 
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
        override public function getNewIndex():int 
        {
        	var newIndex:int = -1;
        	var moreDetail:String;
        	
        	// Wait until the metrics class can calculate a stable average bandwidth
        	if (metrics.averageMaxBandwidth != 0) 
        	{
				// First find the preferred bitrate level we should be at by finding the highest profile that can play, given the current average max bandwidth
				for (var i:int = metrics.dynamicStreamingResource.streamItems.length - 1; i >= 0; i--) 
				{
					if (metrics.averageMaxBandwidth > (metrics.dynamicStreamingResource.streamItems[i].bitrate * BANDWIDTH_SAFETY_MULTIPLE)) 
					{
						newIndex = i;
						break;
					}
				}
								
				// If we are about to recommend a switch up, check some other metrics to verify the recommendation
				if (newIndex > metrics.currentIndex) 
				{
	        		// We switch up only if conditions are perfect - no framedrops and a stable buffer
	        		newIndex = (metrics.droppedFPS < MIN_DROPPED_FPS && metrics.bufferLength > metrics.targetBufferTime) ? newIndex : -1;
	        		
	        		if (newIndex != -1)
	        		{
						moreDetail = "Move up since avg dropped FPS " + Math.round(metrics.droppedFPS) + " < " + MIN_DROPPED_FPS + " and bufferLength > " + metrics.targetBufferTime;
						updateDetail(SwitchingDetailCodes.SWITCHING_UP_BANDWIDTH_SUFFICIENT, moreDetail);	        			
	        		}
	        	}
	        	else
	        	{
	        		newIndex = -1;
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
					_logger = Log.getLogger("org.osmf.net.dynamicstreaming.SufficientBandwidthRule");
				}
				_logger.debug(">>> SwitchUpRule."+args);
			}
		}
		
		private const BANDWIDTH_SAFETY_MULTIPLE:Number = 1.15;
		private const MIN_DROPPED_FPS:int = 2;
		
		CONFIG::LOGGING
		{
			private var _logger:ILogger;
		}
	}
}
