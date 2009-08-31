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
package
{
	import flash.display.Sprite;
	import flash.system.Security;

	/**
	 * Simply SWF, to be used as a video overlay.
	 * Just displays a uni-color rectangle.
	 **/
	public class ReferenceSampleSWF extends Sprite
	{
		public function ReferenceSampleSWF()
		{
			// Allow any SWF that loads this SWF to access objects and
			// variables in this SWF.
			Security.allowDomain(this.root.loaderInfo.loaderURL);

			var child:Sprite = new Sprite();
			child.graphics.beginFill(0xFF9900);
			child.graphics.drawRect(0, 0, 320, 240);
			addChild(child);
		}
	}
}
