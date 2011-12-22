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
	import org.osmf.events.PlayEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.net.StreamType;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.traits.PlayState;
	

	public class TestMediaPlayerWithRTMPLive  extends TestMediaPlayerHelper
	{
		
		/**
		 * Tests the playback of Live RTMP content
		 * Test that you can pause and resume a RTMP Live stream
		 */
		[Test(async, timeout="60000", order=1)]
		public function playLiveStream():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var pauseTimerInterval:uint = 1000;
			var pauseTimer:Timer = null;
			
			var paused:Boolean = false;
			var resumed:Boolean = false;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			function setUpEvents(playerHelper:MediaPlayerHelper, add:Boolean):void
			{
				if (add)
				{
					playerHelper.addEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.addEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.addEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.actualPlayer.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
				}
				else
				{
					playerHelper.removeEventListener(MediaPlayerHelper.READY, 		onReady); 
					playerHelper.removeEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.removeEventListener(MediaPlayerHelper.ERROR, 		onError);
				}
			}
			
			setUpEvents(playerHelper, true);
			
			var streamingResouce: StreamingURLResource = new StreamingURLResource(RTMP_LIVE);
			streamingResouce.streamType = StreamType.LIVE;
			playerHelper.mediaResource = streamingResouce;
			
			function onReady(event:Event):void
			{
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
				assertThat("Verify that you can't seek", !playerHelper.actualPlayer.canSeek);



				if (pauseTimer == null)
				{
					pauseTimer = new Timer(pauseTimerInterval);
					pauseTimer.addEventListener(TimerEvent.TIMER, onPauseTimer);
					pauseTimer.start();
				}
				
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Verify that the stream was paused", paused);
				assertThat("Verify that the stream was resumed", resumed);
				setUpEvents(playerHelper, false);
			}
			
			function onPlayStateChange(event:PlayEvent):void
			{
				
				switch (event.playState)
				{
					case PlayState.PLAYING:
						if (paused)
						{
							resumed = true;
						}	
					break;
					// Do the validations when the playState was changed to "paused"
					case PlayState.PAUSED :
						paused =  playerHelper.actualPlayer.paused;
						playerHelper.actualPlayer.play();

						break;
					
					default :
						break;
				}

			}
			
			function onPauseTimer():void
			{
				if (playerHelper.actualPlayer.temporal 
					&& !isNaN(playerHelper.actualPlayer.currentTime) 
					&& (playerHelper.actualPlayer.currentTime > 0)
				)
				{
					pauseTimer.removeEventListener(TimerEvent.TIMER, onPauseTimer);
					pauseTimer.stop();
					playerHelper.actualPlayer.pause();
				}
			}
			
		}
		
		
		
		
		/// Internals
		private static const RTMP_LIVE:String = "rtmp://mediadelivery.adobe.com/mpp/livestream2";	
	}
}