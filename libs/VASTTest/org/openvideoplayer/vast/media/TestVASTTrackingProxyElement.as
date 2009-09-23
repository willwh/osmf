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
	
	import flash.events.Event;
	
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.proxies.ProxyElement;
	import org.openvideoplayer.proxies.TestListenerProxyElement;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.HTTPLoader;
	import org.openvideoplayer.utils.MockHTTPLoader;
	import org.openvideoplayer.utils.SimpleLoader;
	import org.openvideoplayer.vast.model.VASTTrackingEvent;
	import org.openvideoplayer.vast.model.VASTTrackingEventType;
	import org.openvideoplayer.vast.model.VASTUrl;
	
	public class TestVASTTrackingProxyElement extends TestListenerProxyElement
	{
		public function testInitializeWithNoParams():void
		{
			var proxyElement:ProxyElement = new VASTTrackingProxyElement();
			
			try
			{
				// Should throw if the number of params is incorrect.
				proxyElement.initialize([]);
				
				fail();
			}
			catch (error:ArgumentError)
			{
			}
		}
		
		public function testInitializeWithValidParams():void
		{
			var proxyElement:ProxyElement = new VASTTrackingProxyElement();
			proxyElement.wrappedElement = new DynamicMediaElement
				(   [ MediaTraitType.BUFFERABLE
					, MediaTraitType.PLAYABLE
					, MediaTraitType.LOADABLE
					]
				, 	new SimpleLoader()
				);
			
			var trackingEvents:Vector.<VASTTrackingEvent> = new Vector.<VASTTrackingEvent>();
			var trackingEvent:VASTTrackingEvent = new VASTTrackingEvent(VASTTrackingEventType.START);
			var eventURLs:Vector.<VASTUrl> = new Vector.<VASTUrl>();
			eventURLs.push(START_EVENT_URL1);
			eventURLs.push(START_EVENT_URL2);
			trackingEvent.urls = eventURLs;
			trackingEvents.push(trackingEvent);

			proxyElement.initialize([trackingEvents, httpLoader]);
		}

		// Overrides
		//
		
		override public function setUp():void
		{
			httpLoader = createHTTPLoader();
			
			super.setUp();
		}

		override public function tearDown():void
		{
			super.setUp();

			httpLoader = null;
		}
		
		override protected function createProxyElement():ProxyElement
		{
			return new VASTTrackingProxyElement();
		}
		
		override protected function createMediaElement():MediaElement
		{
			return new VASTTrackingProxyElement(null, null, new MediaElement());
		}

		// Internals
		//
		
		private function createHTTPLoader():HTTPLoader
		{
			// Change to true to run against the network.
			var useMockLoader:Boolean = true;
			
			if (useMockLoader == false)
			{
				return new HTTPLoader();
			}
			else
			{
				var loader:MockHTTPLoader = new MockHTTPLoader();
				return loader;
			}
		}

		private function createProxyElementWithWrappedElement():ProxyElement
		{
			var trackingEvents:Vector.<VASTTrackingEvent> = new Vector.<VASTTrackingEvent>();
			var trackingEvent:VASTTrackingEvent = new VASTTrackingEvent(VASTTrackingEventType.START);
			var eventURLs:Vector.<VASTUrl> = new Vector.<VASTUrl>();
			eventURLs.push(START_EVENT_URL1);
			eventURLs.push(START_EVENT_URL2);
			trackingEvent.urls = eventURLs;
			trackingEvents.push(trackingEvent);
			var proxyElement:ProxyElement = new VASTTrackingProxyElement
				( trackingEvents
				, httpLoader
				, new DynamicMediaElement
					( [	MediaTraitType.BUFFERABLE
					  , MediaTraitType.PLAYABLE
					  ,	MediaTraitType.LOADABLE
					  ]
					, new SimpleLoader()
					)
				);
			return proxyElement;
		}
		
		private function dontCall(event:Event):void
		{
			fail();
		}
		
		private var httpLoader:HTTPLoader;
		
		private static const START_EVENT_URL1:VASTUrl = new VASTUrl("http://example.com/start1", "start1");
		private static const START_EVENT_URL2:VASTUrl = new VASTUrl("http://example.com/start2", "start2");
	}
}