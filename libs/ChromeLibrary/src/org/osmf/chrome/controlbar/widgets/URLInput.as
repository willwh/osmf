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
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import org.osmf.chrome.controlbar.ControlBarWidget;
	import org.osmf.chrome.fonts.Fonts;
	import org.osmf.media.MediaElement;
	
	[Event(name="change", type="flash.events.Change")];
	
	public class URLInput extends ControlBarWidget
	{
		public function URLInput()
		{
			var label:TextField = Fonts.getDefaultTextField();
			label.height = 12;
			label.width = 300;
			label.alpha = 0.4;
			label.y = 7;
			label.text = "MEDIA URL:";
			addChild(label);
			
			input = Fonts.getDefaultTextField();
			input.type = TextFieldType.INPUT;
			input.selectable = true;
			input.background = true;
			input.backgroundColor = 0x808080;
			input.height = 12;
			input.width = 298;
			input.alpha = 0.8;
			input.x = 2;
			input.y = 23;
			input.addEventListener(KeyboardEvent.KEY_DOWN, onInputKeyDown);
			addChild(input);
			
			super();
		}
		
		public function set url(value:String):void
		{
			input.text = value;
			focus();
		}
		public function get url():String
		{
			return input.text;
		}
		
		public function focus():void
		{
			if (visible && stage)
			{
				stage.focus = input;
			}
			input.setSelection(0, input.text.length);
		}
		
		// Overrides
		//
		
		override protected function processElementChange(oldElement:MediaElement):void
		{
			visible = element == null;
			focus();
		}
		
		// Internals
		//
		
		private function onInputKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == 13 /*enter*/)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private var input:TextField;	
	}
}