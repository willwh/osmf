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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openvideoplayer.events.LoaderEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.proxies.ProxyElement;
	import org.openvideoplayer.proxies.TestListenerProxyElement;
	import org.openvideoplayer.traits.BufferableTrait;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.PlayableTrait;
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.HTTPLoader;
	import org.openvideoplayer.utils.MockHTTPLoader;
	import org.openvideoplayer.utils.SimpleLoader;
	import org.openvideoplayer.vast.VASTTestConstants;
	import org.openvideoplayer.vast.model.VASTUrl;
	
	public class TestVASTImpressionProxyElement extends TestListenerProxyElement
	{
		public function testInitializeWithNoParams():void
		{
			var proxyElement:ProxyElement = new VASTImpressionProxyElement();
			
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
			var proxyElement:ProxyElement = new VASTImpressionProxyElement();
			proxyElement.wrappedElement = new DynamicMediaElement
				(   [ MediaTraitType.BUFFERABLE
					, MediaTraitType.PLAYABLE
					, MediaTraitType.LOADABLE
					]
				, 	new SimpleLoader()
				);
			
			var vastURLs:Vector.<VASTUrl> = new Vector.<VASTUrl>();
			vastURLs.push(VAST_URL1);
			vastURLs.push(VAST_URL2);
			proxyElement.initialize([vastURLs, httpLoader]);
			
			doTestPlay(proxyElement, false);
		}
		
		public function testPlay():void
		{
			doTestPlay(createProxyElementWithWrappedElement(), false);
		}

		public function testPlayWithReload():void
		{
			doTestPlay(createProxyElementWithWrappedElement(), true);
		}
		
		private function doTestPlay(proxyElement:ProxyElement, reload:Boolean):void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 4000));
			
			var impressionCount:int = 0;
			var done:Boolean = false;
			
			// Listen for the pings.
			httpLoader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onLoaderStateChange);

			// Playback should cause the impression to fire.
			var playable:PlayableTrait = proxyElement.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			assertTrue(playable != null);
			playable.play();

			function onLoaderStateChange(event:LoaderEvent):void
			{
				if (event.loadable.loadState == LoadState.LOADED)
				{
					impressionCount++;
					
					assertTrue(playable.playing == true);
					
					if (impressionCount == 2)
					{
						if (reload)
						{
							// Playing again should not trigger another impression.
							playable.resetPlaying();
							playable.play();
							
							assertTrue(!done);
							
							// But if we reload first, then play, it should.
							var loadable:ILoadable = proxyElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
							assertTrue(loadable != null);
							loadable.load();
							playable.resetPlaying();
							playable.play();
						}
						else
						{
							eventDispatcher.dispatchEvent(new Event("testComplete"));
						}
					}
					else if (impressionCount == 4 && reload)
					{
						done = true;
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
		}
		
		public function testPlayWhileBuffering():void
		{
			doTestPlayWhileBuffering(false);
		}

		public function testPlayWhileBufferingThenExitingBuffering():void
		{
			doTestPlayWhileBuffering(true);
		}
		
		private function doTestPlayWhileBuffering(exitBuffering:Boolean):void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 4000));
			
			var impressionCount:int = 0;
			
			// We'll fail if we receive any pings.
			httpLoader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, dontCall);

			var proxyElement:ProxyElement = createProxyElementWithWrappedElement();
			
			// Enter the buffering state.
			var bufferable:BufferableTrait = proxyElement.getTrait(MediaTraitType.BUFFERABLE) as BufferableTrait;
			assertTrue(bufferable != null);
			bufferable.buffering = true;
			
			// Playback should not cause the impression to fire because
			// we're buffering.
			var playable:IPlayable = proxyElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable != null);
			playable.play();
			
			// Wait a second to verify that no pings are received.
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			function onTimer(event:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				
				if (exitBuffering)
				{
					httpLoader.removeEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, dontCall);
					httpLoader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onImpressionLoaded);
					
					var impressionCount:int = 0;
					
					bufferable.buffering = false;
					
					function onImpressionLoaded(event:LoaderEvent):void
					{
						if (event.loadable.loadState == LoadState.LOADED)
						{
							impressionCount++;
							
							assertTrue(playable.playing == true);
							
							if (impressionCount == 2)
							{
								eventDispatcher.dispatchEvent(new Event("testComplete"));
							}
						}
					}
				}
				else
				{
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
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
			return new VASTImpressionProxyElement();
		}
		
		override protected function createMediaElement():MediaElement
		{
			return new VASTImpressionProxyElement(null, null, new MediaElement());
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
				loader.setExpectationForURL(VASTTestConstants.IMPRESSION_URL1, true, null);
				loader.setExpectationForURL(VASTTestConstants.IMPRESSION_URL2, true, null);
				return loader;
			}
		}

		private function createProxyElementWithWrappedElement():ProxyElement
		{
			//return new VASTImpressionProxyElement();
			var vastURLs:Vector.<VASTUrl> = new Vector.<VASTUrl>();
			vastURLs.push(VAST_URL1);
			vastURLs.push(VAST_URL2);
			var proxyElement:ProxyElement = new VASTImpressionProxyElement
				( vastURLs
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
				
		private static const VAST_URL1:VASTUrl = new VASTUrl(VASTTestConstants.IMPRESSION_URL1, "id1");
		private static const VAST_URL2:VASTUrl = new VASTUrl(VASTTestConstants.IMPRESSION_URL2, "id2");
	}
}