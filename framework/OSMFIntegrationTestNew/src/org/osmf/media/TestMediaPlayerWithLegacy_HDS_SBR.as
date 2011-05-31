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
	
	import mx.accessibility.AccConst;
	
	import org.flexunit.assertThat;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.object.equalTo;
	import org.osmf.media.URLResource;
	
	/**
	 * @private
	 * 
	 * Tests the functionality of OSMF while playing legacy HDS. The tests cover 
	 * the following legacy HDS cases with single bit rate (SBR) streams:
	 * - Pure Live
	 * - Live with DVR
	 * - VOD
	 */ 
	public class TestMediaPlayerWithLegacy_HDS_SBR  extends TestMediaPlayerHelper
	{
		/**
		 * Tests automatic playback of SBR stream with legacy LIVE.
		 */
		[Test(async, timeout="60000", order=1)]
		public function playLegacyHDSSBRWithLive():void
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
			playerHelper.mediaResource = new URLResource(LEGACY_HDS_SBR_WITH_LIVE);
			
			function onReady(event:Event):void
			{
				assertThat("We should have no access to alternatve audio information", !(playerHelper.actualPlayer.hasAlternativeAudio));
				assertThat("The number of alternative audio streams is equal with 0.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(0));
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
		 * Tests automatic playback of SBR stream with legacy LIVE and DRM.
		 */
		[Test(async, timeout="60000", order=2)]
		public function playLegacyHDSSBRWithLiveDRM():void
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
			playerHelper.mediaResource = new URLResource(LEGACY_HDS_SBR_WITH_LIVE_DRM);
			
			function onReady(event:Event):void
			{
				assertThat("We should have no access to alternatve audio information", !(playerHelper.actualPlayer.hasAlternativeAudio));
				assertThat("The number of alternative audio streams is equal with 0.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(0));
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Player has time trait.", playerHelper.actualPlayer.temporal);
				assertThat("Player current time is valid.", !isNaN(playerHelper.actualPlayer.currentTime));
				assertThat("Player current time greater than 0.", playerHelper.actualPlayer.currentTime, greaterThanOrEqualTo(0));
				
				setUpEvents(playerHelper, false);
			}
		}

		/**
		 * Tests automatic playback of SBR stream with legacy DVR.
		 */
		[Test(async, timeout="60000", order=3)]
		public function playLegacyHDSSBRWithDVR():void
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
			playerHelper.mediaResource = new URLResource(LEGACY_HDS_SBR_WITH_DVR);
			
			function onReady(event:Event):void
			{
				assertThat("We should have no access to alternatve audio information", !(playerHelper.actualPlayer.hasAlternativeAudio));
				assertThat("The number of alternative audio streams is equal with 0.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(0));
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
		 * Tests automatic playback of SBR stream with legacy DVR.
		 */
		[Test(async, timeout="60000", order=4)]
		public function playLegacyHDSSBRWithVOD():void
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
			playerHelper.mediaResource = new URLResource(LEGACY_HDS_SBR_VOD);
			
			function onReady(event:Event):void
			{
				assertThat("We should have no access to alternatve audio information", !(playerHelper.actualPlayer.hasAlternativeAudio));
				assertThat("The number of alternative audio streams is equal with 0.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(0));
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
		 * Tests seek on a LIVE SBR stream.
		 */
		[Test(async, timeout="60000", order=5, bugId="FM-1287")]
		public function seekOutsideBuffer_SBR_VOD():void
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
			
			playerHelper.mediaResource = new URLResource(LEGACY_HDS_SBR_VOD_LARGE);
			
			var seekTimerInterval:uint = 1000;
			var seekTimer:Timer = null;
			var seekInitiated:Boolean = false;
			var bufferTime:uint = 40;
			var seekPosition:uint = 90;
			
			function onReady(event:Event):void
			{
				assertThat("We should have no access to alternatve audio information", !(playerHelper.actualPlayer.hasAlternativeAudio));
				assertThat("The number of alternative audio streams is equal with 0.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(0));
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
				assertThat("Player current time is valid.", !isNaN(playerHelper.actualPlayer.currentTime));
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

					seekInitiated = true;
					playerHelper.actualPlayer.seek(seekPosition);
				}
			}
		}

		/// Internals
		private static const LEGACY_HDS_SBR_WITH_DVR:String = "http://10.131.237.107/live/events/hs_sbr_dvr/events/_definst_/liveevent.f4m";
		private static const LEGACY_HDS_SBR_WITH_LIVE:String = "http://10.131.237.107/live/events/hs_sbr_live/events/_definst_/liveevent.f4m";
		private static const LEGACY_HDS_SBR_WITH_LIVE_DRM:String = "http://10.131.237.107/live/events/hs_sbr_live_drm/events/_definst_/liveevent.f4m";
		private static const LEGACY_HDS_SBR_VOD:String = "http://zeridemo-f.akamaihd.net/content/inoutedit-mbr/inoutedit_h264_3000.f4m";	
		private static const LEGACY_HDS_SBR_VOD_LARGE:String = "http://10.131.237.107/vod/hs/vod/ex.f4m"; 
	}
}