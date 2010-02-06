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
	
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;
	import org.osmf.net.dynamicstreaming.MetricsProvider;
	import org.osmf.net.dynamicstreaming.SwitchingDetailCodes;
	import org.osmf.net.dynamicstreaming.SwitchingRuleBase;

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
		private static const DROP_ONE_FRAMEDROP_FPS:Number = 10;
		private static const DROP_TWO_FRAMEDROP_FPS:Number = 20;
		private static const PANIC_FRAMEDROP_FPS:Number = 24;
		
		/**
		 * Constructor.
		 * 
		 * @param metrics The provider of NetStream metrics.
		 * @param dropOne The number of frame drops that need to occur to cause a switch down by one index.
		 * The default is 10 frames per second.
		 * @param dropTwo The number of frame drops that need to occur to cause a switch down by two indices.
		 * The default is 20 frames per second.
		 * @param dropPanic The number of frame drops that need to occur to cause a switch to the lowest bitrate.
		 * The default is 24 frames per second.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function DroppedFramesRule(dropOne:int=DROP_ONE_FRAMEDROP_FPS, dropTwo:int=DROP_TWO_FRAMEDROP_FPS,
										dropPanic:int=PANIC_FRAMEDROP_FPS)
		{
			super();
			
			_dropOneFrameDropFPS = dropOne;
			_dropTwoFrameDropFPS = dropTwo;
			_panicFrameDropFPS = dropPanic;
			
			lastLockTime = 0;
			lockLevel = int.MAX_VALUE;
		}
		
		/**
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
        	
        	if (metrics.averageDroppedFPS > _panicFrameDropFPS) 
        	{
        		newIndex = 0;
				moreDetail = "Average droppedFPS of " + Math.round(metrics.averageDroppedFPS) + " > " + _panicFrameDropFPS;
        	} 
        	else if (metrics.averageDroppedFPS > _dropTwoFrameDropFPS) 
        	{
				newIndex = metrics.currentIndex - 2 < 0 ? 0 : metrics.currentIndex - 2;
				moreDetail = "Average droppedFPS of " + Math.round(metrics.averageDroppedFPS) + " > " + _dropTwoFrameDropFPS;
        	} 
        	else if (metrics.averageDroppedFPS > _dropOneFrameDropFPS) 
        	{
        		newIndex = metrics.currentIndex -1 < 0 ? 0 : metrics.currentIndex - 1;
				moreDetail = "Average droppedFPS of " + Math.round(metrics.averageDroppedFPS) + " > " + _dropOneFrameDropFPS;
        	}
  			
        	if (newIndex != -1 && newIndex < metrics.currentIndex) 
        	{
        		lockIndex(newIndex);
 				       	 	
        	 	updateDetail(SwitchingDetailCodes.SWITCHING_DOWN_FRAMEDROP_UNACCEPTABLE, moreDetail);
			}
			
			// If the rule says no change, but we're locked at the current index,
			// ensure that we stay locked by returning the current index.
			if (newIndex == -1 && isLocked(metrics.currentIndex))
			{
				debug("getNewIndex() - locked at: " + metrics.currentIndex); 
				
				newIndex = metrics.currentIndex;
			}
        	
        	if (newIndex != -1)
        	{
        		debug("getNewIndex() - about to return: " + newIndex + ", detail=" + moreDetail); 
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
		
		private function debug(...args):void
		{
			CONFIG::LOGGING
			{
				if (_logger == null)
				{
					_logger = Log.getLogger("org.osmf.net.dynamicstreaming.DroppedFramesRule");
				}
				_logger.debug(">>> FrameDropRule."+args);
			}
		}        
		
		private var _dropOneFrameDropFPS:int;
		private var _dropTwoFrameDropFPS:int;
		private var _panicFrameDropFPS:int;
		
		private var lockLevel:Number;
		private var lastLockTime:Number;

		private static const LOCK_INTERVAL:Number = 30000;	// Index levels can be locked for 30 seconds

		CONFIG::LOGGING
		{
			private var _logger:ILogger;
		}
	}
}
