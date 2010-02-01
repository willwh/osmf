package org.osmf.chrome.hint
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import org.osmf.chrome.fonts.Fonts;
	import org.osmf.chrome.utils.FadingSprite;

	public class Hint
	{
		public function Hint(lock:Class)
		{
			if (lock != ConstructorLock)
			{
				throw new IllegalOperationError("Hint is a singleton. Please use the getInstance method");
			}
			
			view = new FadingSprite();
			view.mouseChildren = false;
			view.mouseEnabled = false;
			
			label = Fonts.getDefaultTextField();
			label.height = 12;
			label.multiline = true;
			label.wordWrap = true;
			label.width = 100;
			label.alpha = 0.8;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.background = true;
			label.backgroundColor = 0;
			
			view.addChild(label);
		}
		
		public static function getInstance(stage:Stage):Hint
		{
			if (stage == null)
			{
				throw new ArgumentError("Stage cannot be null");
			}
			
			if (_instance == null)
			{
				_instance = new Hint(ConstructorLock);
				_instance.stage = stage;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, _instance.onStageMouseMove);
			}
			
			return _instance;
		}
		
		
		public function set text(value:String):void
		{
			if (value != _text)
			{
				if (openingTimer != null)
				{
					openingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onOpeningTimerComplete);
					openingTimer.stop();
					openingTimer = null;
				}
				
				if (stage.contains(view))
				{
					stage.removeChild(view);
				}
				
				_text = value;
				label.text = _text || "";
				
				if (value != null || value == "")
				{
					openingTimer = new Timer(OPENING_DELAY, 1);
					openingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onOpeningTimerComplete);
					openingTimer.start();
				}
			}
		}
		
		public function get text():String
		{
			return _text;
		}
		
		// Internals
		//
		
		private static var _instance:Hint;
		private static const OPENING_DELAY:Number = 1200;
		
		private var stage:Stage;
		private var view:Sprite;
		private var _text:String;
		private var label:TextField;
		
		private var openingTimer:Timer;
		
		private function onStageMouseMove(event:MouseEvent):void
		{
			if (_text != null && _text != "")
			{
				if (openingTimer && openingTimer.running)
				{
					openingTimer.reset();
					openingTimer.start();	
				}
				else
				{
					text = null;
				}
			}
		}
		
		private function onOpeningTimerComplete(event:TimerEvent):void
		{
			openingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onOpeningTimerComplete);
			openingTimer.stop();
			openingTimer = null;
			
			stage.addChild(view);
			view.x = stage.mouseX - 13;
			view.y = stage.mouseY - view.height - 2;
			
			trace(stage.mouseX, stage.mouseY, view.height);
		}
			
	}
}

class ConstructorLock
{
}