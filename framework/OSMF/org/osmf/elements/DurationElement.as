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
package org.osmf.elements
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.elements.proxyClasses.DurationSeekTrait;
	import org.osmf.elements.proxyClasses.DurationTimeTrait;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;

	/**
	 * A DurationElement wraps a MediaElement to give it temporal capabilities.
	 * It allows a non-temporal MediaElement to be treated as a temporal MediaElement.
	 * <p>The DurationElement class is especially useful for creating delays
	 * in the presentation of a media composition.
	 * For example, the following code presents a sequence of videos,
	 * separated from each another by five-second delays.</p>
	 * <listing>
	 * var sequence:SerialElement = new SerialElement();
	 * 
	 * sequence.addChild(new VideoElement(
	 * 	new URLResource("http://www.example.com/video1.flv")));
	 * sequence.addChild(new DurationElement(5));
	 * sequence.addChild(new VideoElement(
	 * 	new URLResource("http://www.example.com/ad.flv")));
	 * sequence.addChild(new DurationElement(5));
	 * sequence.addChild(new VideoElement(
	 * 	new URLResource("http://www.example.com/video2.flv")));
	 * 
	 * // Add the SerialElement to the MediaPlayer.
	 * player.media = sequence;
	 * </listing>
	 * <p>The following example presents a sequence of rotating banners.
	 * The delays separating the appearances of the banners are 
	 * created with DurationElements.
	 * In addition, the images themselves are wrapped in DurationElements
	 * to enable them to support a duration.</p>
	 * <listing>
	 * // The first banner does not appear for five seconds.
	 * // Each banner is shown for 20 seconds.
	 * // There is a 15-second delay between images.
	 * 
	 * var bannerSequence:SerialElement = new SerialElement();
	 * 
	 * bannerSequence.addChild(new DurationElement(5));
	 * bannerSequence.addChild(new DurationElement(20,new ImageElement(new ImageLoader(),
	 * 	new URLResource("http://www.examplebanners.com/banner1.jpg")));
	 * bannerSequence.addChild(new DurationElement(15));
	 * bannerSequence.addChild(new DurationElement(20,new ImageElement(new ImageLoader(),
	 * 	new URLResource("http://www.examplebanners.com/banner2.jpg")));
	 * bannerSequence.addChild(new DurationElement(15));
	 * bannerSequence.addChild(new DurationElement(20,new ImageElement(new ImageLoader(),
	 * 	new URLResource("http://www.examplebanners.com/banner3.jpg")));
	 * </listing>
	 * 
	 * The DurationElement will not work with elements that already have a Time trait, such
	 * as VideoElement.  Use the subclips feature for modyifying these elements.
	 * 
	 * @see ProxyElement
	 * @see org.osmf.elements.SerialElement
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class DurationElement extends ProxyElement
	{
		/**
	 	 * Constructor.
	 	 * @param duration Duration of the DurationElement's TimeTrait, in seconds.
	 	 * @param mediaElement Optional element to be wrapped by this DurationElement.
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 10
	 	 *  @playerversion AIR 1.5
	 	 *  @productversion OSMF 1.0
	 	 */		
		public function DurationElement(duration:Number, mediaElement:MediaElement=null)
		{
			_duration = duration;
			
			// Prepare the position timer.
			playheadTimer = new Timer(DEFAULT_PLAYHEAD_UPDATE_INTERVAL);
			playheadTimer.addEventListener(TimerEvent.TIMER, onPlayheadTimer, false, 0, true);
			
			super(mediaElement != null ? mediaElement : new MediaElement());
		}
		
		/**
		 * @private
		 * 
	 	 * Sets up the element's TimeTrait, SeekTrait, and PlayTrait.
	 	 * The proxy's traits will override the same traits in the wrapped element.
	 	 * <p>This gives the application access to the trait properties in the wrapped
	 	 * element that did not exist before it was wrapped.</p>
	 	 * <p>For example, the DurationElement in the following line wraps an ImageElement.
	 	 * The <code>duration</code> property of the DurationElement's TimeTrait allows
	 	 * the application to specify the duration that the image is displayed, in this case 20 seconds.</p>
	 	 * <listing>
	 	 * bannerSequence.addChild(new DurationElement(20,new ImageElement(new ImageLoader(),
	 	 * 	new URLResource("http://www.examplebanners.com/banner1.jpg")));	
	 	 * </listing>
	 	 */	
		override protected function setupOverriddenTraits():void
		{
			super.setupOverriddenTraits();
			
			timeTrait = new DurationTimeTrait(_duration);
			timeTrait.addEventListener(TimeEvent.COMPLETE, onComplete);
			addTrait(MediaTraitType.TIME, timeTrait);

			seekTrait = new DurationSeekTrait(timeTrait);
			addTrait(MediaTraitType.SEEK, seekTrait);
			
			// Reduce priority of our listener so that all other listeners will
			// receive the seeking=true event before we dispatch the seeking=false
			// event. 
			seekTrait.addEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange, false, -1);
			
			playTrait = new PlayTrait();
			playTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
			addTrait(MediaTraitType.PLAY, playTrait);
		}
		
		// Internals
		//
		
		private function get time():Number
		{
			// Return value is in seconds.
			return playTrait.playState == PlayState.PLAYING
						? (elapsedTime + (flash.utils.getTimer() - absoluteTimeAtLastPlay))/1000
						: elapsedTime;
		}

		private function onPlayheadTimer(event:TimerEvent):void
		{
			if (time >= _duration)
			{
				playheadTimer.stop();
				playTrait.stop();

				elapsedTime = _duration;
			}
			else
			{
				elapsedTime = time;
			}
		}
		
		private function onPlayStateChange(event:PlayEvent):void
		{
			if (event.playState == PlayState.PLAYING)
			{
				absoluteTimeAtLastPlay = flash.utils.getTimer();
				playheadTimer.start();
			}
			else if (event.playState == PlayState.PAUSED)
			{
				elapsedTime += ((flash.utils.getTimer() - absoluteTimeAtLastPlay) /1000);
				playheadTimer.stop();
			}
			else
			{
				elapsedTime += ((flash.utils.getTimer() - absoluteTimeAtLastPlay) /1000);
				playheadTimer.stop();
			}			
		}
		
		private function onSeekingChange(event:SeekEvent):void
		{
			if (event.seeking)
			{				
				elapsedTime = event.time;
				absoluteTimeAtLastPlay = flash.utils.getTimer();
			}
		}
		
		private function onComplete(event:TimeEvent):void
		{
			playheadTimer.stop();
		}
				
		private function get elapsedTime():Number
		{
			return _elapsedTime;
		}
		
		private function set elapsedTime(value:Number):void
		{
			_elapsedTime = timeTrait.currentTime = value;
		}
		
		private static const DEFAULT_PLAYHEAD_UPDATE_INTERVAL:Number = 250;
		
		private var _elapsedTime:Number = 0; // seconds
		private var _duration:Number = 0;	// seconds
		private var absoluteTimeAtLastPlay:Number = 0; // milliseconds
		private var playheadTimer:Timer;
		
		private var timeTrait:DurationTimeTrait;
		private var seekTrait:DurationSeekTrait;
		private var playTrait:PlayTrait;
	}
}