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