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
	import org.hamcrest.object.equalTo;
	import org.osmf.events.SeekEvent;
	
	/**
	 * @private
	 * 
	 * Tests the functionality of OSMF while playing legacy HDS. The tests cover 
	 * the following legacy HDS cases with multi bit rate (MBR) streams:
	 * - Pure Live
	 * - Live with DVR
	 * - VOD
	 */ 
	public class TestMediaPlayerWithRTMP_MBR  extends TestMediaPlayerHelper
	{
		
		/**
		 * Tests the auto switching behavior for an RTMP MBR stream.
		 * The assumption is that due the fact that the stream is encoded 
		 * at small bitrates, there will be a switch to another bitrate
		 * so the index will be different than 0.
		 */
		[Test(async, timeout="60000", order=1)]
		public function playVOD_AutoSwitch():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
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
			playerHelper.mediaResource = new URLResource(RTMP_MBR_VOD);
			
			function onReady(event:Event):void
			{
				assertThat("We should have multiple bit rates available", playerHelper.actualPlayer.isDynamicStream);
				assertThat("The initial index of the dynamic stream trait is 0.", playerHelper.actualPlayer.currentDynamicStreamIndex, equalTo(0));
				playerHelper.actualPlayer.autoDynamicStreamSwitch = true;
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Player has time trait.", playerHelper.actualPlayer.temporal);
				assertThat("Player current time is valid.", !isNaN(playerHelper.actualPlayer.currentTime));
				assertThat("Player current time greater than 0.", playerHelper.actualPlayer.currentTime, greaterThan(0));
				assertThat("The current index of the dynamic stream trait is greater than 0.", playerHelper.actualPlayer.currentDynamicStreamIndex, greaterThan(0));
				setUpEvents(playerHelper, false);
			}
		}
		
		
		/**
		 * Tests the manual switching behavior for an MBR stream.
		 */
		[Test(async, timeout="60000", order=2)]
		public function playVOD_ManualSwitchUp_AfterPlay():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var expectedData:Object = new Object();
			expectedData["numDynamicStreams"] = 4;
			expectedData["selectedIndex_onReady"] = 0;
			expectedData["selectedIndex_onComplete"] = 2;
			
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
			playerHelper.mediaResource = new URLResource(RTMP_MBR_VOD);
			
			function onReady(event:Event):void
			{
				assertThat("We should have multiple bit rates available", playerHelper.actualPlayer.isDynamicStream);
				assertThat("The initial index of the dynamic stream trait is 0.", playerHelper.actualPlayer.currentDynamicStreamIndex, equalTo(expectedData.selectedIndex_onReady));
				assertThat("There are 4 bit rates available.", playerHelper.actualPlayer.numDynamicStreams, equalTo(expectedData.numDynamicStreams));
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
				playerHelper.actualPlayer.switchDynamicStreamIndex(expectedData.selectedIndex_onComplete);
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Player has time trait.", playerHelper.actualPlayer.temporal);
				assertThat("Player current time is valid.", !isNaN(playerHelper.actualPlayer.currentTime));
				assertThat("Player current time greater than 0.", playerHelper.actualPlayer.currentTime, greaterThan(0));
				assertThat("The current index of the dynamic stream trait is the expected one.", playerHelper.actualPlayer.currentDynamicStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
				setUpEvents(playerHelper, false);
			}
		}
		
		[Test(async, timeout="60000", order=3)]
		public function playVOD_RTMP_Seek():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var seekTimerInterval:uint = 1000;
			var seekTimer:Timer = null;
			var seekInitiated:Boolean = false;
			var seekPosition:uint = 30;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			function setUpEvents(playerHelper:MediaPlayerHelper, add:Boolean):void
			{
				if (add)
				{
					playerHelper.addEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.addEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.addEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.actualPlayer.addEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChangeHandler);

				}
				else
				{
					playerHelper.removeEventListener(MediaPlayerHelper.READY, 		onReady); 
					playerHelper.removeEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.removeEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.actualPlayer.removeEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChangeHandler);

				}
			}
			
			setUpEvents(playerHelper, true);
			playerHelper.mediaResource = new URLResource(RTMP_MBR_VOD);
			
			
			function onSeekingChangeHandler(event:SeekEvent):void
			{
				if (event.seeking)
				{
				}
				else
				{
					// The seek was complete
					assertThat("Player current time should be the position we have seeked.", playerHelper.actualPlayer.currentTime, equalTo(seekPosition));
					seekInitiated = true;
		
				}
			}

			
			function onReady(event:Event):void
			{
				assertThat("We should have multiple bit rates available", playerHelper.actualPlayer.isDynamicStream);
				playerHelper.actualPlayer.autoDynamicStreamSwitch = true;
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
				
				if (seekTimer == null)
				{
					seekTimer = new Timer(seekTimerInterval);
					seekTimer.addEventListener(TimerEvent.TIMER, onSeekTimer);
					seekTimer.start();
				}
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("We performed the seek operation", seekInitiated);

				setUpEvents(playerHelper, false);
			}
			
			function onSeekTimer():void
			{
				if (playerHelper.actualPlayer.temporal 
					&& !isNaN(playerHelper.actualPlayer.currentTime) 
					&& (playerHelper.actualPlayer.currentTime > 0)
				)
				{
					seekTimer.removeEventListener(TimerEvent.TIMER, onSeekTimer);
					seekTimer.stop();
					playerHelper.actualPlayer.seek(seekPosition);
				}
			}
		}
		
		
		/// Internals
		private static const RTMP_MBR_VOD:String = "http://cobra.certificationsuites.com/vod/media/video/f4v/H264PbF24Ht480Qlt_MBR_900_750_500_350.f4m";	
	}
}