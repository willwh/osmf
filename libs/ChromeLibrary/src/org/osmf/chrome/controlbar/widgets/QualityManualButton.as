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
	
	public class QualityManualButton extends QualityAutoButton
	{
		import __AS3__.vec.Vector;
	
		import flash.events.MouseEvent;
		
		import org.osmf.media.MediaElement;
		import org.osmf.traits.DynamicStreamTrait;
		import org.osmf.traits.MediaTraitType;
			
		[Embed("../assets/images/qualityManual_up.png")]
		public var qualityManualUpType:Class;
		[Embed("../assets/images/qualityManual_down.png")]
		public var qualityManualDownType:Class;
		[Embed("../assets/images/qualityManual_disabled.png")]
		public var qualityManualDisabledType:Class;
		
		public function QualityManualButton(up:Class = null, down:Class = null, disabled:Class = null)
		{
			super
				( up || qualityManualUpType
				, down || qualityManualDownType
				, disabled || qualityManualDisabledType
				); 
		}
		
		// Overrides
		//
		
		override protected function visibilityDeterminingEventHandler(event:Event = null):void
		{
			visible
				=	enabled
				=	element != null
				&& 	(dynamicStream ? dynamicStream.autoSwitch == true : false);
		}
		
		// Internals
		//
		
		/* static */
		private static const _requiredTraits:Vector.<String> = new Vector.<String>;
		_requiredTraits[0] = MediaTraitType.DYNAMIC_STREAM;
		
	}
}