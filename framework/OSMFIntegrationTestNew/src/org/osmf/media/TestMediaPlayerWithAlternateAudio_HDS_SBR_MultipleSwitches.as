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
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.object.equalTo;
	
	import org.osmf.media.URLResource;

	/**
	 * Class tests late binding audio behavior when consecutive changes are
	 * requested.
	 */
	public class TestMediaPlayerWithAlternateAudio_HDS_SBR_MultipleSwitches extends TestMediaPlayerHelper
	{
		/**
		 * Tests the late-binding behavior when another switch command is issued without 
		 * waiting the completion of the first one. Once the player is ready, before we start 
		 * playing, we issue two consecutive switchAlternateAudioIndex commands.
		 */ 
		[Test(async, timeout="60000")]
		public function playLive_ConsecutiveSwitches_NoWait_BeforePlay():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var expectedData:Object = new Object();
			expectedData["numAlternativeAudioStreams"] = 2;
			expectedData["selectedIndex_onReady"] = -1;
			expectedData["selectedIndex_onComplete"] = 0;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			playerHelper.addEventListener(MediaPlayerHelper.READY, onReady);
			playerHelper.addEventListener(MediaPlayerHelper.PLAYING, onPlaying);
			playerHelper.addEventListener(MediaPlayerHelper.ERROR, onError);
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE);
			
			var switchInitiated:Boolean = false;
			function onReady(event:Event):void
			{
				assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
				assertThat("The number of alternative audio streams should be greater than 0", playerHelper.actualPlayer.numAlternativeAudioStreams, greaterThan(0));
				assertThat("The number of alternative audio streams should be greater than 0", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
				assertThat("No alternate audio stream change is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
				
				if (!switchInitiated)
				{
					switchInitiated = true;
					playerHelper.actualPlayer.switchAlternativeAudioIndex(1);
					playerHelper.actualPlayer.switchAlternativeAudioIndex(0);
				}
				
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
				assertThat("The number of alternative audio streams should be greater than 0", playerHelper.actualPlayer.numAlternativeAudioStreams, greaterThan(0));
				assertThat("The number of alternative audio streams should be greater than 0", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
				assertThat("No alternate audio stream change is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("Specified alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
			}
		}

		/**
		 * Tests the late-binding behavior when another switch command is issued without 
		 * waiting the completion of the first one. Once the player is ready, we start playing 
		 * the media element and when the player changes its state to playing state, we issue
		 * two consecutive switchAlternateAudioIndex commands.
		 */ 
		[Test(async, timeout="60000")]
		public function playLive_ConsecutiveSwitches_NoWait_AfterPlay():void
		{
			const testLenght:uint = DEFAULT_TEST_LENGTH;
			
			var expectedData:Object = new Object();
			expectedData["numAlternativeAudioStreams"] = 2;
			expectedData["selectedIndex_onReady"] = -1;
			expectedData["selectedIndex_onComplete"] = 1;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);

			playerHelper.addEventListener(MediaPlayerHelper.READY, onReady);
			playerHelper.addEventListener(MediaPlayerHelper.PLAYING, onPlaying);
			playerHelper.addEventListener(MediaPlayerHelper.ERROR, onError);
			playerHelper.mediaResource = new URLResource(ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE);
				
			function onReady(event:Event):void
			{
				assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
				assertThat("The number of alternative audio streams should be greater than 0", playerHelper.actualPlayer.numAlternativeAudioStreams, greaterThan(0));
				assertThat("The number of alternative audio streams should be greater than 0", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
				assertThat("No alternate audio stream change is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("No alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onReady));
				playerHelper.actualPlayer.play();
			}
			
			var switchInitiated:Boolean = false;
			function onPlaying(event:Event):void
			{
				if (!switchInitiated)
				{
					switchInitiated = true;
					playerHelper.actualPlayer.switchAlternativeAudioIndex(0);
					playerHelper.actualPlayer.switchAlternativeAudioIndex(1);
				}
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("We should have access to alternatve audio information", playerHelper.actualPlayer.hasAlternativeAudio);
				assertThat("The number of alternative audio streams should be greater than 0", playerHelper.actualPlayer.numAlternativeAudioStreams, greaterThan(0));
				assertThat("The number of alternative audio streams should be greater than 0", playerHelper.actualPlayer.numAlternativeAudioStreams, equalTo(expectedData.numAlternativeAudioStreams));
				assertThat("No alternate audio stream change is in progress.", playerHelper.actualPlayer.alternativeAudioStreamSwitching, equalTo(false));
				assertThat("Specified alternate audio stream is selected.", playerHelper.actualPlayer.currentAlternativeAudioStreamIndex, equalTo(expectedData.selectedIndex_onComplete));
			}
		}
		
		/// Internals
		protected static const ALTERNATE_AUDIO_HDS_SBR_WITH_LIVE:String = "http://10.131.237.107/live/events/latebind/events/_definst_/liveevent.f4m";
	}
}