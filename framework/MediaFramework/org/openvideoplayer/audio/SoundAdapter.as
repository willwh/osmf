/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.openvideoplayer.audio
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import org.openvideoplayer.events.PlayingChangeEvent;
    
	/**
	 * Dispatched when playback of the Sound completes.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
    [Event(name="complete", type="flash.events.Event")]
    
	/**
	 * Dispatched when download of the Sound completes.
	 * 
	 * @eventType downloadComplete
	 */
    [Event(name="downloadComplete", type="flash.events.Event")]
    
	/**
	 * Dispatched periodically as the download of the Sound progresses.
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
    [Event(name="progress", type="flash.events.ProgressEvent")]
    
	/**
	 * Dispatched when the playing state of the Sound changes.
	 * 
	 * @eventType org.openvideoplayer.events.PlayingChangeEvent.PLAYING_CHANGE
	 */
    [Event(name="playingChange", type="org.openvideoplayer.events.PlayingChangeEvent")]
    
	/**
	 * Dispatched when playback of the Sound fails due to an error..
	 * 
	 * @eventType playbackError
	 */
    [Event(name="playbackError", type="flash.events.Event")]
    
    /**
    * Utility class to make working with the Sound class a bit easier.
    **/
	internal class SoundAdapter extends EventDispatcher
	{
		public static const PLAYBACK_ERROR:String = "playbackError";	
		public static const DOWNLOAD_COMPLETE:String = "downloadComplete";	
		
		public function SoundAdapter(stream:URLRequest=null, context:SoundLoaderContext=null)
		{
			sound = new Sound(stream);	
			sound.addEventListener(Event.COMPLETE, onDownloaded);
			sound.addEventListener(ProgressEvent.PROGRESS, onProgress);
			sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		public function get playing():Boolean
		{
			return _playing;
		}

		/**
		 *  Return the position in seconds.
		 */ 
		public function get position():Number
		{			
			return channel ? channel.position / 1000 : lastStartTime / 1000;
		}

		/**
		 * Returns an estimate of the duration of the partially downloaded
		 * audio file, in seconds.
		 **/ 
		public function get estimatedDuration():Number
		{
			return sound.length / (1000 * sound.bytesLoaded / sound.bytesTotal);	
		}	
		
		public function get soundTransform():SoundTransform
		{
			return _transform;
		}
		
		public function set soundTransform(value:SoundTransform):void
		{
			_transform = value;
			if (channel)
			{
				channel.soundTransform = value;	
			}		
		}

		/**
		 * Play the sound.  If the given time is -1, starts from the
		 * beginning.  Otherwise, attempts to play from that point.
		 **/
		public function play(time:Number=-1):void
		{
			if (channel == null)
			{
				channel = sound.play(time != -1 ? time : lastStartTime);
				if (channel != null)
				{
					_playing = true;
					channel.soundTransform = _transform;
					
					channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
					
					dispatchEvent(new PlayingChangeEvent(true));
				}
				else
				{
					dispatchEvent(new Event(PLAYBACK_ERROR));
				}
			}
		}
					
		public function pause():void
		{
			if (channel)
			{
				lastStartTime = channel.position;
				
				clearChannel();
				_playing = false;
				
				dispatchEvent(new PlayingChangeEvent(false));
			}
		}
		
		public function seek(time:Number):void
		{		
			if (channel != null)
			{
				clearChannel();
				
				var wasPlaying:Boolean = _playing;
				
				play(time*1000);

				if (wasPlaying == false)
				{
					pause();
				}
			}
			else
			{
				play(time);
			}
		}	
						
		// Internals
		//
		
		private function clearChannel():void
		{
			if (channel != null)
			{
				channel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
				channel.stop();
				channel = null;
			}
		}
		
		private function onComplete(event:Event):void
		{
			_playing = false;
			lastStartTime = 0;
			
			clearChannel();
			dispatchEvent(new PlayingChangeEvent(false));
			dispatchEvent(new Event(Event.COMPLETE));			
		}
				
		private function onDownloaded(event:Event):void
		{
			dispatchEvent(new Event(DOWNLOAD_COMPLETE));
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			dispatchEvent(event.clone());
		}

		private function onIOError(event:IOErrorEvent):void
		{
			dispatchEvent(new Event(PLAYBACK_ERROR));
		}
		
		private var _transform:SoundTransform = new SoundTransform();	
		private var sound:Sound;	
		private var _playing:Boolean = false;		
		private var channel:SoundChannel;
		private var lastStartTime:Number = 0;
	}
}