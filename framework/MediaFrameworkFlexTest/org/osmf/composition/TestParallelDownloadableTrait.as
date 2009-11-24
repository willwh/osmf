package org.osmf.composition
{
	import org.osmf.events.LoadEvent;
	import org.osmf.traits.DownloadableTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TestIDownloadable;
	import org.osmf.utils.DynamicMediaElement;
	
	public class TestParallelDownloadableTrait extends TestIDownloadable
	{
		
		override protected function createInterfaceObject(...args):Object
		{
			var aggregator:TraitAggregator =  new TraitAggregator();
			aggregator.addChild(new DynamicMediaElement([MediaTraitType.DOWNLOADABLE]));
			aggregator.addChild(new DynamicMediaElement([MediaTraitType.DOWNLOADABLE]));
			
			childTrait1 = aggregator.getChildAt(0).getTrait(MediaTraitType.DOWNLOADABLE) as DownloadableTrait;
			childTrait2 = aggregator.getChildAt(1).getTrait(MediaTraitType.DOWNLOADABLE) as DownloadableTrait;
						
			return new CompositeDownloadableTrait(CompositionMode.PARALLEL, aggregator);
		}
				
		public function testInitialProperties():void
		{
			assertEquals(20, downloadable.bytesLoaded);
			assertEquals(200, downloadable.bytesTotal);
		}
		
		public function testProperties():void
		{
			var downloadableTrait:CompositeDownloadableTrait = downloadable as CompositeDownloadableTrait;
			assertTrue(downloadableTrait != null);
			
			downloadableTrait.addEventListener(LoadEvent.BYTES_TOTAL_CHANGE, eventCatcher);
			
			childTrait1.bytesTotal = 150;	
			childTrait1.bytesLoaded = 50;
				
			childTrait2.bytesTotal = 100;	
			childTrait2.bytesLoaded = 60;
									
			assertEquals(110, downloadableTrait.bytesLoaded);
			assertEquals(250, downloadableTrait.bytesTotal);
			
			assertEquals(1, events.length);
		}
				
		
		private var childTrait1:DownloadableTrait;		
		private var childTrait2:DownloadableTrait;
		
	}
}