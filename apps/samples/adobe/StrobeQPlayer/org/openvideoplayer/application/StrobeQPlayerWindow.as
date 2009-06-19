package org.openvideoplayer.application
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import org.openvideoplayer.audio.AudioElement;
	import org.openvideoplayer.display.*;
	import org.openvideoplayer.events.BufferTimeChangeEvent;
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.events.PlayheadChangeEvent;
	import org.openvideoplayer.events.VolumeChangeEvent;
	import org.openvideoplayer.image.ImageElement;
	import org.openvideoplayer.image.ImageLoader;
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.media.*;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.IAudible;
	import org.openvideoplayer.traits.IBufferable;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IPausible;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.ISeekable;
	import org.openvideoplayer.traits.ISpatial;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.version.Version;
	import org.openvideoplayer.video.*;
	import org.openvideoplayer.view.MediaQPlayerWrapper;
	
	

	
	public class StrobeQPlayerWindow extends StrobeQPlayerWindowLayout
	{
		public function StrobeQPlayerWindow()
		{
			super();
				
		}
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();		

			initWrapper();					
			factory = new MediaFactory();
			registerMedia(factory);
			
			mediaControlPanel.loadBtn.addEventListener(MouseEvent.CLICK, onLoadMedia);	
			mediaControlPanel.unloadBtn.addEventListener(MouseEvent.CLICK, onUnLoadMedia);
			
			mediaControlPanel.mediaBtns.playBtn.addEventListener(MouseEvent.CLICK, onPlayBtn);
			mediaControlPanel.mediaBtns.pauseBtn.addEventListener(MouseEvent.CLICK, onPauseBtn);
			mediaControlPanel.mediaBtns.stopBtn.addEventListener(MouseEvent.CLICK, onStopBtn);
			mediaControlPanel.mediaBtns.resumeBtn.addEventListener(MouseEvent.CLICK, onResumeBtn);
			mediaControlPanel.mediaBtns.volumeBar.addEventListener(Event.CHANGE, onVolume);
			mediaControlPanel.mediaBtns.muteToggleBtn.addEventListener(MouseEvent.CLICK, onMuteToggleBtn);
			mediaControlPanel.mediaBtns.panSlider.addEventListener(Event.CHANGE, onPan);
						
			mediaControlPanel.progressBars.scrubBar.addEventListener(Event.CHANGE, onScrubBar);
			mediaControlPanel.progressBars.seekBar.addEventListener(Event.CHANGE, onSeekBar);
			mediaControlPanel.progressBars.seekBar.dataTipFormatFunction = displaySeekToolTip;
			
			mediaControlPanel.viewableControlPanel.scaleModeCombo.addEventListener(Event.CLOSE, onScaleMode);

	
			fplayerVer.text = FLASHPLAYER_VERSION + Capabilities.version   
			frameworkVer.text = STROBE_FRAMEWORK_VERION + ": " + Version.version();
			qplayerkVer.text = qplayerVerion();
			
			invalidateDisplayList();
			
		}
				
		
		private function registerMedia(factory:IMediaFactory):void
		{
			
			loader = new NetLoader();
			factory.addMediaInfo
				( new MediaInfo
					( "audio"
					, loader as IMediaResourceHandler
					, AudioElement
					, [NetLoader]
				 	)
				);
				
			loader = new ImageLoader();
			factory.addMediaInfo
				( new MediaInfo
					( "image"
					, loader as IMediaResourceHandler
					, ImageElement
					, [ImageLoader]
					)
				);
			
			// Video should be the last one to register, for it accepts
			// any URL as a valid URL for video. Registering it first,
			// results in sounds (.mp3 postfixed urls) to get treated as
			// videos too. 
			
			var loader:ILoader = new NetLoader();
			
			factory.addMediaInfo
				( new MediaInfo
					( "video"
					, loader as IMediaResourceHandler
					, VideoElement
					, [NetLoader]
					)
				);
	
		}
		

		
		private function videoHandleResource(urlResource:IURLResource):Boolean
		{
			var result:Boolean = false;
			
			if (urlResource != null && urlResource.url)
			{
				var url:String = urlResource.url.toLocaleLowerCase();
					
				if (url.lastIndexOf(".flv") == (url.length - 4)  || url.lastIndexOf(".mov") == (url.length - 4))
				{
					result = true;
				}
			}
			
			return result;
		}
		
		
		private function loadMediaByURL(url:IURLResource):void
		{						
			if(videoHandleResource(url))
			{
			//Vidoe Element takes url as param. Other MediaType doesn't need to.
				media = new VideoElement(new NetLoader(), url );
			}	
			else
			{
				media = factory.createMediaElement(url);
			}
						
			if(media != null)
			{								
				if(media.hasTrait(MediaTraitType.LOADABLE))
				{
					media.getTrait(MediaTraitType.LOADABLE).addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableState);					
				}								
			}
		 	
		 	createElement(media);			
		}
		


		private function onLoadableState(event:LoadableStateChangeEvent):void
		{
			var log:String = event.newState.toString();
			if(event.newState == LoadState.LOADED)
			{
						mediaControlPanel.mediaBtns.visible = true;
						mediaControlPanel.viewableControlPanel.visible = true;
						mediaControlPanel.progressBars.visible = true;
						mediaControlPanel.progressBars.progressBar.maximum = 0;
			}

			mediaControlPanel.loadStateTxt.text = log.toString();
		}
		
				
				
		private function onLoadMedia(event:MouseEvent):void
		{	
			var url:String = mediaControlPanel.urlInput.text;
			if(url.length > 0)
			{							
				loadMediaByURL(new URLResource(url));
			}
		}
		
		
		protected function initWrapper():void
		{
			wrapperPlayer = new MediaQPlayerWrapper();
			this.addChildAt(wrapperPlayer, 0);
			wrapperPlayer.percentHeight = 100;
			wrapperPlayer.percentWidth = 100;
			wrapperPlayer.scaleMode = ScaleMode.NONE;
		}
		
		
		protected function createElement(media:MediaElement):void
		{
			wrapperPlayer.autoPlay = false;
			if(wrapperPlayer && media)
			{
				wrapperPlayer.element = media;
			}
		}

		
		protected function onUnLoadMedia(event:MouseEvent):void
		{
			if(wrapperPlayer)
			{
				wrapperPlayer.element = null;
			}
		}
		
		protected function onVolumeChanged(event:VolumeChangeEvent):void
		{
			wrapperPlayer.volume = event.newVolume;
			mediaControlPanel.mediaBtns.volumeBar.value = event.newVolume;
		}
		
				
		/*
		protected function onBufferChanged(event:BufferingChangeEvent):void
		{
			trace("buffering change" + event.buffering.toString());
			if(wrapperPlayer.buffering != event.buffering)
			{
				wrapperPlayer.buffering = event.buffering;
			}
		}*/
		

		
		protected function onBufferTimeChanged(event:BufferTimeChangeEvent):void
		{
			if(wrapperPlayer.bufferTime!= event.newTime)
			{
				wrapperPlayer.bufferTime = event.newTime;
			}
		}
		

					
		protected function onPlayBtn(event:MouseEvent):void
		{
			if(media)
			{	
				if(media.hasTrait(MediaTraitType.PLAYABLE))
				{
					wrapperPlayer.addEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, checkprogress);
					wrapperPlayer.play();
				}								
			}
		}
		
		
		protected function onPauseBtn(event:MouseEvent):void
		{
			if(media != null)
			{
				if(media.hasTrait(MediaTraitType.PAUSIBLE))
				{	
					wrapperPlayer.pause();
				}
			}
		}
		
		
		protected function onStopBtn(event:MouseEvent):void
		{
			if(media != null)
			{
			    if(media.hasTrait(MediaTraitType.PAUSIBLE))
			    {
			    	wrapperPlayer.pause();
			    }
			}
		}
		
		
		protected function onResumeBtn(event:MouseEvent):void
		{
			if(media != null)
			{
				if(media.hasTrait(MediaTraitType.PLAYABLE))
				{
					wrapperPlayer.play();
				}				
			}
		}
		
		protected function onScrubBar(event:Event):void
		{
			wrapperPlayer.seek(event.target.value);
			mediaControlPanel.progressBars.playHeadTxt.text = event.target.value.toString();
		}
		
		protected function onSeekBar(event:Event):void
		{
			var pos:Number = event.target.value;
			wrapperPlayer.seek(mediaControlPanel.progressBars.progressBar.maximum*pos/100);
			
		}
		
		
		protected function onVolume(event:Event):void
		{	
			if(media.hasTrait(MediaTraitType.AUDIBLE))
			{
				wrapperPlayer.volume = event.target.value;		
			}
			mediaControlPanel.mediaBtns.volumeTxt.text = event.target.value.toString();
			
		}
		
		
		protected function onPan(event:Event):void
		{
			if(media.hasTrait(MediaTraitType.AUDIBLE))
			{
				wrapperPlayer.pan = event.target.value;
			}
		}

		
	
		protected function onMuteToggleBtn(event:MouseEvent):void
		{
			if(media.hasTrait(MediaTraitType.AUDIBLE))
			{
				muted = !muted;
				wrapperPlayer.muted = muted;
			}
		}

		protected function onScaleMode(event:Event):void
		{
			var scaleMode:String = event.target.selectedItem.toString();
			
			switch(scaleMode)
			{
				case "LETTERBOX":
					wrapperPlayer.scaleMode = ScaleMode.LETTERBOX;
					break;
				case "STRETCH":
					wrapperPlayer.scaleMode = ScaleMode.STRETCH;
					break;
				case "CROP":
					wrapperPlayer.scaleMode = ScaleMode.CROP;
					break;
				case "NONE":
					wrapperPlayer.scaleMode = ScaleMode.NONE;
					break;					
			}
			mediaControlPanel.viewableControlPanel.screenWidth.text = wrapperPlayer.width.toString();
			mediaControlPanel.viewableControlPanel.screenHeight.text = wrapperPlayer.height.toString();
			
		}
		
		protected function checkprogress(event:PlayheadChangeEvent):void
		{
			  mediaControlPanel.progressBars.durationTxt.text = wrapperPlayer.duration.toString();
			  mediaControlPanel.progressBars.playHeadTxt.text = wrapperPlayer.playhead.toString();
			  
			  mediaControlPanel.progressBars.progressBar.maximum = wrapperPlayer.duration;
			  
			  mediaControlPanel.progressBars.scrubBar.maximum = wrapperPlayer.duration;
			  mediaControlPanel.progressBars.scrubBar.value   = wrapperPlayer.playhead;
			  
			  if(wrapperPlayer.playhead)
			  {
				mediaControlPanel.progressBars.progressBar.setProgress(wrapperPlayer.playhead, mediaControlPanel.progressBars.progressBar.maximum);
				if(wrapperPlayer.bufferable) //Not all media is bufferable!
				{
					mediaControlPanel.progressBars.progressBar.label = "Playing %3%%: position at "+ numberFormatter.format(wrapperPlayer.playhead) 
							+ " bufferLength:" + numberFormatter.format(wrapperPlayer.bufferLength);
				}
			  }
		}
	
	   /*
	   	This is a formatter function called by numberFormatter.
	   */
		private function displaySeekToolTip(value:Number):String
		{
			return numberFormatter.format(mediaControlPanel.progressBars.progressBar.maximum*value/100);
		}
		

		
		private function qplayerVerion():String
		{
			return QPLAYER_VERION + ": Sprint3";
		}
		
		
		private var factory:IMediaFactory;		
		private var loadable:ILoadable;
		private var media:MediaElement;
		private var playable:IPlayable;
		private var pausible:IPausible;
		private var viewable:IViewable;
		private var spatial:ISpatial;
		private var seekable:ISeekable;
		private var audible:IAudible;
		private var bufferable:IBufferable;
		private var muted:Boolean;
		
		private var wrapperPlayer:MediaQPlayerWrapper;
		
		public static const FLASHPLAYER_VERSION:String = "FlashPlayer Version";
		public static const STROBE_FRAMEWORK_VERION:String = "FrameWork Version";
		public static const QPLAYER_VERION:String = "QPlayer Version";
	}
}
