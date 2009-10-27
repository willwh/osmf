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
			
			function onPositionReached(event:TemporalFacetEvent):void
			{
				trace("onPositionReached() - event.value.time = "+(event.value as TemporalIdentifier).time);
				
				var newEvent:TemporalFacetEvent = event.clone() as TemporalFacetEvent;
				assertNotNull(newEvent);
				
				if ((event.value as TemporalIdentifier).time == 3)
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
