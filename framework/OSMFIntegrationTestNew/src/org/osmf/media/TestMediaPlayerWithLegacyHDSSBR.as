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
	import flexunit.framework.Test;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.hamcrest.number.greaterThan;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.TimeEvent;
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
	[Ignore]
	public class TestMediaPlayerWithLegacyHDSSBR extends TestMediaPlayerHelper
	{
		/**
		 * Tests automatic playback of SBR stream with legacy LIVE.
		 */
		[Test(async, timeout="60000", order=1)]
		public function playLegacyHDSSBRWithLive():void
		{
			mediaPlayerExpectedStates.push(MediaPlayerState.LOADING, MediaPlayerState.READY, MediaPlayerState.PLAYING);
			
			checkPlayerState(null);
			
			mediaElement = createMediaElement(new URLResource(LEGACY_HDS_SBR_WITH_LIVE));
			mediaPlayer.media = mediaElement;
		}

		/**
		 * Tests automatic playback of SBR stream with legacy LIVE and DRM.
		 */
		[Test(async, timeout="60000", order=2)]
		public function playLegacyHDSSBRWithLiveDRM():void
		{
			mediaPlayerExpectedStates.push(MediaPlayerState.LOADING, MediaPlayerState.READY, MediaPlayerState.PLAYING);
			
			checkPlayerState(null);
			
			mediaElement = createMediaElement(new URLResource(LEGACY_HDS_SBR_WITH_LIVE_DRM));
			mediaPlayer.media = mediaElement;
		}

		/**
		 * Tests automatic playback of SBR stream with legacy DVR.
		 */
		[Test(async, timeout="60000", order=3)]
		public function playLegacyHDSSBRWithDVR():void
		{
			mediaPlayerExpectedStates.push(MediaPlayerState.LOADING, MediaPlayerState.READY, MediaPlayerState.PLAYING);
			
			checkPlayerState(null);

			mediaElement = createMediaElement(new URLResource(LEGACY_HDS_SBR_WITH_DVR));
			mediaPlayer.media = mediaElement;
		}
		
		/**
		 * Tests automatic playback of SBR stream with legacy DVR.
		 */
		[Test(async, timeout="60000", order=4)]
		public function playLegacyHDSSBRWithVOD():void
		{
			mediaPlayerExpectedStates.push(MediaPlayerState.LOADING, MediaPlayerState.READY, MediaPlayerState.PLAYING);

			checkPlayerState(null);
			
			mediaElement = createMediaElement(new URLResource(LEGACY_HDS_SBR_VOD));
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
				if (mediaPlayer.canPlay)
				{
					mediaPlayer.play();
				}
			}
		}

		/**
		 * @private
		 * 
		 * We verify that the player playhead is advancing so it is processing data.
		 */
		protected function onTimeChange(event:TimeEvent, passThroughData:Object):void
		{
			assertThat("Current time is a valid number.",  !isNaN(event.time));
			assertThat("Current time is greater than 0.",  event.time, greaterThan(0));
			
			assertThat("Media player has time trait.", mediaPlayer.temporal);
			assertThat("Media player current time is valid.", mediaPlayer.currentTime, greaterThan(0));
		}

		/**
		 * @private
		 * 
		 * Check the player state.
		 */
		override protected function checkPlayerState(state:String):void
		{
			super.checkPlayerState(state);
			
			if (mediaPlayerExpectedStates.length <= mediaPlayerRecordedStatesCount)
			{
				// we've checked all our expected states, let's wait for a time change event
				// in order to see that actually the NetStream is processing data
				var info:Object = new Object;
				info.expectedEventType = "TimeEvent";
				info.expectedEvent = TimeEvent.CURRENT_TIME_CHANGE;
				
				mediaPlayer.addEventListener(
					TimeEvent.CURRENT_TIME_CHANGE,
					Async.asyncHandler(this, onTimeChange, 6000, info, onTimeout),
					false,
					0,
					true
				);
				
			}
		}
		
		/// Internals
		private static const LEGACY_HDS_SBR_WITH_DVR:String = "http://10.131.237.107/live/events/hs_sbr_dvr/events/_definst_/liveevent.f4m";
		private static const LEGACY_HDS_SBR_WITH_LIVE:String = "http://10.131.237.107/live/events/hs_sbr_live/events/_definst_/liveevent.f4m";
		private static const LEGACY_HDS_SBR_WITH_LIVE_DRM:String = "http://10.131.237.107/live/events/hs_sbr_live_drm/events/_definst_/liveevent.f4m";
		private static const LEGACY_HDS_SBR_VOD:String = "http://zeridemo-f.akamaihd.net/content/inoutedit-mbr/inoutedit_h264_3000.f4m";	
		
		private static const LEGACY_HDS_MBR_WITH_DVR:String = "http://10.131.237.107/live/events/hs_mbr_dvr/events/_definst_/liveevent.f4m";
		private static const LEGACY_HDS_MBR_WITH_LIVE:String = "http://10.131.237.107/live/events/hs_mbr_live/events/_definst_/liveevent.f4m";
	}
}