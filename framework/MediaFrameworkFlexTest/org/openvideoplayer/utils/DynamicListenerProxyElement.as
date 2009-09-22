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
package org.openvideoplayer.utils
{
	import flash.display.DisplayObject;
	
	import org.openvideoplayer.net.dynamicstreaming.SwitchingDetail;
	import org.openvideoplayer.proxies.ListenerProxyElement;
	import org.openvideoplayer.traits.LoadState;
		
	public class DynamicListenerProxyElement extends ListenerProxyElement
	{
		public function DynamicListenerProxyElement(changeEventQueue:Array)
		{
			super();
			
			this.changeEventQueue = changeEventQueue; 
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

		override protected function processLoadableStateChange(oldState:LoadState, newState:LoadState):void
		{
		}
		
		override protected function processPlayingChange(playing:Boolean):void
		{
		}

		override protected function processPausedChange(paused:Boolean):void
		{
		}

		override protected function processSeekingChange(seeking:Boolean, time:Number):void
		{
		}
		
		override protected function processDurationReached():void
		{
		}

		override protected function processDurationChange(oldDuration:Number, newDuration:Number):void
		{
		}

		override protected function processDimensionChange(oldWidth:Number, oldHeight:Number, newWidth:Number, newHeight:Number):void
		{
		}
		
		override protected function processSwitchingChange(oldState:int, newState:int, detail:SwitchingDetail):void
		{
		}	

		override protected function processViewChange(oldView:DisplayObject, newView:DisplayObject):void
		{
		}
		
		private var changeEventQueue:Array;
	}
}