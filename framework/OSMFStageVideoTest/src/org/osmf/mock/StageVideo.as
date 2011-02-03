package org.osmf.mock
{
	import flash.events.EventDispatcher;
	import flash.events.StageVideoEvent;
	import flash.geom.Rectangle;
	import flash.net.NetStream;

	public class StageVideo extends EventDispatcher
	{	
		public var viewPort:Rectangle = new Rectangle(0,0,0,0);
		public var depth:int;
		
		public function StageVideo()
		{
				
		}
		
		public function renderStateAccelerated():void
		{
			dispatchEvent(new StageVideoEvent(StageVideoEvent.RENDER_STATE, false, false, StageVideoEvent.RENDER_STATUS_ACCELERATED, null));
		}
		
		public function renderStateSoftware():void
		{
			dispatchEvent(new StageVideoEvent(StageVideoEvent.RENDER_STATE, false, false, StageVideoEvent.RENDER_STATUS_SOFTWARE, null));
		}
		
		public function renderStateUnavailable():void
		{
			dispatchEvent(new StageVideoEvent(StageVideoEvent.RENDER_STATE, false, false, StageVideoEvent.RENDER_STATUS_UNAVAILABLE, null));
		}
		
		public function attachNetStream(netStream:NetStream):void
		{
			
		}	
	}
}