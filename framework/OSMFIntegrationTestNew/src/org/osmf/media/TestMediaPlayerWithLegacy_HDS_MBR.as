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
	import org.osmf.media.URLResource;
	
	/**
	 * @private
	 * 
	 * Tests the functionality of OSMF while playing legacy HDS. The tests cover 
	 * the following legacy HDS cases with multi bit rate (MBR) streams:
	 * - Pure Live
	 * - Live with DVR
	 * - VOD
	 */ 
	public class TestMediaPlayerWithLegacy_HDS_MBR  extends TestMediaPlayerHelper
	{
		/**
		 * Tests multiple seek on a DVR MBR stream.
		 */
		[Test(async, timeout="60000", order=1, bugId="FM-1288")]
		public function seekToBegin_MBR_DVR():void
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
			playerHelper.mediaResource = new URLResource(LEGACY_HDS_MBR_WITH_DVR);
			
			var seekTimerInterval:uint = 1000;
			var seekTimer:Timer = new Timer(seekTimerInterval, 15);
			seekTimer.addEventListener(TimerEvent.TIMER, onSeekTimer);
			var seekTimerStarted:Boolean = false;
			
			var startSeekOnStep:uint = 13;
			var seekPositionStep:uint = 1;
			var seekPosition:uint = 0;
			
			function onReady(event:Event):void
			{
				assertThat("We should have no access to alternatve audio information", !(playerHelper.actualPlayer.hasAlternativeAudio));
				assertThat("The number of alternative audio streams is equal with 0.", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(0));
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
				if (!seekTimerStarted)
				{
					seekTimerStarted = true;
					seekTimer.start();
				}
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("Player has time trait.", playerHelper.actualPlayer.temporal);
				assertThat("Player current time is valid.", !isNaN(playerHelper.actualPlayer.currentTime));
				assertThat("Player current time greater than 0.", playerHelper.actualPlayer.currentTime, greaterThan(0));
				setUpEvents(playerHelper, false);
			}
			
			function onSeekTimer():void
			{
				if (seekTimer.currentCount >= startSeekOnStep)
				{
					playerHelper.actualPlayer.seek(seekPosition);
					seekPosition += seekPositionStep;
				}
			}
		}

		/// Internals
		private static const LEGACY_HDS_MBR_WITH_DVR:String = "http://10.131.237.107/live/events/hs_mbr_dvr/events/_definst_/liveevent.f4m";
//		private static const LEGACY_HDS_MBR_WITH_LIVE:String = "http://10.131.237.107/live/events/hs_mbr_live/events/_definst_/liveevent.f4m";
	}
}