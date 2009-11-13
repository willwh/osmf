/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.plugin
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.*;
	import org.osmf.media.*;
	import org.osmf.net.*;
	import org.osmf.traits.*;
	import org.osmf.utils.*;

	public class TestBasicStreamingPlugin extends TestCase
	{
		public function TestBasicStreamingPlugin(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			super.setUp();
			
			mediaFactory = new MediaFactory();
			pluginManager = new PluginManager(mediaFactory);
			eventDispatcher = new EventDispatcher();
		}

		override public function tearDown():void
		{
			super.tearDown();

			mediaFactory = null;
			pluginManager = null;
			eventDispatcher = null;
		}
		
		public function testPlayVODStreamWithAuth():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TEST_TIME));
			
			callAfterLoad(doTestPlayVODStreamWithAuth);
		}

		public function testPlayLiveStreamWithAuth():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TEST_TIME));
			
			callAfterLoad(doTestPlayLiveStreamWithAuth);
		}

		public function testPlayVODStream():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TEST_TIME));
			
			callAfterLoad(doTestPlayVODStream);
		}

		public function testPlayBadLiveStream():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TEST_TIME));
			
			callAfterLoad(doTestPlayBadLiveStream);
		}

		public function testPlayProgressive():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TEST_TIME));
			
			callAfterLoad(doTestPlayProgressive);
		}
		
		// Internals
		//

		private function doTestPlayVODStreamWithAuth():void
		{
			// on-demand stream with an auth token
			doTestMediaElementLoadAndPlay(new URL(REMOTE_STREAM_WITH_AUTH));
		}

		private function doTestPlayLiveStreamWithAuth():void
		{
			// a live stream with an auth token
			doTestMediaElementLoadAndPlay(new URL(REMOTE_LIVE_WITH_AUTH));
		}

		private function doTestPlayVODStream():void
		{
			// on-demand stream with no auth
			doTestMediaElementLoadAndPlay(new FMSURL(REMOTE_STREAM));
		}

		private function doTestPlayBadLiveStream():void
		{
			// a bad live stream, cause it to test the retry timer
			doTestMediaElementLoadAndPlay(new FMSURL(REMOTE_LIVE_BAD));
		}

		private function doTestPlayProgressive():void
		{
			// a progressive file
			doTestMediaElementLoadAndPlay(new FMSURL(PROGRESSIVE_FLV));
		}

		private function callAfterLoad(callback:Function):void
		{
			assertTrue(mediaFactory.getMediaInfoById(AKAMAI_VIDEO_MEDIA_INFO_ID) == null);
			assertTrue(mediaFactory.getMediaInfoById(AKAMAI_AUDIO_MEDIA_INFO_ID) == null);
			
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, onPluginLoaded);
			pluginManager.loadPlugin(new URLResource(new URL(AKAMAI_BASIC_STREAMING_PLUGIN_URL)));
			
			function onPluginLoaded(event:PluginLoadEvent):void
			{
				assertTrue(mediaFactory.getMediaInfoById(AKAMAI_VIDEO_MEDIA_INFO_ID) != null);
				assertTrue(mediaFactory.getMediaInfoById(AKAMAI_AUDIO_MEDIA_INFO_ID) != null);
				
				callback.apply(this);
			}
		}
		
		private function doTestMediaElementLoadAndPlay(url:URL):void
		{			
			var urlResource:IURLResource = new URLResource(url);
			var mediaElement:MediaElement = mediaFactory.createMediaElement(urlResource);
			assertTrue(mediaElement != null);
			
			var loadable:ILoadable = mediaElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			loadable.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onElementLoadStateChange);
			loadable.load();
						
			function onElementLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					var loadedContext:ILoadedContext = loadable.loadedContext;
					assertTrue(loadedContext != null);
					assertTrue(loadedContext is NetLoadedContext);
	
					var playable:IPlayable = mediaElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
					mediaElement.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError, false, 0, true);
					assertTrue(playable != null);
					playable.play();
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));			
				}
				else if (event.loadState == LoadState.LOAD_ERROR)
				{
					elementLoadFailed(null);
				}
			}
		}
						
		private function loadFailed(event:Event):void
		{
			fail("Loading the plugin failed - make sure you are loading both this app and the plugin swf from localhost or a web server.");			
		}
		
		private function elementLoadFailed(event:Event):void
		{
			fail("Loading a media element failed - check the address and make sure the resource exists at that URL/URI.");
		}

		private function onMediaError(event:MediaErrorEvent):void
		{
			fail("Media Error: "+ event.error.errorCode + " - " + event.error.description);	
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
			
		private var mediaFactory:MediaFactory;
		private var pluginManager:PluginManager;
		private var eventDispatcher:EventDispatcher;
		
		private static const AKAMAI_VIDEO_MEDIA_INFO_ID:String = "com.akamai.osmf.BasicStreamingVideoElement";
		private static const AKAMAI_AUDIO_MEDIA_INFO_ID:String = "com.akamai.osmf.BasicStreamingAudioElement";
		
		private static const AKAMAI_BASIC_STREAMING_PLUGIN_URL:String = "http://mediapm.edgesuite.net/osmf/swf/AkamaiBasicStreamingPlugin.swf";
		private static const TEST_TIME:int = 4000;

		private static const PROGRESSIVE_FLV:String 		= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		private static const REMOTE_STREAM_WITH_AUTH:String	= "rtmp://cp78634.edgefcs.net/ondemand/mp4:mediapmsec/osmf/content/test/SpaceAloneHD_sounas_640_700.mp4?auth=daEc2a9a5byaMa.avcxbiaoa8dBcibqbAa8-bkxDGK-b4toa-znnrqzzBvl&aifp=v0001";
		private static const REMOTE_STREAM:String 			= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
		private static const REMOTE_LIVE_WITH_AUTH:String	= "rtmp://cp78635.live.edgefcs.net/live/osmb-test-secure-700@s12015?auth=daEcobPbeaAbxa6d.c8cEbxcBdMdMdQdqa4-bkxDMF-b4toa-zonsnyBCql&aifp=v0001";
		private static const REMOTE_LIVE_BAD:String			= "rtmp://cp34973.live.edgefcs.net/live/Flash_Live_Benchmarkxxx@632";
	}
}
