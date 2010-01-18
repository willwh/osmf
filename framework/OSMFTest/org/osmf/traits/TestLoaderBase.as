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
	
	import org.osmf.media.IMediaResource;
	import org.osmf.media.URLResource;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.SimpleResource;
	import org.osmf.utils.URL;
	
	// TODO:
	// - Merge ILoader and LoaderBase
	// - Modify merged class to make load/unload methods final, and use process/postProcess metaphor.
	// - Modify TestLoaderBase to include logic from TestILoader, but to match the pattern for base
	//   trait classes.
	public class TestLoaderBase extends TestILoader
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new LoaderBase();
		}

		/**
		 * Subclasses can override to specify their own resource.
		 **/
		override protected function get successfulResource():IMediaResource
		{
			return new SimpleResource(SimpleResource.SUCCESSFUL);
		}

		override protected function get failedResource():IMediaResource
		{
			return new SimpleResource(SimpleResource.FAILED);
		}

		override protected function get unhandledResource():IMediaResource
		{
			return new SimpleResource(SimpleResource.UNHANDLED);
		}

		/*
		public function testLoadValidation():void
		{
			var loader:LoaderBase = new LoaderBase();
			var loadTrait:LoadTrait = createLoadTrait(loader, null);
				
			shouldThrowLoad(loader, null, OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			loadTrait.loadState = LoadState.READY;
			shouldThrowLoad(loader, loadTrait, OSMFStrings.getString(OSMFStrings.ALREADY_READY));
			loadTrait.loadState = LoadState.LOADING;
			shouldThrowLoad(loader, loadTrait, OSMFStrings.getString(OSMFStrings.ALREADY_LOADING));	
			loadTrait.loadState = LoadState.UNINITIALIZED;		
			shouldThrowLoad(loader, loadTrait, OSMFStrings.getString(OSMFStrings.ILOADER_CANT_HANDLE_RESOURCE));
						
		}
		
		public function testUnloadValidation():void
		{
			var loader:LoaderBase = new LoaderBase();
			var loadTrait:LoadTrait = createLoadTrait(loader, null);
			
			shouldThrowUnload(loader, null, OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			loadTrait.loadState = LoadState.UNINITIALIZED;
			shouldThrowUnload(loader, loadTrait, OSMFStrings.getString(OSMFStrings.ALREADY_UNLOADED));
			loadTrait.loadState = LoadState.UNLOADING;
			shouldThrowUnload(loader, loadTrait, OSMFStrings.getString(OSMFStrings.ALREADY_UNLOADING));			
			loadTrait.loadState = LoadState.READY;		
			shouldThrowUnload(loader, loadTrait, OSMFStrings.getString(OSMFStrings.ILOADER_CANT_HANDLE_RESOURCE));						
		}
		
		private function shouldThrowLoad(loader:ILoader, loadTrait:LoadTrait, message:String):void
		{
			var caught:Boolean = false;
			try
			{
				loader.load(loadTrait);
			}
			catch (error:IllegalOperationError)
			{
				assertEquals(error.message, message);
				caught = true;
			}
			assertTrue(caught);
		}
		
		private function shouldThrowUnload(loader:ILoader, loadTrait:LoadTrait, message:String):void
		{
			var caught:Boolean = false;
			try
			{
				loader.unload(loadTrait);
			}
			catch (error:IllegalOperationError)
			{
				assertEquals(error.message, message);
				caught = true;
			}
			assertTrue(caught);
		}
		
		override public function testCanHandleResource():void
		{
			super.testCanHandleResource();
			
			var loader:LoaderBase = new LoaderBase();
			assertFalse(loader.canHandleResource(null));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://test.com"))));
		}*/
	}
}