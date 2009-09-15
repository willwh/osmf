package org.openvideoplayer.composition
{
	import org.openvideoplayer.events.TraitEvent;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingItem;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingResource;
	import org.openvideoplayer.netmocker.MockDynamicStreamingNetLoader;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.ISwitchable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.TestISwitchable;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.video.VideoElement;
	
	public class TestParallelSwitchableTrait extends TestISwitchable
	{	
		override protected function createInterfaceObject(... args):Object
		{			
			var elem:VideoElement = createVideoElem();
			var elem2:VideoElement = createVideoElem();
			parallelElem = new ParallelElement();
			
			parallelElem.addChild(elem);
			parallelElem.addChild(elem2);
						
			(parallelElem.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();
			var playable:IPlayable = parallelElem.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			playable.play();	
												
			return parallelElem.getTrait(MediaTraitType.SWITCHABLE);
		}
		
		override public function testGetBitrateForIndex():void
		{
			assertEquals(500, switchable.getBitrateForIndex(0));
			assertEquals(800, switchable.getBitrateForIndex(1));
			assertEquals(1000, switchable.getBitrateForIndex(2));
			assertEquals(3000, switchable.getBitrateForIndex(3));		
		}
		
		public function testIndexChangeEvent():void
		{
			switchable.addEventListener(TraitEvent.INDICES_CHANGE, onIndexChange);
			var eventTriggered:Boolean = false;
			var rangeFired:Boolean;
			var newChild:VideoElement = createVideoElem();
			DynamicStreamingResource(newChild.resource).addItem(new DynamicStreamingItem("stream_4000", 4000));
						
			try
			{
				switchable.getBitrateForIndex(4)
			}
			catch(error:RangeError)
			{
				assertEquals(error.message, MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
				rangeFired = true;
			}
										
			assertTrue(rangeFired);	
			
			parallelElem.addChild(newChild);
			
			assertEquals(switchable.getBitrateForIndex(0), 500);
			assertEquals(switchable.getBitrateForIndex(1), 800);
			assertEquals(switchable.getBitrateForIndex(2), 1000);
			assertEquals(switchable.getBitrateForIndex(3), 3000);						
			
						
			function onIndexChange(event:TraitEvent):void
			{
				eventTriggered = true;
			}		
			assertTrue(eventTriggered);
			
			assertEquals(switchable.getBitrateForIndex(0), 500);
			assertEquals(switchable.getBitrateForIndex(1), 800);
			assertEquals(switchable.getBitrateForIndex(2), 1000);
			assertEquals(switchable.getBitrateForIndex(3), 3000);
			assertEquals(switchable.getBitrateForIndex(4), 4000);	
			
			eventTriggered = false;
			
			parallelElem.removeChild(newChild);
			
			assertTrue(eventTriggered);
			eventTriggered = false;
			
			parallelElem.removeChild(parallelElem.getChildAt(0));
			
			assertFalse(eventTriggered);
									
		}	
		
		public function testMaxIndex():void
		{
			var rangeFired:Boolean;
			try
			{
				switchable.maxIndex = -1;
			}
			catch(error:RangeError)
			{
				assertEquals(error.message, MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
				rangeFired = true;
			}
			assertTrue(rangeFired);
			rangeFired = false;
			try
			{
				switchable.maxIndex = 10;
			}
			catch(error:RangeError)
			{
				assertEquals(error.message, MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX);
				rangeFired = true;
			}
			assertTrue(rangeFired);
		}
		
		public function testRecomputationAutoSwitch():void
		{
			testRecomputation(true);
			testRecomputation(false);
		}
		
		private function testRecomputation(autoSwitch:Boolean):void
		{
			var newChild:VideoElement = createVideoElem();
			DynamicStreamingResource(newChild.resource).addItem(new DynamicStreamingItem("stream_4000", 4000));
			parallelElem.addChild(newChild);
			(parallelElem.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).autoSwitch = autoSwitch;
			var wrappingElement:ParallelElement = new ParallelElement();
			var eventTriggered:Boolean = false;			
			wrappingElement.addChild(parallelElem);
			(wrappingElement.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).autoSwitch = autoSwitch;
			var parentSwitchable:ISwitchable = (wrappingElement.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable);
			
			function onIndexChange(event:TraitEvent):void
			{
				eventTriggered = true;
			}				
					
			parentSwitchable.addEventListener(TraitEvent.INDICES_CHANGE, onIndexChange);
			
			parallelElem.removeChild(newChild);
			assertTrue(eventTriggered);
		}
		
		private function createVideoElem():VideoElement
		{
			var dsr:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL("http://www.example.com/ondemand"));
			dsr.addItem(new DynamicStreamingItem("stream_500kbps", 500));
			dsr.addItem(new DynamicStreamingItem("stream_800kbps", 800));
			dsr.addItem(new DynamicStreamingItem("stream_1000kbps", 1000));
			dsr.addItem(new DynamicStreamingItem("stream_3000kbps", 3000));
			
			var netLoader:MockDynamicStreamingNetLoader = new MockDynamicStreamingNetLoader();
			
			return  new VideoElement(netLoader, dsr);
		}
		
		private var parallelElem:ParallelElement;
		
	}
}