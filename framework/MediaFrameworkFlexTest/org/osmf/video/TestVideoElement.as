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
package org.osmf.video
{
	import flash.events.Event;
	
	import org.osmf.events.DimensionEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MetadataEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.TestMediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.TemporalFacet;
	import org.osmf.metadata.TemporalFacetEvent;
	import org.osmf.metadata.TemporalIdentifier;
	import org.osmf.net.NetLoader;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.StreamType;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.netmocker.EventInfo;
	import org.osmf.netmocker.MockNetLoader;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.IPausable;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.ISeekable;
	import org.osmf.traits.ISpatial;
	import org.osmf.traits.IViewable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.NetFactory;
	import org.osmf.utils.TestConstants;
	import org.osmf.utils.URL;

	public class TestVideoElement extends TestMediaElement
	{
		override public function setUp():void
		{
			netFactory = new NetFactory();
			loader = netFactory.createNetLoader();

			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			netFactory = null;
			loader = null;
		}
		
		////////////////////////////////////////////////////////
		//
		//	Tests
		//
		////////////////////////////////////////////////////////
		
		public function testGetClient():void
		{
			var videoElement:VideoElement = createMediaElement() as VideoElement;
			videoElement.resource = resourceForMediaElement;

			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 4000));

			var loadable:ILoadable = videoElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			loadable.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
			loadable.load();
			
			function onLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					loadable.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
					assertNotNull(videoElement.client);
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
		}
		
		public function testLiveTraits():void
		{
			var videoElement:VideoElement = createMediaElement() as VideoElement;
			videoElement.resource = new StreamingURLResource(new URL(TestConstants.REMOTE_STREAMING_VIDEO_LIVE),
																StreamType.LIVE);

			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 4000));

			var loadable:ILoadable = videoElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			loadable.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
			loadable.load();
			
			function onLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					loadable.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
					
					var seekable:ISeekable = videoElement.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
					assertNull(seekable);
					
					var pausable:IPausable = videoElement.getTrait(MediaTraitType.PAUSABLE) as IPausable;
					assertNotNull(pausable);
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
		}
		
		/**
		 * This test is for the in-stream onCuePoint callback
		 * in VideoElement.
		 */
		public function testOnCuePoint():void
		{
			var cuePointCount:int = 0;
			
			if (loader is MockNetLoader)
			{
				var testCuePoints:Array = [ {type:"event", time:1, name:"1 sec"},
										{type:"event", time:2, name:"2 sec"},
										{type:"event", time:3, name:"3 sec"} ];
				cuePoints = testCuePoints;
			}
			
			var videoElement:VideoElement = createMediaElement() as VideoElement;
			videoElement.resource = new URLResource(new URL(TestConstants.REMOTE_STREAMING_VIDEO));
			videoElement.metadata.addEventListener(MetadataEvent.FACET_ADD, onFacetAdd);
			
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 4000));

			var loadable:ILoadable = videoElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			loadable.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
			loadable.load();
			
			function onLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					loadable.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
					
					var playable:IPlayable = videoElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
					playable.play();
				}
			}

			function onFacetAdd(event:MetadataEvent):void
			{
				if (event.facet is TemporalFacet)
				{
					trace(">>> got the TemporalFacet");
					videoElement.metadata.removeEventListener(MetadataEvent.FACET_ADD, onFacetAdd);
					event.facet.addEventListener(TemporalFacetEvent.POSITION_REACHED, onPositionReached);
				}
			}
			
			function onPositionReached(event:TemporalFacetEvent):void
			{
				trace("!!! onPositionReached time="+(event.value as TemporalIdentifier).time+", cuePointCount="+cuePointCount);
				if (testCuePoints)
				{
					if (++cuePointCount >= testCuePoints.length)
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
						cuePoints = null;				
					} 
				}
			}
		}

		public function testGetMetadata():void
		{
			var mediaElement:MediaElement = createMediaElement();
			mediaElement.resource = resourceForMediaElement;
			
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 4000));

			var loadable:ILoadable = mediaElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			loadable.addEventListener
					( LoadEvent.LOAD_STATE_CHANGE
					, onTestGetMetadata
					);
			loadable.load();
			
			function onTestGetMetadata(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					loadable.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onTestGetMetadata);
					
					// We should now have a spatial trait with the default dimensions:
					var spatial:ISpatial = mediaElement.getTrait(MediaTraitType.SPATIAL) as ISpatial;
					assertTrue(spatial != null);
					assertTrue(spatial.width == 0);
					assertTrue(spatial.height == 0);
					
					// See if the view matches the reported size:
					var viewable:IViewable = mediaElement.getTrait(MediaTraitType.VIEWABLE) as IViewable;
					assertNotNull(viewable);
					assertEquals(0, viewable.view.width);
					assertEquals(0, viewable.view.height);
					
					spatial.addEventListener
							( DimensionEvent.DIMENSION_CHANGE
							, onDimensionChange
							);
					
					// Playing the media should result in our receiving the
					// metadata, which should impact our dimensions.
					var playable:IPlayable = mediaElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
					assertTrue(playable != null);
					playable.play();
					
					function onDimensionChange(event:DimensionEvent):void
					{
						spatial.removeEventListener(DimensionEvent.DIMENSION_CHANGE, onDimensionChange);
						
						assertTrue(spatial.width == TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_WIDTH);
						assertTrue(spatial.height == TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_HEIGHT);
						
						assertEquals(spatial.width, viewable.view.width);
						assertEquals(spatial.height, viewable.view.height);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
		}

		public function testMediaErrorPlayFailed():void
		{
			doTestMediaError(NetStreamCodes.NETSTREAM_PLAY_FAILED, MediaErrorCodes.PLAY_FAILED);
		}

		public function testMediaErrorStreamNotFound():void
		{
			doTestMediaError(NetStreamCodes.NETSTREAM_PLAY_STREAMNOTFOUND, MediaErrorCodes.STREAM_NOT_FOUND);
		}
		
		public function testMediaErrorFileStructureInvalid():void
		{
			doTestMediaError(NetStreamCodes.NETSTREAM_PLAY_FILESTRUCTUREINVALID, MediaErrorCodes.FILE_STRUCTURE_INVALID);
		}

		public function testMediaErrorNoSupportedTrackFound():void
		{
			doTestMediaError(NetStreamCodes.NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND, MediaErrorCodes.NO_SUPPORTED_TRACK_FOUND);
		}

		////////////////////////////////////////////////////////
		//
		//	Private and Protected properties and methods
		//
		////////////////////////////////////////////////////////

		override protected function createMediaElement():MediaElement
		{
			if (loader is MockNetLoader)
			{
				// Give our mock loader an arbitrary duration and size to ensure
				// we get metadata.
				MockNetLoader(loader).netStreamExpectedDuration = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_DURATION;
				MockNetLoader(loader).netStreamExpectedWidth = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_WIDTH;
				MockNetLoader(loader).netStreamExpectedHeight = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_HEIGHT;
				
				if (cuePoints != null && cuePoints.length > 0)
				{
					MockNetLoader(loader).netStreamExpectedCuePoints = cuePoints;
				}
			}

			return new VideoElement(loader); 
		}
		
		override protected function get loadable():Boolean
		{
			return true;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			// Use a valid URL so that the tests will pass if we use
			// a real NetLoader rather than a MockNetLoader.
			return new URLResource(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO));
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [MediaTraitType.LOADABLE];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [ MediaTraitType.AUDIBLE
				   , MediaTraitType.BUFFERABLE
				   , MediaTraitType.LOADABLE
				   , MediaTraitType.PAUSABLE
				   , MediaTraitType.PLAYABLE
				   , MediaTraitType.SEEKABLE
				   , MediaTraitType.SPATIAL
				   , MediaTraitType.TEMPORAL
				   , MediaTraitType.VIEWABLE
				   , MediaTraitType.DOWNLOADABLE
				   ];
		}	

		private function doTestMediaError(netStreamCode:String, errorCode:int, level:String="error"):void
		{
			var mockLoader:MockNetLoader = loader as MockNetLoader;
			if (mockLoader != null)
			{
				mockLoader.netStreamExpectedEvents = [ new EventInfo(netStreamCode, level, 0) ];
					
				var mediaElement:MediaElement = createMediaElement();
				mediaElement.resource = resourceForMediaElement;
				
				mediaElement.addEventListener(MediaErrorEvent.MEDIA_ERROR, onTestMediaError);
				
				eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 4000));
				
				var mediaPlayer:MediaPlayer = new MediaPlayer(mediaElement);
				
				function onTestMediaError(event:MediaErrorEvent):void
				{
					assertTrue(event.error.errorCode == errorCode);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
		}
		
		private var netFactory:NetFactory;
		private var loader:NetLoader;
		private var cuePoints:Array;
	}
}
