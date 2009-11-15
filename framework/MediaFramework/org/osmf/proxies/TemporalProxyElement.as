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
package org.osmf.proxies
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.PausedChangeEvent;
	import org.osmf.events.PlayingChangeEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.IPausable;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PausableTrait;
	import org.osmf.traits.PlayableTrait;
	import org.osmf.traits.SeekableTrait;
	import org.osmf.traits.TemporalTrait;

	/**
	 * A TemporalProxyElement wraps a MediaElement to give it temporal capabilities.
	 * It allows a non-temporal MediaElement to be treated as a temporal MediaElement.
	 * <p>The TemporalProxyElement class is especially useful for creating delays
	 * in the presentation of a media composition.
	 * For example, the following code presents a sequence of videos,
	 * separated from each another by five-second delays.</p>
	 * <listing>
	 * var sequence:SerialElement = new SerialElement();
	 * 
	 * sequence.addChild(new VideoElement(new NetLoader(),
	 * 	new URLResource("http://www.example.com/video1.flv")));
	 * sequence.addChild(new TemporalProxyElement(new MediaElement(),5));
	 * sequence.addChild(new VideoElement(new NetLoader(),
	 * 	new URLResource("http://www.example.com/ad.flv")));
	 * sequence.addChild(new TemporalProxyElement(new MediaElement(),5));
	 * sequence.addChild(new VideoElement(new NetLoader(),
	 * 	new URLResource("http://www.example.com/video2.flv")));
	 * 
	 * // Add the SerialElement to the MediaPlayer.
	 * player.media = sequence;
	 * </listing>
	 * <p>The following example presents a sequence of rotating banners.
	 * The delays separating the appearances of the banners are 
	 * created with TemporalProxyElements.
	 * In addition, the images themselves are wrapped in TemporalProxyElements
	 * to enable them to support a duration.</p>
	 * <listing>
	 * // The first banner does not appear for five seconds.
	 * // Each banner is shown for 20 seconds.
	 * // There is a 15-second delay between images.
	 * 
	 * var bannerSequence:SerialElement = new SerialElement();
	 * 
	 * bannerSequence.addChild(new TemporalProxyElement(new MediaElement(),5));
	 * bannerSequence.addChild(new TemporalProxyElement(new ImageElement(new ImageLoader(),
	 * 	new URLResource("http://www.examplebanners.com/banner1.jpg")),20);
	 * bannerSequence.addChild(new TemporalProxyElement(new MediaElement(),15));
	 * bannerSequence.addChild(new TemporalProxyElement(new ImageElement(new ImageLoader(),
	 * 	new URLResource("http://www.examplebanners.com/banner2.jpg")),20);
	 * bannerSequence.addChild(new TemporalProxyElement(new MediaElement(),15));
	 * bannerSequence.addChild(new TemporalProxyElement(new ImageElement(new ImageLoader(),
	 * 	new URLResource("http://www.examplebanners.com/banner3.jpg")),20);
	 * </listing>
	 * @see ProxyElement
	 * @see org.osmf.composition.SerialElement
	 **/	
	public class TemporalProxyElement extends ProxyElement
	{
		/**
	 	 * Constructor.
	 	 * @param duration Duration of the TemporalProxyElement's temporal trait, in seconds.
	 	 * @param mediaElement Element to be wrapped by this TemporalProxyElement.
	 	 **/		
		public function TemporalProxyElement(duration:Number, mediaElement:MediaElement=null)
		{
			this.duration = duration;
			
			// Prepare the position timer.
			playheadTimer = new Timer(DEFAULT_PLAYHEAD_UPDATE_INTERVAL);
			playheadTimer.addEventListener(TimerEvent.TIMER, onPlayheadTimer, false, 0, true);
			
			super(mediaElement != null ? mediaElement : new MediaElement());
		}
		
		/**
	 	 * Sets up the temporal proxy's TemporalTrait,
	 	 * SeekableTrait, PlayableTrait and PausableTrait.
	 	 * The proxy's traits will override the same traits in the wrapped element.
	 	 * <p>This gives the application access to the trait properties in the wrapped
	 	 * element that did not exist before it was wrapped.</p>
	 	 * <p>For example, the TemporalProxyElement in the following line wraps an ImageElement.
	 	 * The <code>duration</code> property of the TemporalProxyElement's TemporalTrait allows
	 	 * the application to specify the duration that the image is displayed, in this case 20 seconds.</p>
	 	 * <listing>
	 	 * bannerSequence.addChild(new TemporalProxyElement(new ImageElement(new ImageLoader(),
	 	 * 	new URLResource("http://www.examplebanners.com/banner1.jpg")),20);	
	 	 * </listing>
	 	 **/	
		override protected function setupOverriddenTraits():void
		{
			super.setupOverriddenTraits();
			
			temporalTrait = new TemporalTrait();
			temporalTrait.duration = _duration;
			temporalTrait.currentTime = 0;
			temporalTrait.addEventListener(TimeEvent.DURATION_REACHED, onDurationReached);
			addTrait(MediaTraitType.TEMPORAL, temporalTrait);

			seekableTrait = new SeekableTrait();
			seekableTrait.temporal = temporalTrait;
			addTrait(MediaTraitType.SEEKABLE, seekableTrait);
			
			// Reduce priority of our listener so that all other listeners will
			// receive the seeking=true event before we dispatch the seeking=false
			// event. 
			seekableTrait.addEventListener(SeekEvent.SEEK_BEGIN, onSeekingChange, false, -1);
			seekableTrait.addEventListener(SeekEvent.SEEK_END, onSeekingChange, false, -1);
			
			playableTrait = new PlayableTrait(this);
			playableTrait.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChange);
			addTrait(MediaTraitType.PLAYABLE, playableTrait);
			
			pausableTrait = new PausableTrait(this);
			pausableTrait.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChange);
			addTrait(MediaTraitType.PAUSABLE, pausableTrait);
		}
		
		// Internals
		//
		
		private function get time():Number
		{
			// Return value is in seconds.
			return playableTrait.playing
						? (elapsedTime + (flash.utils.getTimer() - absoluteTimeAtLastPlay))/1000
						: elapsedTime;
		}

		private function onPlayheadTimer(event:TimerEvent):void
		{
			if (time >= _duration)
			{
				elapsedTime = _duration;
				
				playheadTimer.stop();
				pausableTrait.resetPaused();
				playableTrait.resetPlaying();
				temporalTrait.currentTime = _duration;
			}
			else
			{
				temporalTrait.currentTime = time;
			}
		}
		
		private function onPlayingChange(event:PlayingChangeEvent):void
		{
			if (event.playing)
			{
				absoluteTimeAtLastPlay = flash.utils.getTimer();
				playheadTimer.start();
				
				var playable:IPlayable = wrappedElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
				if (playable != null)
				{
					playable.play();
				}
			}
			else
			{
				var pausable:IPausable = wrappedElement.getTrait(MediaTraitType.PAUSABLE) as IPausable;
				if (pausable != null)
				{
					pausable.pause();
				}
			}			
		}

		private function onPausedChange(event:PausedChangeEvent):void
		{
			if (event.paused)
			{
				elapsedTime += ((flash.utils.getTimer() - absoluteTimeAtLastPlay) /1000);
				playheadTimer.stop();
				
				var pausable:IPausable = wrappedElement.getTrait(MediaTraitType.PAUSABLE) as IPausable;
				if (pausable != null)
				{
					pausable.pause();
				}
			}
			else
			{
				var playable:IPlayable = wrappedElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
				if (playable != null)
				{
					playable.play();
				}
			}			
		}
		
		private function onSeekingChange(event:SeekEvent):void
		{
			if (event.type == SeekEvent.SEEK_BEGIN)
			{				
				elapsedTime = event.time;
				absoluteTimeAtLastPlay = flash.utils.getTimer();
				seekableTrait.processSeekCompletion(event.time);				
			}
		}
		
		private function onDurationReached(event:TimeEvent):void
		{
			playheadTimer.stop();
		}
		
		private function set duration(value:Number):void
		{
			// Coerce to valid value, if necessary.
			_duration = isNaN(value) ? 0 : Math.max(0, value);
			
			// Update our temporal trait, if it exists.
			if (temporalTrait != null)
			{
				temporalTrait.duration = _duration;
			}
		}
		
		private function get elapsedTime():Number
		{
			return _elapsedTime;
		}
		
		private function set elapsedTime(value:Number):void
		{
			_elapsedTime = temporalTrait.currentTime = value;
		}
		
		private static const DEFAULT_PLAYHEAD_UPDATE_INTERVAL:Number = 250;
		
		private var _elapsedTime:Number = 0; // seconds
		private var _duration:Number = 0;	// seconds
		private var absoluteTimeAtLastPlay:Number = 0; // milliseconds
		private var playheadTimer:Timer;
		
		private var temporalTrait:TemporalTrait;
		private var seekableTrait:SeekableTrait;
		private var playableTrait:PlayableTrait;
		private var pausableTrait:PausableTrait;
	}
}