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
package org.openvideoplayer.video
{
	import flash.events.Event;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.events.MediaErrorCodes;
	import org.openvideoplayer.events.MediaErrorEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaPlayer;
	import org.openvideoplayer.media.TestMediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.net.NetStreamCodes;
	import org.openvideoplayer.netmocker.EventInfo;
	import org.openvideoplayer.netmocker.MockNetLoader;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.ISpatial;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.NetFactory;
	import org.openvideoplayer.utils.TestConstants;
	import org.openvideoplayer.utils.URL;

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

		override protected function createMediaElement():MediaElement
		{
			if (loader is MockNetLoader)
			{
				// Give our mock loader an arbitrary duration and size to ensure
				// we get metadata.
				MockNetLoader(loader).netStreamExpectedDuration = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_DURATION;
				MockNetLoader(loader).netStreamExpectedWidth = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_WIDTH;
				MockNetLoader(loader).netStreamExpectedHeight = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_HEIGHT;
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
				   , MediaTraitType.PAUSIBLE
				   , MediaTraitType.PLAYABLE
				   , MediaTraitType.SEEKABLE
				   , MediaTraitType.SPATIAL
				   , MediaTraitType.TEMPORAL
				   , MediaTraitType.VIEWABLE
				   ];
		}	

		public function testGetMetadata():void
		{
			var mediaElement:MediaElement = createMediaElement();
			mediaElement.resource = resourceForMediaElement;
			
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 4000));

			var loadable:ILoadable = mediaElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			loadable.addEventListener
					( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
					, onTestGetMetadata
					);
			loadable.load();
			
			function onTestGetMetadata(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					loadable.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onTestGetMetadata);
					
					// We should now have a spatial trait with no dimensions.
					var spatial:ISpatial = mediaElement.getTrait(MediaTraitType.SPATIAL) as ISpatial;
					assertTrue(spatial != null);
					assertTrue(spatial.width == 0);
					assertTrue(spatial.height == 0);
					
					spatial.addEventListener
							( DimensionChangeEvent.DIMENSION_CHANGE
							, onDimensionChange
							);
					
					// Playing the media should result in our receiving the
					// metadata, which should impact our dimensions.
					var playable:IPlayable = mediaElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
					assertTrue(playable != null);
					playable.play();
					
					function onDimensionChange(event:DimensionChangeEvent):void
					{
						spatial.removeEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onDimensionChange);
						
						assertTrue(spatial.width == TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_WIDTH);
						assertTrue(spatial.height == TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_HEIGHT);
						
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
	}
}