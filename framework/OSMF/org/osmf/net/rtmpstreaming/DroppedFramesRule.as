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
	import flash.utils.getTimer;
	
	CONFIG::LOGGING
	{
	import org.osmf.logging.Logger;
	import org.osmf.logging.Log;
	}
	
	import org.osmf.net.NetStreamMetricsBase;
	import org.osmf.net.SwitchingRuleBase;
	import org.osmf.utils.OSMFStrings;

	/**
	 * Switching rule for frame drop detection. Monitors frame drops using the data 
	 * provided by the MetricsProvider object provided to the constructor and
	 * recommends switching down if necessary.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class DroppedFramesRule extends SwitchingRuleBase
	{
		/**
		 * Constructor.
		 * 
		 * @param metrics The provider of NetStream metrics.
		 * @param downSwitchByOne The number of dropped frames per second that
		 * need to occur to cause a switch down by one index.
		 * The default is 10 frames per second.
		 * @param downSwitchByTwo The number of dropped frames per second that
		 * need to occur to cause a switch down by two indices.
		 * The default is 20 frames per second.
		 * @param downSwitchToZero The number of dropped frames per second that
		 * need to occur to cause a switch to the lowest bitrate.
		 * The default is 24 frames per second.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function DroppedFramesRule
			( metrics:NetStreamMetricsBase
			, downSwitchByOne:int=10
			, downSwitchByTwo:int=20
			, downSwitchToZero:int=24
			)
		{
			super(metrics);
			
			this.downSwitchByOne = downSwitchByOne;
			this.downSwitchByTwo = downSwitchByTwo;
			this.downSwitchToZero = downSwitchToZero;
			
			lastLockTime = 0;
			lockLevel = int.MAX_VALUE;
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
        	
        	if (rtmpMetrics.averageDroppedFPS > downSwitchToZero) 
        	{
        		newIndex = 0;
				moreDetail = "Average droppedFPS of " + Math.round(rtmpMetrics.averageDroppedFPS) + " > " + downSwitchToZero;
        	} 
        	else if (rtmpMetrics.averageDroppedFPS > downSwitchByTwo) 
        	{
				newIndex = rtmpMetrics.currentIndex - 2 < 0 ? 0 : rtmpMetrics.currentIndex - 2;
				moreDetail = "Average droppedFPS of " + Math.round(rtmpMetrics.averageDroppedFPS) + " > " + downSwitchByTwo;
        	} 
        	else if (rtmpMetrics.averageDroppedFPS > downSwitchByOne) 
        	{
        		newIndex = rtmpMetrics.currentIndex -1 < 0 ? 0 : rtmpMetrics.currentIndex - 1;
				moreDetail = "Average droppedFPS of " + Math.round(rtmpMetrics.averageDroppedFPS) + " > " + downSwitchByOne;
        	}
  			
        	if (newIndex != -1 && newIndex < rtmpMetrics.currentIndex) 
        	{
        		lockIndex(newIndex);
			}
			
			// If the rule says no change, but we're locked at the current index,
			// ensure that we stay locked by returning the current index.
			if (newIndex == -1 && isLocked(rtmpMetrics.currentIndex))
			{
				CONFIG::LOGGING
				{
					debug("getNewIndex() - locked at: " + metrics.currentIndex);
				} 
				
				newIndex = rtmpMetrics.currentIndex;
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
        
		/**
		 * Sets the lock level at the provided index. Any item at this index or higher will be
		 * unavailable until the LOCK_INTERVAL has passed.
		 */	
		private function lockIndex(index:int):void 
		{
			if (!isLocked(index))
			{
				lockLevel = index;
				lastLockTime = getTimer();
			}
		}
							
		/**
		 * Returns true if this index level is currently locked.
		 */	
		private function isLocked(index:int):Boolean 
		{
			return (index >= lockLevel) && (getTimer() - lastLockTime) < LOCK_INTERVAL;
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
				
		private var downSwitchByOne:int;
		private var downSwitchByTwo:int;
		private var downSwitchToZero:int;
		
		private var lockLevel:Number;
		private var lastLockTime:Number;

		private static const LOCK_INTERVAL:Number = 30000;	// Index levels can be locked for 30 seconds

		CONFIG::LOGGING
		{
			private static const logger:Logger = Log.getLogger("org.osmf.net.rtmpstreaming.DroppedFramesRule");
		}
	}
}
