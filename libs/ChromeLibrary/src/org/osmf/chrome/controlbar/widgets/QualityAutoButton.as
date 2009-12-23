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
	
	import org.osmf.events.SwitchEvent;
	
	public class QualityAutoButton extends Button
	{
		import __AS3__.vec.Vector;
	
		import flash.events.MouseEvent;
		
		import org.osmf.media.MediaElement;
		import org.osmf.traits.DynamicStreamTrait;
		import org.osmf.traits.MediaTraitType;
			
		[Embed("../assets/images/qualityAuto_up.png")]
		public var qualityAutoUpType:Class;
		[Embed("../assets/images/qualityAuto_down.png")]
		public var qualityAutoDownType:Class;
		[Embed("../assets/images/qualityAuto_disabled.png")]
		public var qualityAutoDisabledType:Class;
		
		public function QualityAutoButton(up:Class = null, down:Class = null, disabled:Class = null)
		{
			super
				( up || qualityAutoUpType
				, down || qualityAutoDownType
				, disabled || qualityAutoDisabledType
				); 
		}
		
		// Overrides
		//
		
		override protected function processElementChange(oldElement:MediaElement):void
		{
			visibilityDeterminingEventHandler();
		}
		
		override protected function processRequiredTraitsAvailable(element:MediaElement):void
		{
			dynamicStream = element.getTrait(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait;
			dynamicStream.addEventListener(SwitchEvent.AUTO_SWITCH_CHANGE, visibilityDeterminingEventHandler);
			
			visibilityDeterminingEventHandler();
		}
		
		override protected function processRequiredTraitsUnavailable(element:MediaElement):void
		{
			if (dynamicStream)
			{
				dynamicStream.removeEventListener(SwitchEvent.AUTO_SWITCH_CHANGE, visibilityDeterminingEventHandler);
				dynamicStream = null;
			}
			
			visibilityDeterminingEventHandler();
		}
		
		override protected function get requiredTraits():Vector.<String>
		{
			return _requiredTraits;
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			dynamicStream.autoSwitch = !dynamicStream.autoSwitch;
		}
		
		// Internals
		//
		
		protected function visibilityDeterminingEventHandler(event:Event = null):void
		{
			visible
				=	element != null 
				&&	(dynamicStream ? dynamicStream.autoSwitch == false : true);
				 
			enabled = dynamicStream != null;
		}
		
		protected var dynamicStream:DynamicStreamTrait;
		
		/* static */
		private static const _requiredTraits:Vector.<String> = new Vector.<String>;
		_requiredTraits[0] = MediaTraitType.DYNAMIC_STREAM;
		
	}
}