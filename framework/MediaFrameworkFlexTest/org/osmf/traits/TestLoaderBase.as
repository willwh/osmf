/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.traits
{
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.media.URLResource;
	import org.osmf.utils.MediaFrameworkStrings;
	import org.osmf.utils.URL;
	
	public class TestLoaderBase extends TestCase
	{
		public function testLoad():void
		{
			var loader:LoaderBase = new LoaderBase();
			var loadable:LoadableTrait = new LoadableTrait(loader,null);
				
			shouldThrowLoad(loader, null, MediaFrameworkStrings.NULL_PARAM);
			loadable.loadState = LoadState.READY;
			shouldThrowLoad(loader, loadable, MediaFrameworkStrings.ALREADY_READY);
			loadable.loadState = LoadState.LOADING;
			shouldThrowLoad(loader, loadable, MediaFrameworkStrings.ALREADY_LOADING);	
			loadable.loadState = LoadState.UNINITIALIZED;		
			shouldThrowLoad(loader, loadable, MediaFrameworkStrings.ILOADER_CANT_HANDLE_RESOURCE);
						
		}
		
		public function testUnload():void
		{
			var loader:LoaderBase = new LoaderBase();
			var loadable:LoadableTrait = new LoadableTrait(loader,null);
			
			shouldThrowUnload(loader, null, MediaFrameworkStrings.NULL_PARAM);
			loadable.loadState = LoadState.UNINITIALIZED;
			shouldThrowUnload(loader, loadable, MediaFrameworkStrings.ALREADY_UNLOADED);
			loadable.loadState = LoadState.UNLOADING;
			shouldThrowUnload(loader, loadable, MediaFrameworkStrings.ALREADY_UNLOADING);			
			loadable.loadState = LoadState.READY;		
			shouldThrowUnload(loader, loadable, MediaFrameworkStrings.ILOADER_CANT_HANDLE_RESOURCE);						
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