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
package org.osmf.examples.chromeless
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.osmf.traits.TemporalTrait;
	
	internal class SWFTemporalTrait extends TemporalTrait
	{
		public function SWFTemporalTrait(swfRoot:DisplayObject)
		{
			super();
			
			this.swfRoot = swfRoot;
			
			// Keep in sync with the state of the SWF.
			Object(swfRoot).videoPlayer.addEventListener("playheadChange", onPlayheadChange);
			Object(swfRoot).videoPlayer.addEventListener("durationChange", onDurationChange);
			
			onPlayheadChange(null);
			onDurationChange(null);
		}
		
		private function onPlayheadChange(event:Event):void
		{
			// Stay in sync with the state of the SWF.
			var newPosition:Number = Object(swfRoot).videoPlayer.playhead;
			if (newPosition != position)
			{
				super.position = newPosition;
			}
		}
		
		private function onDurationChange(event:Event):void
		{
			var newDuration:Number = Object(swfRoot).videoPlayer.duration;
			if (newDuration != duration)
			{
				super.duration = newDuration;
			}
		}
		
		private var swfRoot:DisplayObject;
	}
}