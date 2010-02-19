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
	
	import org.osmf.events.DVREvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.DVRTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.SeekTrait;
	
	public class RecordButton extends Button
	{
		[Embed("../assets/images/record_up.png")]
		public var recordUpType:Class;
		[Embed("../assets/images/record_down.png")]
		public var recordDownType:Class;
		[Embed("../assets/images/record_disabled.png")]
		public var recordDisabledType:Class;
		
		public function RecordButton(up:Class = null, down:Class = null, disabled:Class = null)
		{
			super
				( up || recordUpType
				, down || recordDownType
				, disabled || recordDisabledType
				);
		}
		
		// Overrides
		//
		
		override protected function processRequiredTraitsAvailable(element:MediaElement):void
		{
			dvrTrait = element.getTrait(MediaTraitType.DVR) as DVRTrait;
			dvrTrait.addEventListener(DVREvent.IS_RECORDING_CHANGE, visibilityDeterminingEventHandler);
			
			visibilityDeterminingEventHandler();
		}
		
		override protected function processRequiredTraitsUnavailable(element:MediaElement):void
		{
			if (dvrTrait)
			{
				dvrTrait.removeEventListener(DVREvent.IS_RECORDING_CHANGE, visibilityDeterminingEventHandler);
				dvrTrait = null;
			}
			
			visibilityDeterminingEventHandler();
		}
		
		override protected function get requiredTraits():Vector.<String>
		{
			return _requiredTraits;
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			var seekable:SeekTrait = element.getTrait(MediaTraitType.SEEK) as SeekTrait;
			if (seekable && dvrTrait)
			{
				var livePosition:Number = dvrTrait.livePosition;
				if (seekable.canSeekTo(livePosition))
				{
					// While seeking, disable the button:
					enabled = false;
					seekable.addEventListener
						( SeekEvent.SEEK_END
						, function(event:Event):void
							{
								// Re-enable the button:
								removeEventListener(event.type, arguments.callee);
								enabled = true;
							}
						);
						
					// Seek to the live position:
					seekable.seek(livePosition);
				}
			}
		}
		
		// Internals
		//
		
		protected function visibilityDeterminingEventHandler(event:Event = null):void
		{
			visible
				=	dvrTrait != null
				&&	dvrTrait.isRecording == true; 
		}
		
		protected var dvrTrait:DVRTrait;
		
		/* static */
		private static const _requiredTraits:Vector.<String> = new Vector.<String>;
		_requiredTraits[0] = MediaTraitType.DVR;
	}
}