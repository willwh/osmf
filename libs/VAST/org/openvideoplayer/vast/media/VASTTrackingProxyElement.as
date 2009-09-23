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
package org.openvideoplayer.vast.media
{
	import __AS3__.vec.Vector;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.proxies.ListenerProxyElement;
	import org.openvideoplayer.tracking.Beacon;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.HTTPLoader;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.vast.model.VASTTrackingEvent;
	import org.openvideoplayer.vast.model.VASTTrackingEventType;
	import org.openvideoplayer.vast.model.VASTUrl;
	
	/**
	 * A ProxyElement that wraps up another MediaElement and fires
	 * HTTP events as the wrapped media enters different states.
	 **/ 
	public class VASTTrackingProxyElement extends ListenerProxyElement
	{
		/**
		 * Constructor.
		 * 
		 * @param events An Array containing all VAST TrackingEvents which
		 * should trigger the firing of HTTP events.
		 * @param httpLoader The HTTPLoader to use to ping the beacon.  If
		 * null, then a default HTTPLoader will be used.
		 * @param wrappedElement The MediaElement to wrap.
		 **/
		public function VASTTrackingProxyElement(events:Vector.<VASTTrackingEvent>=null, httpLoader:HTTPLoader=null, wrappedElement:MediaElement=null)
		{
			setEvents(events);
			this.httpLoader = httpLoader;
			
			playheadTimer = new Timer(250);
			playheadTimer.addEventListener(TimerEvent.TIMER, onPlayheadTimer);
			
			super(wrappedElement);
		}
		
		/**
         * @private
		 **/
		override public function initialize(value:Array):void
		{
			if (value && value.length == 2)
			{
				setEvents(value[0] as Vector.<VASTTrackingEvent>);
				this.httpLoader = value[1] as HTTPLoader;
			}
			else
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_INITIALIZATION_ARGS);
			}
		}
		
		// Overrides
		//
		
		/**
		 * @private
		 **/
		override protected function processMutedChange(muted:Boolean):void
		{
			if (muted)
			{
				fireEventOfType(VASTTrackingEventType.MUTE);
			}
		}
		
		/**
		 * @private
		 **/
		override protected function processPlayingChange(playing:Boolean):void
		{
			if (playing)
			{
				playheadTimer.start();
				if (startReached == false)
				{
					startReached = true;
					
					fireEventOfType(VASTTrackingEventType.START);
				}
			}
			else
			{
				playheadTimer.stop();
			}
		}

		
		/**
		 * @private
		 **/
		override protected function processPausedChange(paused:Boolean):void
		{
			if (paused)
			{
				fireEventOfType(VASTTrackingEventType.PAUSE);
			}
		}
		
		/**
		 * @private
		 **/
		override protected function processDurationReached():void
		{
			playheadTimer.stop();
			
			// Reset our flags so the events can fire once more.
			startReached = false;
			firstQuartileReached = false;
			midpointReached = false;
			thirdQuartileReached = false;
			
			fireEventOfType(VASTTrackingEventType.COMPLETE);
		}

		// Internals
		//
		
		private function setEvents(events:Vector.<VASTTrackingEvent>):void
		{
			eventsMap = new Dictionary();
			
			if (events != null)
			{
				for each (var event:VASTTrackingEvent in events)
				{
					eventsMap[event.type] = event;
				}
			}
		}
		
		private function fireEventOfType(eventType:VASTTrackingEventType):void
		{
			var vastEvent:VASTTrackingEvent = eventsMap[eventType] as VASTTrackingEvent;
			if (vastEvent != null)
			{
				for each (var vastURL:VASTUrl in vastEvent.urls)
				{
					var beacon:Beacon = new Beacon(new URL(vastURL.url), httpLoader);
					beacon.ping();
				}
			}
		}
		
		private function onPlayheadTimer(event:TimerEvent):void
		{
			// Check for 25%, 50%, and 75%.
			var percent:Number = this.percentPlayback;
			
			if (percent >= 25 && firstQuartileReached == false)
			{
				firstQuartileReached = true;
				
				fireEventOfType(VASTTrackingEventType.FIRST_QUARTILE);
			}
			else if (percent >= 50 && midpointReached == false)
			{
				midpointReached = true;
				
				fireEventOfType(VASTTrackingEventType.MIDPOINT);
			}
			else if (percent >= 75 && thirdQuartileReached == false)
			{
				thirdQuartileReached = true;
				
				fireEventOfType(VASTTrackingEventType.THIRD_QUARTILE);
			}
		}
		
		private function get position():Number
		{
			var temporal:ITemporal = getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			return temporal != null ? temporal.position : 0;
		}

		private function get percentPlayback():Number
		{
			var temporal:ITemporal = getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			if (temporal != null)
			{
				var duration:Number = temporal.duration;
				return duration > 0 ? 100 * temporal.position / duration : 0;
			}
			
			return 0;
		}

		private var eventsMap:Dictionary;
			// Key:   VASTTrackingEventType
			// Value: VASTTrackingEvent
		private var httpLoader:HTTPLoader;
		private var playheadTimer:Timer;
		
		private var startReached:Boolean = false;
		private var firstQuartileReached:Boolean = false;
		private var midpointReached:Boolean = false;
		private var thirdQuartileReached:Boolean = false;
	}
}