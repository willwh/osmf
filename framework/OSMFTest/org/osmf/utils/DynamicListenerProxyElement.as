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
		
	public class DynamicListenerProxyElement extends ListenerProxyElement
	{
		public function DynamicListenerProxyElement(changeEventQueue:Array, processTraitEvents:Boolean = false)
		{
			super(null);
			
			this.changeEventQueue = changeEventQueue;
			this.processTraitEvents = processTraitEvents;
		}
		
		override protected function processTraitAdd(traitType:String):void
		{
			if (processTraitEvents)
			{
				changeEventQueue.push({"traitTypeAdded":traitType});
			}
		}

		override protected function processTraitRemove(traitType:String):void
		{
			if (processTraitEvents)
			{
				changeEventQueue.push({"traitTypeRemoved":traitType});
			}
		}
		
		override protected function processVolumeChange(newVolume:Number):void
		{
			changeEventQueue.push({"newVolume":newVolume});
		}

		override protected function processMutedChange(muted:Boolean):void
		{
			changeEventQueue.push({"muted":muted});
		}

		override protected function processPanChange(newPan:Number):void
		{
			changeEventQueue.push({"newPan":newPan});
		}
		
		override protected function processBufferingChange(buffering:Boolean):void
		{
			changeEventQueue.push({"buffering":buffering});
		}

		override protected function processBufferTimeChange(newBufferTime:Number):void
		{
			changeEventQueue.push({"newBufferTime":newBufferTime});
		}

		override protected function processLoadStateChange(loadState:String):void
		{
			changeEventQueue.push({"loadState":loadState});
		}
		
		override protected function processBytesTotalChange(newBytes:Number):void
		{
			changeEventQueue.push({"bytesTotal":newBytes});
		}

		override protected function processCanPauseChange(canPause:Boolean):void
		{
			changeEventQueue.push({"canPause":canPause});
		}

		override protected function processPlayStateChange(playState:String):void
		{
			changeEventQueue.push({"playState":playState});
		}

		override protected function processSeekingChange(seeking:Boolean, time:Number):void
		{
			changeEventQueue.push({"seeking":seeking, "time":time});
		}
		
		override protected function processComplete():void
		{
			changeEventQueue.push({"complete":true});
		}

		override protected function processDurationChange(newDuration:Number):void
		{
			changeEventQueue.push({"newDuration":newDuration});
		}

		override protected function processMediaSizeChange(oldWidth:Number, oldHeight:Number, newWidth:Number, newHeight:Number):void
		{
			changeEventQueue.push({"oldWidth":oldWidth, "oldHeight":oldHeight, "newWidth":newWidth, "newHeight":newHeight});
		}
		
		override protected function processSwitchingChange(switching:Boolean, detail:SwitchingDetail):void
		{
			changeEventQueue.push({"switching":switching, "detail":detail});
		}

		override protected function processNumDynamicStreamsChange():void
		{
			changeEventQueue.push({"numDynamicStreamsChange":true});
		}

		override protected function processAutoSwitchChange(newAutoSwitch:Boolean):void
		{
			changeEventQueue.push({"newAutoSwitch":newAutoSwitch});
		}

		override protected function processDisplayObjectChange(oldDisplayObject:DisplayObject, newDisplayObject:DisplayObject):void
		{
			changeEventQueue.push({"oldDisplayObject":oldDisplayObject, "newDisplayObject":newDisplayObject});
		}

		private var changeEventQueue:Array;
		private var processTraitEvents:Boolean;
	}
}