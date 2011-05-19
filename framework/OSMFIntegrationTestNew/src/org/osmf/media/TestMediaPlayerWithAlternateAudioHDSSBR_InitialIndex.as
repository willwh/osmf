/*****************************************************
 *  
 *  Copyright 2011 Adobe Systems Incorporated.  All Rights Reserved.
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
 *  Portions created by Adobe Systems Incorporated are Copyright (C) 2011 Adobe Systems 
 *  Incorporated. All Rights Reserved. 
 *  
 *****************************************************/
package org.osmf.media
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flashx.textLayout.operations.PasteOperation;
	
	import flexunit.framework.Test;
	
	import mx.effects.Sequence;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.flexunit.internals.runners.InitializationError;
	import org.fluint.sequence.SequenceCaller;
	import org.fluint.sequence.SequenceDelay;
	import org.fluint.sequence.SequenceRunner;
	import org.fluint.sequence.SequenceWaiter;
	import org.hamcrest.number.closeTo;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.object.equalTo;
	import org.osmf.events.AlternativeAudioEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.URLResource;

	public class TestMediaPlayerWithAlternateAudioHDSSBR_InitialIndex extends TestMediaPlayerHelper
	{
		[Before]
		override public function setUp():void
		{
			super.setUp();
			timer = new Timer(TIMER_INTERVAL, TIMER_REPEAT);
		}
		
		[After]
		override public function tearDown():void
		{
			super.tearDown();
			
			timer.stop();
			timer = null;
		}
		
		/**
		 * Tests automatic playback os SBR stream with alternative audio track.  
		 * Once the playback has started after 5 seconds into the stream, change the 
		 * alternative audio track to the specified one. The change should be 
		 * seemless and the playhead should not change back to 0.
		 */ 
		[Test(async, timeout="600000")]
		public function playLive_InitialAlternativeIndex_ChangeOnTheFlyAfter5Sec():void
		{
			audioInitialIndex = 0;
			mediaPlayerExpectedStates.push(MediaPlayerState.LOADING, MediaPlayerState.READY, MediaPlayerState.PLAYING);
			
			checkPlayerState(null);
			
			mediaElement = createMediaElement(new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE));
			mediaPlayer.media = mediaElement;	
		}

		/// Events handlers
		/**
		 * @private
		 * 
		 * We verify that the player goes through our expected states.
		 */
		override protected function onStateChange(event:MediaPlayerStateChangeEvent, passThroughData:Object):void
		{
			checkPlayerState(event.state);
			
			// we are seting autoPlay flag to false so we need to start the playback ourselves
			if (mediaPlayer.state == MediaPlayerState.READY)
			{
				assertThat("We should have access to alternatve audio information", mediaPlayer.hasAlternativeAudio);
				assertThat("The number of alternative audio streams should be greater than 0", mediaPlayer.numAlternativeAudioStreams, greaterThan(0));
				assertThat("No alternate audio stream change is in progress.", mediaPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("No alternate audio stream is selected.", mediaPlayer.currentAlternativeAudioStreamIndex, equalTo(-1));
				
				if (audioInitialIndex != -1 && mediaPlayer.hasAlternativeAudio)
				{
					mediaPlayer.switchAlternativeAudioIndex(audioInitialIndex);	
				}
				if (mediaPlayer.canPlay)
				{
					mediaPlayer.play();
				}
			}
			
			// when we are in playing mode set a timer to do the actual change of alternate audio index
			if (mediaPlayer.state == MediaPlayerState.PLAYING)
			{
				if (!audioChangeInitiated)
				{
					audioChangeInitiated = true;

					var info:Object = new Object();
					info.currentTime = mediaPlayer.currentTime;
					info.desiredAlternativeAudioIndex = 1;
					info.expectedEventType = "AlternativeAudioEvent";
					info.expectedEvent = AlternativeAudioEvent.AUDIO_SWITCHING_CHANGE;

					var args:Array = new Array(info);
					
					var sequence:SequenceRunner = new SequenceRunner(this);
					sequence.addStep( new SequenceCaller(this, startAlternativeAudioTimer, args));
					sequence.addStep( new SequenceWaiter(timer, TimerEvent.TIMER_COMPLETE, 6000, onTimeout));
					sequence.addStep( new SequenceCaller(this, changeAlternativeAudioIndex, args));
					sequence.addStep( new SequenceWaiter(mediaPlayer, AlternativeAudioEvent.AUDIO_SWITCHING_CHANGE, 10000, onTimeout));
					sequence.addStep( new SequenceWaiter(mediaPlayer, AlternativeAudioEvent.AUDIO_SWITCHING_CHANGE, 10000, onTimeout));
					sequence.addAssertHandler(onAlternativeAudio, info);
					sequence.run();
				}
			}
		}
		
		/**
		 * @private
		 * 
		 * We start the alternative audio timer in order to allow the play head
		 * to advance and process few more media seconds.
		 */
		public function startAlternativeAudioTimer(... args):void
		{
			timer.start();	
		}
		
		public function changeAlternativeAudioIndex(... args):void
		{
			timer.stop();
			mediaPlayer.switchAlternativeAudioIndex(1);
		}
		/**
		 * @private
		 * 
		 * The alternative audio stream change is completed. We check to see if we actually switched.
		 * Keep in mind that for every change we dispatch two events - one when the change is starting
		 * and one when the change is completed.
		 */
		protected function onAlternativeAudio(event:AlternativeAudioEvent, passThroughData:Object):void
		{
			assertThat("The alternative audio stream change is now completed.", mediaPlayer.alternativeAudioStreamSwitching, equalTo(false));
			if ( passThroughData != null)
			{
				if (passThroughData.hasOwnProperty("desiredAlternativeAudioIndex"))
				{
					assertThat("The current alternative index is changed.", mediaPlayer.currentAlternativeAudioStreamIndex, equalTo(passThroughData.desiredAlternativeAudioIndex));
				}
				if (passThroughData.hasOwnProperty("currentTime"))
				{
					assertThat("The current time is still close to the previous time.", mediaPlayer.currentTime, greaterThanOrEqualTo(passThroughData.currentTime));
				}
			}
			
//			
//			if (event.streamChanging)
//			{
//				mediaPlayer.addEventListener(
//					AlternativeAudioEvent.STREAM_CHANGE,
//					Async.asyncHandler(this, onAlternativeAudioChange, 10000, passThroughData, onTimeout),
//					false,
//					0,
//					true
//				);
//
//				assertThat("An alternative audio stream change is now in progress.", mediaPlayer.alternativeAudioStreamChanging, equalTo(true));
//				assertThat("The current alternative index is not yet changed.", mediaPlayer.currentAlternativeAudioIndex, equalTo(audioInitialIndex));
//			}
//			else
//			{
//				assertThat("The alternative audio stream change is now completed.", mediaPlayer.alternativeAudioStreamChanging, equalTo(false));
//				if ( passThroughData != null)
//				{
//					if (passThroughData.hasOwnProperty("desiredAlternativeAudioIndex"))
//					{
//						assertThat("The current alternative index is changed.", mediaPlayer.currentAlternativeAudioIndex, equalTo(passThroughData.desiredAlternativeAudioIndex));
//					}
//					if (passThroughData.hasOwnProperty("currentTime"))
//					{
//						assertThat("The current time is still close to the previous time.", mediaPlayer.currentTime, greaterThanOrEqualTo(passThroughData.currentTime));
//					}
//				}
//			}
		}
		
		/// Internals
		protected static const ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE:String = "http://10.131.237.107/live/events/latebind/events/_definst_/liveevent.f4m";
		
		protected var timer:Timer = null;
		protected static const TIMER_INTERVAL:uint = 5000;
		protected static const TIMER_REPEAT:uint = 1;
		
		protected var audioChangeInitiated:Boolean = false;
		protected var audioInitialIndex:int = -1;
	}
}