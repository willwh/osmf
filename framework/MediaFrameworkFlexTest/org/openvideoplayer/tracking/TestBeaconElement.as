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
package org.openvideoplayer.tracking
{
	import flash.events.Event;
	
	import org.openvideoplayer.events.LoaderEvent;
	import org.openvideoplayer.events.PlayingChangeEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.TestMediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.HTTPLoader;
	import org.openvideoplayer.utils.MockHTTPLoader;
	import org.openvideoplayer.utils.NetFactory;
	import org.openvideoplayer.utils.TestConstants;
	import org.openvideoplayer.utils.URL;
	
	public class TestBeaconElement extends TestMediaElement
	{
		public function testPlay():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 4000));
			
			var playingChangeCount:int = 0;
			var pingComplete:Boolean = false;
			
			var httpLoader:HTTPLoader = createHTTPLoader();
			httpLoader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onLoaderStateChange);
			
			var mediaElement:MediaElement = new BeaconElement(new Beacon(RESOURCE.url, httpLoader));
			var playable:IPlayable = mediaElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable != null);
			playable.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChange);
			
			playable.play();
			
			function onPlayingChange(event:PlayingChangeEvent):void
			{
				if (playingChangeCount == 0)
				{
					assertTrue(event.playing == true);
				}
				else if (playingChangeCount == 1)
				{
					assertTrue(event.playing == false);
				}
				else fail();
				
				playingChangeCount++;
				
				checkForCompletion();
			}
			
			function onLoaderStateChange(event:LoaderEvent):void
			{
				if (event.loadable.loadState == LoadState.LOADED)
				{
					pingComplete = true;
					
					checkForCompletion();
				}
			}
			
			function checkForCompletion():void
			{
				if (playingChangeCount == 2 && pingComplete)
				{
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
		}
		
		// Overrides
		//
		
		override protected function createMediaElement():MediaElement
		{
			return new BeaconElement(new Beacon(RESOURCE.url, createHTTPLoader()));
		}
		
		override protected function get loadable():Boolean
		{
			return false;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return RESOURCE;
		}

		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [MediaTraitType.PLAYABLE];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [MediaTraitType.PLAYABLE];
		}
		
		// Internals
		//
		
		private function createHTTPLoader():HTTPLoader
		{
			if (NetFactory.neverUseMockObjects)
			{
				return new HTTPLoader();
			}
			else
			{
				var loader:MockHTTPLoader = new MockHTTPLoader();
				loader.setExpectationForURL(RESOURCE.url.rawUrl, true, null);
				return loader;
			}
		}
		
		private static const RESOURCE:URLResource = new URLResource(new URL(TestConstants.REMOTE_IMAGE_FILE));
	}
}