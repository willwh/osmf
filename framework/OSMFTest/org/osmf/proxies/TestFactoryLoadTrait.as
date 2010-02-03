package org.osmf.proxies
{
	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.LoaderBase;

	public class TestFactoryLoadTrait extends TestCase
	{
		public function testGetter():void
		{
			var loader:LoaderBase = new LoaderBase();
			
			var resource:MediaResourceBase = new MediaResourceBase();
			
			var trait:FactoryLoadTrait = new FactoryLoadTrait(loader, resource);
					
			var elem:MediaElement = new MediaElement();
			trait.mediaElement  = elem;
			
			assertEquals(elem, trait.mediaElement);
			
			assertEquals(resource, trait.resource);
			
		}
		
	}
}