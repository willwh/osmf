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
	
	import flash.utils.Dictionary;
	
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.proxies.ListenerProxyElement;
	import org.openvideoplayer.tracking.Beacon;
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
		override protected function processPausedChange(paused:Boolean):void
		{
			if (paused)
			{
				fireEventOfType(VASTTrackingEventType.PAUSE);
			}
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

		private var eventsMap:Dictionary;
			// Key:   VASTTrackingEventType
			// Value: VASTTrackingEvent
		private var httpLoader:HTTPLoader;
	}
}