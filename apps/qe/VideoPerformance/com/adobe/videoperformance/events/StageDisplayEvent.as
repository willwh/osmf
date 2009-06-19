package com.adobe.videoperformance.events
{
	import flash.events.Event;

	public class StageDisplayEvent extends Event
	{
		public static const STAGE_DISPLAY_EVENT:String = "stageDisplayEvent";
		
		public function StageDisplayEvent(newState:String, hardwareScaled:Boolean, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_newState = newState;
			_hardwareScaled = hardwareScaled;
		}
		
		public function get newState():String
		{
			return _newState;
		}
		
		public function get hardwareScaled():Boolean
		{
			return _hardwareScaled;
		}
		
		private var _hardwareScaled:Boolean;
		private var _newState:String;		
	}
}