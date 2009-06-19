/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
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