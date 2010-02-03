package org.osmf.proxies
{
	import org.osmf.events.LoadEvent;
	import org.osmf.events.LoaderEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.URL;
	
	public class TestFactoryElement extends TestProxyElement
	{
				
		public function testWithLoader():void
		{
			var resource:URLResource = new URLResource(new URL("http://example.com/blah"));
			var loader:LoaderBase = new LoaderBase();
			var factory:FactoryElement = new FactoryElement(resource, loader);
			var testFacet:KeyValueFacet = new KeyValueFacet(new URL("http://adobe.com/"));
			factory.metadata.addFacet(testFacet);
						
			var wrapped:MediaElement = new MediaElement();
						
			assertEquals(resource, factory.resource);
				
			resource = new URLResource(new URL("http://newresource.com/test"));		
			factory.resource = resource;
			assertEquals(resource, factory.resource);
									
			assertTrue(factory.hasTrait(MediaTraitType.LOAD));
			
			assertNotNull(factory.metadata);
			
			var load:FactoryLoadTrait = factory.getTrait(MediaTraitType.LOAD) as FactoryLoadTrait;
			
			assertNotNull(load);
			
			load.mediaElement = wrapped;
			loader.dispatchEvent(new LoaderEvent(LoadEvent.LOAD_STATE_CHANGE, false, false, loader, load, LoadState.LOADING, LoadState.READY));
			
			//Ensure metadata proxy is functioning properly
			assertEquals(factory.metadata.getFacet(new URL("http://adobe.com/")), testFacet);		
			
			assertEquals(factory.metadata.namespaceURLs.length, wrapped.metadata.namespaceURLs.length);
						
		}
	}
}