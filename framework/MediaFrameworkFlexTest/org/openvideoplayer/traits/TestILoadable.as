/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
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