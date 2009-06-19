package org.openvideoplayer.view.wrapper
{
	import org.openvideoplayer.application.StrobeQPlayerWindow;
	import org.openvideoplayer.*;
	import org.openvideoplayer.display.MediaElementSprite;
	import org.openvideoplayer.display.MediaPlayerSprite;
	import org.openvideoplayer.display.ScalableSprite;
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.video.VideoElement;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.events.PlayheadChangeEvent;
	import org.openvideoplayer.events.BufferTimeChangeEvent;
	import org.openvideoplayer.events.VolumeChangeEvent;
		
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MediaPlayerUIWrapper extends StrobeQPlayerWindow
	{
	
	
		public function MediaPlayerUIWrapper()
		{
		}
		
		override protected function childrenCreated():void
		{
			mediaPlayerWrapper = new MediaPlayerSprite();
			super.childrenCreated();
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);	
		}
		
		
		
		override protected function initWrapper():void
		{
			if(mediaPlayerWrapper)
			{
				//uic.removeChild(mediaPlayerWrapper);
			}
			 
			mediaPlayerWrapper.scaleMode = ScaleMode.LETTERBOX;	
			uic.addChildAt(mediaPlayerWrapper,0);		
	//		mediaPlayerWrapper.setAvailableSize(stage.stageWidth, stage.stageHeight);
		}
		
		private function onStage(event:Event):void
		{			
		    stage..scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
		}
		
		private function onResize(event:Event):void
		{	
			if (mediaPlayerWrapper)
			{			
				mediaPlayerWrapper.setAvailableSize(stage.stageWidth, stage.stageHeight);		
			}	
		}
		
		override protected function createElement(media:MediaElement):void
		{
			mediaPlayerWrapper.element = media;
			mediaPlayerWrapper.mediaPlayer.autoPlay = false;
		}
		
		
		override protected function onPlayBtn(event:MouseEvent):void
		{
			if(mediaPlayerWrapper.element.hasTrait(MediaTraitType.PLAYABLE))
			{
				mediaPlayerWrapper.mediaPlayer.addEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, checkprogress);

				mediaPlayerWrapper.mediaPlayer.play();
			}									
		}
		
		override protected function onPauseBtn(event:MouseEvent):void
		{
			if(mediaPlayerWrapper.element.hasTrait(MediaTraitType.PAUSIBLE))
			{
				mediaPlayerWrapper.mediaPlayer.pause();
			}									
		}		
		
		override protected function onStopBtn(event:MouseEvent):void
		{
			onPauseBtn(event);
		}
		
		
		override protected function onResumeBtn(event:MouseEvent):void
		{
			onPlayBtn(event);
		}

		
		override protected function onUnLoadMedia(event:MouseEvent):void
		{
			if(mediaPlayerWrapper.mediaPlayer)
			{
				mediaPlayerWrapper.element = null;
			}
		}
		
		override protected function onVolumeChanged(event:VolumeChangeEvent):void
		{
			mediaPlayerWrapper.mediaPlayer.volume = event.newVolume;
			mediaControlPanel.mediaBtns.volumeBar.value = event.newVolume;
		}
	
		
		override protected function onBufferTimeChanged(event:BufferTimeChangeEvent):void
		{
			if(mediaPlayerWrapper.mediaPlayer.bufferTime!= event.newTime)
			{
				mediaPlayerWrapper.mediaPlayer.bufferTime = event.newTime;
			}
		}
		
		

		
		override protected function onScrubBar(event:Event):void
		{
			mediaPlayerWrapper.mediaPlayer.seek(event.target.value);
			mediaControlPanel.progressBars.playHeadTxt.text = event.target.value.toString();
		}
		
		override protected function onSeekBar(event:Event):void
		{
			var pos:Number = event.target.value;
			mediaPlayerWrapper.mediaPlayer.seek(mediaControlPanel.progressBars.progressBar.maximum*pos/100);
			
		}
		
		
		override protected function onVolume(event:Event):void
		{	
			if(mediaPlayerWrapper.mediaPlayer.audible)
			{
				mediaPlayerWrapper.mediaPlayer.volume = event.target.value;		
			}
			mediaControlPanel.mediaBtns.volumeTxt.text = event.target.value.toString();
			
		}
		
		
		override protected function onPan(event:Event):void
		{
			if(mediaPlayerWrapper.mediaPlayer.audible)
			{
				mediaPlayerWrapper.mediaPlayer.pan = event.target.value;
			}
		}

		
	
		override protected function onMuteToggleBtn(event:MouseEvent):void
		{
			if(mediaPlayerWrapper.mediaPlayer.audible)
			{
				mediaPlayerWrapper.mediaPlayer.muted = !mediaPlayerWrapper.mediaPlayer.muted;
			}
		}

		override protected function onScaleMode(event:Event):void
		{
			var scaleMode:String = event.target.selectedItem.toString();
			
			switch(scaleMode)
			{
				case "LETTERBOX":
					mediaPlayerWrapper.scaleMode = ScaleMode.LETTERBOX;
					break;
				case "STRETCH":
					mediaPlayerWrapper.scaleMode = ScaleMode.STRETCH;
					break;
				case "CROP":
					mediaPlayerWrapper.scaleMode = ScaleMode.CROP;
					break;
				case "NONE":
					mediaPlayerWrapper.scaleMode = ScaleMode.NONE;
					break;					
			}
			mediaControlPanel.viewableControlPanel.screenWidth.text = mediaPlayerWrapper.width.toString();
			mediaControlPanel.viewableControlPanel.screenHeight.text = mediaPlayerWrapper.height.toString();
			
		}
		
		override protected function checkprogress(event:PlayheadChangeEvent):void
		{
			  mediaControlPanel.progressBars.durationTxt.text = mediaPlayerWrapper.mediaPlayer.duration.toString();
			  mediaControlPanel.progressBars.playHeadTxt.text = mediaPlayerWrapper.mediaPlayer.playhead.toString();
			  
			  mediaControlPanel.progressBars.progressBar.maximum = mediaPlayerWrapper.mediaPlayer.duration;
			  
			  mediaControlPanel.progressBars.scrubBar.maximum = mediaPlayerWrapper.mediaPlayer.duration;
			  mediaControlPanel.progressBars.scrubBar.value   = mediaPlayerWrapper.mediaPlayer.playhead;
			  
			  if(mediaPlayerWrapper.mediaPlayer.playhead)
			  {
				mediaControlPanel.progressBars.progressBar.setProgress(mediaPlayerWrapper.mediaPlayer.playhead, mediaControlPanel.progressBars.progressBar.maximum);
				if(mediaPlayerWrapper.mediaPlayer.bufferable) //Not all media is bufferable!
				{
					mediaControlPanel.progressBars.progressBar.label = "Playing %3%%: position at "+ numberFormatter.format(mediaPlayerWrapper.mediaPlayer.playhead) 
							+ " bufferLength:" + numberFormatter.format(mediaPlayerWrapper.mediaPlayer.bufferLength);
				}
			  }
		}	
		
		private var mediaPlayerWrapper:MediaPlayerSprite;

	}
}