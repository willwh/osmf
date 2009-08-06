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
package org.openvideoplayer.traits
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.utils.InterfaceTestCase;
	
	public class TestILoadable extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			currentLoadable = null;
			eventDispatcher = new EventDispatcher();
			eventCount = 0;
			doTwice = false;
		}
		
		//---------------------------------------------------------------------
		
		public function testGetResource():void
		{
			var loadable:ILoadable = createILoadable();
			
			assertTrue(loadable.resource == null);
			
			var resource:IMediaResource = validResource;
			
			loadable = createILoadable(resource);
			
			assertTrue(loadable.resource != null);
			assertTrue(loadable.resource == resource);
		}

		public function testGetLoadState():void
		{
			var loadable:ILoadable = createILoadable();
			
			assertTrue(loadable.loadState == LoadState.CONSTRUCTED);
		}

		public function testGetLoadedContext():void
		{
			var loadable:ILoadable = createILoadable();
			
			assertTrue(loadable.loadedContext == null);
		}
		
		public function testLoad():void
		{
			doTestLoad();
		}

		public function testLoadTwice():void
		{
			doTwice = true;
			doTestLoad();
		}
		
		private function doTestLoad():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var loadable:ILoadable = currentLoadable = createILoadable(validResource);
			
			loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE,onTestLoad);
			loadable.load();
		}
		
		private function onTestLoad(event:LoadableStateChangeEvent):void
		{
			assertTrue(event.loadable == currentLoadable);
			assertTrue(event.target is ILoadable);
			
			var reload:Boolean = false;
			
			switch (eventCount)
			{
				case 0:
					assertTrue(event.oldState == LoadState.CONSTRUCTED);
					assertTrue(event.newState == LoadState.LOADING);
					
					assertTrue(event.loadable.loadedContext == null);
					break;
				case 1:
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOADED);
					
					assertTrue(event.loadable.loadedContext != null);
					
					if (doTwice)
					{
						reload = true;
					}
					else
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
					break;
				case 2:
					assertTrue(doTwice);
					
					assertTrue(event.oldState == LoadState.LOADED);
					assertTrue(event.newState == LoadState.LOADING);
					
					assertTrue(event.loadable.loadedContext == null);
					break;
				case 3:
					assertTrue(doTwice);
					
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOADED);
					
					assertTrue(event.loadable.loadedContext != null);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
					break;
				default:
					fail();
			}
			
			eventCount++;
			
			if (reload)
			{
				// Calling load a second time should repeat the process.
				event.loadable.load();
			}
		}
		
		public function testLoadWithFailure():void
		{
			doTestLoadWithFailure();
		}
		
		public function testLoadWithFailureThenReload():void
		{
			doTwice = true;
			doTestLoadWithFailure();
		}
		
		private function doTestLoadWithFailure():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var loadable:ILoadable = currentLoadable = createILoadable(invalidResource);
			
			loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE,onTestLoadWithFailure);
			loadable.load();
		}
				
		private function onTestLoadWithFailure(event:LoadableStateChangeEvent):void
		{
			assertTrue(event.loadable == currentLoadable);
			assertTrue(event.target is ILoadable);
			
			var reload:Boolean = false;
			
			switch (eventCount)
			{
				case 0:
					assertTrue(event.oldState == LoadState.CONSTRUCTED);
					assertTrue(event.newState == LoadState.LOADING);
					
					assertTrue(event.loadable.loadedContext == null);
					break;
				case 1:
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOAD_FAILED);
					
					assertTrue(event.loadable.loadedContext == null);
					
					if (eventCount == 1 && doTwice)
					{
						reload = true;
					}
					else
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
					break;
				case 2:
					assertTrue(doTwice);
					
					assertTrue(event.oldState == LoadState.LOAD_FAILED);
					assertTrue(event.newState == LoadState.LOADING);
					
					assertTrue(event.loadable.loadedContext == null);
					break;
				case 3:
					assertTrue(doTwice);
					
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOAD_FAILED);
					
					assertTrue(event.loadable.loadedContext == null);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
					break;
				default:
					fail();
			}
			
			eventCount++;
			
			if (reload)
			{
				// Reloading should repeat the failure.
				event.loadable.load();
			}
		}
		
		public function testLoadWithInvalidResource():void
		{
			var loadable:ILoadable = createILoadable(unhandledResource);
			
			try
			{
				loadable.load();
				
				fail();
			}
			catch (error:IllegalOperationError)
			{
			}
		}
		
		public function testUnload():void
		{
			doTestUnload();
		}
		
		public function testUnloadTwice():void
		{
			doTwice = true;
			doTestUnload();
		}

		private function doTestUnload():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			var loadable:ILoadable = currentLoadable = createILoadable(validResource);
			
			loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE,onTestUnload);
			loadable.load();
		}
		
		private function onTestUnload(event:LoadableStateChangeEvent):void
		{
			assertTrue(event.loadable == currentLoadable);
			assertTrue(event.target is ILoadable);
			
			var doUnload:Boolean = false;
			
			switch (eventCount)
			{
				case 0:
					assertTrue(event.oldState == LoadState.CONSTRUCTED);
					assertTrue(event.newState == LoadState.LOADING);
					
					assertTrue(event.loadable.loadedContext == null);
					break;
				case 1:
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOADED);
					
					assertTrue(event.loadable.loadedContext != null);
					
					// Now unload.
					doUnload = true;
					
					break;
				case 2:
					assertTrue(event.oldState == LoadState.LOADED);
					assertTrue(event.newState == LoadState.UNLOADING);
					
					assertTrue(event.loadable.loadedContext != null);
					break;
				case 3:
					assertTrue(event.oldState == LoadState.UNLOADING);
					assertTrue(event.newState == LoadState.CONSTRUCTED);
					
					assertTrue(event.loadable.loadedContext == null);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
					break;
					
				default:
					fail();
			}
			
			eventCount++;
			
			if (doUnload)
			{
				event.loadable.unload();
				
				if (doTwice)
				{
					// Unloading a second time should have no effect.
					event.loadable.unload();
				}
			}
		}
		
		public function testUnloadWithInvalidResource():void
		{
			var loadable:ILoadable = createILoadable(unhandledResource);
			
			try
			{
				loadable.unload();
				
				fail();
			}
			catch (error:IllegalOperationError)
			{
			}
		}
		
		//---------------------------------------------------------------------
		
		protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			return createInterfaceObject(resource) as ILoadable; 
		}
		
		protected function get validResource():IMediaResource
		{
			throw new Error("Subclass must override get validResource!");
		}

		protected function get invalidResource():IMediaResource
		{
			throw new Error("Subclass must override get invalidResource!");
		}

		protected function get unhandledResource():IMediaResource
		{
			throw new Error("Subclass must override get unhandledResource!");
		}
				
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}

		private function mustNotReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is NOT received.
			fail();
		}
		
		private static const TEST_TIME:int = 5000;
		
		private var eventDispatcher:EventDispatcher;
		private var eventCount:int = 0;
		private var currentLoadable:ILoadable;
		private var doTwice:Boolean;
	}
}