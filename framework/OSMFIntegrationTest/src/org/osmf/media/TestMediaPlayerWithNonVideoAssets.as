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
	
	/**
	 * @private
	 * 
	 * Tests the functionality of OSMF while playing non Video Assets. The tests cover 
	 * the following assets:
	 * - MP3
	 * - SWF
	 */ 
	public class TestMediaPlayerWithNonVideoAssets  extends TestMediaPlayerHelper
	{

		/**
		 * Tests seek on a Progressive MP3
		 */
		[Test(async, timeout="60000")]
		public function playAndSeekProgressiveMP3():void
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
					
				}
			}
			
			setUpEvents(playerHelper, true);
			
			playerHelper.mediaResource = new URLResource(REMOTE_MP3);
			
			var seekTimerInterval:uint = 7000;
			var seekTimer:Timer = null;
			var seekInitiated:Boolean = false;
			var bufferTime:uint = 10;
			var seekPosition:uint = 10;
			var mediaPlayerVolume:Number = 0.5;
			
			function onSeekingChangeHandler(event:SeekEvent):void
			{
				if (event.seeking)
				{
				}
				else
				{
			
					assertThat("Player current time should be the position we have seeked.", Math.floor(playerHelper.actualPlayer.currentTime), equalTo(seekPosition));
					seekInitiated = true;
					playerHelper.actualPlayer.removeEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChangeHandler);

				}
			}
			
			function onReady(event:Event):void
			{
				playerHelper.actualPlayer.bufferTime = bufferTime;
				playerHelper.actualPlayer.play();
				playerHelper.actualPlayer.volume = mediaPlayerVolume;
			}
			
			function onPlaying(event:Event):void
			{
				if (seekTimer == null)
				{
					seekTimer = new Timer(seekTimerInterval,1);
					seekTimer.addEventListener(TimerEvent.TIMER, onSeekTimer);
					seekTimer.start();
				}
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("We performed the seek operation", seekInitiated);
				assertThat("Player has time trait.", playerHelper.actualPlayer.temporal);
				assertThat("Player current time is valid.", !isNaN(playerHelper.actualPlayer.currentTime));
				assertThat("Player current time greater than 0.", playerHelper.actualPlayer.currentTime, greaterThan(0));
				assertThat("Player current time greater than seeked position.", playerHelper.actualPlayer.currentTime, greaterThan(seekPosition));
				
				assertThat("MediaElement has Audio trait",playerHelper.actualPlayer.media.hasTrait(MediaTraitType.AUDIO));
				assertThat("Player current volume is the one we have set", playerHelper.actualPlayer.volume, equalTo(mediaPlayerVolume));


				
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

		
		/**
		 * Tests seek on a Streaming RTMP MP3
		 */
		[Test(async, timeout="60000")]
		public function playAndSeekRTMPStreamingMP3():void
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
					
				}
			}
			
			setUpEvents(playerHelper, true);
			
			playerHelper.mediaResource = new URLResource(REMOTE_MP3);
			
			var seekTimerInterval:uint = 7000;
			var seekTimer:Timer = null;
			var seekInitiated:Boolean = false;
			var bufferTime:uint = 10;
			var seekPosition:uint = 10;
			var mediaPlayerVolume:Number = 0.5;
			
			function onSeekingChangeHandler(event:SeekEvent):void
			{
				if (event.seeking)
				{
				}
				else
				{
					
					assertThat("Player current time should be the position we have seeked.", Math.floor(playerHelper.actualPlayer.currentTime), equalTo(seekPosition));
					seekInitiated = true;
					playerHelper.actualPlayer.removeEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChangeHandler);
					
				}
			}
			
			function onReady(event:Event):void
			{
				playerHelper.actualPlayer.bufferTime = bufferTime;
				playerHelper.actualPlayer.play();
				playerHelper.actualPlayer.volume = mediaPlayerVolume;
			}
			
			function onPlaying(event:Event):void
			{
				if (seekTimer == null)
				{
					seekTimer = new Timer(seekTimerInterval,1);
					seekTimer.addEventListener(TimerEvent.TIMER, onSeekTimer);
					seekTimer.start();
				}
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("We performed the seek operation", seekInitiated);
				assertThat("Player has time trait.", playerHelper.actualPlayer.temporal);
				assertThat("Player current time is valid.", !isNaN(playerHelper.actualPlayer.currentTime));
				assertThat("Player current time greater than 0.", playerHelper.actualPlayer.currentTime, greaterThan(0));
				assertThat("Player current time greater than seeked position.", playerHelper.actualPlayer.currentTime, greaterThan(seekPosition));
				
				assertThat("MediaElement has Audio trait",playerHelper.actualPlayer.media.hasTrait(MediaTraitType.AUDIO));
				assertThat("Player current volume is the one we have set", playerHelper.actualPlayer.volume, equalTo(mediaPlayerVolume));
				
				
				
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
		
		/**
		 * Test the loading of a SWF
		 */
		
		[Test(async, timeout="60000", order=4)]
		public function testSWF():void
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
			playerHelper.mediaResource = new URLResource(CHROMELESS_SWF_AS3);
			
			function onReady(event:Event):void
			{
				assertThat("MediaElement has display trait",playerHelper.actualPlayer.media.hasTrait(MediaTraitType.DISPLAY_OBJECT));
				assertThat("Player doesn't have time trait.", !playerHelper.actualPlayer.temporal);

			}
			
			function onPlaying(event:Event):void
			{
			}
			
			function onComplete(passThroughData:Object):void
			{
				setUpEvents(playerHelper, false);
			}
		}
		
		private static const CHROMELESS_SWF_AS3:String			= "http://mediapm.edgesuite.net/osmf/swf/ChromelessPlayer.swf";
				
		
		private static const REMOTE_MP3:String 					= "http://mediapm.edgesuite.net/osmf/content/test/train_1500.mp3";
		private static const REMOTE_AUDIO_STREAM:String 		= "rtmp://cp67126.edgefcs.net/ondemand/mp3:mediapm/strobe/content/test/train_1500";

	}
}