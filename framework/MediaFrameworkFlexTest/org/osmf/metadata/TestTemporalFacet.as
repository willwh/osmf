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
package org.osmf.metadata
{
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.netmocker.MockNetLoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.NetFactory;
	import org.osmf.utils.TestConstants;
	import org.osmf.utils.URL;
	import org.osmf.video.VideoElement;	

	public class TestTemporalFacet extends TestCase
	{
		override public function setUp():void
		{
			netFactory = new NetFactory();
			loader = netFactory.createNetLoader();
			createTemporalData();
			eventDispatcher = new EventDispatcher();
			
			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			netFactory = null;
			loader = null;
			_testValues = null;
			eventDispatcher = null;
		}
		
		public function testConstructor():void		
		{
			// Test passing null arguments
			try
			{
				var temporalFacet:TemporalFacet = new TemporalFacet(null, null);
				fail();
			}
			catch(error:ArgumentError)
			{
			}
			
			// Test passing valid arguments
			var facet:TemporalFacet = new TemporalFacet(new URL(NAMESPACE), new VideoElement(new NetLoader()));
			assertTrue(facet != null);
			assertEquals(NAMESPACE, facet.namespaceURL.rawUrl);
		}
		
		public function testAddValue():void
		{
			var facet:TemporalFacet = new TemporalFacet(new URL(NAMESPACE), new VideoElement(new NetLoader()));
			
			for each(var value:TemporalIdentifier in _testValues)
			{
				facet.addValue(value);
			}
			
			// Values should be sorted by time when we get them back
			var numValues:int = facet.numValues;
			var lastValue:Number = 0;
			
			for (var i:int = 0; i < numValues; i++)
			{
				var val:TemporalIdentifier = facet.getValueAt(i);
				assertTrue(val.time > lastValue);
				lastValue = val.time;	
			}
			
			// Test invalid values
			try
			{
				facet.addValue(null);
				fail();
			}
			catch(err:ArgumentError)
			{
			}
			
			try
			{
				facet.addValue(new TemporalIdentifier(-100, -10));
				fail();
			}
			catch(err:ArgumentError)
			{
			}
		}
		
		public function testGetValue():void
		{
			var facet:TemporalFacet = new TemporalFacet(new URL(NAMESPACE), new VideoElement(new NetLoader()));

			facet.addValue(new TemporalIdentifier(500, 5));
			
			assertNotNull(facet.getValue(new TemporalIdentifier(500, 5)));
			assertNull(facet.getValue(null));
			assertNull(facet.getValue(new TemporalIdentifier(123, 2)));
			assertNull(facet.getValueAt(-5));
			assertTrue(facet.synthesizer is FacetSynthesizer);
		}
		
		public function testPositionReached():void
		{
			testEvents();
		}
		
		public function testPositionReachedWithPause():void
		{
			testEvents(true);
		}
		
		public function testRemovingATrait():void
		{
			testOnTraitRemove();
		}
				
		private function testEvents(testPause:Boolean=false):void
		{
			var videoElement:VideoElement = createMediaElement();
			videoElement.resource = resourceForMediaElement;
			
			var facet:TemporalFacet = new TemporalFacet(new URL(NAMESPACE), videoElement);

			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TIMEOUT));

			for each(var value:TemporalIdentifier in _testValues)
			{
				facet.addValue(value);
			}
			
			var positionReachedCount:int = 0;

			facet.addEventListener(TemporalFacetEvent.POSITION_REACHED, onPositionReached);
			
			var loadTrait:LoadTrait = videoElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
			assertTrue(loadTrait != null);
			loadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
			loadTrait.load();
			
			function onLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					var playTrait:PlayTrait = videoElement.getTrait(MediaTraitType.PLAY) as PlayTrait;
					assertTrue(playTrait != null);
					playTrait.play();
				}
			}
			
			function onPositionReached(event:TemporalFacetEvent):void
			{
				positionReachedCount++;
				
				var newEvent:TemporalFacetEvent = event.clone() as TemporalFacetEvent;
				assertNotNull(newEvent);
				
				var timeTrait:TimeTrait = videoElement.getTrait(MediaTraitType.TIME) as TimeTrait;
				assertTrue(timeTrait != null);
				
				var playTrait:PlayTrait = videoElement.getTrait(MediaTraitType.PLAY) as PlayTrait;
				assertTrue(playTrait != null);
				
				// The time should be within TOLERANCE seconds of the playhead position
				var timeValue:Number = (event.value as TemporalIdentifier).time;
				var playheadPosition:Number = timeTrait.currentTime;
				assertTrue((playheadPosition >= (timeValue - TOLERANCE)) && (playheadPosition <= (timeValue + TOLERANCE)));
				
				if (testPause && (positionReachedCount == (facet.numValues/2)))
				{
					playTrait.pause();
					playTrait.play();
				}
								
				// This ensures we got all the "position reached" events
				if (positionReachedCount == facet.numValues)
				{
					facet.removeEventListener(TemporalFacetEvent.POSITION_REACHED, onPositionReached);
					playTrait.pause();
					
					var seekTrait:SeekTrait = videoElement.getTrait(MediaTraitType.SEEK) as SeekTrait;
					seekTrait.seek(5);
	
					facet.enable = false;
					if (eventDispatcher != null)
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
				}
			}
		}
		
		private function testOnTraitRemove():void
		{
			var mediaElement:DynamicMediaElement = createDynamicMediaElement();
																			 			
			var facet:TemporalFacet = new TemporalFacet(new URL(NAMESPACE), mediaElement);

			for each(var value:TemporalIdentifier in _testValues)
			{
				facet.addValue(value);
			}
						
			var loadTrait:LoadTrait = mediaElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
			assertTrue(loadTrait != null);
			loadTrait.load();
			assertTrue(loadTrait.loadState == LoadState.READY);
			
			var playTrait:PlayTrait = mediaElement.getTrait(MediaTraitType.PLAY) as PlayTrait;
			assertTrue(playTrait != null);
			playTrait.play();
			
			var timeTrait:TimeTrait = mediaElement.getTrait(MediaTraitType.TIME) as TimeTrait;
			assertTrue(timeTrait != null);
			
			var seekTrait:SeekTrait = mediaElement.getTrait(MediaTraitType.SEEK) as SeekTrait;
			assertTrue(seekTrait != null);
						
			// Remove the traits while playing
			mediaElement.doRemoveTrait(MediaTraitType.SEEK);
			mediaElement.doRemoveTrait(MediaTraitType.PLAY);
			mediaElement.doRemoveTrait(MediaTraitType.TIME);
		}

		private function createTemporalData():void
		{
			_testValues = new Vector.<TemporalIdentifier>();
			
			_testValues.push(new TemporalIdentifier(3.5, 1));
			_testValues.push(new TemporalIdentifier(1, TemporalIdentifier.UNDEFINED));
			_testValues.push(new TemporalIdentifier(3, 0));
			_testValues.push(new TemporalIdentifier(2, TemporalIdentifier.UNDEFINED));
			_testValues.push(new TemporalIdentifier(2.5, 1));
			
			// Add a few duplicates
			_testValues.push(new TemporalIdentifier(1, 1));
			_testValues.push(new TemporalIdentifier(3, 1));
		}
		
		
		private function createMediaElement():VideoElement
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
		
		private function createDynamicMediaElement():DynamicMediaElement
		{
			if (loader is MockNetLoader)
			{
				// Give our mock loader an arbitrary duration and size to ensure
				// we get metadata.
				MockNetLoader(loader).netStreamExpectedDuration = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_DURATION;
				MockNetLoader(loader).netStreamExpectedWidth = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_WIDTH;
				MockNetLoader(loader).netStreamExpectedHeight = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_HEIGHT;
			}

			return new DynamicMediaElement([ MediaTraitType.LOAD, MediaTraitType.PLAY,
											 MediaTraitType.SEEK, MediaTraitType.TIME ],
											 loader, resourceForMediaElement);
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
		
		private function get resourceForMediaElement():IMediaResource
		{
			// Use a valid URL so that the tests will pass if we use
			// a real NetLoader rather than a MockNetLoader.
			return new URLResource(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO));
		}
		
		private static const NAMESPACE:String = "www.osmf.org.test";
		private static const TOLERANCE:Number = .25;
		private static const TIMEOUT:Number = 5000;
		
		private var _testValues:Vector.<TemporalIdentifier>;
		
		private var netFactory:NetFactory;
		private var loader:NetLoader;
		private var eventDispatcher:EventDispatcher;
		
	}
}
