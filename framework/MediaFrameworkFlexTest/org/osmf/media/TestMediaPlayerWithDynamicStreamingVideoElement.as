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
package org.osmf.media
{
	import org.osmf.net.NetLoader;
	import org.osmf.net.dynamicstreaming.DynamicStreamingItem;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.netmocker.MockDynamicStreamingNetLoader;
	import org.osmf.netmocker.NetConnectionExpectation;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.NetFactory;
	import org.osmf.utils.TestConstants;
	import org.osmf.video.VideoElement;
	
	public class TestMediaPlayerWithDynamicStreamingVideoElement extends TestMediaPlayer
	{
		// Overrides
		//
				
		override public function setUp():void
		{
			netFactory = new NetFactory();
			loader = netFactory.createDynamicStreamingNetLoader();

			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			netFactory = null;
			loader = null;
		}

		override protected function createMediaElement(resource:IMediaResource):MediaElement
		{
			if (loader is MockDynamicStreamingNetLoader)
			{
				// Give our mock loader an arbitrary duration and size to ensure
				// we get metadata.
				MockDynamicStreamingNetLoader(loader).netStreamExpectedDuration = 1; // TODO: ???
				MockDynamicStreamingNetLoader(loader).netStreamExpectedWidth = 768;
				MockDynamicStreamingNetLoader(loader).netStreamExpectedHeight = 428;
			
				if (resource == INVALID_RESOURCE)
				{
					MockDynamicStreamingNetLoader(loader).netConnectionExpectation = NetConnectionExpectation.INVALID_FMS_APPLICATION;
				}
			}

			var videoElement:VideoElement = new VideoElement(loader);
			videoElement.resource = resource;
			return videoElement; 
		}
		
		override protected function get loadable():Boolean
		{
			return true;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			// Use a valid URL so that the tests will pass if we use
			// a real NetLoader rather than a MockNetLoader.
			return switchableResource;
		}

		override protected function get invalidResourceForMediaElement():IMediaResource
		{
			// Use an invalid URL so that the tests will fail if we use
			// a real NetLoader rather than a MockNetLoader.
			return INVALID_RESOURCE;
		}
		
		override protected function get switchableResource():IMediaResource
		{
			var dsResource:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL(TEST_HOST_NAME));
			for each (var item:Object in TEST_STREAMS)
			{
				dsResource.addItem(new DynamicStreamingItem(item["stream"], item["bitrate"]));
			}
			return dsResource;
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
				   , MediaTraitType.SWITCHABLE
				   , MediaTraitType.TEMPORAL
				   , MediaTraitType.VIEWABLE
				   ];
		}
		
		override protected function get expectedWidthOnInitialization():Number
		{
			// Default width for a Video object.
			return 320;
		}

		override protected function get expectedHeightOnInitialization():Number
		{
			// Default height for a Video object.
			return 240;
		}
		
		override protected function get expectedWidthAfterLoad():Number
		{
			return 768;
		}

		override protected function get expectedHeightAfterLoad():Number
		{
			return 428;
		}
		
		override protected function getExpectedBitrateForIndex(index:int):Number
		{
			switch (index)
			{
				case 0: return 408000;
				case 1: return 608000;
				case 2: return 908000;
				case 3: return 1308000;
				case 4: return 1708000;
			}
			
			return -1;
		}
		
		// Internals
		//
		
		private static const TEST_HOST_NAME:String = "rtmp://cp67126.edgefcs.net/ondemand";
		private static const TEST_STREAMS:Array = [ 
			{stream:"mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_768x428_24.0fps_408kbps.mp4", bitrate:"408000"},
			{stream:"mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_768x428_24.0fps_608kbps.mp4", bitrate:"608000"},
			{stream:"mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_1024x522_24.0fps_908kbps.mp4", bitrate:"908000"},
			{stream:"mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_1024x522_24.0fps_1308kbps.mp4", bitrate:"1308000"},
			{stream:"mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_1280x720_24.0fps_1708kbps.mp4", bitrate:"1708000"} ]

		private static const INVALID_RESOURCE:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL(TestConstants.INVALID_STREAMING_VIDEO));
		
		private var netFactory:NetFactory;
		private var loader:NetLoader;
	}
}
