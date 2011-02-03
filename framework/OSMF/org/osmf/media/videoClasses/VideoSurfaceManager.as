package org.osmf.media.videoClasses
{
	import flash.events.Event;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.events.VideoEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.utils.Dictionary;
	
	CONFIG::PLATFORM import flash.display.Stage;
	CONFIG::MOCK	 import org.osmf.mock.Stage;
	
	CONFIG::PLATFORM import flash.media.StageVideo;
	CONFIG::MOCK     import org.osmf.mock.StageVideo;

	CONFIG::LOGGING  import org.osmf.logging.Logger;	
	
	/**
	 * VideoSurfaceManager manages the workflow related to StageVideo support.
	 */ 
	internal class VideoSurfaceManager
	{	
		CONFIG::LOGGING private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.media.videoClasses.VideoSurfaceManager");
		
		internal function registerStage(stage:Stage):void
		{
			_stage = stage;
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailability);
		}
		
		public function registerVideoSurface(videoSurface:VideoSurface):void
		{			
			videoSurface.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			videoSurface.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onStageVideoAvailability(event:StageVideoAvailabilityEvent):void
		{	
			if (stageVideoAvailability != event.availability)
			{
				stageVideoAvailability = event.availability;
				trace("event.availability=", event.availability);
				//stageVideoAvailable = (event.availability == "available");			
				for (var key:* in videoSurfaces)
				{
					var videoSurface:VideoSurface = key as VideoSurface;
					if (videoSurface.info._stageVideoAvailability != event.availability)
					{
						videoSurface.info._stageVideoAvailability = event.availability;
						switchRenderer(videoSurface);	
					}
				}
			}
		}
		
		private function onAddedToStage(event:Event):void
		{			
			if (_stage == null)
			{				
				registerStage(event.target.stage);
			}
			
			stageVideoAvailability = _stage.stageVideos.length > 0 ? "available" : "";
			
			var videoSurface:VideoSurface = event.target as VideoSurface;		
			
			videoSurface.info._stageVideoAvailability = stageVideoAvailability;
		
			switchRenderer(videoSurface);	
			videoSurface.updateView();
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			var videoSurface:VideoSurface = event.target as VideoSurface;
			videoSurface.info._stageVideoAvailability = "";
			videoSurface.clear();
			videoSurfaces[videoSurface] = null;
			videoSurface.switchRenderer(null);
		}
		
		private function onStageVideoRenderState(event:StageVideoEvent):void
		{
			if (event.status == StageVideoEvent.RENDER_STATUS_UNAVAILABLE)
			{
				for (var key:* in videoSurfaces)
				{
					var videoSurface:VideoSurface = key as VideoSurface;
					if (event.target == videoSurface.stageVideo)
					{
						videoSurface.stageVideo = null;
						switchRenderer(videoSurface);
					}
				}
			}
		}
		
		private function switchRenderer(videoSurface:VideoSurface):void
		{
			var maxDepth:int = 0;
			for (var index:int = 0; index < _stage.stageVideos.length; index++)
			{
				if (maxDepth < _stage.stageVideos[index].depth)
				{
					maxDepth = _stage.stageVideos[index].depth;
				}
			}			
			
			var renderer:*;
			if (stageVideoAvailability != "available")
			{
				if (videoSurface.video == null)
				{
					videoSurface.video =  videoSurface.createVideo();
				}
				renderer = videoSurface.video;
			}
			else
			{
				if (!videoSurfaces.hasOwnProperty(videoSurface))
				{
					var stageVideo:StageVideo;
					for (var i:int = 0; i < _stage.stageVideos.length; i++)
					{
						stageVideo = _stage.stageVideos[i];
						//stageVideo.depth = 1;
						for (var j:* in videoSurfaces)
						{
							if (stageVideo == videoSurfaces[j])
							{
								stageVideo = null;
							}
						}
						if (stageVideo != null)
						{							
							break;
						}
					}
					
					if (stageVideo != null)
					{
						videoSurfaces[videoSurface] = stageVideo;
						videoSurface.stageVideo = stageVideo;
						renderer = stageVideo;
						stageVideo.depth = maxDepth + 1;
						renderer.addEventListener(StageVideoEvent.RENDER_STATE, onStageVideoRenderState);						
					}
					else
					{
						videoSurface.video = videoSurface.createVideo();//s[videoSurface] = createVideoFunctions[videoSurface]();
						renderer = videoSurface.video;
					}
				}
			}
			if (videoSurfaces[videoSurface] is StageVideo && videoSurfaces[videoSurface] != renderer)
			{
				videoSurfaces[videoSurface].viewPort = new Rectangle(0,0,0,0);
			}
		
			videoSurfaces[videoSurface] = renderer;
			videoSurface.switchRenderer(renderer);
		}					
	
		internal var videoSurfaces:Dictionary = new Dictionary(true);
		private var stageVideoAvailability:String = "";
		private var _stage:Stage = null;		
	}
}