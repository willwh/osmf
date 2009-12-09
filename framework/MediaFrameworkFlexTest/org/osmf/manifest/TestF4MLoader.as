package org.osmf.manifest
{
	import flexunit.framework.TestCase;
	
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MediaTypeFacet;
	import org.osmf.traits.LoadTrait;
	import org.osmf.utils.URL;

	public class TestF4MLoader extends TestCase
	{
		public function testConstructorParams():void
		{
			//Test that both constructors work...
			var loader:F4MLoader = new F4MLoader(null);
			var loader2:F4MLoader = new F4MLoader(new ManifestParser(), new MediaFactory());
			var loader3:F4MLoader = new F4MLoader(new ManifestParser());
			var loader4:F4MLoader = new F4MLoader(null, new MediaFactory());		
			assertTrue(true);	
		}
		
		public function testCanHandle():void
		{		
			var loader:F4MLoader = new F4MLoader();
			
			var res1:URLResource = new URLResource(new URL('http://example.com/manifest.f4m'));
			
			var res2:URLResource = new URLResource(new URL('http://example.com/manifest.f4m'));
			res2.metadata.addFacet(new MediaTypeFacet(null, F4MLoader.F4M_MIME_TYPE));
			
			var res3:URLResource = new URLResource(new URL('http://example.com/manifest.blah'));
			res3.metadata.addFacet(new MediaTypeFacet(null, F4MLoader.F4M_MIME_TYPE));
			
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
			var loader:F4MLoader = new F4MLoader();
			var loadTrait:LoadTrait = new LoadTrait(loader, new URLResource(new URL("http://example.com/notValid")));
			var errorThrown:Boolean = false;
			try
			{
				loader.unload(loadTrait);
			}
			catch(error:Error)
			{
				errorThrown = true;	
			}
			assertTrue(errorThrown);			
		}
		
		public function testLoadFail():void
		{
			
			var loader:F4MLoader = new F4MLoader();
			var loadTrait:LoadTrait = new LoadTrait(loader, new URLResource(new URL("http://example.com/notValid.f4m")));
			loadTrait.addEventListener(MediaErrorEvent.MEDIA_ERROR, addAsync(onError, 3000));
			
			var errorThrown:Boolean = false;
			var errorThrownLoader:Boolean = false;
			
			loader.load(loadTrait);
					
			function onError(event:MediaErrorEvent):void
			{
			}
				
		}
		
		
		
	}
}