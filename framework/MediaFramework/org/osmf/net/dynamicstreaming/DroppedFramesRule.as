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
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;

	/**
	 * Switching rule for frame drop detection. Monitors frame drops using the data 
	 * provided by the INetStreamMetrics object provided to the constructor and
	 * recommends switching down if necessary.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class DroppedFramesRule extends SwitchingRuleBase
	{
		private const DROP_ONE_FRAMEDROP_FPS:Number = 10;
		private const DROP_TWO_FRAMEDROP_FPS:Number = 20;
		private const PANIC_FRAMEDROP_FPS:Number = 24;
		
		/**
		 * Constructor.
		 * 
		 * @param nsMetrics A metrics provider which implements the INetStreamMetrics interface
		 * @param dropOne The number of frame drops that need to occur to cause a switch down by one index.
		 * The default is 10 frames per second.
		 * @param dropTwo The number of frame drops that need to occur to cause a switch down by two indices.
		 * The default is 20 frames per second.
		 * @param dropPanic The number of frame drops that need to occur to cause a switch to the lowest bitrate.
		 * The default is 24 frames per second.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function DroppedFramesRule(nsMetrics:INetStreamMetrics, dropOne:int=DROP_ONE_FRAMEDROP_FPS, dropTwo:int=DROP_TWO_FRAMEDROP_FPS,
										dropPanic:int=PANIC_FRAMEDROP_FPS)
		{
			super(nsMetrics);
			_dropOneFrameDropFPS = dropOne;
			_dropTwoFrameDropFPS = dropTwo;
			_panicFrameDropFPS = dropPanic;
		}

		/**
		 * The new bitrate index to which this rule recommends switching. If the rule has no change request it will
		 * return a value of -1. 
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
        	
        	if (metrics.averageDroppedFPS > _panicFrameDropFPS) 
        	{
				moreDetail = "Average droppedFPS of " + Math.round(metrics.averageDroppedFPS) + " > " + _panicFrameDropFPS;
        		newIndex = 0;
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
        		var ns:DynamicNetStream = metrics.netStream as DynamicNetStream;
        		
        	 	if (!ns.isDSILocked(metrics.currentIndex)) 
        	 	{
        	 		ns.lockDSI(metrics.currentIndex);
        	 		debug(".getNewIndex() - Frame drop rule locking at index level: " + metrics.currentIndex);
        	 	}
        	 	
        	 	updateDetail(SwitchingDetailCodes.SWITCHING_DOWN_FRAMEDROP_UNACCETPABLE, moreDetail);
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
					_logger = Log.getLogger("org.osmf.net.dynamicstreaming.DroppedFramesRule");
				}
				_logger.debug(">>> FrameDropRule."+args);
			}
		}        
		
		private var _dropOneFrameDropFPS:int;
		private var _dropTwoFrameDropFPS:int;
		private var _panicFrameDropFPS:int;
				
		CONFIG::LOGGING
		{
			private var _logger:ILogger;
		}
	}
}
