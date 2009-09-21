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
	
	import mx.events.ListEvent;
	import mx.events.SliderEvent;
	
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.events.BufferTimeChangeEvent;
	import org.openvideoplayer.events.DurationChangeEvent;
	import org.openvideoplayer.events.MediaErrorEvent;
	import org.openvideoplayer.events.MediaPlayerCapabilityChangeEvent;
	import org.openvideoplayer.events.MediaPlayerStateChangeEvent;
	import org.openvideoplayer.events.MutedChangeEvent;
	import org.openvideoplayer.events.PlayheadChangeEvent;
	import org.openvideoplayer.examples.AllExamples;
	import org.openvideoplayer.examples.Example;
	import org.openvideoplayer.version.Version;
	
	public class MainWindow extends MainWindowLayout
	{
		// Overrides
		//
				
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			// Set up our list of examples.
			//
			
			examples = AllExamples.examples;
			exampleList.dataProvider = examples;
			exampleList.labelField = "name";
			
			// Add UI event handlers.
			//

			exampleList.addEventListener(ListEvent.CHANGE, onExampleListSelect);
			
			buttonPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
			buttonPause.addEventListener(MouseEvent.CLICK, onPauseClick);
			
			panControl.addEventListener(SliderEvent.CHANGE, onPan);
			volumeSlider.addEventListener(SliderEvent.CHANGE, onVolume);
			muteToggle.addEventListener(MouseEvent.CLICK, onToggleMuteClick);
			
			seekBar.addEventListener(SliderEvent.CHANGE, onSeek);
			
			// Add MediaPlayer event handlers.
			//
			
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE, onCapabilityChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.BUFFERABLE_CHANGE, onCapabilityChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.LOADABLE_CHANGE, onCapabilityChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PAUSABLE_CHANGE, onCapabilityChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE, onCapabilityChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.SEEKABLE_CHANGE, onCapabilityChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE, onCapabilityChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.TEMPORAL_CHANGE, onCapabilityChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE, onCapabilityChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);

			mediaPlayerWrapper.mediaPlayer.addEventListener(DurationChangeEvent.DURATION_CHANGE, onDurationChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, onPlayheadChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(MutedChangeEvent.MUTED_CHANGE, onMutedChange);
			mediaPlayerWrapper.mediaPlayer.addEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE, onBufferTimeChange);

			// Set up the MediaPlayer.
			//
			
			mediaPlayerWrapper.scaleMode = ScaleMode.NONE;
			mediaPlayerWrapper.mediaPlayer.autoPlay = false;
			mediaPlayerWrapper.mediaPlayer.autoRewind = false;

			// Sync the UI to the current (empty) state.
			//
			
			updateControls();

			version.text = "OSMF Version: " + Version.version();
		}
					
		// UI Event Handlers
		//
		
		private function onPan(event:SliderEvent):void
		{
			mediaPlayerWrapper.mediaPlayer.pan = event.value;
		}
				
		private function onVolume(event:SliderEvent):void
		{
			mediaPlayerWrapper.mediaPlayer.volume = event.value;
		}

		private function onPlayClick(event:MouseEvent):void
		{
			mediaPlayerWrapper.mediaPlayer.play();
		}
		
		private function onPauseClick(event:MouseEvent):void
		{
			mediaPlayerWrapper.mediaPlayer.pause();
		}
		
		private function onToggleMuteClick(event:MouseEvent):void
		{
			mediaPlayerWrapper.mediaPlayer.muted = muteToggle.selected;
		}
		
		private function onSeek(event:SliderEvent):void
		{
			if (mediaPlayerWrapper.mediaPlayer.seekable)
			{
				mediaPlayerWrapper.mediaPlayer.seek(event.value);
			}	
		}

		private function onExampleListSelect(event:ListEvent):void
		{
			if (example != null)
			{
				example.dispose();
			}
			
			if (exampleList.selectedIndex >= 0)
			{
				example = examples[exampleList.selectedIndex] as Example;
				
				mediaPlayerWrapper.element = example.mediaElement;
				exampleDescription.text = example.description;
			}
			else
			{
				mediaPlayerWrapper.element = null;
				exampleDescription.text = "";
			}
			
			errorCodeBox.visible = errorDescriptionBox.visible = errorDetailBox.visible = false;
			errorCode.text = errorDescription.text = errorDetail.text = "";
			duration.text = "";
			
			updateControls();
		}

		// MediaPlayer Event Handlers
		//
		
		private function onStateChange(event:MediaPlayerStateChangeEvent):void
		{
			stateControls.visible = true;
			playerState.text = event.newState.name;
		}
		
		private function onCapabilityChange(event:MediaPlayerCapabilityChangeEvent):void
		{
			updateControls();
		}

		private function onMediaError(event:MediaErrorEvent):void
		{
			errorCodeBox.visible = errorDescriptionBox.visible = errorDetailBox.visible = true;
			
			errorCode.text = "" + event.error.errorCode;
			errorDescription.text = event.error.description;
			errorDetail.text = event.error.detail;
			
			updateControls();
		}
		
		private function onDurationChange(event:DurationChangeEvent):void
		{
			seekBar.maximum = event.newDuration;
			duration.text = "" + Math.round(event.newDuration);
		}

		private function onPlayheadChange(event:PlayheadChangeEvent):void
		{
			position.text = "" + Math.round(event.newPosition);

			seekBar.value = 	mediaPlayerWrapper.mediaPlayer.temporal
							? 	mediaPlayerWrapper.mediaPlayer.playhead
							:	0;
			
			bufferLength.text = mediaPlayerWrapper.mediaPlayer.bufferable
							? 	mediaPlayerWrapper.mediaPlayer.bufferLength.toFixed(1)
							: "";
		}
		
		private function onMutedChange(event:MutedChangeEvent):void
		{
			muteToggle.selected = event.muted;
		}
		

		private function onBufferTimeChange(event:BufferTimeChangeEvent):void
		{
			bufferTime.text = mediaPlayerWrapper.mediaPlayer.bufferTime.toFixed(1);
		}
		
		private function updateControls():void
		{
			buttonPlay.visible 			= mediaPlayerWrapper.mediaPlayer.playable;
			buttonPause.visible 		= mediaPlayerWrapper.mediaPlayer.pausable;
			audioControls.visible 		= mediaPlayerWrapper.mediaPlayer.audible;
			temporalControls.visible	= mediaPlayerWrapper.mediaPlayer.temporal;
			bufferable.visible			= mediaPlayerWrapper.mediaPlayer.bufferable;
			seekBar.enabled 			= mediaPlayerWrapper.mediaPlayer.seekable;
			
			if (mediaPlayerWrapper.mediaPlayer.temporal)
			{
				seekBar.maximum = mediaPlayerWrapper.mediaPlayer.duration;
			}
			else
			{
				seekBar.maximum = 0;
			}
			
			if (mediaPlayerWrapper.mediaPlayer.bufferable)
			{
				bufferTime.text = mediaPlayerWrapper.mediaPlayer.bufferTime.toFixed(1);
				bufferLength.text = mediaPlayerWrapper.mediaPlayer.bufferLength.toFixed(1);
			}
			else
			{
				bufferTime.text = "";
				bufferLength.text = "";
			}
			
			if (mediaPlayerWrapper.mediaPlayer.audible)
			{
				muteToggle.selected = mediaPlayerWrapper.mediaPlayer.muted;
				volumeSlider.value = mediaPlayerWrapper.mediaPlayer.volume;
				panControl.value = mediaPlayerWrapper.mediaPlayer.pan;
			}
		}
		
		private var examples:Array;
		private var example:Example;
	}
}
