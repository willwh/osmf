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
	
	import org.osmf.media.IMediaResource;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.netmocker.MockNetLoader;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.IPausable;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.ISeekable;
	import org.osmf.traits.ITemporal;
	import org.osmf.traits.MediaTraitType;
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
			assertNull(facet.merge(null));
		}
		
		public function testEvents():void
		{
			var videoElement:VideoElement = createMediaElement();
			videoElement.resource = resourceForMediaElement;
			
			var facet:TemporalFacet = new TemporalFacet(new URL(NAMESPACE), videoElement);

			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 5000));

			for each(var value:TemporalIdentifier in _testValues)
			{
				facet.addValue(value);
			}
			
			facet.addEventListener(TemporalFacetEvent.POSITION_REACHED, onPositionReached);
			
			var loadable:ILoadable = videoElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			loadable.load();
			
			var playable:IPlayable = videoElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable != null);
			playable.play();
			
			var pausable:IPausable = videoElement.getTrait(MediaTraitType.PAUSABLE) as IPausable;
			assertTrue(pausable != null);
			
			var temporal:ITemporal = videoElement.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			assertTrue(temporal != null);
			
			var positionReachedCount:int = 0;
			
			function onPositionReached(event:TemporalFacetEvent):void
			{
				positionReachedCount++;
				
				var newEvent:TemporalFacetEvent = event.clone() as TemporalFacetEvent;
				assertNotNull(newEvent);
				
				// The time should be within .5 seconds of the playhead position
				var timeValue:Number = (event.value as TemporalIdentifier).time;
				var playheadPosition:Number = temporal.currentTime;
				trace("onPositionReached() - event.value.time = "+timeValue+", playhead position="+playheadPosition);
				assertTrue((playheadPosition >= (timeValue - .5)) && (playheadPosition <= (timeValue + .5)));
				
				if (positionReachedCount == 3)
				{
					facet.removeEventListener(TemporalFacetEvent.POSITION_REACHED, onPositionReached);
					pausable.pause();
					
					var seekable:ISeekable = videoElement.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
					seekable.seek(5);
	
					facet.enable = false;
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
			}
		}
		
		private function createTemporalData():void
		{
			_testValues = new Vector.<TemporalIdentifier>();
			
			_testValues.push(new TemporalIdentifier(1, 1));
			_testValues.push(new TemporalIdentifier(2, TemporalIdentifier.UNDEFINED));
			_testValues.push(new TemporalIdentifier(3, 1));
			_testValues.push(new TemporalIdentifier(3, 5));
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
		private var _testValues:Vector.<TemporalIdentifier>;
		
		private var netFactory:NetFactory;
		private var loader:NetLoader;
		private var eventDispatcher:EventDispatcher;
		
	}
}
