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
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexunit.assertThat;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.object.equalTo;
	
	/**
	 * Class tests late binding audio behavior when single switches are
	 * requested.
	 */
	public class TestMediaPlayerWithAlternateAudio_HDS_SBR extends TestMediaPlayerHelper
	{
		/**
		 * Tests automatic playback os SBR stream with alternative audio track.  
		 * Before the playback has started switch the alternative audio track to 
		 * the specified one. 
		 */
		[Test(async, timeout="60000", order=1)]
		public function playLive_NoInitialAlternativeIndex_SwitchBeforePlay():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var expectedData:Object = new Object();
			expectedData["numAlternativeAudioStreams"] = 2;
			expectedData["selectedIndex_onReady"] = -1;
			expectedData["selectedIndex_onComplete"] = 0;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			function setUpEvents(playerHelper:MediaPlayerHelper, add:Boolean):void
			{
				if (add)
				{
					playerHelper.addEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.addEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.addEventListener(MediaPlayerHelper.ERROR, 		onError);
				}
				else
				{
					playerHelper.removeEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.removeEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.removeEventListener(MediaPlayerHelper.ERROR, 		onError);
				}
			}
			
			setUpEvents(playerHelper, true);
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE);
			
			var switchInitiated:Boolean = false;
			
			function onReady(event:Event):void
			{
				if (!switchInitiated)
				{
					assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
					assertThat("The number of alternative audio streams is equal with the expected one.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
					assertThat("No alternate audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
					assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
					
					switchInitiated = true;
					playerHelper.actualPlayer.switchAlternativeAudioIndex(expectedData.selectedIndex_onComplete);
				}
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				setUpEvents(playerHelper, false);
			}
		}

		/**
		 * Tests automatic playback os SBR stream with alternative audio track.  
		 * Once the playback has started switch the alternative audio track to 
		 * the specified one. The switch should be seemless and the playhead 
		 * should not change back to 0.
		 */
		[Test(async, timeout="60000", order=2)]
		public function playLive_NoInitialAlternativeIndex_SwitchAfterPlay():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var expectedData:Object = new Object();
			expectedData["numAlternativeAudioStreams"] = 2;
			expectedData["selectedIndex_onReady"] = -1;
			expectedData["selectedIndex_onComplete"] = 1;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			function setUpEvents(playerHelper:MediaPlayerHelper, add:Boolean):void
			{
				if (add)
				{
					playerHelper.addEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.addEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.addEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.addEventListener(MediaPlayerHelper.AUDIO_SWITCH_BEGIN, onAudioSwitchBegin);
					playerHelper.addEventListener(MediaPlayerHelper.AUDIO_SWITCH_END, 	onAudioSwitchEnd);
				}
				else
				{
					playerHelper.removeEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.removeEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.removeEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.removeEventListener(MediaPlayerHelper.AUDIO_SWITCH_BEGIN, onAudioSwitchBegin);
					playerHelper.removeEventListener(MediaPlayerHelper.AUDIO_SWITCH_END, 	onAudioSwitchEnd);
				}
			}
			
			setUpEvents(playerHelper, true);
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE);
			
			var switchInitiated:Boolean = false;
			
			function onReady(event:Event):void
			{
				if (!switchInitiated)
				{
					assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
					assertThat("The number of alternative audio streams is equal with the expected one.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
					assertThat("No alternate audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
					assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
	
					playerHelper.actualPlayer.play();
				}
			}
			
			function onPlaying(event:Event):void
			{
				if (!switchInitiated)
				{
					switchInitiated = true;
					playerHelper.actualPlayer.switchAlternativeAudioIndex(expectedData.selectedIndex_onComplete);
				}
			}
			
			function onAudioSwitchBegin(event:Event):void
			{
				expectedData["currentTime_onAudioSwitchBegin"] = playerHelper.actualPlayer.currentTime;

				assertThat("The alternative audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(true));
			}
			
			function onAudioSwitchEnd(event:Event):void
			{
				expectedData["currentTime_onAudioSwitchEnd"] = playerHelper.actualPlayer.currentTime;
				
				assertThat("The alternative audio stream switch is now completed.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				assertThat("The current time is still close to the previous time.", playerHelper.actualPlayer.currentTime, greaterThanOrEqualTo(expectedData.currentTime_onAudioSwitchBegin));
				
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				assertThat("The playback has continued. Current time is greater than switch end time.", playerHelper.actualPlayer.currentTime, greaterThanOrEqualTo(expectedData.currentTime_onAudioSwitchEnd));
				
				setUpEvents(playerHelper, false);
			}
		}

		/**
		 * Tests automatic playback os SBR stream with alternative audio track.  
		 * Once the playback has started after 2 seconds into the stream, change the 
		 * alternative audio track to the specified one. The change should be 
		 * seemless and the playhead should not change back to 0.
		 */ 
		[Test(async, timeout="60000", order=3)]
		public function playLive_NoInitialAlternativeIndex_SwitchAfter2Sec():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var expectedData:Object = new Object();
			expectedData["numAlternativeAudioStreams"] = 2;
			expectedData["selectedIndex_onReady"] = -1;
			expectedData["selectedIndex_onComplete"] = 0;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			function setUpEvents(playerHelper:MediaPlayerHelper, add:Boolean):void
			{
				if (add)
				{
					playerHelper.addEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.addEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.addEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.addEventListener(MediaPlayerHelper.AUDIO_SWITCH_BEGIN, onAudioSwitchBegin);
					playerHelper.addEventListener(MediaPlayerHelper.AUDIO_SWITCH_END, 	onAudioSwitchEnd);
				}
				else
				{
					playerHelper.removeEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.removeEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.removeEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.removeEventListener(MediaPlayerHelper.AUDIO_SWITCH_BEGIN, onAudioSwitchBegin);
					playerHelper.removeEventListener(MediaPlayerHelper.AUDIO_SWITCH_END, 	onAudioSwitchEnd);
				}
			}
			
			setUpEvents(playerHelper, true);
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE);
			
			const switchTimerInterval:Number = 2000;			
			var switchTimer:Timer = new Timer(switchTimerInterval, 1);
			switchTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onSwitchTimerComplete);

			var switchInitiated:Boolean = false;
			
			function onReady(event:Event):void
			{
				if (!switchInitiated)
				{
					assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
					assertThat("The number of alternative audio streams is equal with the expected one.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
					assertThat("No alternate audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
					assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
					playerHelper.actualPlayer.play();
				}
			}
			
			function onPlaying(event:Event):void
			{
				if (!switchInitiated)
				{
					switchInitiated = true;
					switchTimer.start();		
				}
			}

			function onAudioSwitchBegin(event:Event):void
			{
				expectedData["currentTime_onAudioSwitchBegin"] = playerHelper.actualPlayer.currentTime;
				
				assertThat("The alternative audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(true));
			}
			
			function onAudioSwitchEnd(event:Event):void
			{
				expectedData["currentTime_onAudioSwitchEnd"] = playerHelper.actualPlayer.currentTime;
				
				assertThat("The alternative audio stream switch is now completed.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				assertThat("The current time is still close to the previous time.", playerHelper.actualPlayer.currentTime, greaterThanOrEqualTo(expectedData.currentTime_onAudioSwitchBegin));
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				assertThat("The playback has continued. Current time is greater than switch end time.", playerHelper.actualPlayer.currentTime, greaterThanOrEqualTo(expectedData.currentTime_onAudioSwitchEnd));
				
				setUpEvents(playerHelper, false);
			}

			function onSwitchTimerComplete(event:TimerEvent):void
			{
				playerHelper.actualPlayer.switchAlternativeAudioIndex(expectedData.selectedIndex_onComplete);
				
				switchTimer.stop();
				switchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onSwitchTimerComplete);
				switchTimer = null;
			}
		}
		
		/**
		 * Tests automatic playback os SBR stream with alternative audio track. We
		 * set an initial alternative audio index when the player is ready.
		 * Once the playback has started switch the alternative audio track to 
		 * the specified one. The switch should be seemless and the playhead 
		 * should not change back to 0.
		 */
		[Test(async, timeout="60000", order=4)]
		public function playLive_InitialAlternativeIndex_SwitchAfterPlay():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var expectedData:Object = new Object();
			expectedData["numAlternativeAudioStreams"] = 2;
			expectedData["selectedIndex_onReady"] = -1;
			expectedData["initialIndex_onReady"] = 0;
			expectedData["selectedIndex_onComplete"] = 1;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			function setUpEvents(playerHelper:MediaPlayerHelper, add:Boolean):void
			{
				if (add)
				{
					playerHelper.addEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.addEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.addEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.addEventListener(MediaPlayerHelper.AUDIO_SWITCH_BEGIN, onAudioSwitchBegin);
					playerHelper.addEventListener(MediaPlayerHelper.AUDIO_SWITCH_END, 	onAudioSwitchEnd);
				}
				else
				{
					playerHelper.removeEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.removeEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.removeEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.removeEventListener(MediaPlayerHelper.AUDIO_SWITCH_BEGIN, onAudioSwitchBegin);
					playerHelper.removeEventListener(MediaPlayerHelper.AUDIO_SWITCH_END, 	onAudioSwitchEnd);
				}
			}
			
			setUpEvents(playerHelper, true);
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE);
			
			var switchInitiated:Boolean = false;
			
			function onReady(event:Event):void
			{
				if (!switchInitiated)
				{
					assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
					assertThat("The number of alternative audio streams is equal with the expected one.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
					assertThat("No alternate audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
					assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
					playerHelper.actualPlayer.switchAlternativeAudioIndex(expectedData.initialIndex_onReady);
					playerHelper.actualPlayer.play();
				}
			}

			function onPlaying(event:Event):void
			{
			}

			function onAudioSwitchBegin(event:Event):void
			{
				expectedData["currentTime_onAudioSwitchBegin"] = playerHelper.actualPlayer.currentTime;
				
				assertThat("The alternative audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(true));
			}
			
			function onAudioSwitchEnd(event:Event):void
			{
				expectedData["currentTime_onAudioSwitchEnd"] = playerHelper.actualPlayer.currentTime;

				assertThat("The alternative audio stream change is now completed.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("The current time is still close to the previous time.", playerHelper.actualPlayer.currentTime, greaterThanOrEqualTo(expectedData.currentTime_onAudioSwitchBegin));
				if (!switchInitiated)
				{
					assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.initialIndex_onReady));
				}
				else
				{
					assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				}
				
				if (!switchInitiated)
				{
					switchInitiated = true;
					playerHelper.actualPlayer.switchAlternativeAudioIndex(expectedData.selectedIndex_onComplete);
				}
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				assertThat("The playback has continued. Current time is greater than switch end time.", playerHelper.actualPlayer.currentTime, greaterThanOrEqualTo(expectedData.currentTime_onAudioSwitchEnd));
				
				setUpEvents(playerHelper, false);
			}
		}
		
		/**
		 * Tests automatic playback os SBR stream with alternative audio track. We
		 * set an initial alternative audio index when the player is ready. 
		 * Once the playback has started after 2 seconds into the stream, change the 
		 * alternative audio track to the specified one. The change should be 
		 * seemless and the playhead should not change back to 0.
		 */ 
		[Test(async, timeout="60000", order=5)]
		public function playLive_InitialAlternativeIndex_SwitchAfter2Sec():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var expectedData:Object = new Object();
			expectedData["numAlternativeAudioStreams"] = 2;
			expectedData["selectedIndex_onReady"] = -1;
			expectedData["initialIndex_onReady"] = 0;
			expectedData["selectedIndex_onComplete"] = 0;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			function setUpEvents(playerHelper:MediaPlayerHelper, add:Boolean):void
			{
				if (add)
				{
					playerHelper.addEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.addEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.addEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.addEventListener(MediaPlayerHelper.AUDIO_SWITCH_BEGIN, onAudioSwitchBegin);
					playerHelper.addEventListener(MediaPlayerHelper.AUDIO_SWITCH_END, 	onAudioSwitchEnd);
				}
				else
				{
					playerHelper.removeEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.removeEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.removeEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.removeEventListener(MediaPlayerHelper.AUDIO_SWITCH_BEGIN, onAudioSwitchBegin);
					playerHelper.removeEventListener(MediaPlayerHelper.AUDIO_SWITCH_END, 	onAudioSwitchEnd);
				}
			}
			
			setUpEvents(playerHelper, true);
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE);
			
			const switchTimerInterval:Number = 2000;			
			var switchTimer:Timer = new Timer(switchTimerInterval, 1);
			switchTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onSwitchTimerComplete);
			
			var switchInitiated:Boolean = false;
			
			function onReady(event:Event):void
			{
				if (!switchInitiated)
				{
					assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
					assertThat("The number of alternative audio streams is equal with the expected one.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
					assertThat("No alternate audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
					assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
					playerHelper.actualPlayer.switchAlternativeAudioIndex(expectedData.initialIndex_onReady);
					playerHelper.actualPlayer.play();
				}
			}

			function onPlaying(event:Event):void
			{
			}

			function onAudioSwitchBegin(event:Event):void
			{
				expectedData["currentTime_onAudioSwitchBegin"] = playerHelper.actualPlayer.currentTime;
				
				assertThat("The alternative audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(true));
			}
			
			function onAudioSwitchEnd(event:Event):void
			{
				expectedData["currentTime_onAudioSwitchEnd"] = playerHelper.actualPlayer.currentTime;
				
				assertThat("The alternative audio stream change is now completed.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("The current time is still close to the previous time.", playerHelper.actualPlayer.currentTime, greaterThanOrEqualTo(expectedData.currentTime_onAudioSwitchBegin));
				
				if (!switchInitiated)
				{
					assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.initialIndex_onReady));
				}
				else
				{
					assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				}

				if (!switchInitiated)
				{
					switchInitiated = true;
					switchTimer.start();		
				}
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				assertThat("The playback has continued. Current time is greater than switch end time.", playerHelper.actualPlayer.currentTime, greaterThanOrEqualTo(expectedData.currentTime_onAudioSwitchEnd));
				
				setUpEvents(playerHelper, false);
			}
			
			function onSwitchTimerComplete(event:TimerEvent):void
			{
				playerHelper.actualPlayer.switchAlternativeAudioIndex(expectedData.selectedIndex_onComplete);
				
				switchTimer.stop();
				switchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onSwitchTimerComplete);
				switchTimer = null;
			}
		}
		
		/**
		 * Tests automatic playback os SBR stream with  a shorter alternative audio track.  
		 * Before the playback has started switch the alternative audio track to 
		 * the specified one. Check that the entire main media is played.
		 */
		[Test(async, timeout="150000", order=6)]
		public function playVOD_ShorterAudio_SwitchBeforePlay():void
		{
			const testLenght:uint = 130000;
			
			var expectedData:Object = new Object();
			expectedData["numAlternativeAudioStreams"] = 2;
			expectedData["selectedIndex_onReady"] = -1;
			expectedData["selectedIndex_onComplete"] = 0;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			function setUpEvents(playerHelper:MediaPlayerHelper, add:Boolean):void
			{
				if (add)
				{
					playerHelper.addEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.addEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.addEventListener(MediaPlayerHelper.ERROR, 		onError);
				}
				else
				{
					playerHelper.removeEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.removeEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.removeEventListener(MediaPlayerHelper.ERROR, 		onError);
				}
			}
			
			setUpEvents(playerHelper, true);
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_SHORTER_AUDIO);
			
			var stepTimerInterval:uint = 10000;
			var stepTimer:Timer = new Timer(stepTimerInterval, 11);
			stepTimer.addEventListener(TimerEvent.TIMER, onStepTimer);

			var switchInitiated:Boolean = false;
			var stepTimerInitiated:Boolean = false;
			
			function onReady(event:Event):void
			{
				if (!switchInitiated)
				{
					assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
					assertThat("The number of alternative audio streams is equal with the expected one.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
					assertThat("No alternate audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
					assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
				
				
					switchInitiated = true;
					playerHelper.actualPlayer.switchAlternativeAudioIndex(expectedData.selectedIndex_onComplete);
				}
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
				expectedData["currentTime_stepTimer"] = playerHelper.actualPlayer.currentTime;
				if (!stepTimerInitiated)
				{
					stepTimerInitiated = true;
					stepTimer.start();
				}
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				setUpEvents(playerHelper, false);
			}
			
			function onStepTimer(event:TimerEvent):void
			{
				assertThat("Media is still playing.", playerHelper.actualPlayer.currentTime, greaterThan(expectedData.currentTime_stepTimer));
				expectedData["currentTime_stepTimer"] = playerHelper.actualPlayer.currentTime;
			}
		}

		/**
		 * Tests automatic playback os SBR stream with alternative audio track.  
		 * Before the playback has started switch the alternative audio track to 
		 * the specified one. 
		 */
		[Test(async, timeout="60000", order=7)]
		public function playVOD_NoInitialAlternativeIndex_SwitchBeforePlay():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var expectedData:Object = new Object();
			expectedData["numAlternativeAudioStreams"] = 2;
			expectedData["selectedIndex_onReady"] = -1;
			expectedData["selectedIndex_onComplete"] = 0;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			function setUpEvents(playerHelper:MediaPlayerHelper, add:Boolean):void
			{
				if (add)
				{
					playerHelper.addEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.addEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.addEventListener(MediaPlayerHelper.ERROR, 		onError);
				}
				else
				{
					playerHelper.removeEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.removeEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.removeEventListener(MediaPlayerHelper.ERROR, 		onError);
				}
			}
			
			setUpEvents(playerHelper, true);
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_VOD);
			
			var switchInitiated:Boolean = false;
			
			function onReady(event:Event):void
			{
				if (!switchInitiated)
				{
					assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
					assertThat("The number of alternative audio streams is equal with the expected one.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
					assertThat("No alternate audio stream switch is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
					assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
					
					switchInitiated = true;
					playerHelper.actualPlayer.switchAlternativeAudioIndex(expectedData.selectedIndex_onComplete);
				}
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				setUpEvents(playerHelper, false);
			}
		}

		/// Internals
		protected static const ALTERNATE_AUDIO_HDS_SBR_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_v_2_alternate_a/1_media_v_2_alternate_a.f4m";
		
		protected static const ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE:String = "http://10.131.237.107/live/events/latebind/events/_definst_/liveevent.f4m";
		protected static const ALTERNATE_AUDIO_HDS_SBR_WITH_SHORTER_AUDIO:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_av_2_shorter_alternate_a/1_media_av_2_shorter_alternate_a.f4m";
		
	}
}