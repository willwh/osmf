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
package org.openvideoplayer.loaders
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.events.LoaderEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.utils.InterfaceTestCase;
	
	public class TestILoader extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			_loader = createILoader();
			
			eventDispatcher = new EventDispatcher();
			eventCount = 0;
			doTwice = false;
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			_loader = null;
			eventDispatcher = null;
		}
		
		//---------------------------------------------------------------------
		
		public function testCanHandleResource():void
		{
			assertTrue(loader.canHandleResource(successfulResource) == true);
			assertTrue(loader.canHandleResource(failedResource) == true);
			assertTrue(loader.canHandleResource(unhandledResource) == false);
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
						
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onTestLoad);
			loader.load(createILoadable(successfulResource));
		}
		
		private function onTestLoad(event:LoaderEvent):void
		{
			assertTrue(event.loader == loader);
			assertTrue(event.loadable != null);
			assertTrue(event.type == LoaderEvent.LOADABLE_STATE_CHANGE);
			
			var reload:Boolean = false;
			
			switch (eventCount)
			{
				case 0:
					assertTrue(event.oldState == LoadState.CONSTRUCTED);
					assertTrue(event.newState == LoadState.LOADING);
					
					assertTrue(event.loadedContext == null);
					break;
				case 1:
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOADED);
					
					assertTrue(event.loadedContext != null);
					
					if (doTwice)
					{
						reload = true;
					}
					else
					{
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
					break;
				default:
					fail();
			}
			
			eventCount++;
			
			if (reload)
			{
				// Calling load a second time should throw an exception.
				try
				{
					event.loader.load(event.loadable);
					
					fail();
				}
				catch (error:IllegalOperationError)
				{
					eventDispatcher.dispatchEvent(new Event("testComplete"));
				}
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
			
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE,onTestLoadWithFailure);
			loader.load(createILoadable(failedResource));
		}
		
		private function onTestLoadWithFailure(event:LoaderEvent):void
		{
			assertTrue(event.loader == loader);
			assertTrue(event.loadable != null);
			assertTrue(event.type == LoaderEvent.LOADABLE_STATE_CHANGE);
			
			var reload:Boolean = false;
			
			switch (eventCount)
			{
				case 0:
					assertTrue(event.oldState == LoadState.CONSTRUCTED);
					assertTrue(event.newState == LoadState.LOADING);
					
					assertTrue(event.loadedContext == null);
					break;
				case 1:
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOAD_FAILED);
					
					assertTrue(event.loadedContext == null);
					
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
					
					assertTrue(event.loadedContext == null);
					break;
				case 3:
					assertTrue(doTwice);
					
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOAD_FAILED);
					
					assertTrue(event.loadedContext == null);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
					break;
				default:
					fail();
			}
			
			eventCount++;
			
			if (reload)
			{
				// Reloading should repeat the failure.
				event.loader.load(event.loadable);
			}
		}

		public function testLoadWithInvalidResource():void
		{
			try
			{
				loader.load(createILoadable(unhandledResource));
				
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
			
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE,onTestUnload);
			loader.load(createILoadable(successfulResource));
		}
		
		private function onTestUnload(event:LoaderEvent):void
		{
			assertTrue(event.loader == loader);
			assertTrue(event.loadable != null);
			assertTrue(event.type == LoaderEvent.LOADABLE_STATE_CHANGE);
			
			var doUnload:Boolean = false;
			
			switch (eventCount)
			{
				case 0:
					assertTrue(event.oldState == LoadState.CONSTRUCTED);
					assertTrue(event.newState == LoadState.LOADING);
					
					assertTrue(event.loadedContext == null);
					break;
				case 1:
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOADED);
					
					assertTrue(event.loadedContext != null);
					
					// Now unload.
					doUnload = true;
					
					break;
				case 2:
					assertTrue(event.oldState == LoadState.LOADED);
					assertTrue(event.newState == LoadState.UNLOADING);
					
					assertTrue(event.loadedContext != null);
					break;
				case 3:
					assertTrue(event.oldState == LoadState.UNLOADING);
					assertTrue(event.newState == LoadState.CONSTRUCTED);
					
					assertTrue(event.loadedContext == null);
					
					eventDispatcher.dispatchEvent(new Event("testComplete"));
					break;
					
				default:
					fail();
			}
			
			eventCount++;
			
			if (doUnload)
			{
				event.loader.unload(event.loadable);
				
				if (doTwice)
				{
					// Unloading a second time should throw an exception
					// (but the first unload will complete).
					try
					{
						event.loader.unload(event.loadable);
						
						fail();
					}
					catch (error:IllegalOperationError)
					{
					}
				}
			}
		}
		
		public function testUnloadWithInvalidResource():void
		{
			try
			{
				loader.unload(createILoadable(unhandledResource));
				
				fail();
			}
			catch (error:IllegalOperationError)
			{
			}
		}
		
		//---------------------------------------------------------------------
		
		final protected function createILoader():ILoader
		{
			return createInterfaceObject() as ILoader; 
		}
		
		final protected function get loader():ILoader
		{
			return _loader;
		}
		
		protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			throw new Error("Subclass must override createILoadable!");
		}
		
		protected function get successfulResource():IMediaResource
		{
			throw new Error("Subclass must override get successfulResource!");
		}

		protected function get failedResource():IMediaResource
		{
			throw new Error("Subclass must override get failedResource!");
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
		
		private static const TEST_TIME:int = 4000;
		
		private var eventDispatcher:EventDispatcher;
		private var eventCount:int = 0;
		private var _loader:ILoader;
		private var doTwice:Boolean;
	}
}