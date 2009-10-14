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
package org.osmf.media
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.BufferTimeChangeEvent;
	import org.osmf.events.DimensionChangeEvent;
	import org.osmf.events.LoadableStateChangeEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.MutedChangeEvent;
	import org.osmf.events.PanChangeEvent;
	import org.osmf.events.PausedChangeEvent;
	import org.osmf.events.PlayheadChangeEvent;
	import org.osmf.events.PlayingChangeEvent;
	import org.osmf.events.SeekingChangeEvent;
	import org.osmf.events.SwitchingChangeEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.events.VolumeChangeEvent;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.URL;
	
	public class TestMediaPlayer extends TestCase
	{
		// Overrides
		//
		
		override public function setUp():void
		{
			mediaPlayer = new MediaPlayer();
			mediaPlayer.autoPlay = false;
			mediaPlayer.autoRewind = false;
			eventDispatcher = new EventDispatcher();

			super.setUp();
		}

		override public function tearDown():void
		{
			super.tearDown();
			
			mediaPlayer = null;
			eventDispatcher = null;
		}
		
		// Tests
		//
		
		public function testSource():void
		{
			var mediaElement:MediaElement = createMediaElement(resourceForMediaElement);
			
			assertTrue(mediaPlayer.state == MediaPlayerState.CONSTRUCTED);
			
			if (this.loadable)
			{
				eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
				
				var eventCount:int = 0;
				
				mediaPlayer.addEventListener
					( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
					, onTestSource
					);
				mediaPlayer.source = mediaElement;
				
				function onTestSource(event:LoadableStateChangeEvent):void
				{
					eventCount++;
					
					if (eventCount == 1)
					{
						assertTrue(event.newState == LoadState.LOADING);
						assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZING);
					}
					else if (eventCount == 2)
					{
						assertTrue(event.newState == LoadState.LOADED);
						assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZED);
						
						// Now verify that we can unload the media.
						mediaPlayer.source = null;
					}
					else if (eventCount == 3)
					{
						assertTrue(event.newState == LoadState.UNLOADING);
						assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZED);
					}
					else if (eventCount == 4)
					{
						assertTrue(event.newState == LoadState.CONSTRUCTED);
						assertTrue(mediaPlayer.state == MediaPlayerState.CONSTRUCTED);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
					else fail();
				}
			}
			else
			{
				mediaPlayer.addEventListener
					( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
					, mustNotReceiveEvent
					);
						
				mediaPlayer.source = mediaElement;
				assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZED);
				
				// Now verify that we can unload the media.
				mediaPlayer.source = null;
				assertTrue(mediaPlayer.state == MediaPlayerState.CONSTRUCTED);
			}
		}
		
		public function testSourceWithInvalidResource():void
		{
			var mediaElement:MediaElement = createMediaElement(invalidResourceForMediaElement);
			
			assertTrue(mediaPlayer.state == MediaPlayerState.CONSTRUCTED);
			
			if (this.loadable)
			{
				eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
				
				var eventCount:int = 0;
				var errorCount:int = 0;
				
				mediaPlayer.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
				mediaPlayer.addEventListener
					( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
					, onTestSourceWithInvalidResource
					);
				mediaPlayer.source = mediaElement;
				
				function onMediaError(event:MediaErrorEvent):void
				{
					errorCount++;
				}
				
				function onTestSourceWithInvalidResource(event:LoadableStateChangeEvent):void
				{
					eventCount++;
					
					if (eventCount == 1)
					{
						assertTrue(event.newState == LoadState.LOADING);
						assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZING);
					}
					else if (eventCount == 2)
					{
						assertTrue(event.newState == LoadState.LOAD_FAILED);
						assertTrue(mediaPlayer.state == MediaPlayerState.PLAYBACK_ERROR);
						
						// TODO: Reenable once this works for dynamic streams.  Probably
						// need to have the error event dispatched in NetLoader.
						//assertTrue(errorCount == 1);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
					else fail();
				}
			}
			else
			{
				mediaPlayer.addEventListener
					( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
					, mustNotReceiveEvent
					);
						
				mediaPlayer.source = mediaElement;
				assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZED);
			}
		}
		
		public function testVolume():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestVolume, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestVolume();
			}
		}
		
		private function doTestVolume():void
		{
			if (traitExists(MediaTraitType.AUDIBLE))
			{
				assertTrue(mediaPlayer.volume == 1.0);
				
				mediaPlayer.addEventListener(VolumeChangeEvent.VOLUME_CHANGE, onTestVolume);
				mediaPlayer.volume = 0.2;
				
				function onTestVolume(event:VolumeChangeEvent):void
				{
					mediaPlayer.removeEventListener(VolumeChangeEvent.VOLUME_CHANGE, onTestVolume);
					
					assertTrue(mediaPlayer.volume == 0.2);
					assertTrue(event.oldVolume == 1.0);
					assertTrue(event.newVolume == 0.2);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
			else
			{
				assertTrue(mediaPlayer.audible == false);
				assertTrue(isNaN(mediaPlayer.volume));
				
				// Setting the volume has no effect.
				mediaPlayer.volume = 0.5;
				assertTrue(isNaN(mediaPlayer.volume));
								
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testMuted():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestMuted, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestMuted();
			}
		}
		
		private function doTestMuted():void
		{
			if (traitExists(MediaTraitType.AUDIBLE))
			{
				assertTrue(mediaPlayer.muted == false);
				
				mediaPlayer.addEventListener(MutedChangeEvent.MUTED_CHANGE, onTestMuted);
				mediaPlayer.muted = true;
				
				function onTestMuted(event:MutedChangeEvent):void
				{
					mediaPlayer.removeEventListener(MutedChangeEvent.MUTED_CHANGE, onTestMuted);
					
					assertTrue(mediaPlayer.muted == true);
					assertTrue(event.muted == true);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
			else
			{
				assertTrue(mediaPlayer.audible == false);
				assertTrue(mediaPlayer.muted == false);
				
				// Setting muted has no effect.
				mediaPlayer.muted = true;
				assertTrue(mediaPlayer.muted == false);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testPan():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestPan, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestPan();
			}
		}
		
		private function doTestPan():void
		{
			if (traitExists(MediaTraitType.AUDIBLE))
			{
				assertTrue(mediaPlayer.pan == 0.0);
				
				mediaPlayer.addEventListener(PanChangeEvent.PAN_CHANGE, onTestPan);
				mediaPlayer.pan = 0.7;
				
				function onTestPan(event:PanChangeEvent):void
				{
					mediaPlayer.removeEventListener(PanChangeEvent.PAN_CHANGE, onTestPan);
					
					assertTrue(mediaPlayer.pan == 0.7);
					assertTrue(event.oldPan == 0.0);
					assertTrue(event.newPan == 0.7);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
			else
			{
				assertTrue(mediaPlayer.audible == false);
				assertTrue(isNaN(mediaPlayer.pan));

				// Setting pan has no effect.				
				mediaPlayer.pan = 0.3;
				assertTrue(isNaN(mediaPlayer.pan));
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testPlay():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestPlay, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestPlay();
			}
		}
		
		private function doTestPlay():void
		{
			if (traitExists(MediaTraitType.PLAYABLE))
			{
				doTestPlayPause(false);
			}
			else
			{
				assertTrue(mediaPlayer.playable == false);
				assertTrue(mediaPlayer.playing == false);
				
				try
				{
					mediaPlayer.play();
					
					fail();
				}
				catch (e:IllegalOperationError)
				{
					// Swallow.
				}
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testPause():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestPause, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestPause();
			}
		}
		
		private function doTestPause():void
		{
			if (traitExists(MediaTraitType.PAUSABLE))
			{
				doTestPlayPause(true);
			}
			else
			{
				assertTrue(mediaPlayer.pausable == false);
				assertTrue(mediaPlayer.paused == false);
				
				try
				{
					mediaPlayer.pause();
					
					fail();
				}
				catch (e:IllegalOperationError)
				{
					// Swallow.
				}
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		private function doTestPlayPause(pauseAfterPlay:Boolean):void
		{
			assertTrue(mediaPlayer.playable == true);
			assertTrue(mediaPlayer.playing == false);
			assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZED);
				
			mediaPlayer.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onTestPlayPause1);
			mediaPlayer.play();
		
			function onTestPlayPause1(event:PlayingChangeEvent):void
			{
				mediaPlayer.removeEventListener(PlayingChangeEvent.PLAYING_CHANGE, onTestPlayPause1);
				
				assertTrue(mediaPlayer.playing == true);
				assertTrue(event.playing == true);
				assertTrue(mediaPlayer.state == MediaPlayerState.PLAYING);
				
				if (pauseAfterPlay)
				{
					assertTrue(mediaPlayer.paused == false);
					
					mediaPlayer.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onTestPlayPause2);
					mediaPlayer.pause();
					
					function onTestPlayPause2(event2:PausedChangeEvent):void
					{
						mediaPlayer.removeEventListener(PausedChangeEvent.PAUSED_CHANGE, onTestPlayPause2);
						
						assertTrue(mediaPlayer.paused == true);
						assertTrue(mediaPlayer.playing == false);
						assertTrue(event2.paused == true);
						assertTrue(mediaPlayer.state == MediaPlayerState.PAUSED);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
				else
				{
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
		}
		
		public function testSeek():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestSeek, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestSeek();
			}
		}

		private function doTestSeek():void
		{
			if (traitExists(MediaTraitType.SEEKABLE))
			{
				assertTrue(mediaPlayer.seekable == true);
				assertTrue(mediaPlayer.seeking == false);
				assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZED);
				
				// For some media, triggering playback will cause the duration
				// to get set.
				if (isNaN(mediaPlayer.duration))
				{
					mediaPlayer.play();
					mediaPlayer.pause();
				}
				
				var seekTarget:Number = mediaPlayer.duration - 1;
				
				var canSeek:Boolean = mediaPlayer.canSeekTo(seekTarget);
				
				var eventCount:int = 0;

				mediaPlayer.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, canSeek ? onTestSeek : mustNotReceiveEvent);
				mediaPlayer.seek(seekTarget);
				
				if (!canSeek)
				{
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
				
				function onTestSeek(event:SeekingChangeEvent):void
				{
					eventCount++;
					
					if (eventCount == 1)
					{
						assertTrue(mediaPlayer.seeking == true);
						assertTrue(event.seeking == true);
						assertTrue(mediaPlayer.state == MediaPlayerState.SEEKING);
					}
					else if (eventCount == 2)
					{
						assertTrue(mediaPlayer.seeking == false);
						assertTrue(event.seeking == false);
						assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZED ||
								   mediaPlayer.state == MediaPlayerState.PAUSED);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
			else
			{
				assertTrue(mediaPlayer.seekable == false);
				assertTrue(mediaPlayer.seeking == false);
				
				try
				{
					mediaPlayer.seek(1);
					
					fail();
				}
				catch (e:IllegalOperationError)
				{
					// Swallow.
				}

				try
				{
					mediaPlayer.canSeekTo(1);
					
					fail();
				}
				catch (e:IllegalOperationError)
				{
					// Swallow.
				}
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testPlayheadWithChangeEvents():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestPlayheadWithChangeEvents, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestPlayheadWithChangeEvents();
			}
		}
		
		public function testPlayheadWithNoChangeEvents():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestPlayheadWithNoChangeEvents, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestPlayheadWithNoChangeEvents();
			}
		}
		
		private function doTestPlayheadWithChangeEvents():void
		{
			doTestPlayhead(true);
		}

		private function doTestPlayheadWithNoChangeEvents():void
		{
			doTestPlayhead(false);
		}
		
		private function doTestPlayhead(enableChangeEvents:Boolean):void
		{
			if (traitExists(MediaTraitType.TEMPORAL))
			{
				assertTrue(mediaPlayer.temporal == true);
				assertTrue(mediaPlayer.playhead == 0 || isNaN(mediaPlayer.playhead));
				
				assertTrue(mediaPlayer.playheadUpdateInterval == 250);

				mediaPlayer.addEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, onPlayheadChange);
				mediaPlayer.addEventListener(TraitEvent.DURATION_REACHED, onTestPlayhead);
				
				if (enableChangeEvents)
				{
					mediaPlayer.playheadUpdateInterval = 1000;
					assertTrue(mediaPlayer.playheadUpdateInterval == 1000);
				}
				else
				{
					mediaPlayer.playheadUpdateInterval = 0;
					assertTrue(mediaPlayer.playheadUpdateInterval == 0);
				}
				
				mediaPlayer.play();
				
				var playheadUpdateCount:int = 0;
				
				function onTestPlayhead(event:TraitEvent):void
				{
					mediaPlayer.removeEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, onPlayheadChange);
					mediaPlayer.removeEventListener(TraitEvent.DURATION_REACHED, onTestPlayhead);
					
					assertTrue(Math.abs(mediaPlayer.playhead - mediaPlayer.duration) < 1);
					assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZED);
					
					if (enableChangeEvents)
					{
						// We should get roughly 1 update per second.  Note that
						// the timing model isn't precise, so we leave some wiggle
						// room in our assertion.
						assertTrue(Math.abs(playheadUpdateCount - Math.floor(mediaPlayer.duration)) <= 1);
					}
					else
					{
						assertTrue(playheadUpdateCount == 0);
					}
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
				
				function onPlayheadChange(event:PlayheadChangeEvent):void
				{
					playheadUpdateCount++;
				}
			}
			else
			{
				assertTrue(mediaPlayer.temporal == false);
				
				assertTrue(isNaN(mediaPlayer.duration));
				assertTrue(isNaN(mediaPlayer.playhead));
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}

		public function testWidthHeight():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestWidthHeight, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestWidthHeight();
			}
		}

		private function doTestWidthHeight():void
		{
			if (traitExists(MediaTraitType.SPATIAL))
			{
				assertTrue(mediaPlayer.width == 320);
				assertTrue(mediaPlayer.height == 240);
				
				mediaPlayer.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onTestWidthHeight);
								
				// For some media, triggering playback will cause the true
				// dimensions to get set.
				mediaPlayer.play();
				
				function onTestWidthHeight(event:DimensionChangeEvent):void
				{
					mediaPlayer.removeEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onTestWidthHeight);

					assertTrue(mediaPlayer.width == expectedWidthAfterLoad);
					assertTrue(mediaPlayer.height == expectedHeightAfterLoad);

					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
			else
			{
				assertTrue(mediaPlayer.spatial == false);
				assertTrue(mediaPlayer.width == 0);
				assertTrue(mediaPlayer.height == 0);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testView():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestView, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestView();
			}
		}

		private function doTestView():void
		{
			if (traitExists(MediaTraitType.VIEWABLE))
			{
				assertTrue(mediaPlayer.view != null);

				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
			else
			{
				assertTrue(mediaPlayer.viewable == false);
				assertTrue(mediaPlayer.view == null);
								
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testBufferTime():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));

			if (loadable)
			{
				callAfterLoad(doTestBufferTime, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestBufferTime();
			}
		}

		private function doTestBufferTime():void
		{
			if (traitExists(MediaTraitType.BUFFERABLE))
			{
				assertTrue(mediaPlayer.buffering == false);
				assertTrue(mediaPlayer.bufferLength == 0);
				assertTrue(mediaPlayer.bufferTime == 0);
				
				mediaPlayer.addEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE, onTestBufferTime);
								
				mediaPlayer.bufferTime = 10;
				
				function onTestBufferTime(event:BufferTimeChangeEvent):void
				{
					mediaPlayer.removeEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE, onTestBufferTime);

					assertTrue(mediaPlayer.bufferTime == 10);
					assertTrue(event.oldTime == 0);
					assertTrue(event.newTime == 10);

					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
			else
			{
				assertTrue(mediaPlayer.bufferable == false);
				assertTrue(mediaPlayer.buffering == false);
				assertTrue(isNaN(mediaPlayer.bufferLength));
				assertTrue(isNaN(mediaPlayer.bufferTime));

				// Setting the bufferTime has no effect.			
				mediaPlayer.bufferTime = 5;
				assertTrue(isNaN(mediaPlayer.bufferTime));
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testSwitchable():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestSwitchable, false, switchableResource);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestSwitchable();
			}
		}

		private function doTestSwitchable():void
		{
			if (traitExists(MediaTraitType.SWITCHABLE))
			{
				// The stream must be playing before a switch can happen.
				mediaPlayer.play();
				
				assertTrue(mediaPlayer.autoSwitch == true);
				assertTrue(mediaPlayer.currentStreamIndex == 0);
				assertTrue(mediaPlayer.maxStreamIndex == 4);
				assertTrue(mediaPlayer.switchUnderway == false);
				
				for (var i:int = 0; i <= 4; i++)
				{
					assertTrue(mediaPlayer.getBitrateForIndex(i) == getExpectedBitrateForIndex(i));
				}
				
				var eventCount:int = 0;
				
				mediaPlayer.maxStreamIndex = 2;
				
				mediaPlayer.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onTestSwitchable);
				mediaPlayer.autoSwitch = false;
				mediaPlayer.switchTo(1);
				
				function onTestSwitchable(event:SwitchingChangeEvent):void
				{
					eventCount++;
					
					if (eventCount == 1)
					{
						assertTrue(mediaPlayer.autoSwitch == false);
						assertTrue(mediaPlayer.currentStreamIndex == 0);
						assertTrue(mediaPlayer.maxStreamIndex == 2);
						assertTrue(mediaPlayer.switchUnderway == true);
					}
					else if (eventCount == 2)
					{
						assertTrue(mediaPlayer.autoSwitch == false);
						assertTrue(mediaPlayer.currentStreamIndex == 0);
						assertTrue(mediaPlayer.maxStreamIndex == 2);
						assertTrue(mediaPlayer.switchUnderway == true);
					}
					else if (eventCount == 3)
					{
						assertTrue(mediaPlayer.autoSwitch == false);
						assertTrue(mediaPlayer.currentStreamIndex == 1);
						assertTrue(mediaPlayer.maxStreamIndex == 2);
						assertTrue(mediaPlayer.switchUnderway == false);

						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
					else fail();
				}
			}
			else
			{
				assertTrue(mediaPlayer.switchable == false);
				assertTrue(mediaPlayer.autoSwitch == false);
				assertTrue(mediaPlayer.currentStreamIndex == -1);
				assertTrue(mediaPlayer.maxStreamIndex == -1);
				assertTrue(mediaPlayer.switchUnderway == false);

				// Setting autoSwitch should have no effect.
				mediaPlayer.autoSwitch = true;
				assertTrue(mediaPlayer.autoSwitch == false);
								
				try
				{
					mediaPlayer.switchTo(1);
					
					fail();
				}
				catch (e:IllegalOperationError)
				{
					// Swallow.
				}
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testLoop():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestLoop, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestLoop();
			}
		}
		
		public function testLoopWithAutoRewind():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			mediaPlayer.autoRewind = true;
			
			if (loadable)
			{
				callAfterLoad(doTestLoop, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestLoop();
			}
		}

		private function doTestLoop():void
		{
			if (traitExists(MediaTraitType.TEMPORAL))
			{
				mediaPlayer.loop = true;
				
				var states:Array = [];
				
				mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
				mediaPlayer.addEventListener(TraitEvent.DURATION_REACHED, onTestLoop);
				mediaPlayer.play();
				
				function onTestLoop(event:TraitEvent):void
				{
					mediaPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
					mediaPlayer.removeEventListener(TraitEvent.DURATION_REACHED, onTestLoop);
					
					assertTrue(mediaPlayer.playing == true);
					
					var statesStr:String = states.join(" ");
					assertTrue(statesStr == "playing seeking playing"); 

					mediaPlayer.pause();
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
				
				function onStateChange(event:MediaPlayerStateChangeEvent):void
				{
					// Ignore any buffering state changes, they can happen
					// intermittently.
					if (event.newState != MediaPlayerState.BUFFERING &&
						event.oldState != MediaPlayerState.BUFFERING)
					{
						states.push(event.newState.name);
					}
				}
			}
			else
			{
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testAutoRewind():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestAutoRewind, false);
			}
			else
			{
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				doTestAutoRewind();
			}
		}
		
		private function doTestAutoRewind():void
		{
			if (traitExists(MediaTraitType.TEMPORAL))
			{
				mediaPlayer.autoRewind = true;
				
				var states:Array = [];
				
				mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
				mediaPlayer.addEventListener(TraitEvent.DURATION_REACHED, onTestAutoRewind);
				mediaPlayer.play();
				
				function onTestAutoRewind(event:TraitEvent):void
				{
					mediaPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
					mediaPlayer.removeEventListener(TraitEvent.DURATION_REACHED, onTestAutoRewind);
					
					assertTrue(mediaPlayer.playing == false);
					assertTrue(Math.floor(mediaPlayer.playhead) == 0);
					
					// These are all possible/permissible state sequences.
					var statesStr:String = states.join(" ");
					assertTrue(		statesStr == "playing seeking paused"
								||	statesStr == "playing paused seeking"
								||	statesStr == "playing paused seeking paused"
								||	statesStr == "playing seeking playing paused"
								||	statesStr == "playing seeking"
							  ); 
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
				
				function onStateChange(event:MediaPlayerStateChangeEvent):void
				{
					// Ignore any buffering state changes, they can happen
					// intermittently.
					if (event.newState != MediaPlayerState.BUFFERING &&
						event.oldState != MediaPlayerState.BUFFERING)
					{
						states.push(event.newState.name);
					}
				}
			}
			else
			{
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testAutoPlay():void
		{
			if (loadable)
			{
				eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
				
				mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
				mediaPlayer.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoaded);

				var eventCount:int = 0;
				
				mediaPlayer.autoPlay = true;
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				
				function onStateChange(event:MediaPlayerStateChangeEvent):void
				{
					eventCount++;
					
					if (eventCount == 1)
					{
						assertTrue(event.newState == MediaPlayerState.INITIALIZING);
					}
					else if (eventCount == 2)
					{
						assertTrue(event.newState == MediaPlayerState.INITIALIZED);
					}
					else if (eventCount == 3)
					{
						assertTrue(event.newState == MediaPlayerState.PLAYING);
						
						mediaPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
					else fail();
				}
			
				function onLoaded(event:LoadableStateChangeEvent):void
				{
					if (event.newState == LoadState.LOADED)
					{
						if (traitExists(MediaTraitType.PLAYABLE) == false)
						{
							assertTrue(eventCount == 2);
							
							eventDispatcher.dispatchEvent(new Event("testComplete"));
						}
					}
				}
			}
		}

		public function testMediaErrorEvent():void
		{
			if (loadable)
			{
				mediaPlayer.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
				
				var mediaElement:MediaElement = createMediaElement(resourceForMediaElement);
				
				mediaPlayer.source = mediaElement;
	
				var loadableTrait:ILoadable = mediaElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				assertTrue(loadableTrait);
	
				var testComplete:Boolean = false;
				
				// Make sure error events dispatched on the trait are redispatched
				// on the MediaPlayer.
				loadableTrait.dispatchEvent(new MediaErrorEvent(new MediaError(99)));
				
				function onMediaError(event:MediaErrorEvent):void
				{
					assertTrue(event.error.errorCode == 99);
					assertTrue(event.error.description == "");
					
					assertTrue(mediaPlayer.state == MediaPlayerState.PLAYBACK_ERROR);
					
					// The MediaElement is null, because it's derived from the target.
					// (Arguably, this is poor modelling.  We might want to make the
					// MediaElement more explicit, so that these events can have
					// varying targets.)
					assertTrue(event.media == null);
					
					testComplete = true;
				}
				
				assertTrue(testComplete);
			}
		}
		
		public function testCapabilityEvents():void
		{
			if (loadable)
			{
				eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
				
				var eventCount:int = 0;
				
				mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE	, onCapabilityChange);
				mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.BUFFERABLE_CHANGE	, onCapabilityChange);
				mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.LOADABLE_CHANGE	, onCapabilityChange);
				mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PAUSABLE_CHANGE	, onCapabilityChange);
				mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE	, onCapabilityChange);
				mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.SEEKABLE_CHANGE	, onCapabilityChange);
				mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE	, onCapabilityChange);
				mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.SWITCHABLE_CHANGE	, onCapabilityChange);
				mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.TEMPORAL_CHANGE	, onCapabilityChange);
				mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE	, onCapabilityChange);
				mediaPlayer.source = createMediaElement(resourceForMediaElement);
				
				function onCapabilityChange(event:MediaPlayerCapabilityChangeEvent):void
				{
					if (event.enabled)
					{
						eventCount++;
					}
					
					if (eventCount == existentTraitTypesAfterLoad.length)
					{
						for each (var traitType:MediaTraitType in existentTraitTypesAfterLoad)
						{
							switch (traitType)
							{
								case MediaTraitType.AUDIBLE:
									assertTrue(mediaPlayer.audible == true);
									break;
								case MediaTraitType.BUFFERABLE:
									assertTrue(mediaPlayer.bufferable == true);
									break;
								case MediaTraitType.LOADABLE:
									assertTrue(mediaPlayer.loadable == true);
									break;
								case MediaTraitType.PAUSABLE:
									assertTrue(mediaPlayer.pausable == true);
									break;
								case MediaTraitType.PLAYABLE:
									assertTrue(mediaPlayer.playable == true);
									break;
								case MediaTraitType.SEEKABLE:
									assertTrue(mediaPlayer.seekable == true);
									break;
								case MediaTraitType.SPATIAL:
									assertTrue(mediaPlayer.spatial == true);
									break;
								case MediaTraitType.SWITCHABLE:
									assertTrue(mediaPlayer.switchable == true);
									break;
								case MediaTraitType.TEMPORAL:
									assertTrue(mediaPlayer.temporal == true);
									break;
								case MediaTraitType.VIEWABLE:
									assertTrue(mediaPlayer.viewable == true);
									break;
								default:
									fail();
							}
						}

						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
		}
		
		// Protected
		//
		
		protected function createMediaElement(resource:IMediaResource):MediaElement
		{
			// Subclasses can override to specify the MediaElement subclass
			// to use with the MediaPlayer.
			var mediaElement:MediaElement = new MediaElement();
			mediaElement.resource = resource;
			return mediaElement; 
		}
		
		protected function get loadable():Boolean
		{
			// Subclasses can override to specify that the MediaElement starts
			// with the ILoadable trait.
			return false;
		}
		
		protected function get resourceForMediaElement():IMediaResource
		{
			// Subclasses can override to specify a resource that the
			// MediaElement can work with.
			return new URLResource(new URL("http://www.example.com"));
		}

		protected function get invalidResourceForMediaElement():IMediaResource
		{
			// Subclasses can override to specify a resource that the
			// MediaElement should fail to load.
			return new URLResource(new URL("http://www.example.com/fail"));
		}

		protected function get existentTraitTypesOnInitialization():Array
		{
			// Subclasses can override to specify the trait types which are
			// expected upon initialization of the MediaElement
			return [];
		}

		protected function get existentTraitTypesAfterLoad():Array
		{
			// Subclasses can override to specify the trait types which are
			// expected after a load of the MediaElement.  Ignored if the
			// MediaElement lacks the ILoadable trait.
			return [];
		}
		
		protected function get expectedWidthOnInitialization():Number
		{
			// Subclasses can override to specify the expected width of the
			// MediaElement upon initialization.
			return 0;
		}

		protected function get expectedHeightOnInitialization():Number
		{
			// Subclasses can override to specify the expected height of the
			// MediaElement upon initialization.
			return 0;
		}

		protected function get expectedWidthAfterLoad():Number
		{
			// Subclasses can override to specify the expected width of the
			// MediaElement after it has been loaded.
			return 0;
		}

		protected function get expectedHeightAfterLoad():Number
		{
			// Subclasses can override to specify the expected height of the
			// MediaElement after it has been loaded.
			return 0;
		}
		
		protected function get switchableResource():IMediaResource
		{
			// Subclasses can override to specify a media resource that is
			// switchable.
			return null;
		}
		
		protected function getExpectedBitrateForIndex(index:int):Number
		{
			// Subclasses can override to specify the expected bitrates for each
			// switchable index.
			return -1;
		}
		
		// Internals
		//
		
		private function traitExists(traitType:MediaTraitType):Boolean
		{
			var traitTypes:Array = existentTraitTypesAfterLoad;
			for each (var type:MediaTraitType in traitTypes)
			{
				if (type == traitType)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function callAfterLoad(func:Function, triggerTestCompleteEvent:Boolean=true, requestedResource:IMediaResource=null):void
		{
			assertTrue(this.loadable);
			
			if (triggerTestCompleteEvent)
			{
				eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			}

			var mediaElement:MediaElement = createMediaElement(requestedResource != null ? requestedResource : resourceForMediaElement);
			
			assertTrue(mediaPlayer.state == MediaPlayerState.CONSTRUCTED);
			
			mediaPlayer.addEventListener
					( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
					, onTestCallAfterLoad
					);
			mediaPlayer.source = mediaElement;
			
			function onTestCallAfterLoad(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					mediaPlayer.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onTestCallAfterLoad);
					
					assertTrue(mediaPlayer.state == MediaPlayerState.INITIALIZED);
					
					if (func != null)
					{
						func();
					}

					if (triggerTestCompleteEvent)
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
		}

		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}

		private function mustNotReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is NOT received.
			fail();
		}

		private static const ASYNC_DELAY:Number = 8000;
		
		private var mediaPlayer:MediaPlayer;
		private var eventDispatcher:EventDispatcher;
	}
}