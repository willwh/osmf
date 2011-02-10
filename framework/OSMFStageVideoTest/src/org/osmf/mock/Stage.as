package org.osmf.mock
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.media.StageVideoAvailability;

	public class Stage extends EventDispatcher
	{
		public function Stage()
		{
			stageVideo = new StageVideo();
			internalStageVideos.push(stageVideo);
		}
		
		public function get stageVideos():Array
		{
			return internalStageVideos;
		}
		
		public function updateStageVideos(videos:Array, replace:Boolean = false):void
		{
			if (replace)
				internalStageVideos= videos;
			else
				internalStageVideos = internalStageVideos.concat(videos);
		}
		
		public function stageVideoAvailable():void
		{
			dispatchEvent(new StageVideoAvailabilityEvent(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, false, false, StageVideoAvailability.AVAILABLE));
		}
		
	
		public function renderUnavailable():void
		{
			var stageVideoEvent: StageVideoEvent = new StageVideoEvent(StageVideoEvent.RENDER_STATE, false, false, StageVideoEvent.RENDER_STATUS_UNAVAILABLE);
			
			dispatchEvent(stageVideoEvent);
		}
		
		public function addChild(child:DisplayObject):DisplayObject
		{
			child.dispatchEvent(new Event(Event.ADDED_TO_STAGE));
			if (child is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = child as DisplayObjectContainer;
				
				for (var i:int = 0; i < container.numChildren; i++)
				{
					addChild(container.getChildAt(i));
				}
					
			}
			return child;
		}
		
		public function removeChild(child:DisplayObject):DisplayObject
		{
			child.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
			if (child is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = child as DisplayObjectContainer;
				
				for (var i:int = 0; i < container.numChildren; i++)
				{
					removeChild(container.getChildAt(i));
				}
				
			}
			return child;
		}
		
		private var internalStageVideos:Array = new Array();
		
		private var stageVideo:StageVideo;
	}
}