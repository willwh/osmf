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
	import __AS3__.vec.Vector;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	
	public class FullScreenLeaveButton extends Button
	{
		[Embed("../assets/images/fullScreenLeave_up.png")]
		public var fullScreenLeaveUpType:Class;
		[Embed("../assets/images/fullScreenLeave_down.png")]
		public var fullScreenLeaveDownType:Class;
		[Embed("../assets/images/fullScreenLeave_disabled.png")]
		public var fullScreenLeaveDisabledType:Class;
		
		public function FullScreenLeaveButton(up:Class = null, down:Class = null, disabled:Class = null)
		{
			super
				( up || fullScreenLeaveUpType
				, down || fullScreenLeaveDownType
				, disabled || fullScreenLeaveDisabledType
				);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		// Overrides
		//
		
		override protected function get requiredTraits():Vector.<String>
		{
			return _requiredTraits;
		}
		
		override protected function processRequiredTraitsUnavailable(element:MediaElement):void
		{
			visible = false;
		}
		
		override protected function processRequiredTraitsAvailable(element:MediaElement):void
		{
			visible
				=	element != null
				&&	stage != null
				&&	stage.displayState != StageDisplayState.NORMAL;
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			stage.displayState = StageDisplayState.NORMAL;
		}
		
		// Internals
		//
		
		private function onAddedToStage(event:Event):void
		{
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenEvent);
			processRequiredTraitsAvailable(element);
		}
		
		private function onFullScreenEvent(event:FullScreenEvent):void
		{
			processRequiredTraitsAvailable(element);
		}
		
		/* static */
		private static const _requiredTraits:Vector.<String> = new Vector.<String>;
		_requiredTraits[0] = MediaTraitType.DISPLAY_OBJECT;
	}
}