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
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import org.flexunit.assertThat;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.object.equalTo;
	import org.osmf.net.NetClient;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * @private
	 * 
	 * Tests the functionality of OSMF while playing legacy HDS. The tests cover 
	 * the following legacy HDS cases with single bit rate (SBR) streams:
	 * - Pure Live
	 * - Live with DVR
	 * - VOD
	 */ 
	public class TestMediaPlayerWithLegacy_Events  extends TestMediaPlayerHelper
	{
		/**
		 * Tests metadata event when playing SBR stream with legacy LIVE.
		 */
		[Test(async, timeout="60000", order=1)]
		public function playLegacyHDSSBRWithLive_MetaData():void
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
			
			var lowLevelAPI_NetStream:NetStream = null;
			var metadataReceived:Boolean = false;
			
			function onReady(event:Event):void
			{
				if (lowLevelAPI_NetStream == null)
				{
					var loadTrait:LoadTrait = playerHelper.actualPlayer.media.getTrait(MediaTraitType.LOAD) as LoadTrait;
					if (loadTrait != null && loadTrait.hasOwnProperty("netStream"))
					{
						lowLevelAPI_NetStream = loadTrait["netStream"] as NetStream;
						if (lowLevelAPI_NetStream != null && lowLevelAPI_NetStream.client != null)
						{
							NetClient(lowLevelAPI_NetStream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
						}
					}
				}
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
				assertThat("We received the expected metadata.", (lowLevelAPI_NetStream != null && metadataReceived));
				
				setUpEvents(playerHelper, false);
			}
			
			function onMetaData(info:Object):void
			{
				metadataReceived = true;	
			}
				
		}

		/**
		 * Tests metadata event when playing SBR stream with legacy LIVE.
		 */
		[Test(async, timeout="60000", order=1)]
		public function playLegacyHDSSBRWithVOD_MetaData():void
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
			
			var lowLevelAPI_NetStream:NetStream = null;
			var metadataReceived:Boolean = false;
			
			function onReady(event:Event):void
			{
				if (lowLevelAPI_NetStream == null)
				{
					var loadTrait:LoadTrait = playerHelper.actualPlayer.media.getTrait(MediaTraitType.LOAD) as LoadTrait;
					if (loadTrait != null && loadTrait.hasOwnProperty("netStream"))
					{
						lowLevelAPI_NetStream = loadTrait["netStream"] as NetStream;
						if (lowLevelAPI_NetStream != null && lowLevelAPI_NetStream.client != null)
						{
							NetClient(lowLevelAPI_NetStream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
						}
					}
				}
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
				assertThat("We received the expected metadata.", (lowLevelAPI_NetStream != null && metadataReceived));
				
				setUpEvents(playerHelper, false);
			}
			
			function onMetaData(info:Object):void
			{
				metadataReceived = true;	
			}
			
		}

		/// Internals
		private static const LEGACY_HDS_SBR_WITH_DVR:String = "http://10.131.237.107/live/events/hs_sbr_dvr/events/_definst_/liveevent.f4m";
		private static const LEGACY_HDS_SBR_WITH_LIVE:String = "http://10.131.237.107/live/events/hs_sbr_live/events/_definst_/liveevent.f4m";
		private static const LEGACY_HDS_SBR_WITH_LIVE_DRM:String = "http://10.131.237.107/live/events/hs_sbr_live_drm/events/_definst_/liveevent.f4m";
		private static const LEGACY_HDS_SBR_VOD:String = "http://zeridemo-f.akamaihd.net/content/inoutedit-mbr/inoutedit_h264_3000.f4m";	
	}
}