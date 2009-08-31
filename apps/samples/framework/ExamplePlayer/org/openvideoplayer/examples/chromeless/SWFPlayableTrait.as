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
package org.openvideoplayer.examples.chromeless
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.PausableTrait;
	import org.openvideoplayer.traits.PlayableTrait;
	
	internal class SWFPlayableTrait extends PlayableTrait
	{
		public function SWFPlayableTrait(swfRoot:DisplayObject, owner:MediaElement)
		{
			super(owner);
			
			this.swfRoot = swfRoot;
			
			// Keep in sync with the state of the SWF.
			Object(swfRoot).videoPlayer.addEventListener("isPlayingChange", onPlayingChange);
			onPlayingChange(null);
		}

		override protected function processPlayingChange(newPlaying:Boolean):void
		{
			if (newPlaying && Object(swfRoot).videoPlayer.isPlaying == false)
			{
				Object(swfRoot).videoPlayer.playVideo();
			}
		}
		
		private function onPlayingChange(event:Event):void
		{
			// Stay in sync with the state of the SWF.
			if (Object(swfRoot).videoPlayer.isPlaying)
			{
				play();
			}
		}
		
		private var swfRoot:DisplayObject;
	}
}