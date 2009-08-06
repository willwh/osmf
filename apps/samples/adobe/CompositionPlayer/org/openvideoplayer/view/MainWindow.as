/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.openvideoplayer.view
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.events.ListEvent;
	import mx.events.SliderEvent;
	
	import org.openvideoplayer.audio.AudioElement;
	import org.openvideoplayer.composition.ParallelElement;
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.events.DurationChangeEvent;
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.events.MediaErrorEvent;
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.image.ImageElement;
	import org.openvideoplayer.image.ImageLoader;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.version.Version;
	import org.openvideoplayer.video.VideoElement;

	public class MainWindow extends MainWindowLayout
	{
		// Overrides
		//
				
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			// Add button handlers:
			buttonPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
			buttonPause.addEventListener(MouseEvent.CLICK, onPauseClick);
			buttonLoad.addEventListener(MouseEvent.CLICK, onLoadClick);
			
			mediaMenu.dataProvider = getMediaElementNames();
			mediaMenu.addEventListener(ListEvent.CHANGE, onMediaMenuSelect);
			
			panControl.addEventListener(SliderEvent.CHANGE, onPan);
			volumeSlider.addEventListener(SliderEvent.CHANGE, onVolume);
			muteToggle.addEventListener(MouseEvent.CLICK, onToggleMuteClick);
			
			// Add progress timer
			timer.addEventListener(TimerEvent.TIMER, onProgressTimer);
			
			// Get seek requests
			seekBar.addEventListener(SliderEvent.CHANGE, onSeek);
			
			mediaPlayerWrapper.scaleMode = ScaleMode.NONE;
			mediaPlayerWrapper.autoPlay = false;
			
			version.text = "OSMF Version: " + Version.version();
			
			updateControls();
		}
					
		// Internals
		//
		
		private function loadMediaByIndex(index:int):void
		{
			// Stop listening to the current media, if any.
			toggleMediaListeners(mediaPlayerWrapper.element, false);
			
			// Create the new media.
			var media:MediaElement = createMediaElement(index-1);
			
			// Listen for events related to the new media.
			toggleMediaListeners(media, true);
			
			// Set it on our media player.
			mediaPlayerWrapper.element = media;
		}
		
		private function getMediaElementNames():Array
		{
			return ["", "Progressive Video", "Streaming Video", "Image", "Progressive Audio", "Invalid Streaming Video", "Invalid Image", "Serial Composition", "Parallel Composition", "Invalid Serial Composition"];
		}

		private function createMediaElement(index:int):MediaElement
		{
			var mediaElement:MediaElement = null;
			var serialElement:SerialElement;
			if (index == 0)
			{
				mediaElement = new VideoElement(new NetLoader(), new URLResource(new URL(REMOTE_PROGRESSIVE)));
			}
			else if (index == 1)
			{
				mediaElement = new VideoElement(new NetLoader(), new URLResource(new FMSURL(REMOTE_STREAM)));
			}
			else if (index == 2)
			{
				mediaElement = new ImageElement(new ImageLoader(), new URLResource(new URL(REMOTE_IMAGE)));
			}
			else if (index == 3)
			{
				mediaElement = new AudioElement(new NetLoader(), new URLResource(new URL(REMOTE_MP3)));
			}
			else if (index == 4)
			{
				mediaElement = new VideoElement(new NetLoader(), new URLResource(new FMSURL(REMOTE_INVALID_STREAM)));
			}
			else if (index == 5)
			{
				mediaElement = new ImageElement(new ImageLoader(), new URLResource(new URL(REMOTE_INVALID_IMAGE)));
			}
			else if (index == 6)
			{
				serialElement = new SerialElement();
				serialElement.addChild(new VideoElement(new NetLoader(), new URLResource(new URL(REMOTE_PROGRESSIVE)))); 
				serialElement.addChild(new VideoElement(new NetLoader(), new URLResource(new FMSURL(REMOTE_STREAM))));
				mediaElement = serialElement;
			}
			else if (index == 7)
			{
				var parallelElement:ParallelElement = new ParallelElement();
				parallelElement.addChild(new VideoElement(new NetLoader(), new URLResource(new URL(REMOTE_PROGRESSIVE)))); 
				parallelElement.addChild(new VideoElement(new NetLoader(), new URLResource(new FMSURL(REMOTE_STREAM))));
				mediaElement = parallelElement;
			}
			else if (index == 8)
			{
				serialElement = new SerialElement();
				serialElement.addChild(new VideoElement(new NetLoader(), new URLResource(new URL(REMOTE_PROGRESSIVE)))); 
				serialElement.addChild(new VideoElement(new NetLoader(), new URLResource(new FMSURL(REMOTE_INVALID_STREAM))));
				mediaElement = serialElement;
			}			
			return mediaElement;
		}
		
		private function toggleMediaListeners(media:MediaElement,on:Boolean):void
		{
			if (media != null)
			{
				var loadable:ILoadable = media.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				if (loadable)
				{
					if (on)
					{
						loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
					}
					else
					{
						loadable.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
					}
				}
				
				media.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
				media.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
				media.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
			}
		}
		
		// Event Handlers
		//
		
		private function onPan(event:SliderEvent):void
		{
			mediaPlayerWrapper.pan = event.value;
		}
				
		private function onVolume(event:SliderEvent):void
		{
			mediaPlayerWrapper.volume = event.value;
		}

		private function onPlayClick(event:MouseEvent):void
		{
			mediaPlayerWrapper.play();
		}
		
		private function onPauseClick(event:MouseEvent):void
		{
			mediaPlayerWrapper.pause();
		}
		
		private function onToggleMuteClick(event:MouseEvent):void
		{
			mediaPlayerWrapper.muted = muteToggle.selected;
		}
		
		private function onLoadClick(event:MouseEvent):void
		{
			loadMediaByIndex(mediaMenu.selectedIndex);
			
			errorCode.text = errorDescription.text = errorDetail.text = "";
		}
		
		private function onMediaMenuSelect(event:ListEvent):void
		{
			buttonLoad.visible = mediaMenu.selectedIndex > 0;
			
			mediaPlayerWrapper.element = null;
			
			updateControls();
		}
		
		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			loadState.text = event.newState.toString();

			if (event.newState == LoadState.LOADED &&
				mediaPlayerWrapper.element)
			{
				updateControls();
			}
		}
		
		private function updateControls():void
		{
			buttonPlay.visible 			= mediaPlayerWrapper.playable;
			buttonPause.visible 		= mediaPlayerWrapper.pausible;
			audioControls.visible 		= mediaPlayerWrapper.audible;
			seekControls.visible		= mediaPlayerWrapper.seekable;
			bufferable.visible			= mediaPlayerWrapper.bufferable;

			if (mediaPlayerWrapper.temporal)
			{
				mediaPlayerWrapper.addEventListener(DurationChangeEvent.DURATION_CHANGE, onDurationChanged, false, 0, true);
				seekBar.maximum = mediaPlayerWrapper.duration;
				timer.start();
			}
			else
			{
				seekBar.maximum = 0;
				timer.stop();
			}
			
			if (mediaPlayerWrapper.bufferable)
			{
				bufferTime.text = mediaPlayerWrapper.bufferTime.toString();
			}
			else
			{
				bufferTime.text = "";
				bufferLength.text = "";
			}
		}
		
		private function onTraitAdd(event:TraitsChangeEvent):void
		{
			updateControls();
		}

		private function onTraitRemove(event:TraitsChangeEvent):void
		{
			updateControls();
		}
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			errorCode.text = "" + event.error.errorCode;
			errorDescription.text = event.error.description;
			errorDetail.text = event.error.detail;
			
			updateControls();
		}
		
		private function onDurationChanged(event:DurationChangeEvent):void
		{
			seekBar.maximum = event.newDuration;
			duration.text = event.newDuration.toString();
		}
		
		private function onProgressTimer(event:TimerEvent):void
		{
			seekBar.value = mediaPlayerWrapper.temporal ? mediaPlayerWrapper.playhead : 0;
			
			bufferLength.text = mediaPlayerWrapper.bufferable ? mediaPlayerWrapper.bufferLength.toString() : "";
		}

		private function onSeek(event:SliderEvent):void
		{
			if (mediaPlayerWrapper.seekable)
			{
				mediaPlayerWrapper.seek(event.value);
			}	
		}
		
		private var media:MediaElement;
		private var timer:Timer = new Timer(DEFAULT_PROGRESS_DELAY);

		private static const DEFAULT_PROGRESS_DELAY:Number 	= 250; 
		private static const REMOTE_PROGRESSIVE:String 		= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		private static const REMOTE_STREAM:String 			= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
		private static const REMOTE_INVALID_STREAM:String 	= "rtmp://cp67126.fail.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
		private static const REMOTE_IMAGE:String 			= "http://www.adobe.com/ubi/globalnav/include/adobe-lq.png";
		private static const REMOTE_INVALID_IMAGE:String 	= "http://www.adobe.com/ubi/globalnav/include/fail.png";
		private static const REMOTE_MP3:String 				= "http://mediapm.edgesuite.net/osmf/content/test/train_1500.mp3";
	}
}
