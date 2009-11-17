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
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.AudioEvent;
	import org.osmf.events.BufferEvent;
	import org.osmf.events.DimensionEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.PausedChangeEvent;
	import org.osmf.events.PlayingChangeEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.events.SwitchEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.traits.DownloadableTrait;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.MockMediaElementWithDownloadableTrait;
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
			events = new Vector.<Event>();

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
			
			assertTrue(mediaPlayer.state == MediaPlayerState.UNINITIALIZED);
			
			if (this.loadable)
			{
				eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
				
				var eventCount:int = 0;
				
				mediaPlayer.addEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, onTestSource
					);
				mediaPlayer.element = mediaElement;
				
				function onTestSource(event:LoadEvent):void
				{
					eventCount++;
					
					if (eventCount == 1)
					{
						assertTrue(event.loadState == LoadState.LOADING);
						assertTrue(mediaPlayer.state == MediaPlayerState.LOADING);
					}
					else if (eventCount == 2)
					{
						assertTrue(event.loadState == LoadState.READY);
						assertTrue(mediaPlayer.state == MediaPlayerState.READY);
						
						// Now verify that we can unload the media.
						mediaPlayer.element = null;
					}
					else if (eventCount == 3)
					{
						assertTrue(event.loadState == LoadState.UNLOADING);
						assertTrue(mediaPlayer.state == MediaPlayerState.READY);
					}
					else if (eventCount == 4)
					{
						assertTrue(event.loadState == LoadState.UNINITIALIZED);
						assertTrue(mediaPlayer.state == MediaPlayerState.UNINITIALIZED);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
					else fail();
				}
			}
			else
			{
				mediaPlayer.addEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, mustNotReceiveEvent
					);
						
				mediaPlayer.element = mediaElement;
				assertTrue(mediaPlayer.state == MediaPlayerState.READY);
				
				// Now verify that we can unload the media.
				mediaPlayer.element = null;
				assertTrue(mediaPlayer.state == MediaPlayerState.UNINITIALIZED);
			}
		}
		
		public function testSourceWithInvalidResource():void
		{
			var mediaElement:MediaElement = createMediaElement(invalidResourceForMediaElement);
			
			assertTrue(mediaPlayer.state == MediaPlayerState.UNINITIALIZED);
			
			if (this.loadable)
			{
				eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
				
				var eventCount:int = 0;
				var errorCount:int = 0;
				
				mediaPlayer.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
				mediaPlayer.addEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, onTestSourceWithInvalidResource
					);
				mediaPlayer.element = mediaElement;
				
				function onMediaError(event:MediaErrorEvent):void
				{
					errorCount++;
				}
				
				function onTestSourceWithInvalidResource(event:LoadEvent):void
				{
					eventCount++;
					
					if (eventCount == 1)
					{
						assertTrue(event.loadState == LoadState.LOADING);
						assertTrue(mediaPlayer.state == MediaPlayerState.LOADING);
					}
					else if (eventCount == 2)
					{
						assertTrue(event.loadState == LoadState.LOAD_ERROR);
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
					( LoadEvent.LOAD_STATE_CHANGE
					, mustNotReceiveEvent
					);
						
				mediaPlayer.element = mediaElement;
				assertTrue(mediaPlayer.state == MediaPlayerState.READY);
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestVolume();
			}
		}

		private function doTestVolume():void
		{
			doTestVolumeCommon(1);
		}

		public function testVolumeWithPreset():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			// Assign a volume up front.  This value will take precedence over
			// any volume inherited from the MediaElement.
			mediaPlayer.volume = 0.33;
			
			if (loadable)
			{
				callAfterLoad(doTestVolumeWithPreset, false);
			}
			else
			{
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestVolumeWithPreset();
			}
		}
		
		private function doTestVolumeWithPreset():void
		{
			doTestVolumeCommon(0.33);
		}
		
		private function doTestVolumeCommon(expectedVolume:Number):void
		{
			if (traitExists(MediaTraitType.AUDIBLE))
			{
				assertTrue(mediaPlayer.volume == expectedVolume);
				
				mediaPlayer.addEventListener(AudioEvent.VOLUME_CHANGE, onTestVolume);
				mediaPlayer.volume = 0.2;
				
				function onTestVolume(event:AudioEvent):void
				{
					mediaPlayer.removeEventListener(AudioEvent.VOLUME_CHANGE, onTestVolume);
					
					assertTrue(mediaPlayer.volume == 0.2);
					assertTrue(event.volume == 0.2);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
			else
			{
				assertTrue(mediaPlayer.audible == false);
				assertTrue(mediaPlayer.volume == expectedVolume);
				
				// Setting the volume should apply, even when the MediaPlayer isn't audible.
				mediaPlayer.volume = 0.5;
				assertTrue(mediaPlayer.volume == 0.5);
								
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestMuted();
			}
		}
		
		private function doTestMuted():void
		{
			doTestMutedCommon(false);
		}

		public function testMutedWithPreset():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			// Assign a muted value up front.  This value will take precedence over
			// any muted value inherited from the MediaElement.
			mediaPlayer.muted = true;
			
			if (loadable)
			{
				callAfterLoad(doTestMutedWithPreset, false);
			}
			else
			{
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestMutedWithPreset();
			}
		}
		
		private function doTestMutedWithPreset():void
		{
			doTestMutedCommon(true);
		}
		
		private function doTestMutedCommon(expectedMuted:Boolean):void
		{
			if (traitExists(MediaTraitType.AUDIBLE))
			{
				assertTrue(mediaPlayer.muted == expectedMuted);
				
				mediaPlayer.addEventListener(AudioEvent.MUTED_CHANGE, onTestMuted);
				mediaPlayer.muted = !expectedMuted;
				
				function onTestMuted(event:AudioEvent):void
				{
					mediaPlayer.removeEventListener(AudioEvent.MUTED_CHANGE, onTestMuted);
					
					assertTrue(mediaPlayer.muted == !expectedMuted);
					assertTrue(event.muted == !expectedMuted);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
			else
			{
				assertTrue(mediaPlayer.audible == false);
				assertTrue(mediaPlayer.muted == expectedMuted);
				
				// Setting muted should apply, even when the MediaPlayer isn't audible.
				mediaPlayer.muted = !expectedMuted;
				assertTrue(mediaPlayer.muted == !expectedMuted);
				
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestPan();
			}
		}
		
		private function doTestPan():void
		{
			doTestPanCommon(0);
		}

		public function testPanWithPreset():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));

			// Assign a pan value up front.  This value will take precedence
			// over any pan value inherited from the MediaElement.
			mediaPlayer.pan = -0.5;
			
			if (loadable)
			{
				callAfterLoad(doTestPanWithPreset, false);
			}
			else
			{
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestPanWithPreset();
			}
		}
		
		private function doTestPanWithPreset():void
		{
			doTestPanCommon(-0.5);
		}
		
		private function doTestPanCommon(expectedPan:Number):void
		{
			if (traitExists(MediaTraitType.AUDIBLE))
			{
				assertTrue(mediaPlayer.pan == expectedPan);
				
				mediaPlayer.addEventListener(AudioEvent.PAN_CHANGE, onTestPan);
				mediaPlayer.pan = 0.7;
				
				function onTestPan(event:AudioEvent):void
				{
					mediaPlayer.removeEventListener(AudioEvent.PAN_CHANGE, onTestPan);
					
					assertTrue(mediaPlayer.pan == 0.7);
					assertTrue(event.pan == 0.7);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
			else
			{
				assertTrue(mediaPlayer.audible == false);
				assertTrue(mediaPlayer.pan == expectedPan);

				// Setting pan should apply, even when the MediaPlayer isn't audible.
				mediaPlayer.pan = 0.3;
				assertTrue(mediaPlayer.pan == 0.3);
				
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
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
			assertTrue(mediaPlayer.state == MediaPlayerState.READY);
				
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
		
		public function testStop():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestStop, false);
			}
			else
			{
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestStop();
			}
		}
		
		private function doTestStop():void
		{
			if (traitExists(MediaTraitType.PAUSABLE) && traitExists(MediaTraitType.SEEKABLE))
			{
				assertTrue(mediaPlayer.playable == true);
				assertTrue(mediaPlayer.playing == false);
				assertTrue(mediaPlayer.state == MediaPlayerState.READY);
					
				mediaPlayer.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onTestStop1);
				mediaPlayer.play();
			
				function onTestStop1(event:PlayingChangeEvent):void
				{
					mediaPlayer.removeEventListener(PlayingChangeEvent.PLAYING_CHANGE, onTestStop1);
					
					assertTrue(mediaPlayer.playing == true);
					assertTrue(event.playing == true);
					assertTrue(mediaPlayer.state == MediaPlayerState.PLAYING);

					var hasPaused:Boolean = false;
					var hasSeeked:Boolean = false;
					
					mediaPlayer.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onTestStop2);
					mediaPlayer.addEventListener(SeekEvent.SEEK_BEGIN, onTestStop3);
					mediaPlayer.addEventListener(SeekEvent.SEEK_END, onTestStop3);
					
					mediaPlayer.stop();
					
					function onTestStop2(event2:PausedChangeEvent):void
					{
						hasPaused = true;
						
						assertTrue(mediaPlayer.paused == true);
						assertTrue(mediaPlayer.playing == false);
						assertTrue(event2.paused == true);
						assertTrue(mediaPlayer.state == MediaPlayerState.PAUSED);
					}
					
					function onTestStop3(event3:SeekEvent):void
					{
						assertTrue(hasPaused);
						
						if (hasSeeked == false)
						{
							hasSeeked = true;
							
							assertTrue(mediaPlayer.paused == true);
							assertTrue(mediaPlayer.playing == false);
							assertTrue(mediaPlayer.seeking == true);
							assertTrue(event3.type == SeekEvent.SEEK_BEGIN);
							assertTrue(mediaPlayer.state == MediaPlayerState.BUFFERING);
						}
						else
						{
							mediaPlayer.removeEventListener(PausedChangeEvent.PAUSED_CHANGE, onTestStop2);
							mediaPlayer.removeEventListener(SeekEvent.SEEK_BEGIN, onTestStop3);
							mediaPlayer.removeEventListener(SeekEvent.SEEK_END, onTestStop3);
							
							assertTrue(mediaPlayer.paused == true);
							assertTrue(mediaPlayer.playing == false);
							assertTrue(mediaPlayer.seeking == false);
							assertTrue(event3.type == SeekEvent.SEEK_END);
							
							// Not sure whether this should be PAUSED or READY?
							assertTrue(mediaPlayer.state == MediaPlayerState.PAUSED);
	
							eventDispatcher.dispatchEvent(new Event("testComplete"));
						}
					}
				}
			}
			else
			{
				eventDispatcher.dispatchEvent(new Event("testComplete"));
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestSeek();
			}
		}

		private function doTestSeek():void
		{
			if (traitExists(MediaTraitType.SEEKABLE))
			{
				assertTrue(mediaPlayer.seekable == true);
				assertTrue(mediaPlayer.seeking == false);
				assertTrue(mediaPlayer.state == MediaPlayerState.READY);
				
				// For some media, triggering playback will cause the duration
				// to get set.
				if (mediaPlayer.duration == 0)
				{
					mediaPlayer.play();
					mediaPlayer.pause();
				}
				
				var seekTarget:Number = mediaPlayer.duration - 1;
				
				var canSeek:Boolean = mediaPlayer.canSeekTo(seekTarget);
				
				var eventCount:int = 0;

				mediaPlayer.addEventListener(SeekEvent.SEEK_BEGIN, canSeek ? onTestSeek : mustNotReceiveEvent);
				mediaPlayer.addEventListener(SeekEvent.SEEK_END, canSeek ? onTestSeek : mustNotReceiveEvent);
				mediaPlayer.seek(seekTarget);
				
				if (!canSeek)
				{
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
				
				function onTestSeek(event:SeekEvent):void
				{
					eventCount++;
					
					if (eventCount == 1)
					{
						assertTrue(mediaPlayer.seeking == true);
						assertTrue(event.type == SeekEvent.SEEK_BEGIN);
						assertTrue(mediaPlayer.state == MediaPlayerState.BUFFERING);
					}
					else if (eventCount == 2)
					{
						assertTrue(mediaPlayer.seeking == false);
						assertTrue(event.type == SeekEvent.SEEK_END);
						assertTrue(mediaPlayer.state == MediaPlayerState.READY ||
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
		
		public function testCurrentTimeWithChangeEvents():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestCurrentTimeWithChangeEvents, false);
			}
			else
			{
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestCurrentTimeWithChangeEvents();
			}
		}
		
		public function testCurrentTimeWithNoChangeEvents():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			
			if (loadable)
			{
				callAfterLoad(doTestCurrentTimeWithNoChangeEvents, false);
			}
			else
			{
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestCurrentTimeWithNoChangeEvents();
			}
		}
		
		private function doTestCurrentTimeWithChangeEvents():void
		{
			doTestCurrentTime(true);
		}

		private function doTestCurrentTimeWithNoChangeEvents():void
		{
			doTestCurrentTime(false);
		}
		
		private function doTestCurrentTime(enableChangeEvents:Boolean):void
		{
			if (traitExists(MediaTraitType.TEMPORAL))
			{
				assertTrue(mediaPlayer.temporal == true);
				assertTrue(mediaPlayer.currentTime == 0 || isNaN(mediaPlayer.currentTime));
				
				assertTrue(mediaPlayer.currentTimeUpdateInterval == 250);

				mediaPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onCurrentTimeChange);
				mediaPlayer.addEventListener(TimeEvent.DURATION_REACHED, onTestCurrentTime);
				
				if (enableChangeEvents)
				{
					mediaPlayer.currentTimeUpdateInterval = 1000;
					assertTrue(mediaPlayer.currentTimeUpdateInterval == 1000);
				}
				else
				{
					mediaPlayer.currentTimeUpdateInterval = 0;
					assertTrue(mediaPlayer.currentTimeUpdateInterval == 0);
				}
				
				mediaPlayer.play();
				
				var currentTimeUpdateCount:int = 0;
				
				function onTestCurrentTime(event:TimeEvent):void
				{
					mediaPlayer.removeEventListener(TimeEvent.CURRENT_TIME_CHANGE, onCurrentTimeChange);
					mediaPlayer.removeEventListener(TimeEvent.DURATION_REACHED, onTestCurrentTime);
					
					assertTrue(Math.abs(mediaPlayer.currentTime - mediaPlayer.duration) < 1);
					assertTrue(mediaPlayer.state == MediaPlayerState.READY);
					
					if (enableChangeEvents)
					{
						// We should get roughly 1 update per second.  Note that
						// the timing model isn't precise, so we leave some wiggle
						// room in our assertion (and in particular give ourselves
						// more wiggle room if the duration is longer).
						assertTrue(Math.abs(currentTimeUpdateCount - Math.floor(mediaPlayer.duration)) <= Math.max(1, mediaPlayer.duration * 0.10));
					}
					else
					{
						assertTrue(currentTimeUpdateCount == 0);
					}
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
				
				function onCurrentTimeChange(event:TimeEvent):void
				{
					currentTimeUpdateCount++;
				}
			}
			else
			{
				assertTrue(mediaPlayer.temporal == false);
				
				assertEquals(0, mediaPlayer.duration);
				assertEquals(0, mediaPlayer.currentTime);
				
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				doTestWidthHeight();
			}
		}

		private function doTestWidthHeight():void
		{
			if (traitExists(MediaTraitType.SPATIAL))
			{
				assertTrue(mediaPlayer.width == 0);
				assertTrue(mediaPlayer.height == 0);
				
				mediaPlayer.addEventListener(DimensionEvent.DIMENSION_CHANGE, onTestWidthHeight);
								
				// For some media, triggering playback will cause the true
				// dimensions to get set.
				mediaPlayer.play();
				
				function onTestWidthHeight(event:DimensionEvent):void
				{
					mediaPlayer.removeEventListener(DimensionEvent.DIMENSION_CHANGE, onTestWidthHeight);

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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
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
				
				mediaPlayer.addEventListener(BufferEvent.BUFFER_TIME_CHANGE, onTestBufferTime);
								
				mediaPlayer.bufferTime = 10;
				
				function onTestBufferTime(event:BufferEvent):void
				{
					mediaPlayer.removeEventListener(BufferEvent.BUFFER_TIME_CHANGE, onTestBufferTime);

					assertTrue(mediaPlayer.bufferTime == 10);
					assertTrue(event.bufferTime == 10);

					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
			else
			{
				assertTrue(mediaPlayer.bufferable == false);
				assertTrue(mediaPlayer.buffering == false);
				assertEquals(0, mediaPlayer.bufferLength);
				assertEquals(0, mediaPlayer.bufferTime);

				// Setting the bufferTime has no effect.			
				mediaPlayer.bufferTime = 5;
				assertEquals(0, mediaPlayer.bufferTime);
				
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
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
				assertTrue(mediaPlayer.maxStreamIndex == expectedMaxStreamIndex);
				assertTrue(mediaPlayer.switchUnderway == false);
				
				for (var i:int = 0; i <= expectedMaxStreamIndex; i++)
				{
					assertTrue(mediaPlayer.getBitrateForIndex(i) == getExpectedBitrateForIndex(i));
				}
				
				var eventCount:int = 0;
				
				mediaPlayer.maxStreamIndex = 2;
				
				mediaPlayer.addEventListener(SwitchEvent.SWITCHING_CHANGE, onTestSwitchable);
				mediaPlayer.autoSwitch = false;
				mediaPlayer.switchTo(1);
				
				function onTestSwitchable(event:SwitchEvent):void
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
						
						// TODO: Fix this, then reenable.  For some reason
						// MockDynamicNetStream isn't dispatching the correct
						// series of events.
						//assertTrue(mediaPlayer.currentStreamIndex == 1);
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
				assertTrue(mediaPlayer.autoSwitch == true);
				assertTrue(mediaPlayer.currentStreamIndex == 0);
				assertTrue(mediaPlayer.maxStreamIndex == 0);
				assertTrue(mediaPlayer.switchUnderway == false);

				// Setting autoSwitch should have no effect.
				mediaPlayer.autoSwitch = false;
				assertTrue(mediaPlayer.autoSwitch == true);
								
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
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
				mediaPlayer.addEventListener(TimeEvent.DURATION_REACHED, onTestLoop);
				mediaPlayer.play();
				
				function onTestLoop(event:TimeEvent):void
				{
					mediaPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
					mediaPlayer.removeEventListener(TimeEvent.DURATION_REACHED, onTestLoop);
					
					assertTrue(mediaPlayer.playing == true);
					
					var statesStr:String = states.join(" ");
					assertTrue(statesStr == "playing"); 

					mediaPlayer.pause();
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
				
				function onStateChange(event:MediaPlayerStateChangeEvent):void
				{
					// Ignore any buffering state changes, they can happen
					// intermittently.
					if (event.state != MediaPlayerState.BUFFERING &&
						!(states.length > 0 && event.state == states[states.length-1]))
					{
						states.push(event.state);
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
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
				mediaPlayer.addEventListener(TimeEvent.DURATION_REACHED, onTestAutoRewind);
				mediaPlayer.play();
				
				function onTestAutoRewind(event:TimeEvent):void
				{
					mediaPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
					mediaPlayer.removeEventListener(TimeEvent.DURATION_REACHED, onTestAutoRewind);
					
					assertTrue(mediaPlayer.playing == false);
					
					// These are all possible/permissible state sequences.
					var statesStr:String = states.join(" ");
					assertTrue(		statesStr == "playing paused"
								||	statesStr == "playing"
							  ); 
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
				
				function onStateChange(event:MediaPlayerStateChangeEvent):void
				{
					// Ignore any buffering state changes, they can happen
					// intermittently.
					if (event.state != MediaPlayerState.BUFFERING &&
						!(states.length > 0 && event.state == states[states.length-1]))
					{
						states.push(event.state);
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
				mediaPlayer.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoaded);

				var eventCount:int = 0;
				
				mediaPlayer.autoPlay = true;
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				
				function onStateChange(event:MediaPlayerStateChangeEvent):void
				{
					eventCount++;
					
					if (eventCount == 1)
					{
						assertTrue(event.state == MediaPlayerState.LOADING);
					}
					else if (eventCount == 2)
					{
						assertTrue(event.state == MediaPlayerState.READY);
					}
					else if (eventCount == 3)
					{
						assertTrue(event.state == MediaPlayerState.PLAYING);
						
						mediaPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
					else fail();
				}
			
				function onLoaded(event:LoadEvent):void
				{
					if (event.loadState == LoadState.READY)
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
				
				mediaPlayer.element = mediaElement;
	
				var loadableTrait:ILoadable = mediaElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				assertTrue(loadableTrait);
	
				var testComplete:Boolean = false;
				
				// Make sure error events dispatched on the trait are redispatched
				// on the MediaPlayer.
				loadableTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new MediaError(99)));
				
				function onMediaError(event:MediaErrorEvent):void
				{
					assertTrue(event.error.errorCode == 99);
					assertTrue(event.error.description == "");
					
					assertTrue(mediaPlayer.state == MediaPlayerState.PLAYBACK_ERROR);
					
					assertTrue(event.target == mediaPlayer);
					
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
				mediaPlayer.element = createMediaElement(resourceForMediaElement);
				
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
		
		public function testDownloadable():void
		{
			var mediaElement:MockMediaElementWithDownloadableTrait 
				= new MockMediaElementWithDownloadableTrait(new LoaderBase());
				
			mediaPlayer.autoPlay = false;
			mediaPlayer.element = mediaElement;
			
			assertTrue(mediaPlayer.downloadable == false);
			assertEquals(0, mediaPlayer.bytesLoaded);
			assertEquals(0, mediaPlayer.bytesTotal);
			
			mediaPlayer.bytesLoadedUpdateInterval = 120;
			assertTrue(mediaPlayer.bytesLoadedUpdateInterval == 120);
			mediaPlayer.bytesLoadedUpdateInterval = 120;
			assertTrue(mediaPlayer.bytesLoadedUpdateInterval == 120);
			
			mediaPlayer.addEventListener(LoadEvent.BYTES_LOADED_CHANGE, eventCatcher);
			mediaPlayer.addEventListener(LoadEvent.BYTES_TOTAL_CHANGE, eventCatcher);
			
			mediaElement.prepareForTesting();
			
			mediaPlayer.bytesLoadedUpdateInterval = NaN;
			assertTrue(isNaN(mediaPlayer.bytesLoadedUpdateInterval));
			
			mediaPlayer.bytesLoadedUpdateInterval = -500;
			assertTrue(mediaPlayer.bytesLoadedUpdateInterval == -500);
			
			mediaPlayer.bytesLoadedUpdateInterval = 50;
			assertTrue(mediaPlayer.bytesLoadedUpdateInterval == 50);
			
			assertTrue(mediaPlayer.downloadable == true);
			
			var downloadable:DownloadableTrait = mediaElement.getTrait(MediaTraitType.DOWNLOADABLE) as DownloadableTrait;
			assertTrue(downloadable != null);
			downloadable.bytesTotal = 100;
			downloadable.bytesLoaded = 10;
			downloadable.bytesTotal = 100;
			
			assertTrue(mediaPlayer.bytesLoaded == 10);
			assertTrue(mediaPlayer.bytesTotal == 100);
			
			mediaPlayer.removeEventListener(LoadEvent.BYTES_LOADED_CHANGE, eventCatcher);
			mediaPlayer.removeEventListener(LoadEvent.BYTES_TOTAL_CHANGE, eventCatcher);

			assertTrue(events.length > 0);
			var bytesTotalChangeCount:int = 0;
			for (var i:int; i < events.length; i++)
			{
				if (events[i].type == LoadEvent.BYTES_TOTAL_CHANGE)
				{
					bytesTotalChangeCount++;
					assertTrue(bytesTotalChangeCount == 1);
				}
				else
				{
					assertTrue(events[i].type == LoadEvent.BYTES_LOADED_CHANGE);
				}
			}			
		}
		
		public function testSubclip():void
		{
			if (supportsSubclips)
			{
				eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
				
				if (loadable)
				{
					callAfterLoad(doTestSubclip, false);
				}
				else
				{
					mediaPlayer.element = createMediaElement(resourceForMediaElement);
					doTestSubclip();
				}
			}
		}

		private function doTestSubclip():void
		{
			var states:Array = [];
			
			assertTrue(mediaPlayer.currentTime == 0);
			
			mediaPlayer.addEventListener(TimeEvent.DURATION_REACHED, onTestSubclip);
			mediaPlayer.play();
			
			function onTestSubclip(event:TimeEvent):void
			{
				mediaPlayer.removeEventListener(TimeEvent.DURATION_REACHED, onTestSubclip);
				
				assertTrue(Math.abs(mediaPlayer.currentTime - mediaPlayer.duration) < 1);
				assertTrue(mediaPlayer.duration == expectedSubclipDuration);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
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
		
		protected function get expectedMaxStreamIndex():int
		{
			// Subclasses can override to specify the expected max stream index
			// when switchable.
			return -1;
		}
		
		protected function getExpectedBitrateForIndex(index:int):Number
		{
			// Subclasses can override to specify the expected bitrates for each
			// switchable index.
			return -1;
		}
		
		protected function get supportsSubclips():Boolean
		{
			// Subclasses can override to indicate that they are capable of
			// playing subclips.
			return false;
		}
		
		protected function get expectedSubclipDuration():Number
		{
			// Subclasses can override to specify the expected duration of
			// the subclip.  Ignored unless supportsSubclips returns true.
			return 0;
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
			
			assertTrue(mediaPlayer.state == MediaPlayerState.UNINITIALIZED);
			
			mediaPlayer.addEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, onTestCallAfterLoad
					);
			mediaPlayer.element = mediaElement;
			
			function onTestCallAfterLoad(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					mediaPlayer.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onTestCallAfterLoad);
					
					assertTrue(mediaPlayer.state == MediaPlayerState.READY);
					
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
		
		private function eventCatcher(event:Event):void
		{
			events.push(event);
		}
		
		// Large delay to accommodate non-mocked unit tests.
		private static const ASYNC_DELAY:Number = 53000;
		
		private var mediaPlayer:MediaPlayer;
		private var eventDispatcher:EventDispatcher;
		private var events:Vector.<Event>;
	}
}