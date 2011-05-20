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
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.hamcrest.object.equalTo;
	import org.osmf.events.AlternativeAudioEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	
	
	
	/**
	 * Helper class to be used in integration tests.
	 * It wraps an object and dispatches more ranular events.
	 */
	public class MediaPlayerHelper extends EventDispatcher
	{	
		public static const ERROR:String = "helperError";
		public static const READY:String = "helperReady";
		public static const PLAYING:String = "helperPlaying";
		public static const AUDIO_SWITCH_BEGIN:String = "audioSwitchBegin";
		public static const AUDIO_SWITCH_END:String = "audioSwitchEnd";

		/**
		 * Default constructor.
		 */
		public function MediaPlayerHelper()
		{
			_mediaPlayer = createMediaPlayer();
			_mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			_mediaPlayer.addEventListener(MediaErrorEvent.MEDIA_ERROR, onError);
			_mediaPlayer.addEventListener(AlternativeAudioEvent.AUDIO_SWITCHING_CHANGE, onAudioSwitchingChange);
		}
		
		public function dispose():void
		{
			if (_mediaPlayer != null && _mediaPlayer.canPlay)
			{
				_mediaPlayer.stop();
			}
			
			if (_mediaPlayer.media != null && _mediaPlayer.media.hasTrait(MediaTraitType.LOAD))
			{
				(_mediaPlayer.media.getTrait(MediaTraitType.LOAD) as LoadTrait).unload();
				_mediaPlayer.media = null;
			}
			
			_mediaPlayer = null;
			_mediaResource = null;
		}
		
		/**
		 * Media resource associated with this player helper.
		 */
		public function get mediaResource():MediaResourceBase
		{
			return _mediaResource;
		}
		public function set mediaResource(value:MediaResourceBase):void
		{
			if (_mediaResource != value)
			{
				_mediaResource = value;
				_mediaPlayer.media = createMediaElement(_mediaResource);
			}
		}
		
		/**
		 * Media information associated with this player helper.
		 */
		public function get info():Object
		{
			if (_info == null)
			{
				_info = new Object();
			}
			return _info;
		}
		public function set info(value:Object):void
		{
			_info = value;
		}
		
		/**
		 * Last media error encounter by thius player helper.
		 */
		public function get lastError():MediaError
		{
			return _lastError;
		}
		
		/**
		 * Actual player.
		 */
		public function get actualPlayer():MediaPlayer
		{
			return _mediaPlayer;
		}
		
		//		// Protected API
//		/**
//		 * @private
//		 * 
//		 * Check the player state.
//		 */
//		protected function checkPlayerState(state:String):void
//		{
//			var info:Object = null;
//			if (state != null)
//			{
//				assertThat("MediaPlayer is the expected state.", state, equalTo(mediaPlayerExpectedStates[mediaPlayerRecordedStatesCount]));
//				mediaPlayerRecordedStatesCount++;
//			}
//			
//			// if we didn't verified all our expected states then wait for more events
//			if (mediaPlayerExpectedStates.length > mediaPlayerRecordedStatesCount)
//			{
//				info = new Object;
//				info.expectedEventType = "MediaPlayerStateChangeEvent";
//				info.expectedEvent = mediaPlayerExpectedStates[mediaPlayerRecordedStatesCount];
//				
//				mediaPlayer.addEventListener(
//					MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,
//					Async.asyncHandler(this, onStateChange, 2000, info, onTimeout),
//					false,
//					0,
//					true
//				);
//			}
//		}
//
//		/// Protected event handlers
//		/**
//		 * @private
//		 * 
//		 * Event handler called when the state of the media player is changing.
//		 */
//		protected function onStateChange(event:MediaPlayerStateChangeEvent, passThroughData:Object):void
//		{
//		}
//		
//		/**
//		 * @private
//		 * 
//		 * We fail the test and provide the error message.
//		 */
//		protected function onError(event:MediaErrorEvent):void
//		{
//			fail("MediaErrorEvent received. Error (" + event.error.errorID + ") with message (" + event.error.detail + ")");
//		}
		
//		/**
//		 * @private
//		 * 
//		 * We fail the test on timeout.
//		 */
//		protected function onTimeout( passThroughData:Object):void
//		{
//			if (passThroughData != null && passThroughData.hasOwnProperty("expectedEvent") && passThroughData.hasOwnProperty("expectedEventType"))
//			{
//				fail("Expected event <" + passThroughData["expectedEvent"] + "> of type <" + passThroughData["expectedEventType"] + "> was not received.");
//			}
//			else
//			{
//				fail("Expected event was not received.");	
//			}
//		}
		
		/// Protected API
		/**
		 * @private
		 * 
		 * Creates a media factory object to be used when tests need to 
		 * create media elements. Subclasses can override this method to 
		 * provide their own classes.
		 */
		protected function createMediaFactory():MediaFactory
		{
			return new DefaultMediaFactory();
		}
		
		/**
		 * @private
		 * 
		 * Creates a media player object to be used when tests need to
		 * control the playback of media elements. Subclasses can override 
		 * this method to provide their oen classes.
		 */
		protected function createMediaPlayer():MediaPlayer
		{
			var mediaPlayer:MediaPlayer = new MediaPlayer();
			mediaPlayer.autoPlay = false;
			mediaPlayer.muted = true;
			mediaPlayer.autoDynamicStreamSwitch = false;
			mediaPlayer.loop = false;
			
			return mediaPlayer;
		}
		
		/**
		 * @private
		 * 
		 * Creates a media element object to be used when tests need to 
		 * create video elements. Subclasses can override this method to 
		 * provide their own classes.
		 */
		protected function createMediaElement(resource:MediaResourceBase):MediaElement
		{
			var factory:MediaFactory = createMediaFactory();
			if (factory == null)
				return null;
			
			return factory.createMediaElement(resource);
		}
		
		/// Private event handler
		/**
		 * @private
		 * 
		 * When internal player is changing its state we
		 * dispatch events to our listeners.
		 */
		private function onStateChange(event:MediaPlayerStateChangeEvent):void
		{
			switch(event.state)
			{
				case MediaPlayerState.READY:
					dispatchEvent(new Event(READY));
					break;
				
				case MediaPlayerState.PLAYING:
					dispatchEvent(new Event(PLAYING));
					break;
				
				case MediaPlayerState.PLAYBACK_ERROR:
					dispatchEvent(new Event(ERROR));
					
				default:				
				//case MediaPlayerState.LOADING:
				//case MediaPlayerState.BUFFERING:
				//case MediaPlayerState.PAUSED:
				//case MediaPlayerState.UNINITIALIZED:
					// do not bubble up these events
					break;
			}
		}
		
		/**
		 * @private
		 * 
		 * When an error occures while playing current media element
		 * dispatch an Error event to our listeners.
		 */
		private function onError(event:MediaErrorEvent):void
		{
			_lastError = event.error;
			dispatchEvent(new Event(ERROR));
		}
		
		private function onAudioSwitchingChange(event:AlternativeAudioEvent):void
		{
			if (event.switching)
			{
				dispatchEvent(new Event(AUDIO_SWITCH_BEGIN));
			}
			else
			{
				dispatchEvent(new Event(AUDIO_SWITCH_END));
			}
		}

		/// Internals
		private var _mediaResource:MediaResourceBase = null;
		private var _mediaPlayer:MediaPlayer = null;
		
		private var _lastError:MediaError = null;
		private var _info:Object = null;
	}
}