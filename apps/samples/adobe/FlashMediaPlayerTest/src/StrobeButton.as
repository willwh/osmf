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
	import flash.display.Graphics;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class StrobeButton extends Sprite
	{						
		public function StrobeButton(text:String, color:Number)
		{
			super();	
			buttonBase = new SimpleButton(  new Sprite(),
											new Sprite(),
											new Sprite(),
											new Sprite());		
			
			_color = color;
			label = text;	
			addChild(buttonBase);			
			addChild(labelField);					
		}
		
		private function fillState(w:Number, h:Number):void
		{
			var skins:Array = [ Sprite(buttonBase.upState).graphics,
								Sprite(buttonBase.overState).graphics,
								Sprite(buttonBase.downState).graphics,
								Sprite(buttonBase.hitTestState).graphics,
								];
			Sprite(buttonBase.upState)
			Sprite(buttonBase.overState).alpha = .8;
			Sprite(buttonBase.downState).alpha = .65;
										
			for each( var g:Graphics in skins)
			{				 
				g.clear();
				g.lineStyle(1, 0xAAAAAA);
				g.beginFill(_color);			
				g.drawRoundRect(0,0,w , h, 10,10);				
				g.endFill();					
			}
	
		}
		
		private function set label(text:String):void
		{		
			labelField.selectable = false;	
			labelField.text = text;	
			labelField.textColor = 0xFFFFFF;
			labelField.mouseEnabled = false;
			labelField.autoSize = TextFieldAutoSize.CENTER
			
			labelField.x =  MARGIN;
			labelField.y =  MARGIN;	
								
			fillState(labelField.textWidth + 2*MARGIN + 2 , labelField.textHeight + 2*MARGIN + 2 );				
		}
		
		private static const MARGIN:Number = 10;
		private var _color:Number;				
		private var labelField:TextField = new TextField();	
		private var buttonBase:SimpleButton;
	}
}