package adobeTV.flash.view 
{
	import adobeTV.flash.PlayerTvMain;
	import adobeTV.flash.events.ScreenDimensionEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class ScreenDimension extends Sprite
	{
		
		public static const FULLSCREEN:int = 1;
		public static const POPOUT:int = 2;
		public static const MAXIMIZE:int = 3;
		public static const NORMAL:int = 4;
		public static const DIM:int = 5;
		public static const DIMOFF:int = 6;
		
		public static const RETURN:int = 7;
		
		public static const FITSCALE:int = 10;
		public static const ORIGINAL:int = 11;
		public static const FITRATIO:int = 12;
						
		private var _mode:int = ScreenDimension.ORIGINAL;
		private var bg:Sprite;
		private var contain:Sprite;
		private var main_btn:Button;
		private var popOut_btn:Button;
		private var maximize_btn:Button;
		private var fullScreen_btn:Button;
		
		private var restore_btn:Button;
		
		private var dim_btn:Button;
		
		private var masker:Sprite

		private var oldSize:Object={w:22,h:22}
		
		override public function get width():Number {  return  oldSize.w;	}
		
		public function ScreenDimension()
		{
			masker = new Sprite();
			bg = new Sprite();		
			popUPDraw(bg.graphics, { x: -2, y:0, width:oldSize.w + 2, height:90 }, 0x686868, 0xE9E9E9);	
			
			main_btn = PlayerTvMain.buttonCreate("Fullscreen", "main", oldSize.w, "fs01", this, 2, clicked);			//
			contain = new Sprite();
			
			dim_btn = PlayerTvMain.buttonCreate("Dim the Lights", "dimmer", oldSize.w, "dimON", contain, 2, clicked,true,hint);
			
			popOut_btn = PlayerTvMain.buttonCreate("Pop Out Player", "pop", oldSize.w, "popOut", contain, dim_btn.y+dim_btn.height,clicked,true,hint);
			maximize_btn = PlayerTvMain.buttonCreate("Maximize On Page", "max", oldSize.w, "maximize", contain, popOut_btn.y+popOut_btn.height,clicked,true,hint);
			fullScreen_btn = PlayerTvMain.buttonCreate("Fullscreen", "full", oldSize.w, "fs01", contain, maximize_btn.y+maximize_btn.height,clicked,true,hint);
			popOut_btn.x = maximize_btn.x = fullScreen_btn.x = 1;
					
			contain.y=masker.y = -bg.height+2;
			
			
			contain.addChildAt(bg,0);
			
			addChild(masker);
			
			var _mode:int = ScreenDimension.ORIGINAL;
			
			if (_mode != ScreenDimension.RETURN && _mode != ScreenDimension.ORIGINAL) 
			{				  
				main_btn.icon = PlayerTvMain.convert2Class("restore") ;
				main_btn.name = "restore"
			}
			
		}
		
		public function get currentMode():int 
		{ 
			return _mode; 
		}
		
		public function set currentMode(mode:int ):void 
		{
			 _mode=mode; 
		}
		public function set enabled(isEnabled:Boolean):void 
		{ 
			main_btn.enabled = isEnabled; 
		}
		
		private function popUPDraw(MC:Graphics,dim:Object,lineColor:uint,fillColor:uint):void 
		{
			MC.lineStyle(1,lineColor,1);
			MC.beginFill(fillColor, 1);
			MC.moveTo(dim.x, dim.y);
			MC.lineTo(dim.x, dim.height);
				MC.lineStyle(0,fillColor,0);
			MC.lineTo(dim.width, dim.height);
				MC.lineStyle(1,lineColor,1);
			MC.lineTo(dim.width, dim.y);
			MC.lineTo(dim.X, dim.y);
			MC.endFill();
		}
		
		private function hint(e:MouseEvent):void 
		{
			var btn:Button = e.target as Button;
			var toolTip:ToolTip = PlayerTvMain.toolTipShow(btn, btn.label, 200, -5, -1, -13,null,false,true,4);
		}
		
		private function clicked(e:MouseEvent):void 
		{

			var btn:Button = e.target as Button;
			var show:Boolean = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var sEvent:ScreenDimensionEvent = new ScreenDimensionEvent(ScreenDimensionEvent.SCREEN_MODE_UPDATE);
			
			if (btn.name == "main") 
			{
				main_btn.icon =  PlayerTvMain.convert2Class("restore");
				main_btn.name = "restore"
				main_btn.label = "Restore On Page";
				sEvent.mode = ScreenDimension.FULLSCREEN;
				sEvent.scale = ScreenDimension.FITRATIO;	
				_mode= ScreenDimension.FULLSCREEN;
			}
			else
			{
				main_btn.icon =  PlayerTvMain.convert2Class("fs01");
				main_btn.name = "main"
				main_btn.label = "Fullscreen";
				sEvent.mode = ScreenDimension.ORIGINAL;
				sEvent.scale = ScreenDimension.FITRATIO;	
			}
			dispatchEvent(sEvent);
					
			
			switch (btn.name) 
			{
				case "main":
						show = (contain.parent?false:true);
				break;
				case "pop":
					sEvent.mode = ScreenDimension.POPOUT;
					sEvent.scale = ScreenDimension.FITRATIO;		
					dispatchEvent(sEvent);
					return;
				break;
				case "max":
					main_btn.icon =  PlayerTvMain.convert2Class("maximize") ;
					btn.icon =  PlayerTvMain.convert2Class("restore") ;
					sEvent.mode = ScreenDimension.MAXIMIZE;
					sEvent.scale = ScreenDimension.FITRATIO;	
					btn.name = "restore"
					maximize_btn.label = "Restore On Page";
				break;
				case "full":
					main_btn.icon =  PlayerTvMain.convert2Class("restore") ;
					main_btn.name = "restore"
					main_btn.label = "Restore On Page";
					sEvent.mode = ScreenDimension.FULLSCREEN;
					sEvent.scale = ScreenDimension.FITRATIO;	
				break;
				case "restore":
					restore(true);
					
					return;
				return;
				case "dimmer":
					show = true;
					btn.emphasized = btn.emphasized?false:true;	
					sEvent.mode = ScreenDimension.DIM;
					sEvent.enabled = btn.emphasized;	
					btn.icon =  PlayerTvMain.convert2Class(btn.emphasized?"dimOFF":"dimON");
					dispatchEvent(sEvent); 
				return;
			}
		
			if (btn.name != "main")
			{
				 _mode = sEvent.mode ; 
				 dispatchEvent(sEvent); 
			}
			
			showOptions(show);
		}
		
		
		public function restore(isUserEvent:Boolean=false):void 
		{
			if(!isUserEvent)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			var sEvent:ScreenDimensionEvent = new ScreenDimensionEvent(ScreenDimensionEvent.SCREEN_MODE_UPDATE);
			main_btn.icon =  PlayerTvMain.convert2Class("fs01");
			sEvent.mode = ScreenDimension.ORIGINAL;
			sEvent.scale = ScreenDimension.FITRATIO;	
			main_btn.name = "main";
			popOut_btn.name = "pop";
			popOut_btn.label="Pop Out Player"
			maximize_btn.name = "max";
			maximize_btn.label="Maximize On Page"
			popOut_btn.icon =  PlayerTvMain.convert2Class("popOut");
			maximize_btn.icon =  PlayerTvMain.convert2Class("maximize");
			dispatchEvent(sEvent);
			if(!isUserEvent)_mode = sEvent.mode ;
		}
		
		
		private function showOptions(show:Boolean):void
		{			
			if (show && contain.parent == null) 
			{
				addChildAt(contain, 0);
				contain.y = 0;
				PlayerTvMain.square(masker.graphics, { x:-2, y:0, width:oldSize.w+2, height:65 }, 1, 0xFFFFFF, .5, .5, 0x000000);
			}
			else if (!show && contain.parent != null) 
			{
				PlayerTvMain.square(masker.graphics, { x:-2, y:0, width:oldSize.w+2, height:65 }, 1, 0xFFFFFF, .5, .5, 0x000000);
				removeChild(contain);
				bg.y = 0;
			}
		}
		
		public function setSize(w:Number, h:Number):void 
		{		
			oldSize.w = w;
			oldSize.h = h;
		}
		
	}
	
}