package com.adobe.videoperformance.control
{
	import com.adobe.videoperformance.events.StageDisplayEvent;
	import com.adobe.videoperformance.events.StageDisplayObjectEvent;
	import com.adobe.videoperformance.model.Model;
	import com.adobe.videoperformance.model.PerformancePoll;
	import com.adobe.videoperformance.model.PerformanceRecord;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.events.TraitEvent;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.IBufferable;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.ISpatial;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.video.VideoElement;

	/**
	 * Dispatched when the VideoRunner would like to have display object placed
	 * on the stage.
	 */
	[Event(name="stageDisplayObject","com.adobe.videoperformance.events.StageDisplayObjectEvent")]

	/**
	 * VideoRunner controls the execution of a single video performance
	 * test.
	 */	
	public class VideoRunner extends EventDispatcher
	{
		// Constants
		//
		
		/**
		 * Defines the buffer time to use with the test: 
		 */		
		public static const BUFFER_TIME:Number = 10;
		
		// Public Interface
		//
		
		/**
		 * Constructor.
		 * 
		 * @param model The model that holds the test configuration.
		 */		
		public function VideoRunner(model:Model):void
		{
			this.model = model;
		}
		
		/**
		 * Start testing.
		 * 
		 * @return True if the test was successfully initiated.
		 */		
		public function run():Boolean
		{	
			if (loadVideo() == true)
			{
				dispatchEvent(new StageDisplayEvent(model.fullScreen ? StageDisplayState.FULL_SCREEN:StageDisplayState.NORMAL, false, StageDisplayEvent.STAGE_DISPLAY_EVENT));
				
				startTimer();
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function get width():Number
		{
			return (video.getTrait(MediaTraitType.SPATIAL) as ISpatial).width;
		}
		
		public function get height():Number
		{
			return (video.getTrait(MediaTraitType.SPATIAL) as ISpatial).height;
		}
		
		// Internals
		//
		
		private var model:Model;
		private var timer:Timer;
		
		private var loader:NetLoader;
		private var video:VideoElement;
		
		private var loadable:ILoadable;
		private var bufferable:IBufferable;
		private var temporal:ITemporal;
		private var playable:IPlayable;
		private var viewable:IViewable;
		private var spatial:ISpatial;
		
		private function startTimer():void
		{
			if (timer == null)
			{
				timer = new Timer(model.interval);
				timer.addEventListener(TimerEvent.TIMER, onTimerTick);
				timer.start();
			}
		}
		
		private function stopTimer():void
		{
			if (timer != null)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimerTick);
				timer = null;
			}
		}
		
		private function onTimerTick(event:TimerEvent):void
		{
			var stream:NetStream = loadable.loadedContext["stream"];
			var poll:PerformancePoll 
				= new PerformancePoll
					( temporal ? temporal.position : 0
					, stream.currentFPS
					, model.videoID
					, bufferable ? bufferable.bufferLength : 0
					, stream.bytesTotal > 0 && stream.bytesTotal == stream.bytesLoaded
					);
			
			model.addPoll(poll);
		}
		
		private function loadVideo():Boolean
		{
			var result:Boolean = false;
			
			loader = new NetLoader()
			video = new VideoElement(loader,new URLResource(model.videoURL));
			
			loadable = video.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			if (loadable != null)
			{
				loadable.addEventListener
					( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
					, onLoadableStateChange
					);
					
				loadable.load();
				
				result = true;
			}
			
			return result;
		}
		
		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			switch (event.newState)
			{
				case LoadState.LOADED:
					
					temporal = video.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
					temporal.addEventListener(TraitEvent.DURATION_REACHED,onPlaybackComplete);
					
					bufferable = video.getTrait(MediaTraitType.BUFFERABLE) as IBufferable;
					bufferable.bufferTime = BUFFER_TIME;
					
					spatial = video.getTrait(MediaTraitType.SPATIAL) as ISpatial;
					spatial.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE,onDimensionsChange);
					
					viewable = video.getTrait(MediaTraitType.VIEWABLE) as IViewable;
					
					dispatchEvent(new StageDisplayObjectEvent(viewable.view));  
					
					playable = video.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
					playable.play();
					
					break;
				
				case LoadState.LOAD_FAILED:
				
					ExternalInterface.call("alert","Failed loading content");
					stopTimer();
					
					break;
			}
		}
		
		private function onDimensionsChange(event:DimensionChangeEvent):void
		{
			viewable.view.width = event.newWidth;
			viewable.view.height = event.newHeight;
		}
		
		private function onPlaybackComplete(event:Event):void
		{
			stopTimer();
			
			var performanceRecord:PerformanceRecord = new PerformanceRecord(model);
			
			var poster:PerformanceRecordPoster = new PerformanceRecordPoster();
			poster.addEventListener(Event.COMPLETE,onPosterComplete);
			poster.post(performanceRecord);
		}
		
		private function onPosterComplete(event:Event):void
		{
			var poster:PerformanceRecordPoster = event.target as PerformanceRecordPoster;
			
			if (poster.succeeded == false)
			{
				ExternalInterface.call("alert","Failed posting data");
			}
		}
	}
}