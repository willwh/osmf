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
	CONFIG::LOGGING
	{
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;
	}
	
	import org.osmf.net.SwitchingRuleBase;
	import org.osmf.utils.OSMFStrings;

	/**
	 * Switching rule for Bandwidth detection. This rule switches down when
	 * bandwidth is insufficient for the current stream.  When comparing stream bitrates 
	 * to available bandwidth, the class uses a "bitrate multiplier", the stream bitrate
	 * is multiplied by this number. The default is 1.15, but can be overridden in the
	 * class constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class InsufficientBandwidthRule extends SwitchingRuleBase
	{
		/**
		 * Constructor.
		 * 
		 * @param metrics The provider of NetStream metrics.
		 * @param bitrateMultiplier A multiplier that is used when the stream bitrate is compared against
		 * available bandwidth.  The stream bitrate is multiplied by this amount. The default is 1.15.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function InsufficientBandwidthRule(metrics:RTMPNetStreamMetrics, bitrateMultiplier:Number=1.15)
		{
			super(metrics);
			
			this.bitrateMultiplier = bitrateMultiplier;
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
        	var moreDetail:String;
        	
        	// Wait until the metrics class can calculate a stable average bandwidth
        	if (rtmpMetrics.averageMaxBytesPerSecond != 0) 
        	{
				// See if we need to switch down based on average max bytes per second
				for (var i:int = rtmpMetrics.currentIndex; i >= 0; i--) 
				{
					if (rtmpMetrics.averageMaxBytesPerSecond * 8 / 1024 > (rtmpMetrics.resource.streamItems[i].bitrate * bitrateMultiplier)) 
					{
						newIndex = i;
						break;
					}
				}
				
				newIndex = (newIndex == rtmpMetrics.currentIndex) ? -1 : newIndex;
				
				if ((newIndex != -1) && (newIndex < rtmpMetrics.currentIndex))
				{
					CONFIG::LOGGING
					{
						debug("Average bandwidth of " + Math.round(rtmpMetrics.averageMaxBytesPerSecond) + " < " + bitrateMultiplier + " * rendition bitrate");
					}
	        	}
        	} 
        	
        	if (newIndex != -1)
        	{
        		CONFIG::LOGGING
				{
        			debug("getNewIndex() - about to return: " + newIndex + ", detail=" + moreDetail);
    			}
        	}
        	 
        	return newIndex;
		}
		
		private function get rtmpMetrics():RTMPNetStreamMetrics
		{
			return metrics as RTMPNetStreamMetrics;
		}
		
		CONFIG::LOGGING
		{
		private function debug(s:String):void
		{
			logger.debug(s);
		}
		}

		private var bitrateMultiplier:Number;
			
		CONFIG::LOGGING
		{
			private static var logger:ILogger = Log.getLogger("org.osmf.net.InsufficientBandwidthRule");
		}
	}
}
