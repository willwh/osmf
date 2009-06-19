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
package org.openvideoplayer.proxies
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openvideoplayer.events.PausedChangeEvent;
	import org.openvideoplayer.events.PlayingChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.PausibleTrait;
	import org.openvideoplayer.traits.PlayableTrait;
	import org.openvideoplayer.traits.SeekableTrait;
	import org.openvideoplayer.traits.TemporalTrait;

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
	 * @see org.openvideoplayer.composition.SerialElement
	 **/	
	public class TemporalProxyElement extends ProxyElement
	{
		/**
	 	 * Constructor.
	 	 * @param duration Duration of the TemporalProxyElement's temporal trait, in seconds.
	 	 * @param mediaElement Element to be wrapped by this TemporalProxyElement.
	 	 **/		
		public function TemporalProxyElement(duration:Number=10, mediaElement:MediaElement=null)
		{
			// Coerce to valid value, if necessary.
			this.duration = isNaN(duration) ? 0 : Math.max(0, duration);
			
			// Prepare the position timer.
			playheadTimer = new Timer(DEFAULT_PLAYHEAD_UPDATE_INTERVAL);
			playheadTimer.addEventListener(TimerEvent.TIMER, onPlayheadTimer, false, 0, true);
			
			super(mediaElement != null ? mediaElement : new MediaElement());
		}

		/**
	 	 * Sets up the temporal proxy's TemporalTrait,
	 	 * SeekableTrait, PlayableTrait and PausibleTrait.
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
			temporalTrait.duration = duration;
			temporalTrait.position = 0;
			addTrait(MediaTraitType.TEMPORAL, temporalTrait);

			seekableTrait = new SeekableTrait();
			seekableTrait.temporal = temporalTrait;
			addTrait(MediaTraitType.SEEKABLE, seekableTrait);
			
			playableTrait = new PlayableTrait();
			playableTrait.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChange);
			addTrait(MediaTraitType.PLAYABLE, playableTrait);
			
			pausibleTrait = new PausibleTrait();
			pausibleTrait.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChange);
			addTrait(MediaTraitType.PAUSIBLE, pausibleTrait);
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
			if (time >= duration)
			{
				elapsedTime = duration;
				
				playheadTimer.stop();
				pausibleTrait.resetPaused();
				playableTrait.resetPlaying();
				temporalTrait.position = duration;
			}
			else
			{
				temporalTrait.position = time;
			}
		}
		
		private function onPlayingChange(event:PlayingChangeEvent):void
		{
			if (event.playing)
			{
				if (pausibleTrait.paused)
				{
					pausibleTrait.resetPaused();
				}
				
				absoluteTimeAtLastPlay = flash.utils.getTimer();
				playheadTimer.start();
			}			
		}

		private function onPausedChange(event:PausedChangeEvent):void
		{
			if (event.paused)
			{
				if (playableTrait.playing)
				{
					playableTrait.resetPlaying();
				}
				
				elapsedTime += ((flash.utils.getTimer() - absoluteTimeAtLastPlay) /1000);
				playheadTimer.stop();
			}			
		}
		
		private static const DEFAULT_PLAYHEAD_UPDATE_INTERVAL:Number = 250;
		
		private var elapsedTime:Number = 0; // seconds
		private var duration:Number = 0;	// seconds
		private var absoluteTimeAtLastPlay:Number = 0; // milliseconds
		private var playheadTimer:Timer;
		
		private var temporalTrait:TemporalTrait;
		private var seekableTrait:SeekableTrait;
		private var playableTrait:PlayableTrait;
		private var pausibleTrait:PausibleTrait;
	}
}