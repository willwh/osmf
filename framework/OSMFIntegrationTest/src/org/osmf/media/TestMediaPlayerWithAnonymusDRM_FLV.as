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
	import org.osmf.events.BufferEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * @private
	 * 
	 * Tests the functionality of OSMF while playing Adonymus DRM streams. 
	 */ 
	public class TestMediaPlayerWithAnonymusDRM_FLV  extends TestMediaPlayerHelper
	{
		CONFIG::FLASH_10_1	
		{
		
		/**
		 * Tests automatic playback of Encrypted FLV. 
		 */
		
		[Test(async, timeout="60000", order=4)]
		public function playProgressiveVOD_FLV_DRM():void
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
			playerHelper.mediaResource = new URLResource(PROGRESSIVE_ENCRYPTED_FLV);
			
			function onReady(event:Event):void
			{
				playerHelper.actualPlayer.play();
			}
			
			function onPlaying(event:Event):void
			{
	
			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("MediaElement has DRM trait",playerHelper.actualPlayer.media.hasTrait(MediaTraitType.DRM));

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
		public function seekInsideBuffer_Progressive_DRM():void
		{
			const testLenght:uint = 25000;
			
			var seekInitiated:Boolean = false;
			var bufferTime:uint = 15;
			var seekPosition:uint = 10;
			
			runAfterInterval(this, testLenght, playerHelper.info, onComplete, onTimeout);
			
			function setUpEvents(playerHelper:MediaPlayerHelper, add:Boolean):void
			{
				if (add)
				{
					playerHelper.addEventListener(MediaPlayerHelper.READY, 		onReady);
					playerHelper.addEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.addEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.actualPlayer.addEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChangeHandler);
					playerHelper.actualPlayer.addEventListener(BufferEvent.BUFFERING_CHANGE, onBufferingChangeHandler);

				}
				else
				{
					playerHelper.removeEventListener(MediaPlayerHelper.READY, 		onReady); 
					playerHelper.removeEventListener(MediaPlayerHelper.PLAYING, 	onPlaying);
					playerHelper.removeEventListener(MediaPlayerHelper.ERROR, 		onError);
					playerHelper.actualPlayer.removeEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChangeHandler);
					playerHelper.actualPlayer.removeEventListener(BufferEvent.BUFFERING_CHANGE, onBufferingChangeHandler);


				}
			}
			
			setUpEvents(playerHelper, true);
			
			playerHelper.mediaResource = new URLResource(PROGRESSIVE_ENCRYPTED_FLV);
			

			
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
			
			// Make the seek when the buffer is full
			
			function onBufferingChangeHandler(event:BufferEvent):void
			{

				if (!event.buffering)
				{
					playerHelper.actualPlayer.seek(seekPosition);					
				}

			}
			function onReady(event:Event):void
			{
				playerHelper.actualPlayer.bufferTime = bufferTime;
				playerHelper.actualPlayer.play();

			}
			
			function onPlaying(event:Event):void
			{

			}
			
			function onComplete(passThroughData:Object):void
			{
				assertThat("We performed the seek operation", seekInitiated);
				assertThat("Player current time greater than seeked position.", playerHelper.actualPlayer.currentTime, greaterThan(seekPosition));
				setUpEvents(playerHelper, false);
			}
			
			
		}


		private static const PROGRESSIVE_ENCRYPTED_FLV:String = "http://cobra.certificationsuites.com/vod/media/video/flv/encrypted/On2F15Ht480Qlt350.flv"; 
		}
	}
}