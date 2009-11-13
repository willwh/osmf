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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.LoaderEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.utils.InterfaceTestCase;
	
	public class TestILoader extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			_loader = createILoader();
			
			eventDispatcher = new EventDispatcher();
			eventCount = 0;
			mediaErrors = [];
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
					assertTrue(event.oldState == LoadState.UNINITIALIZED);
					assertTrue(event.newState == LoadState.LOADING);
					
					// Context may be null, but is not required to be null anymore:
					// assertTrue(event.loadedContext == null);
					break;
				case 1:
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.READY);
					
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
			var loadable:ILoadable = createILoadable(failedResource);
			loadable.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError); 
			loader.load(loadable);
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
					assertTrue(event.oldState == LoadState.UNINITIALIZED);
					assertTrue(event.newState == LoadState.LOADING);
					
					// Loaded context may be null, but can be non-null too:
					// assertTrue(event.loadedContext == null);
					break;
				case 1:
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOAD_ERROR);
					
					assertTrue(event.loadedContext == null);
					
					if (eventCount == 1 && doTwice)
					{
						reload = true;
					}
					else
					{
						markCompleteOnMediaError(1);
					}
					break;
				case 2:
					assertTrue(doTwice);
										
					assertTrue(event.oldState == LoadState.LOAD_ERROR);
					assertTrue(event.newState == LoadState.LOADING);
					
					// Loaded context may be null, but can be non-null too:
					// assertTrue(event.loadedContext == null);
					break;
				case 3:
					assertTrue(doTwice);
					
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.LOAD_ERROR);
					
					assertTrue(event.loadedContext == null);
					
					markCompleteOnMediaError(2);
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
		
		private function markCompleteOnMediaError(numExpected:int):void
		{
			if (numExpected == mediaErrors.length)
			{
				// Just verify one of them.
				verifyMediaErrorOnLoadFailure(mediaErrors[0] as MediaError);

				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
			else
			{
				// Wait a bit, then check again.
				var timer:Timer = new Timer(400);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
				
				function onTimer(event:TimerEvent):void
				{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, onTimer);
					
					markCompleteOnMediaError(numExpected);
				}
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
					assertTrue(event.oldState == LoadState.UNINITIALIZED);
					assertTrue(event.newState == LoadState.LOADING);
					
					// Loaded context may be null, but can be non-null too:
					// assertTrue(event.loadedContext == null);
					break;
				case 1:
					assertTrue(event.oldState == LoadState.LOADING);
					assertTrue(event.newState == LoadState.READY);
					
					assertTrue(event.loadedContext != null);
					
					// Now unload.
					doUnload = true;
					
					break;
				case 2:
					assertTrue(event.oldState == LoadState.READY);
					assertTrue(event.newState == LoadState.UNLOADING);
					
					assertTrue(event.loadedContext != null);
					break;
				case 3:
					assertTrue(event.oldState == LoadState.UNLOADING);
					assertTrue(event.newState == LoadState.UNINITIALIZED);
					
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
		
		protected function setOverriddenLoader(value:ILoader):void
		{
			_loader = value;
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
		
		protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
			// Subclasses can override to check the error's properties.
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
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			mediaErrors.push(event.error);
		}
		
		private static const TEST_TIME:int = 8000;
		
		private var eventDispatcher:EventDispatcher;
		private var eventCount:int = 0;
		private var mediaErrors:Array;
		private var _loader:ILoader;
		private var doTwice:Boolean;
	}
}