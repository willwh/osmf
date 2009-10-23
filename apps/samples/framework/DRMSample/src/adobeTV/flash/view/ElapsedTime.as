package adobeTV.flash.view
{
	import adobeTV.flash.PlayerTvMain;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class ElapsedTime extends Sprite
	{
								
		[Embed(source="../../../../assets/AdobeClean-SemiCn.otf", fontName="AdobeClean-SemiCn",  mimeType="application/x-font")]
		private var AdobeCleanSemi:Class;
		private	var bg:DisplayObject 	
		private var currentTime:TextField;
				
		private var enabled:Boolean = true;
		public function set enabledTime(isEnabled:Boolean):void { setTime(0, 0); enabled = isEnabled; }
		
		public function ElapsedTime()
		{			
			
			currentTime = new TextField();	
			bg = new (PlayerTvMain.btn_bg_UP)() as DisplayObject;
			addChild(bg);
			addChild(currentTime);
			var font:Font = new AdobeCleanSemi();
						
			ElapsedTime.setFont(currentTime, font, 12, 0x3C3C3C, false);
			setTime(0, 0);
		}
		
		public function setTime(elapsed:Number, totalTime:Number):void
		{
			if (!enabled)
			{
				return;
			} 
			currentTime.text = ElapsedTime.convertTime(elapsed) + " / " + ElapsedTime.convertTime(totalTime);
			currentTime.width = currentTime.textWidth + 6;
			currentTime.height = currentTime.textHeight + 3;
		}
		
		public static function convertTime(s:Number):String 
		{
			var nMins:String="";
			var nSecs:String="";
			var mins:int = Math.floor(s / 60);
			var secs:int = s % 60;
			if (mins < 10) 
			{
				nMins = "0" 
			}
			if (secs < 10)
			{
				nSecs = "0" 
			}
				
				return nMins + mins + ":" + nSecs + secs;
		}
		
		
		public static function setFont(textf:TextField,font:Font, size:int,color:uint,bold:Boolean):void 
		{
			var tf:TextFormat = new TextFormat();
			tf.font = font.fontName; 
			tf.size = size;
			tf.color = color;
			tf.align = "left";
			if (bold) tf.bold = bold;
			textf.defaultTextFormat=tf
		}
		
		public function setSize(w:Number, h:Number):void 
		{			
			bg.width = w;
			bg.height = h;
			
			currentTime.x = (w - currentTime.width) * .5;
			currentTime.y = (h - currentTime.height) * .5;
		}
		
	}
	
}