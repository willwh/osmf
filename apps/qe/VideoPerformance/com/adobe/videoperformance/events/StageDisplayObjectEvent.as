package com.adobe.videoperformance.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * Event dispatched to request the view to place a display object
	 * onto the stage.
	 */	
	public class StageDisplayObjectEvent extends Event
	{
		public static const ADD_CHILD_REQUEST:String = "addChildRequest";
		
		public function StageDisplayObjectEvent(child:DisplayObject, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_child = child;
			
			super(ADD_CHILD_REQUEST, bubbles, cancelable);
		}
		
		public function get child():DisplayObject
		{
			return _child;
		}
		
		override public function clone():Event
		{
			return new StageDisplayObjectEvent(_child,bubbles,cancelable);
		}
		
		private var _child:DisplayObject;
	}
}