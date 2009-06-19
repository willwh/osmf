package org.openvideoplayer.view.wrapper
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openvideoplayer.application.StrobeQPlayerWindow;
	import org.openvideoplayer.display.MediaElementSprite;
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.events.PlayheadChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.IAudible;
	import org.openvideoplayer.traits.IBufferable;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IPausible;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.ISeekable;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.MediaTraitType;

	
	public class MediaElementUIWrapper extends StrobeQPlayerWindow
	{
		public function MediaElementUIWrapper()
		{

		}
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			addEventListener(Event.ADDED_TO_STAGE, onStage);		
		}
		
		override protected function initWrapper():void
		{
			mediaElementWrapper = new MediaElementSprite();
			
			mediaElementWrapper.scaleMode = ScaleMode.NONE;
			uic.addChildAt(mediaElementWrapper, 0);
			mediaElementWrapper.setAvailableSize(stage.stageWidth, stage.stageHeight);
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
			if (mediaElementWrapper)
			{			
				mediaElementWrapper.setAvailableSize(stage.stageWidth, stage.stageHeight);		
			}	
		}
		
	
		override protected function createElement(media:MediaElement):void
		{
			this.media = media;
			mediaElementWrapper.element = media;
			if(media.hasTrait(MediaTraitType.LOADABLE))
			{
				(media.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();
			}
		}

		override protected function onPlayBtn(event:MouseEvent):void
		{
				if (mediaElementWrapper.element.hasTrait(MediaTraitType.PLAYABLE))
				{
					(mediaElementWrapper.element.getTrait(MediaTraitType.PLAYABLE) as IPlayable).play();
				}
		}
		
	
		override protected function onPauseBtn(event:MouseEvent):void
		{
			if(media != null)
			{
				if(media.hasTrait(MediaTraitType.PAUSIBLE))
				{	
					(mediaElementWrapper.element.getTrait(MediaTraitType.PAUSIBLE) as IPausible).pause();
				}
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
		
		override protected function onScrubBar(event:Event):void
		{
			(mediaElementWrapper.element.getTrait(MediaTraitType.SEEKABLE) as ISeekable).seek(event.target.value);
			mediaControlPanel.progressBars.playHeadTxt.text = event.target.value.toString();
		}
		
		override protected function onSeekBar(event:Event):void
		{
			var pos:Number = event.target.value;
			(media.getTrait(MediaTraitType.SEEKABLE) as ISeekable).seek(mediaControlPanel.progressBars.progressBar.maximum*pos/100);
			
		}
		
		
		override protected function onVolume(event:Event):void
		{	
			if(media.hasTrait(MediaTraitType.AUDIBLE))
			{
				(mediaElementWrapper.element.getTrait(MediaTraitType.AUDIBLE) as IAudible).volume = event.target.value;		
			}
			mediaControlPanel.mediaBtns.volumeTxt.text = event.target.value.toString();
			
		}
		
		
		override protected function onPan(event:Event):void
		{
			if(media.hasTrait(MediaTraitType.AUDIBLE))
			{
				(mediaElementWrapper.element.getTrait(MediaTraitType.AUDIBLE) as IAudible).pan = event.target.value;
			}
		}

		
	
		override protected function onMuteToggleBtn(event:MouseEvent):void
		{
			if(media.hasTrait(MediaTraitType.AUDIBLE))
			{
				(mediaElementWrapper.element.getTrait(MediaTraitType.AUDIBLE) as IAudible).muted = !(mediaElementWrapper.element.getTrait(MediaTraitType.AUDIBLE) as IAudible).muted;
			}
		}

		override protected function onScaleMode(event:Event):void
		{
			var scaleMode:String = event.target.selectedItem.toString();
			
			switch(scaleMode)
			{
				case "LETTERBOX":
					mediaElementWrapper.scaleMode = ScaleMode.LETTERBOX;
					break;
				case "STRETCH":
					mediaElementWrapper.scaleMode = ScaleMode.STRETCH;
					break;
				case "CROP":
					mediaElementWrapper.scaleMode = ScaleMode.CROP;
					break;
				case "NONE":
					mediaElementWrapper.scaleMode = ScaleMode.NONE;
					break;					
			}
			mediaControlPanel.viewableControlPanel.screenWidth.text = mediaElementWrapper.width.toString();
			mediaControlPanel.viewableControlPanel.screenHeight.text = mediaElementWrapper.height.toString();
			
		}
		
		override protected function checkprogress(event:PlayheadChangeEvent):void
		{
			  var elementPlayhead:Number = (mediaElementWrapper.element.getTrait(MediaTraitType.TEMPORAL) as ITemporal).position;
			 
			  mediaControlPanel.progressBars.durationTxt.text = (mediaElementWrapper.element.getTrait(MediaTraitType.TEMPORAL) as ITemporal).duration.toString();
			  mediaControlPanel.progressBars.playHeadTxt.text = elementPlayhead.toString();
			  
			  mediaControlPanel.progressBars.progressBar.maximum = (mediaElementWrapper.element.getTrait(MediaTraitType.TEMPORAL) as ITemporal).duration;
			  
			  mediaControlPanel.progressBars.scrubBar.maximum = (mediaElementWrapper.element.getTrait(MediaTraitType.TEMPORAL) as ITemporal).duration;
			  mediaControlPanel.progressBars.scrubBar.value   = elementPlayhead;
			  
			  if(elementPlayhead)
			  {
				mediaControlPanel.progressBars.progressBar.setProgress(elementPlayhead, mediaControlPanel.progressBars.progressBar.maximum);
				if(mediaElementWrapper.element.hasTrait(MediaTraitType.BUFFERABLE)) //Not all media is bufferable!
				{
					mediaControlPanel.progressBars.progressBar.label = "Playing %3%%: position at "+ numberFormatter.format(elementPlayhead) 
							+ " bufferLength:" + numberFormatter.format((mediaElementWrapper.element.getTrait(MediaTraitType.BUFFERABLE) as IBufferable).bufferLength);
				}
			  }
		}		
		
		private var mediaElementWrapper:MediaElementSprite;
		private var media:MediaElement;

	}
}