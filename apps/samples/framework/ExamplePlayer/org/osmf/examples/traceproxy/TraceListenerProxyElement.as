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
package org.osmf.examples.traceproxy
{
	import flash.display.DisplayObject;
	
	import org.osmf.events.*;
	import org.osmf.media.*;
	import org.osmf.metadata.*;
	import org.osmf.net.dynamicstreaming.SwitchingDetail;
	import org.osmf.proxies.*;
	import org.osmf.traits.*;
	
	public class TraceListenerProxyElement extends ListenerProxyElement
	{
		public function TraceListenerProxyElement(wrappedElement:MediaElement)
		{
			super(wrappedElement);
		}

		override protected function processTraitAdd(traitType:MediaTraitType):void
		{
			trace("Trait Add: " + traitType.toString());
		}
	
		override protected function processTraitRemove(traitType:MediaTraitType):void
		{
			trace("Trait Remove: " + traitType.toString());
		}
	
		override protected function processVolumeChange(oldVolume:Number, newVolume:Number):void
		{
			trace("Volume Change: " + oldVolume + "->" + newVolume);
		}

		override protected function processMutedChange(muted:Boolean):void
		{
			trace("Muted Change: " + muted);
		}

		override protected function processPanChange(oldPan:Number, newPan:Number):void
		{
			trace("Pan Change: " + oldPan + "->" + newPan);
		}
		
		override protected function processBufferingChange(buffering:Boolean):void
		{
			trace("Buffering Change: " + buffering);
		}

		override protected function processBufferTimeChange(oldTime:Number, newTime:Number):void
		{
			trace("Buffer Time Change: " + oldTime + "->" + newTime);
		}

		override protected function processLoadStateChange(loadState:String):void
		{
			trace("Load State Change: ->" + loadState);
		}
		
		override protected function processPlayingChange(playing:Boolean):void
		{
			trace("Playing Change: " + playing);
		}

		override protected function processPausedChange(paused:Boolean):void
		{
			trace("Paused Change: " + paused);
		}

		override protected function processSeekingChange(seeking:Boolean, time:Number):void
		{
			trace("Seeking Change: " + seeking + " " + time);
		}
		
		override protected function processDurationReached():void
		{
			trace("Duration Reached");
		}

		override protected function processDurationChange(oldDuration:Number, newDuration:Number):void
		{
			trace("Duration Change: " + oldDuration + "->" + newDuration);
		}

		override protected function processDimensionChange(oldWidth:Number, oldHeight:Number, newWidth:Number, newHeight:Number):void
		{
			trace("Dimension Change: " + oldWidth + "x" + oldHeight + "->" + newWidth + "x" + newHeight);
		}
		
		override protected function processSwitchingChange(oldState:int, newState:int, detail:SwitchingDetail):void
		{
			trace("Switching Change: " + oldState + "->" + newState + " (" + detail + ")");
		}
		
		override protected function processIndicesChange():void
		{
			trace("Indices Change");
		}

		override protected function processViewChange(oldView:DisplayObject, newView:DisplayObject):void
		{
			trace("View Change: " + (oldView != null ? oldView.toString() : "null") + "->" + (newView != null ? newView.toString() : "null"));
		}
		
		override protected function processBytesTotalChange(oldBytes:Number, newBytes:Number):void
		{
			trace("Bytes Total Change: " + oldBytes + "->" + newBytes);
		}
	}
}