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
	import org.osmf.events.SeekEvent;
	import org.osmf.traits.MediaTraitType;
	

	public class TestMediaPlayerWithStreamingRTMP_Vod  extends TestMediaPlayerHelper
	{
		
		
		/**
		 * Tests automatic playback of Streaming RTMP VOD
		 */
		[Test(async, timeout="60000", order=1)]
		public function playProgressiveVOD_RTMP():void
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
			playerHelper.mediaResource = new URLResource(STREAMING_RTMP_VOD);
			
			function onReady(event:Event):void
			{
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
				setUpEvents(playerHelper, false);
			}
		}
		
		/**
		 * Tests seek on a Encrypted FLV
		 */
		[Test(async, timeout="60000")]
		public function seekOutsideBuffer_Progressive_DRM():void
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
			
			playerHelper.mediaResource = new URLResource(STREAMING_RTMP_VOD);
			
			var seekTimerInterval:uint = 1000;
			var seekTimer:Timer = null;
			var seekInitiated:Boolean = false;
			var bufferTime:uint = 15;
			var seekPosition:uint = 20;
			
			function onSeekingChangeHandler(event:SeekEvent):void
			{
				if (event.seeking)
				{
				}
				else
				{
					// The seek was complete
					assertThat("Player current time should be the position we have seeked.", Math.floor(playerHelper.actualPlayer.currentTime), equalTo(seekPosition));
					seekInitiated = true;
					
				}
			}
			
			function onReady(event:Event):void
			{
				playerHelper.actualPlayer.bufferTime = bufferTime;
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
				assertThat("Player has time trait.", playerHelper.actualPlayer.temporal);
				assertThat("Player current time greater than 0.", playerHelper.actualPlayer.currentTime, greaterThan(0));
				assertThat("Player current time greater than seeked position.", playerHelper.actualPlayer.currentTime, greaterThan(seekPosition));
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
		
		
		private static const STREAMING_RTMP_VOD:String = "rtmp://cobra.certificationsuites.com/vod/mp4:video/f4v/H264F24Ht720Qlt350.f4v"; 
	}
}