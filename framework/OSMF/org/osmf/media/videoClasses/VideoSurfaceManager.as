package org.osmf.media.videoClasses
{
	[ExcludeClass]
	
	import flash.events.Event;
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
	 * @private
	 * 
	 * VideoSurfaceManager manages the workflow related to StageVideo support.
	 */ 
	internal class VideoSurfaceManager
	{	
		CONFIG::LOGGING private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.media.videoClasses.VideoSurfaceManager");
		
		internal function registerStage(stage:Stage):void
		{
			_stage = stage;
			stage.addEventListener("stageVideoAvailability", onStageVideoAvailability);
		}
		
		public function registerVideoSurface(videoSurface:VideoSurface):void
		{			
			videoSurface.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			videoSurface.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onStageVideoAvailability(event:Event):void
		{				
			if (event.hasOwnProperty("availability") && stageVideoAvailability != event["availability"])
			{
				CONFIG::LOGGING
				{
					logger.info("stageVideoAvailability changed. Previous value = {0}; Current value = {1}", stageVideoAvailability, event["availability"]);
				}
				
				stageVideoAvailability = event["availability"];				
				
				// Switch current VideoSurfaces so that they start using StageVideo if it's available
				// or switch to Video if StageVideo is not available anymore.
				for (var key:* in activeVideoSurfaces)
				{
					var videoSurface:VideoSurface = key as VideoSurface;
					if (videoSurface.info._stageVideoAvailability != stageVideoAvailability)
					{
						videoSurface.info._stageVideoAvailability = stageVideoAvailability;
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
			
			// Don't wait for the StageVideoAvailability event to occur. 
			// Check if stageVideo instances are available.
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
			videoSurface.clear2();
			activeVideoSurfaces[videoSurface] = null;
			videoSurface.switchRenderer(null);
		}
		
		/**
		 * A StageVideo instance might become unavailable while it is being used.
		 * Switches to Video once this happens.
		 */ 
		private function onStageVideoRenderState(event:StageVideoEvent):void
		{
			if (event.status == StageVideoEvent.RENDER_STATUS_UNAVAILABLE)
			{
				for (var key:* in activeVideoSurfaces)
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
			// Retrieve the current max depth, so that we surface the newly used
			// StageVideos to the top
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
				// Find a StageVideo instance that is not in use
				var stageVideo:StageVideo = null;
				for (var i:int = 0; i < _stage.stageVideos.length; i++)
				{
					stageVideo = _stage.stageVideos[i];
					for (var key:* in activeVideoSurfaces)
					{
						if (stageVideo == activeVideoSurfaces[key])
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
					// There is an available stageVideo instance. 
					activeVideoSurfaces[videoSurface] = stageVideo;
					videoSurface.stageVideo = stageVideo;
					renderer = stageVideo;
					stageVideo.depth = maxDepth + 1;
					renderer.addEventListener(StageVideoEvent.RENDER_STATE, onStageVideoRenderState);				
				}
				else
				{
					// All the StageVideo instances are currrently used. Fallback to Video.
					videoSurface.video = videoSurface.createVideo();
					renderer = videoSurface.video;
				}
			}
			
			activeVideoSurfaces[videoSurface] = renderer;
			
			// Start using the new renderer.
			videoSurface.switchRenderer(renderer);
		}					
	
		internal var activeVideoSurfaces:Dictionary = new Dictionary(true);
		private var stageVideoAvailability:String = "";
		private var _stage:Stage = null;		
	}
}