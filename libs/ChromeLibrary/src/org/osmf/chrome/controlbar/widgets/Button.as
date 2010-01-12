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
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.osmf.chrome.controlbar.ControlBarWidget;
	
	public class Button extends ControlBarWidget
	{
		public function Button(up:Class, down:Class, disabled:Class)
		{
			mouseEnabled = true;
			
			this.up = new up();
			this.down = new down();
			this.disabled = new disabled();
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick_internal);
			
			setFace(this.up);
		}
		
		// Internals
		//
		
		private function onMouseOver(event:MouseEvent):void
		{
			mouseOver = true;
			setFace(enabled ? down : disabled);
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			mouseOver = false;
			setFace(enabled ? up : disabled);
		}
		
		private function setFace(face:DisplayObject):void
		{
			if (currentFace != face)
			{
				if (currentFace != null)
				{
					removeChild(currentFace);
				}
				
				currentFace = face;
				
				if (currentFace != null)
				{
					addChild(currentFace);
				}
			}
		}
		
		private function onMouseClick_internal(event:MouseEvent):void
		{
			if (enabled == false)
			{
				event.stopImmediatePropagation();
			}
			else
			{
				onMouseClick(event);
			}
		}
		
		// Overrides
		//
		
		override public function set enabled(value:Boolean):void
		{
			setFace(value ? mouseOver ? down : up : disabled);
			
			super.enabled = value;
		}
		
		// Protected
		//
		
		override protected function processEnabledChange():void
		{
			super.processEnabledChange();
			
			setFace(enabled ? up : disabled);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			// Stub
		}
		
		protected var currentFace:DisplayObject;
		protected var mouseOver:Boolean;
		
		protected var up:DisplayObject;
		protected var down:DisplayObject;
		protected var disabled:DisplayObject;
		
	}
}