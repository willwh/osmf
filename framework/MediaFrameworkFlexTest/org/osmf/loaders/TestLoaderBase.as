package org.osmf.loaders
{
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.media.URLResource;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.utils.MediaFrameworkStrings;
	import org.osmf.utils.URL;
	
	public class TestLoaderBase extends TestCase
	{
		public function testLoad():void
		{
			var loader:LoaderBase = new LoaderBase();
			var loadable:LoadableTrait = new LoadableTrait(loader,null);
				
			shouldThrowLoad(loader, null, MediaFrameworkStrings.NULL_PARAM);
			loadable.loadState = LoadState.LOADED;
			shouldThrowLoad(loader, loadable, MediaFrameworkStrings.ALREADY_LOADED);
			loadable.loadState = LoadState.LOADING;
			shouldThrowLoad(loader, loadable, MediaFrameworkStrings.ALREADY_LOADING);	
			loadable.loadState = LoadState.CONSTRUCTED;		
			shouldThrowLoad(loader, loadable, MediaFrameworkStrings.ILOADER_CANT_HANDLER_RESOURCE);
						
		}
		
		public function testUnload():void
		{
			var loader:LoaderBase = new LoaderBase();
			var loadable:LoadableTrait = new LoadableTrait(loader,null);
			
			shouldThrowUnload(loader, null, MediaFrameworkStrings.NULL_PARAM);
			loadable.loadState = LoadState.CONSTRUCTED;
			shouldThrowUnload(loader, loadable, MediaFrameworkStrings.ALREADY_UNLOADED);
			loadable.loadState = LoadState.UNLOADING;
			shouldThrowUnload(loader, loadable, MediaFrameworkStrings.ALREADY_UNLOADING);			
			loadable.loadState = LoadState.LOADED;		
			shouldThrowUnload(loader, loadable, MediaFrameworkStrings.ILOADER_CANT_HANDLER_RESOURCE);						
		}
		
		private function shouldThrowLoad(loader:ILoader, loadable:ILoadable, message:String):void
		{
			var caught:Boolean = false;
			try
			{
				loader.load(loadable);
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, message);
				caught = true;
			}
			assertTrue(caught);
		}
		
		private function shouldThrowUnload(loader:ILoader, loadable:ILoadable, message:String):void
		{
			var caught:Boolean = false;
			try
			{
				loader.unload(loadable);
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, message);
				caught = true;
			}
			assertTrue(caught);
		}
				
		public function testCanHandleResource():void
		{
			var loader:LoaderBase = new LoaderBase();
			assertFalse(loader.canHandleResource(null));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://test.com"))));
		}

	}
}