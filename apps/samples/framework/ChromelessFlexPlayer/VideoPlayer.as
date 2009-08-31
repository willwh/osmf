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
package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	/**
	 * Dispatched when the <code>isPlaying</code> property has changed.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event(name="isPlayingChange",type="flash.events.Event")]
	
	/**
	 * Dispatched when the volume (as represented by the <code>getVolume</code>
	 * method has changed.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event(name="volumeChange",type="flash.events.Event")]
	
	/**
	 * Dispatched when the <code>isMuted</code> property has changed.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event(name="isMutedChange",type="flash.events.Event")]
	
	/**
	 * Dispatched when the <code>playhead</code> property has changed.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event(name="playheadChange",type="flash.events.Event")]
	
	/**
	 * Dispatched when the <code>duration</code> property has changed.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event(name="durationChange",type="flash.events.Event")]
	
	/**
	 * A barebones VideoPlayer that can play back progressive videos.
	 * 
	 * Note that this class is *not* built using the Open Source Media
	 * Framework.  Rather, it's intended to represent a non-OSMF player
	 * which can be loaded as an external SWF, and whose methods can be
	 * called by a custom SWFElement subclass.  This is to demonstrate
	 * how to build a "chromeless SWF" (i.e. an existing SWF player that is
	 * syndicated to other web video sites, and which exposes an API
	 * that those sites can use to control the player) with OSMF.
	 **/
	public class VideoPlayer extends EventDispatcher
	{
		public function VideoPlayer(url:String)
		{
			nc = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			ns.client = new Object();
			ns.client.onMetaData = onMetaData;
			ns.play(url);
			ns.pause();
			
			_video = new Video(640, 480);
			_video.attachNetStream(ns);
			
			setVolume(1);
			
			playheadTimer = new Timer(250);
			playheadTimer.addEventListener(TimerEvent.TIMER, onPlayheadTimer);
		}
		
		public function get video():Video
		{
			return _video;
		}
		
		public function playVideo():void 
		{
			if (_isPlaying == false)
			{
				ns.resume();
				_isPlaying = true;
				playheadTimer.start();
			
				dispatchEvent(new Event("isPlayingChange"));
			}
		}
		 
		public function pauseVideo():void 
		{
			if (_isPlaying)
			{
				ns.pause();
				_isPlaying = false;
				playheadTimer.stop();
			
				dispatchEvent(new Event("isPlayingChange"));
			}
		}
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function toggleMute():void
		{
			if (_isMuted)
			{
				_isMuted = false;
				
				setVolume(previousVolume);
			}
			else // !_isMuted
			{
				previousVolume = getVolume();
				
				setVolume(0);

				_isMuted = true;
			}
			
			
			dispatchEvent(new Event("isMutedChange"));
		}
		
		public function get isMuted():Boolean
		{
			return _isMuted;
		}
		
		public function setVolume(value:Number):void
		{
			// Only set the volume if we're not muted.
			if (isMuted)
			{
				previousVolume = value;
			}
			else if (value != videoSoundTransform.volume)
			{
				videoSoundTransform.volume = value;
				ns.soundTransform = videoSoundTransform;
				
				dispatchEvent(new Event("volumeChange"));
			}
		}
		
		public function getVolume():Number
		{
			return ns.soundTransform.volume;
		}
		
		public function get playhead():Number
		{
			return ns.time;
		}

		public function get duration():Number
		{
			return _duration;
		}
		
		private function onPlayheadTimer(event:TimerEvent):void
		{
			dispatchEvent(new Event("playheadChange"));
		}
		
		private function onMetaData(info:Object):void
		{
			_duration = info.duration;
			
			dispatchEvent(new Event("durationChange"));
		}
		
		private var nc:NetConnection;
		private var ns:NetStream;
		private var _video:Video;
		private var _isPlaying:Boolean = false;
		private var videoSoundTransform:SoundTransform = new SoundTransform();
		private var previousVolume:Number = 1;
		private var _isMuted:Boolean = false;
		private var _duration:Number = 0;
		private var playheadTimer:Timer;
	}
}