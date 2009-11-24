package org.osmf.composition
{
	import org.osmf.events.LoadEvent;
	import org.osmf.traits.DownloadableTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TestIDownloadable;
	import org.osmf.utils.DynamicMediaElement;

	public class TestSerialDownloadableTrait extends TestIDownloadable
	{
		override protected function createInterfaceObject(...args):Object
		{
			var aggregator:TraitAggregator =  new TraitAggregator();
			aggregator.addChild(new DynamicMediaElement([MediaTraitType.DOWNLOADABLE]));
			aggregator.addChild(new DynamicMediaElement([MediaTraitType.DOWNLOADABLE]));
			aggregator.addChild(new DynamicMediaElement([MediaTraitType.DOWNLOADABLE]));
						
			childTrait1 = aggregator.getChildAt(0).getTrait(MediaTraitType.DOWNLOADABLE) as DownloadableTrait;
			childTrait2 = aggregator.getChildAt(1).getTrait(MediaTraitType.DOWNLOADABLE) as DownloadableTrait;
			childTrait3 = aggregator.getChildAt(2).getTrait(MediaTraitType.DOWNLOADABLE) as DownloadableTrait;
						
			return new CompositeDownloadableTrait(CompositionMode.SERIAL, aggregator);
		}
				
		public function testInitialProperties():void
		{
			assertEquals(30, downloadable.bytesLoaded);
			assertEquals(300, downloadable.bytesTotal);			
		}
		
		public function testProperties():void
		{
			var downloadableTrait:CompositeDownloadableTrait = downloadable as CompositeDownloadableTrait;
			assertTrue(downloadableTrait != null);
			
			downloadableTrait.addEventListener(LoadEvent.BYTES_TOTAL_CHANGE, eventCatcher);
				
			childTrait1.bytesTotal = 110;
			childTrait1.bytesLoaded = 50;
			
			childTrait2.bytesTotal = 120;
			childTrait2.bytesLoaded = 0;
			
			childTrait3.bytesTotal = 120;
			childTrait3.bytesLoaded = 30;
			
			//Test the gap functionality (unstarted downloads removes the following bytesLoaded from the total.
			assertEquals(50, downloadableTrait.bytesLoaded);
			assertEquals(350, downloadableTrait.bytesTotal);
			
			assertEquals(3, events.length);
					
			childTrait2.bytesLoaded = 70;

			assertEquals(150, downloadableTrait.bytesLoaded);
			assertEquals(350, downloadableTrait.bytesTotal);
		}
				
		private var childTrait1:DownloadableTrait;		
		private var childTrait2:DownloadableTrait;
		private var childTrait3:DownloadableTrait;
			
	}
}