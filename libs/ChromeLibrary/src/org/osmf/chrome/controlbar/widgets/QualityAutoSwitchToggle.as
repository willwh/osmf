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
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osmf.events.SwitchEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.DynamicStreamTrait;
	import org.osmf.traits.MediaTraitType;
	
	public class QualityAutoSwitchToggle extends Button
	{
		[Embed("../assets/images/qualityMode_up.png")]
		public var qualityModeUpType:Class;
		[Embed("../assets/images/qualityMode_down.png")]
		public var qualityModeDownType:Class;
		[Embed("../assets/images/qualityMode_disabled.png")]
		public var qualityModeDisabledType:Class;
		
		public function QualityAutoSwitchToggle(up:Class = null, down:Class = null, disabled:Class = null)
		{
			super
				( up || qualityModeUpType
				, down || qualityModeDownType
				, disabled || qualityModeDisabledType
				); 
		}
		
		// Overrides
		//
		
		override protected function processRequiredTraitsAvailable(element:MediaElement):void
		{
			visible = true;
		}
		
		override protected function processRequiredTraitsUnavailable(element:MediaElement):void
		{
			visible = false;
		}
		
		override protected function get requiredTraits():Vector.<String>
		{
			return _requiredTraits;
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			var dynamicStream:DynamicStreamTrait = element.getTrait(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait;
			dynamicStream.autoSwitch = !dynamicStream.autoSwitch;
		}
		
		// Internals
		//
		
		/* static */
		private static const _requiredTraits:Vector.<String> = new Vector.<String>;
		_requiredTraits[0] = MediaTraitType.DYNAMIC_STREAM;
	}
}