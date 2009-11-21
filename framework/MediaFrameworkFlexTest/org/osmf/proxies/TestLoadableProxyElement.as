package org.osmf.proxies
{
	import org.osmf.events.LoadEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.URL;
	
	public class TestLoadableProxyElement extends TestProxyElement
	{
		public function TestLoadableProxyElement()
		{			
		}
		
		public function testWithLoader():void
		{
			var loader:MediaElementLoader = new MediaElementLoader();
			var proxy:LoadableProxyElement = new LoadableProxyElement(loader);
			var wrapped:MediaElement = new MediaElement();
						
			assertNull(proxy.resource);
			var resource:URLResource = new URLResource(new URL('http://example.com/'));
			proxy.resource = resource;
			assertEquals(proxy.resource, resource);
			
			assertTrue(proxy.hasTrait(MediaTraitType.LOADABLE));
			
			//Fake the Load
			(proxy.getTrait(MediaTraitType.LOADABLE) as ILoadable).loadedContext = new MediaElementLoadedContext(wrapped);
			(proxy.getTrait(MediaTraitType.LOADABLE) as ILoadable).dispatchEvent(new LoadEvent(LoadEvent.LOAD_STATE_CHANGE, false,false, LoadState.READY));
			
			assertEquals(proxy.wrappedElement, wrapped);
			assertFalse(proxy.hasTrait(MediaTraitType.LOADABLE));  //Shouldn't still have the phony trait.
			
		}

	}
}