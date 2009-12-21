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
	import org.osmf.media.MediaElement;
	
	public class EjectButton extends Button
	{
		[Embed("../assets/images/eject_up.png")]
		public var ejectUpType:Class;
		[Embed("../assets/images/eject_down.png")]
		public var ejectDownType:Class;
		[Embed("../assets/images/eject_disabled.png")]
		public var ejectDisabledType:Class;
		
		public function EjectButton(up:Class = null, down:Class = null, disabled:Class = null)
		{
			super(up || ejectUpType, down || ejectDownType, disabled || ejectDisabledType);
		}
		
		override protected function processElementChange(oldElement:MediaElement):void
		{
			visible = element != null;
		}
	}
}