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
package org.openvideoplayer.media
{
	import flash.events.Event;
	import flash.media.SoundMixer;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.audio.AudioElement;
	import org.openvideoplayer.events.*;
	import org.openvideoplayer.netmocker.MockNetLoader;
	import org.openvideoplayer.netmocker.NetConnectionExpectation;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.TemporalTrait;
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.TestConstants;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.video.VideoElement;

	public class TestMediaPlayer extends TestCase
	{
		override public function tearDown():void
		{
			super.tearDown();			
			/*if(mediaPlayer.playable && mediaPlayer.playing)
			{
				mediaPlayer.pause();					
			}*/
			mediaPlayer.source = null;
									
			// Kill all sounds.
			SoundMixer.stopAll();
		}
		
		override public function setUp():void
		{
			super.setUp();
			mediaPlayer = new MediaPlayer();			
		}
		
		// Temporarily disabling the test until ROC can figure out why it
		// fails on AIR.
		public function testTemporal():void
		{
			var duration:Number = 3;			
			mediaPlayer.addEventListener(DurationChangeEvent.DURATION_CHANGE,onDurationChanged);
			mediaPlayer.addEventListener(TraitEvent.DURATION_REACHED, onDurationReached);
			mediaPlayer.addEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, onPlayhead);
			mediaPlayer.source = new DynamicMediaElement([MediaTraitType.TEMPORAL]);
			var temporal:TemporalTrait = (mediaPlayer.source.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait);
			temporal.duration = duration;
				
			var durReached:Function = addAsync(function():void{}, 6000);				
			
			function onPlayhead(event:PlayheadChangeEvent):void
			{					
				// Ensure we are in sync								
				assertEquals(event.newPosition, mediaPlayer.playhead, (mediaPlayer.source.getTrait(MediaTraitType.TEMPORAL) as ITemporal).position );		
				temporal.position = duration;
			}
							
			function onDurationChanged(event:DurationChangeEvent):void
			{
				// Give a 100 millisecond buffer, since the duration is an estimate for progressive connections
				assertTrue(duration <= event.newDuration && event.newDuration <= duration);				
			}
			
			function onDurationReached(event:Event):void
			{
				assertEquals(mediaPlayer.playhead, mediaPlayer.duration);
				mediaPlayer.removeEventListener(DurationChangeEvent.DURATION_CHANGE,onDurationChanged);
				mediaPlayer.removeEventListener(TraitEvent.DURATION_REACHED, onDurationReached);
				mediaPlayer.removeEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, onPlayhead);
				durReached(null);			
			}					
		}
		
		public function testAudible():void
		{
			var mock:MockNetLoader = new MockNetLoader();
			mock.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			mock.netStreamExpectedDuration = 100;
			mediaPlayer.source = new AudioElement(mock,	new URLResource(new FMSURL(TestConstants.STREAMING_AUDIO_FILE)));
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE, onAudible, false, 0, true);
			assertFalse(mediaPlayer.audible);
						
			var testDone:Function = addAsync(function():void{}, 3000);
																		
			function onPanChange(event:PanChangeEvent):void
			{
				assertEquals(mediaPlayer.pan, 1);
			}
			
			function onVolChange(event:VolumeChangeEvent):void
			{
				assertEquals(mediaPlayer.volume, .1);
			}
			
			function onMuteChange(event:MutedChangeEvent):void
			{
				assertFalse(mediaPlayer.muted);
			}
			
			function onAudible(event:MediaPlayerCapabilityChangeEvent):void
			{
				if(mediaPlayer.audible)
				{					
					mediaPlayer.volume = .01;
					mediaPlayer.play();			
					assertEquals(mediaPlayer.volume, .01);	
					
					mediaPlayer.pan = -1;			 
					assertEquals(mediaPlayer.pan, -1);	
					
					mediaPlayer.muted = true;
					
					assertEquals(mediaPlayer.volume, .01);	
					
					mediaPlayer.pause();
					
					assertEquals(mediaPlayer.volume, .01);	
					assertEquals(mediaPlayer.pan, -1);	
					assertTrue(mediaPlayer.muted);
					
					//Catch last three changes
					mediaPlayer.addEventListener(VolumeChangeEvent.VOLUME_CHANGE, onVolChange, false, 0, true);
					mediaPlayer.addEventListener(PanChangeEvent.PAN_CHANGE, onPanChange, false, 0, true);
					mediaPlayer.addEventListener(MutedChangeEvent.MUTED_CHANGE, onMuteChange, false, 0, true);
					
					mediaPlayer.pan = 1;
					mediaPlayer.volume = .1;
							
					assertEquals(mediaPlayer.volume, .1);	
					assertEquals(mediaPlayer.pan, 1);	
					assertTrue(mediaPlayer.muted);		
								
					mediaPlayer.muted = false;
							
					assertEquals(mediaPlayer.volume, .1);	
					assertEquals(mediaPlayer.pan, 1);	
					assertFalse(mediaPlayer.muted);
					
					testDone(null);
				}
			}					
		}
		
		public function testPausePlay():void
		{
			var testCalled:Boolean = false;
			mediaPlayer.autoPlay = false;
			mediaPlayer.autoRewind = false;
			var loader:MockNetLoader = new MockNetLoader();
			loader.netStreamExpectedDuration = 100;
			loader.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			
			var pauseTransitions:Array = [ true,false,true];
			var playingTransitions:Array =  [false,true] ;
						
			mediaPlayer.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlaying);
			mediaPlayer.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPause);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE, onPlayablePausible);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PAUSIBLE_CHANGE, onPlayablePausible);
			
			mediaPlayer.source = new VideoElement(loader, 	new URLResource(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO)));
								
			function onPlaying(event:PlayingChangeEvent):void
			{
				assertEquals(event.playing, playingTransitions.pop());			
			}
			
			function onPause(event:PausedChangeEvent):void
			{
				assertEquals(event.paused, pauseTransitions.pop());			
			}
			
			function onPlayablePausible(event:MediaPlayerCapabilityChangeEvent):void
			{				
				if(mediaPlayer.playable && mediaPlayer.pausible)
				{
					
					doTest();
				}
			}
					
			function doTest():void
			{				
				assertFalse(mediaPlayer.paused);
				
				mediaPlayer.pause();
				
				assertTrue(mediaPlayer.paused);
				
				mediaPlayer.play();
				
				assertFalse(mediaPlayer.paused);
				
				mediaPlayer.pause();
				
				assertTrue(mediaPlayer.paused);
				
				assertTrue(pauseTransitions.length == 0);
				assertTrue(playingTransitions.length == 0);
				
				mediaPlayer.removeEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlaying);
				mediaPlayer.removeEventListener(PausedChangeEvent.PAUSED_CHANGE, onPause);
				mediaPlayer.removeEventListener(MediaPlayerCapabilityChangeEvent.PAUSIBLE_CHANGE, onPlayablePausible);
				mediaPlayer.removeEventListener(MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE, onPlayablePausible);
				testCalled = true;
			}
			assertTrue(testCalled);
		}
		
		public function testViewableSpatial():void
		{
			var mockNL:MockNetLoader = new MockNetLoader();	
			mockNL.netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
			mockNL.netStreamExpectedDuration = 20000;	
			mediaPlayer.source = null;
					
			var viewCallBack:Boolean = false;
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE, onView, false, 0, true);
			
			assertFalse(mediaPlayer.viewable);			
			assertFalse(mediaPlayer.spatial);
			
			mediaPlayer.source = new VideoElement(mockNL, new URLResource(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO)));
			
			function onView(event:MediaPlayerCapabilityChangeEvent):void
			{				
				assertTrue(mediaPlayer.viewable);			
				assertFalse(viewCallBack);
				viewCallBack = true;
				mediaPlayer.removeEventListener(MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE, onView);										
			}
			
			assertTrue(viewCallBack);				
		}		
		
		public function testSeekable():void
		{
			var mockLoader:MockNetLoader = new MockNetLoader();
			mockLoader.netStreamExpectedDuration = 10;
			mediaPlayer.source = new VideoElement(mockLoader, 	new URLResource(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO)));
					
			//Can seek within the medias length
			assertTrue(mediaPlayer.canSeekTo(1));
								
			//Seeking-			
			mediaPlayer.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeeking, false, 0, true);
						
			var progCheck:Function = addAsync(function():void{}, 5000);		
			
			var seekOrder:Array = [ false, true];
					
			assertTrue(mediaPlayer.seekable);
			assertTrue(mediaPlayer.canSeekTo(mediaPlayer.duration/2));				
			mediaPlayer.seek(mediaPlayer.duration/2);
										
			function onSeeking(event:SeekingChangeEvent):void
			{		
				assertEquals(mediaPlayer.seeking, event.seeking);		
				assertEquals(event.seeking, seekOrder.pop());		
				if(seekOrder.length == 0)
				{						
					mediaPlayer.pause();					
					progCheck(null);	
				}	
			}												
		}
	
		public function testMediaState():void
		{		
			var initedCallback:Function = addAsync(function():void{},10000);
			
			mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onPlayerState, false, 0, true);	
			mediaPlayer.autoPlay = false;
						
			assertEquals(mediaPlayer.state, MediaPlayerState.CONSTRUCTED);
			
			var mediaPlayerStates:Array = [MediaPlayerState.CONSTRUCTED, MediaPlayerState.PAUSED, MediaPlayerState.SEEKING, MediaPlayerState.PAUSED, MediaPlayerState.PLAYING, MediaPlayerState.INITIALIZED , MediaPlayerState.INITIALIZING];
			
			var loader:MockNetLoader = new MockNetLoader();
			loader.netStreamExpectedDuration = 10;
			
			mediaPlayer.autoPlay = true;
			mediaPlayer.autoRewind = false;
			mediaPlayer.source = new VideoElement(loader, new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO)));		
			
			var seekingStateReached:Boolean = false;
			var pauseAfterSeek:Boolean = false;
			
			function onPlayerState(event:MediaPlayerStateChangeEvent):void
			{
				assertEquals(	event.newState, mediaPlayerStates.pop() );	
				
				if(event.newState == MediaPlayerState.PLAYING)
				{
						mediaPlayer.pause();
				}
				else if(event.newState == MediaPlayerState.PAUSED && event.oldState == MediaPlayerState.PLAYING)
				{			
					assertTrue(mediaPlayer.canSeekTo(	mediaPlayer.duration/2 ));
					mediaPlayer.seek(mediaPlayer.duration/2);		
				}
				else if( event.newState == MediaPlayerState.SEEKING && event.oldState == MediaPlayerState.PAUSED)
				{				
					seekingStateReached = true;
				}
				else if(event.newState == MediaPlayerState.PAUSED && event.oldState == MediaPlayerState.SEEKING)
				{				
					pauseAfterSeek = true;
					mediaPlayer.source = null;
				}
				else if(event.newState == MediaPlayerState.CONSTRUCTED && event.oldState == MediaPlayerState.PAUSED)
				{					
					assertTrue(pauseAfterSeek);
					assertTrue(seekingStateReached);
					initedCallback(null);
				}				
			}			
		}

		public function testSource():void
		{			
			assertNull( mediaPlayer.source );
			
			var newSource:AudioElement =  new AudioElement(new MockNetLoader(), new URLResource(new URL("http://example.com/")));
			
			mediaPlayer.source = newSource;
				
			assertEquals(newSource, mediaPlayer.source);
			
			mediaPlayer.source = null;			
			
			assertNull( mediaPlayer.source );						
		}
	
		public function testAutoPlay():void
		{
			mediaPlayer.source = new VideoElement(new MockNetLoader(), new URLResource(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO)));
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE, onPlaying);
							
			function onPlaying(event:MediaPlayerCapabilityChangeEvent):void
			{	
				if(event.enabled)
				{
					mediaPlayer.removeEventListener(MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE, onPlaying);					
					assertTrue(event.enabled);												
					assertTrue(mediaPlayer.playing);	
					
					mediaPlayer.pause();
					mediaPlayer.autoPlay = false;
					
					mediaPlayer.source =  new VideoElement(new MockNetLoader(), 	new URLResource(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO)));		
					assertFalse(mediaPlayer.playing);					
									
					mediaPlayer.autoPlay = true;
					assertFalse(mediaPlayer.playing);  //Shouldn't affect playstate until the media is set to source.
					
					mediaPlayer.source =  new VideoElement(new MockNetLoader(), 	new URLResource(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO)));
					mediaPlayer.pause();
					
					assertFalse(mediaPlayer.playing);
					
					mediaPlayer.source = null;			
					assertFalse(mediaPlayer.playable);	
				}
			}		
		}
		
		public function testLoop():void
		{
			var mockNL:MockNetLoader = new MockNetLoader();
			mockNL.netStreamExpectedDuration = .1;  // 1/10 second
						
			mediaPlayer.loop = true;
			mediaPlayer.autoPlay = true;			
			mediaPlayer.source = new VideoElement(mockNL, new URLResource(new FMSURL(TestConstants.STREAMING_AUDIO_FILE)));
			mediaPlayer.addEventListener(TraitEvent.DURATION_REACHED, onDuration);
					
			var durReached:Function = addAsync(function():void{}, 6000);
			var loops:Number = 0;
									
			function onDuration(event:Event):void
			{
				if(loops > 1)
				{
					mediaPlayer.loop = false;
					durReached(null);	
				}
				++loops;
			}		
		}
		
		public function testLoopOverRewind():void
		{
			var mockNL:MockNetLoader = new MockNetLoader();
			mockNL.netStreamExpectedDuration = .1;  // 1/10 second
						
			mediaPlayer.loop = true;
			mediaPlayer.autoPlay = true;		
			mediaPlayer.autoRewind = true;	
			mediaPlayer.source = new VideoElement(mockNL, new URLResource(new FMSURL(TestConstants.STREAMING_AUDIO_FILE)));
			mediaPlayer.addEventListener(TraitEvent.DURATION_REACHED, onDuration);
					
			var durReached:Function = addAsync(function():void{}, 6000);
			var loops:Number = 0;
									
			function onDuration(event:Event):void
			{
				if(loops > 1)
				{
					mediaPlayer.loop = false;
					durReached(null);	
				}
				++loops;
			}		
		}
		
		
		public function testAutoRewind():void
		{
			var mockNL:MockNetLoader = new MockNetLoader();
			mockNL.netStreamExpectedDuration = .1;  // 1/10 second
			mediaPlayer.source = new VideoElement(mockNL, new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO)));					
			var seekingStarted:Boolean = false;
			var playingingStarted:Boolean = false;
			var doneRewinding:Function = addAsync(function():void{}, 6000);
			var donePlaying:Boolean = false;
			
			mediaPlayer.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeeking);
			mediaPlayer.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onStopped);
								
			function onSeeking(event:SeekingChangeEvent):void
			{						
				if(!event.seeking)  // done rewinding
				{
					assertTrue(seekingStarted);					
					assertFalse(mediaPlayer.playing);			
					assertTrue(donePlaying);
					doneRewinding(null);
				}
				else
				{
					assertFalse(seekingStarted);
					seekingStarted = true;
				}
			}
			
			function onStopped(event:PlayingChangeEvent):void
			{				
				if(!event.playing)
				{
					assertTrue(playingingStarted);
					donePlaying = true;
				}
				else
				{
					assertFalse(seekingStarted);
					playingingStarted = true;
				}
			}				
		}
	
		public function testTraitAvailability():void
		{	
			var loadableChangedCalled:Boolean = false;
			var seekableChangedCalled:Boolean = false;
			var temporalChangedCalled:Boolean = false;
			var playableChangedCalled:Boolean = false;
			var pausibleChangedCalled:Boolean = false;
			var viewableChangedCalled:Boolean = false;
			var spatialChangedCalled:Boolean = false;
			var audibleChangedCalled:Boolean = false;
						
			mediaPlayer.autoPlay = false;
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.LOADABLE_CHANGE, loadableChanged);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.SEEKABLE_CHANGE, seekableChanged);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.TEMPORAL_CHANGE, temporalChanged);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE, playableChanged);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PAUSIBLE_CHANGE, pausibleChanged);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE, viewableChanged);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE, audibleChanged);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE, spatialChanged);	
					
			function loadableChanged(event:MediaPlayerCapabilityChangeEvent):void
			{				
				loadableChangedCalled = true;
			}
			
			function seekableChanged(event:MediaPlayerCapabilityChangeEvent):void
			{				
				seekableChangedCalled = true;
			}
			
			function temporalChanged(event:MediaPlayerCapabilityChangeEvent):void
			{				
				temporalChangedCalled = true;
			}
			
			function playableChanged(event:MediaPlayerCapabilityChangeEvent):void
			{				
				playableChangedCalled = true;
			}
			
			function pausibleChanged(event:MediaPlayerCapabilityChangeEvent):void
			{				
				pausibleChangedCalled = true;
			}
			
			function viewableChanged(event:MediaPlayerCapabilityChangeEvent):void
			{				
				viewableChangedCalled = true;
			}
			
			function audibleChanged(event:MediaPlayerCapabilityChangeEvent):void
			{				
				audibleChangedCalled = true;
			}
			
			function spatialChanged(event:MediaPlayerCapabilityChangeEvent):void
			{				
				spatialChangedCalled = true;
			}
			
			assertFalse(mediaPlayer.loadable);
			assertFalse(mediaPlayer.seekable);
			assertFalse(mediaPlayer.playable);
			assertFalse(mediaPlayer.pausible);
			assertFalse(mediaPlayer.spatial);
			assertFalse(mediaPlayer.viewable);
			assertFalse(mediaPlayer.audible);
			assertFalse(mediaPlayer.temporal);
						
			mediaPlayer.source = new VideoElement(new MockNetLoader(), new URLResource(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO)));			
									
			assertTrue(loadableChangedCalled);
			assertTrue(seekableChangedCalled);
			assertTrue(temporalChangedCalled);
			assertTrue(playableChangedCalled);
			assertTrue(pausibleChangedCalled);
			assertTrue(viewableChangedCalled);
			assertTrue(spatialChangedCalled);
			assertTrue(audibleChangedCalled);
						
			seekableChangedCalled = false;
			temporalChangedCalled = false;
			playableChangedCalled = false;
			pausibleChangedCalled = false;
			viewableChangedCalled = false;
			spatialChangedCalled = false;
			audibleChangedCalled = false;
			
			mediaPlayer.source = null;
			
			assertTrue(loadableChangedCalled);
			assertTrue(seekableChangedCalled);
			assertTrue(temporalChangedCalled);
			assertTrue(playableChangedCalled);
			assertTrue(pausibleChangedCalled);
			assertTrue(viewableChangedCalled);
			assertTrue(spatialChangedCalled);
			assertTrue(audibleChangedCalled);
			
			assertFalse(mediaPlayer.loadable);
			assertFalse(mediaPlayer.seekable);
			assertFalse(mediaPlayer.playable);
			assertFalse(mediaPlayer.pausible);
			assertFalse(mediaPlayer.spatial);
			assertFalse(mediaPlayer.viewable);
			assertFalse(mediaPlayer.audible);
			assertFalse(mediaPlayer.temporal);
		}
	
		public function testPlayheadInterval():void
		{
			var mockNL:MockNetLoader = new MockNetLoader();
			mockNL.netStreamExpectedDuration = 10;  // 10 seconds
			
			mediaPlayer.addEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, onPlayheadUpdate);
			mediaPlayer.playheadUpdateInterval = 100;  //100 msecs update		
			mediaPlayer.source = new VideoElement(mockNL, new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO)));	
						
			var sliceSeconds:Number = mediaPlayer.playheadUpdateInterval / 1000;
			var doneUpdating:Function = addAsync(function():void{}, 6000);
			var secondRound:Boolean = false;
			var finished:Boolean = false;
			var lastUpdate:Number = 0;
									
			function onPlayheadUpdate(event:PlayheadChangeEvent):void
			{
				var leeway:Number = .2; //200 millisecond leeway since the timers in flash are inaccurate.
				assertTrue( (lastUpdate + sliceSeconds - leeway) < event.newPosition);
				assertTrue( (lastUpdate + sliceSeconds + leeway) > event.newPosition);
				lastUpdate = event.newPosition;
				if(event.newPosition > 1  && !secondRound ) //after 1 second (10 iterations) stop testing 100msec update.
				{
					mediaPlayer.playheadUpdateInterval = 200;
					sliceSeconds = mediaPlayer.playheadUpdateInterval / 1000;
					secondRound = true;				
				}	
				else if(event.newPosition > 2) //after 2 second (10 iterations) stop testing 200 msec update.
				{
					assertFalse(finished)
					finished = true;
					mediaPlayer.playheadUpdateInterval = 0; //If this fires again after setting the update interval to 0 - that is an error.
					doneUpdating(null);					
				}				
			}						
		}
	
		public function testBufferLength():void
		{
			var mockNL:MockNetLoader = new MockNetLoader();
			mockNL.netStreamExpectedDuration = 10;  // 10 seconds
				
			mediaPlayer.source = new VideoElement(mockNL, new URLResource(new FMSURL(TestConstants.REMOTE_STREAMING_VIDEO)));	
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.BUFFERABLE_CHANGE, onBufferable);
			var onBufferableCallback:Function = addAsync(function():void{}, 6000);
			
			function onBufferable(event:MediaPlayerCapabilityChangeEvent):void
			{
				if(event.enabled)
				{
					mediaPlayer.bufferTime = 10;			
					assertEquals(mediaPlayer.bufferTime, 10);
					onBufferableCallback(null);
				}
			}						
		}
		
		public function testMediaErrorEventDispatch():void
		{
			var mediaElement:AudioElement = new AudioElement(new MockNetLoader(), new URLResource(new URL("http://example.com/")));
			mediaPlayer.source = mediaElement;

			mediaPlayer.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
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
		
		private var mediaPlayer:MediaPlayer;		
	}
}