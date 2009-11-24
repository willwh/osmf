package org.osmf.net
{
	import flexunit.framework.TestCase;
	
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MediaTypeFacet;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.utils.URL;

	public class TestFMMLoader extends TestCase
	{
		public function testConstructorParams():void
		{
			//Test that both constructors work...
			var loader:FMMLoader = new FMMLoader(null);
			var loader2:FMMLoader = new FMMLoader(new MediaFactory());		
			assertTrue(true);	
		}
		
		public function testCanHandle():void
		{		
			var loader:FMMLoader = new FMMLoader();
			
			var res1:URLResource = new URLResource(new URL('http://example.com/manifest.f4m'));
			
			var res2:URLResource = new URLResource(new URL('http://example.com/manifest.f4m'));
			res2.metadata.addFacet(new MediaTypeFacet(null, FMMLoader.F4M_MIME_TYPE));
			
			var res3:URLResource = new URLResource(new URL('http://example.com/manifest.blah'));
			res3.metadata.addFacet(new MediaTypeFacet(null, FMMLoader.F4M_MIME_TYPE));
			
			var res4:URLResource = new URLResource(new URL('http://example.com/manifest.blah'));
			
			var res5:URLResource = new URLResource(new URL('http://example.com/manifest.blah'));
			res5.metadata.addFacet(new MediaTypeFacet(null, 'application/blah+xml'));
										
			assertTrue(loader.canHandleResource(res1));
			assertTrue(loader.canHandleResource(res2));
			assertTrue(loader.canHandleResource(res3));
			assertFalse(loader.canHandleResource(res4));
			assertFalse(loader.canHandleResource(res5));
									
		}
		
		public function testUnloadFail():void
		{
			var loader:FMMLoader = new FMMLoader();
			var loadable:LoadableTrait = new LoadableTrait(loader, new URLResource(new URL("http://example.com/notValid")));
			var errorThrown:Boolean = false;
			try
			{
				loader.unload(loadable);
			}
			catch(error:Error)
			{
				errorThrown = true;	
			}
			assertTrue(errorThrown);			
		}
		
		public function testLoadFail():void
		{
			
			var loader:FMMLoader = new FMMLoader();
			var loadable:LoadableTrait = new LoadableTrait(loader, new URLResource(new URL("http://example.com/notValid.f4m")));
			loadable.addEventListener(MediaErrorEvent.MEDIA_ERROR, addAsync(onError, 3000));
			
			var errorThrown:Boolean = false;
			var errorThrownLoader:Boolean = false;
			
			loader.load(loadable);
					
			function onError(event:MediaErrorEvent):void
			{
			}
				
		}
		
		
		
	}
}