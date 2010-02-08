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

package
{
	import flash.display.DisplayObject;
	
	import org.osmf.media.MediaElement;
	import org.osmf.net.dynamicstreaming.SwitchingDetail;
	import org.osmf.elements.ListenerProxyElement;
	import org.osmf.elements.VideoElement;

	public class DebuggerElementProxy extends ListenerProxyElement
	{
		public function DebuggerElementProxy(wrappedElement:MediaElement, debugger:Debugger)
		{
			this.debugger = debugger;
			
			super(wrappedElement);
		}
		
		// Overrides
		//
		
		override protected function processAutoSwitchChange(newAutoSwitch:Boolean):void
		{
			debugger.send("autoSwitchChange", newAutoSwitch);
		}
		
		override protected function processBufferingChange(buffering:Boolean):void
		{
			debugger.send("bufferingChange", buffering);
		}
		
		override protected function processBufferTimeChange(newBufferTime:Number):void
		{
			debugger.send("bufferTimeChange", newBufferTime);
		}
		
		override protected function processComplete():void
		{
			debugger.send("complete");
		}
		
		override protected function processCanPauseChange(canPause:Boolean):void
		{
			debugger.send("canPauseChange");
		}
		
		override protected function processDisplayObjectChange(oldDisplayObject:DisplayObject, newView:DisplayObject):void
		{
			debugger.send("displayObjectChange");
		}
		
		override protected function processDurationChange(newDuration:Number):void
		{
			debugger.send("durantionChange", newDuration);
		}
		
		override protected function processLoadStateChange(loadState:String):void
		{
			debugger.send("loadStateChange", loadState);
		}
		
		override protected function processMediaSizeChange(oldWidth:Number, oldHeight:Number, newWidth:Number, newHeight:Number):void
		{
			debugger.send("mediaSizeChange", newWidth, newHeight);
		}
		
		override protected function processMutedChange(muted:Boolean):void
		{
			debugger.send("mutedChange", muted);
		}
		
		override protected function processNumDynamicStreamsChange():void
		{
			debugger.send("numDynamicStreamsChange");
		}
		
		override protected function processPanChange(newPan:Number):void
		{
			debugger.send("panChange", newPan);
		}
		
		override protected function processPlayStateChange(playState:String):void
		{
			debugger.send("playStateChange", playState);
		}
		
		override protected function processSeekingChange(seeking:Boolean, time:Number):void
		{
			debugger.send("seekingChange", seeking, time);
		}
		
		override protected function processSwitchingChange(switching:Boolean, detail:SwitchingDetail):void
		{
			debugger.send("switchingChange", detail);
		}
		
		override protected function processVolumeChange(newVolume:Number):void
		{
			debugger.send("volumeChange", newVolume);
		}
		
		// Internals
		//
		
		private var debugger:Debugger;
	}
}