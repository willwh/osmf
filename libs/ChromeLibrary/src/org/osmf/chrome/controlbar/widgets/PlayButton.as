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

package org.osmf.chrome.controlbar.widgets
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.PlayEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	
	public class PlayButton extends PlayableButton
	{
		[Embed("../assets/images/play_up.png")]
		public var playUpType:Class;
		[Embed("../assets/images/play_down.png")]
		public var playDownType:Class;
		[Embed("../assets/images/play_disabled.png")]
		public var playDisabledType:Class;
		
		public function PlayButton(up:Class = null, down:Class = null, disabled:Class = null)
		{
			super
				( up || playUpType
				, down || playDownType
				, disabled || playDisabledType
				);
		}
		
		// Overrides
		//
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			var playable:PlayTrait = element.getTrait(MediaTraitType.PLAY) as PlayTrait;
			playable.play();
		}
		
		override protected function visibilityDeterminingEventHandler(event:Event = null):void
		{
			visible = playable && playable.playState != PlayState.PLAYING;
		}
	}
}