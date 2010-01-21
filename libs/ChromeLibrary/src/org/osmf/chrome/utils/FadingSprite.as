package org.osmf.chrome.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FadingSprite extends Sprite
	{
		public function FadingSprite()
		{
			super();
			
			_visible = super.visible;
			_alpha = super.alpha;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		// Overrides
		//
		
		override public function set visible(value:Boolean):void
		{
			if (value != _visible)
			{
				_visible = value;
				mode = _visible
					? MODE_IN
					: MODE_OUT;
			}
		}
		
		override public function get visible():Boolean
		{
			return _visible;
		}
		
		override public function set alpha(value:Number):void
		{
			if (value != _alpha)
			{
				_alpha = value;
			}
		}
		
		override public function get alpha():Number
		{
			return _alpha;
		}

		// Internals
		//
		
		private var _visible:Boolean;
		private var _alpha:Number;
		private var _mode:String;
		private var remainingSteps:uint = 0;
		
		private static const STEPS:uint = 15;
		private static const MODE_IDLE:String = null;
		private static const MODE_IN:String = "in";
		private static const MODE_OUT:String = "out";
		
		private function get mode():String
		{
			return _mode;	
		}
		
		private function set mode(value:String):void
		{
			if (value != _mode)
			{
				_mode = value;
				var fadeRequired:Boolean
					= 	(	_mode == MODE_OUT
						&&	super.alpha != 0
						&&	super.visible != false
						)
					||	(	_mode == MODE_IN
						&&	super.alpha != _alpha
						);
				
				if (fadeRequired)
				{
					if (remainingSteps == 0)
					{
						remainingSteps = STEPS;
					}
					else
					{
						remainingSteps = STEPS - remainingSteps;
					}
					addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				else
				{
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);		
					_mode = MODE_IDLE;
					remainingSteps = 0;
				}	
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (remainingSteps == 0)
			{
				super.visible = _visible;
				mode = MODE_IDLE;
			}
			else 
			{
				remainingSteps--;
				
				if (mode == MODE_IN)
				{
					super.alpha = _alpha - (_alpha * remainingSteps / STEPS);
					super.visible = true;
				}
				else if (mode == MODE_OUT)
				{
					super.alpha = _alpha * remainingSteps / STEPS;
				}
			}
		}
		
		private function onAdded(event:Event):void
		{
			super.alpha = 0;
			mode = MODE_IN;
		}
	}
}