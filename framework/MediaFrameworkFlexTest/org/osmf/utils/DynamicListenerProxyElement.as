/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.utils
{
	import flash.display.DisplayObject;
	
	import org.osmf.net.dynamicstreaming.SwitchingDetail;
	import org.osmf.proxies.ListenerProxyElement;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
		
	public class DynamicListenerProxyElement extends ListenerProxyElement
	{
		public function DynamicListenerProxyElement(changeEventQueue:Array, processTraitEvents:Boolean = false)
		{
			super(null);
			
			this.changeEventQueue = changeEventQueue;
			this.processTraitEvents = processTraitEvents;
		}
		
		override protected function processTraitAdd(traitType:MediaTraitType):void
		{
			if (processTraitEvents)
			{
				changeEventQueue.push({"traitTypeAdded":traitType});
			}
		}

		override protected function processTraitRemove(traitType:MediaTraitType):void
		{
			if (processTraitEvents)
			{
				changeEventQueue.push({"traitTypeRemoved":traitType});
			}
		}
		
		override protected function processVolumeChange(oldVolume:Number, newVolume:Number):void
		{
			changeEventQueue.push({"oldVolume":oldVolume, "newVolume":newVolume});
		}

		override protected function processMutedChange(muted:Boolean):void
		{
			changeEventQueue.push({"muted":muted});
		}

		override protected function processPanChange(oldPan:Number, newPan:Number):void
		{
			changeEventQueue.push({"oldPan":oldPan, "newPan":newPan});
		}
		
		override protected function processBufferingChange(buffering:Boolean):void
		{
			changeEventQueue.push({"buffering":buffering});
		}

		override protected function processBufferTimeChange(oldTime:Number, newTime:Number):void
		{
			changeEventQueue.push({"oldBufferTime":oldTime, "newBufferTime":newTime});
		}

		override protected function processLoadStateChange(loadState:String):void
		{
			changeEventQueue.push({"loadState":loadState});
		}
		
		override protected function processPlayingChange(playing:Boolean):void
		{
			changeEventQueue.push({"playing":playing});
		}

		override protected function processPausedChange(paused:Boolean):void
		{
			changeEventQueue.push({"paused":paused});
		}

		override protected function processSeekingChange(seeking:Boolean, time:Number):void
		{
			changeEventQueue.push({"seeking":seeking, "time":time});
		}
		
		override protected function processDurationReached():void
		{
			changeEventQueue.push({"durationReached":true});
		}

		override protected function processDurationChange(newDuration:Number):void
		{
			changeEventQueue.push({"newDuration":newDuration});
		}

		override protected function processDimensionChange(oldWidth:Number, oldHeight:Number, newWidth:Number, newHeight:Number):void
		{
			changeEventQueue.push({"oldWidth":oldWidth, "oldHeight":oldHeight, "newWidth":newWidth, "newHeight":newHeight});
		}
		
		override protected function processSwitchingChange(oldState:int, newState:int, detail:SwitchingDetail):void
		{
			changeEventQueue.push({"oldState":oldState, "newState":newState, "detail":detail});
		}

		override protected function processIndicesChange():void
		{
			changeEventQueue.push({"indicesChange":true});
		}

		override protected function processViewChange(oldView:DisplayObject, newView:DisplayObject):void
		{
			changeEventQueue.push({"oldView":oldView, "newView":newView});
		}

		override protected function processBytesTotalChange(newBytes:Number):void
		{
			changeEventQueue.push({"newBytes":newBytes});
		}
		
		private var changeEventQueue:Array;
		private var processTraitEvents:Boolean;
	}
}