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
	import flash.events.MouseEvent;
	
	import org.osmf.chrome.controlbar.ControlBarBase;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.metadata.MetadataWatcher;
	import org.osmf.metadata.ObjectFacet;
	
	public class PinUpButton extends Button
	{
		[Embed("../assets/images/pinUp_up.png")]
		public var pinUpUpType:Class;
		[Embed("../assets/images/pinUp_down.png")]
		public var pinUpDownType:Class;
		[Embed("../assets/images/pinUp_disabled.png")]
		public var pinUpDisabledType:Class;
		
		public function PinUpButton(up:Class = null, down:Class = null, disabled:Class = null)
		{
			super(up || pinUpUpType, down || pinUpDownType, disabled || pinUpDisabledType);
		}
		
		// Overrides
		//
		
		override protected function processElementChange(oldElement:MediaElement):void
		{
			if (controlBarAutoHideWatcher)
			{
				controlBarAutoHideWatcher.unwatch();
				controlBarAutoHideWatcher = null;
			}
			
			if (element != null)
			{
				controlBarAutoHideWatcher
					= MetadataUtils.watchFacet
						( element.metadata
						, ControlBarBase.METADATA_AUTO_HIDE_URL
						, controlBarAutoHideChangeCallback
						);
			}
			else
			{
				visible = false;
			}
		}
		
		// Internals
		//
		
		protected function controlBarAutoHideChangeCallback(value:ObjectFacet):void
		{
			visible = value && value.object == false;
		}
		
		private var controlBarAutoHideWatcher:MetadataWatcher;
	}
}