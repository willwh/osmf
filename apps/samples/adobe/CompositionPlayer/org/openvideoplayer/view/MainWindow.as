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
	
	import mx.events.MenuEvent;
	import mx.events.SliderEvent;
	
	import org.openvideoplayer.audio.AudioElement;
	import org.openvideoplayer.composition.ParallelElement;
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.events.DurationChangeEvent;
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.image.ImageElement;
	import org.openvideoplayer.image.ImageLoader;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaPlayer;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.IBufferable;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.video.VideoElement;
	import org.openvideoplayer.version.Version;

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
					
			buttonLoad.addEventListener(MenuEvent.ITEM_CLICK, onLoadClick);
			buttonLoad.dataProvider = getMediaElementNames();
			
			panControl.addEventListener(SliderEvent.CHANGE, onPan);
			volumeSlider.addEventListener(SliderEvent.CHANGE, onVolume);
			muteToggle.addEventListener(MouseEvent.CLICK, onToggleMuteClick);
			
			// Get a reference to our player:
			player = flexMediaPlayer.mediaPlayer;
			
			//Add progress timer
			timer.addEventListener(TimerEvent.TIMER, onProgressTimer);
			
			//Get seek requests
			seekBar.addEventListener(SliderEvent.CHANGE, onSeek);
			
			version.text = "Strobe version: " + Version.version();
		}
					
		// Internals
		//
		
		private function loadMediaByIndex(index:int):void
		{
			// Stop listening to the current media, if any.
			toggleMediaListeners(player.source, false);
			
			// Create the new media.
			var media:MediaElement = createMediaElement(index);
			
			// Listen for events related to the new media.
			toggleMediaListeners(media, true);
			
			// Set it on our media player.
			flexMediaPlayer.viewableSprite.source = media;
		}
		
		private function getMediaElementNames():Array
		{
			return ["Progressive Video", "Streaming Video", "Image", "Progressive Audio", "Serial Composition", "Parallel Composition"];
		}

		private function createMediaElement(index:int):MediaElement
		{
			var mediaElement:MediaElement = null;
			
			if (index == 0)
			{
				mediaElement = new VideoElement(new NetLoader(), new URLResource(REMOTE_PROGRESSIVE));
			}
			else if (index == 1)
			{
				mediaElement = new VideoElement(new NetLoader(), new URLResource(REMOTE_STREAM));
			}
			else if (index == 2)
			{
				mediaElement = new ImageElement(new ImageLoader(), new URLResource(REMOTE_IMAGE));
			}
			else if (index == 3)
			{
				mediaElement = new AudioElement(new NetLoader(), new URLResource(REMOTE_MP3));
			}
			else if (index == 4)
			{
				var serialElement:SerialElement = new SerialElement();
				serialElement.addChild(new VideoElement(new NetLoader(), new URLResource(REMOTE_PROGRESSIVE))); 
				serialElement.addChild(new VideoElement(new NetLoader(), new URLResource(REMOTE_STREAM)));
				mediaElement = serialElement;
			}
			else if (index == 5)
			{
				var parallelElement:ParallelElement = new ParallelElement();
				parallelElement.addChild(new VideoElement(new NetLoader(), new URLResource(REMOTE_PROGRESSIVE))); 
				parallelElement.addChild(new VideoElement(new NetLoader(), new URLResource(REMOTE_STREAM)));
				mediaElement = parallelElement;
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
			}
		}
		
		// Event Handlers
		//
		
		private function onPan(event:SliderEvent):void
		{
			player.pan = event.value;
		}
				
		private function onVolume(event:SliderEvent):void
		{
			player.volume = event.value;
		}

		private function onPlayClick(event:MouseEvent):void
		{
			player.play();
		}
		
		private function onPauseClick(event:MouseEvent):void
		{
			player.pause();
		}
		
		private function onToggleMuteClick(event:MouseEvent):void
		{
			//player.muted = muteToggle.selected;
		}
		
		private function onLoadClick(event:MenuEvent):void
		{
			loadMediaByIndex(event.index);
		}
		
		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			loadState.text = event.newState.toString();

			if (event.newState == LoadState.LOADED &&
				player.source)
			{
				updateControls();
			}
		}
		
		private function updateControls():void
		{
			buttonPlay.visible 			= player.source.hasTrait(MediaTraitType.PLAYABLE);
			buttonPause.visible 		= player.source.hasTrait(MediaTraitType.PAUSIBLE);
			audioControls.visible 		= player.source.hasTrait(MediaTraitType.AUDIBLE);
			seekControls.visible		= player.source.hasTrait(MediaTraitType.SEEKABLE);

			var temporal:ITemporal = player.source.getTrait(MediaTraitType.TEMPORAL) as ITemporal; 
			if (temporal)
			{
				temporal.addEventListener(DurationChangeEvent.DURATION_CHANGE, onDurationChanged, false, 0, true);
				seekBar.maximum = temporal.duration;
				timer.start();
			}
			else
			{
				seekBar.maximum = 0;
				timer.stop();
			}
			var bufferable:IBufferable = player.source.getTrait(MediaTraitType.BUFFERABLE) as IBufferable;
			if (bufferable != null)
			{
				bufferTime.text = bufferable.bufferTime.toString();
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
		
		private function onDurationChanged(event:DurationChangeEvent):void
		{
			seekBar.maximum = event.newDuration;
			duration.text = event.newDuration.toString();
		}
		
		private function onProgressTimer(event:TimerEvent):void
		{
			var temporal:ITemporal = player.source.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			seekBar.value = temporal ? temporal.position : 0;
			
			var bufferable:IBufferable = player.source.getTrait(MediaTraitType.BUFFERABLE) as IBufferable;
			bufferLength.text = bufferable ? bufferable.bufferLength.toString() : "";
		}

		private function onSeek(event:SliderEvent):void
		{
			if (player.seekable)
			{
				player.seek(event.value);
			}	
		}
		
		private var media:MediaElement;
		private var player:MediaPlayer;
		private var timer:Timer = new Timer(DEFAULT_PROGRESS_DELAY);

		private static const DEFAULT_PROGRESS_DELAY:Number 	= 250; 
		private static const REMOTE_PROGRESSIVE:String 		= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		private static const REMOTE_STREAM:String 			= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
		private static const REMOTE_IMAGE:String 			= "http://www.adobe.com/ubi/globalnav/include/adobe-lq.png";
		private static const REMOTE_MP3:String 				= "http://flipside.corp.adobe.com/brian/strobe/media/Remember.mp3";
	}
}
