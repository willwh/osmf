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
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.object.equalTo;
	import org.osmf.media.URLResource;

	/**
	 * Class tests late binding audio behavior when different operations are
	 * requested.
	 */
	public class TestMediaPlayerWithAlternateAudio_HDS_SBR_Operations extends TestMediaPlayerHelper
	{
		/**
		 * Tests the late-binding behavior when another seek command is issued without 
		 * waiting the completion of the first one. Once we switched to an alternative
		 * audio stream, we issue 10 consecutive seek commands without waiting for their
		 * completions.
		 */ 
		[Test(async, timeout="60000", bugId="FM-1301")]
		public function multipleSeeks_SwitchBeforePlay():void
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
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_VOD);
			
			const seekTimerInterval:Number = 30;			
			var seekTimer:Timer = new Timer(seekTimerInterval, 10);
			seekTimer.addEventListener(TimerEvent.TIMER, onSeekTimer);
			
			var switchInitiated:Boolean = false;
			var seekPosition:uint = 10;
			var seekStep:uint = 20;
			
			function onReady(event:Event):void
			{
				assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
				assertThat("The number of alternative audio streams is equal with the expected one.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
				assertThat("No alternate audio stream change is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
				
				if (!switchInitiated)
				{
					switchInitiated = true;
					playerHelper.actualPlayer.switchAlternativeAudioIndex(1);
				}
				playerHelper.actualPlayer.play();
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
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				
				if (!seekTimer.running)
				{
					seekTimer.start();
				}
			}

			function onComplete(passThroughData:Object):void
			{
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				
				setUpEvents(playerHelper, false);
			}
			
			function onSeekTimer(event:TimerEvent):void
			{
				playerHelper.actualPlayer.seek(seekPosition);
				seekPosition+=20;
			}
		}

		/**
		 * Tests the late-binding behavior when another seek command is issued without 
		 * waiting the completion of the first one. Once we switched to an alternative
		 * audio stream, we issue 10 consecutive seek commands without waiting for their
		 * completions.
		 */ 
		[Test(async, timeout="60000")]
		public function multipleSeeks_SwitchAfterPlay():void
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
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_VOD);
			
			const seekTimerInterval:Number = 30;			
			var seekTimer:Timer = new Timer(seekTimerInterval, 10);
			seekTimer.addEventListener(TimerEvent.TIMER, onSeekTimer);
			
			var switchInitiated:Boolean = false;
			var seekPosition:uint = 10;
			var seekStep:uint = 20;
			
			function onReady(event:Event):void
			{
				assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
				assertThat("The number of alternative audio streams is equal with the expected one.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
				assertThat("No alternate audio stream change is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
				
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
				if (!switchInitiated)
				{
					switchInitiated = true;
					playerHelper.actualPlayer.switchAlternativeAudioIndex(1);
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
				
				assertThat("The alternative audio stream change is now completed.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("The current time is still close to the previous time.", playerHelper.actualPlayer.currentTime, greaterThanOrEqualTo(expectedData.currentTime_onAudioSwitchBegin));
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				
				if (!seekTimer.running)
				{
					seekTimer.start();
				}
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Specified alternate audio stream is currently selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				
				setUpEvents(playerHelper, false);
			}
			
			function onSeekTimer(event:TimerEvent):void
			{
				playerHelper.actualPlayer.seek(seekPosition);
				seekPosition+=20;
			}
		}

		/// Internals
		protected static const ALTERNATE_AUDIO_HDS_SBR_WITH_VOD:String = "http://10.131.237.104/vod/late_binding_audio/API_tests_assets/1_media_v_2_alternate_a/1_media_v_2_alternate_a.f4m";
	}
}