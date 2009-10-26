/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.test.mast.loader
{
	import flash.events.*;
	
	import org.osmf.events.LoaderEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.mast.loader.*;
	import org.osmf.mast.model.*;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.URLResource;
	import org.osmf.test.mast.MASTTestConstants;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.traits.TestILoader;
	import org.osmf.utils.HTTPLoader;
	import org.osmf.utils.MockHTTPLoader;
	import org.osmf.utils.NullResource;
	import org.osmf.utils.URL;
	
	public class TestMASTLoader extends TestILoader
	{
		override public function setUp():void
		{
			eventDispatcher = new EventDispatcher();
			
			// Change to HTTPLoader to run against the network.
			httpLoader = new MockHTTPLoader();
			
			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			eventDispatcher = null;
			httpLoader = null;
		}
		
		public function testLoadWithValidMASTDocument():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onTestLoadWithValidMASTDocument);
			loader.load(createILoadable(SUCCESSFUL_RESOURCE));
		}
		
		private function onTestLoadWithValidMASTDocument(event:LoaderEvent):void
		{
			if (event.newState == LoadState.LOADED)
			{
				var loadedContext:MASTLoadedContext = event.loadedContext as MASTLoadedContext;
				assertTrue(loadedContext != null);
				
				// Just check that we got a valid MAST DOM back
				var document:MASTDocument = loadedContext.document;
				assertTrue(document != null);
				assertTrue(document.triggers.length == 1);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		//---------------------------------------------------------------------
		
		override protected function createInterfaceObject(... args):Object
		{
			return new MASTLoader(httpLoader);
		}

		override protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			var mockLoader:MockHTTPLoader = httpLoader as MockHTTPLoader;
			if (mockLoader)
			{
				if (resource == successfulResource)
				{
					mockLoader.setExpectationForURL
						( URLResource(resource).url.rawUrl
						, true
						, MASTTestConstants.MAST_DOCUMENT_CONTENTS
						);
				}
				else if (resource == failedResource)
				{
					mockLoader.setExpectationForURL
						( URLResource(resource).url.rawUrl
						, false
						, null
						);
				}
				else if (resource == unhandledResource)
				{
					mockLoader.setExpectationForURL
						( URLResource(resource).url.rawUrl
						, false
						, null
						);
				}
			}
			return new LoadableTrait(loader, resource);
		}
		
		override protected function get successfulResource():IMediaResource
		{
			return SUCCESSFUL_RESOURCE;
		}
		
		override protected function get failedResource():IMediaResource
		{
			return FAILED_RESOURCE;
		}

		override protected function get unhandledResource():IMediaResource
		{
			return UNHANDLED_RESOURCE;
		}
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
			assertTrue(		error.errorCode == MediaErrorCodes.HTTP_IO_LOAD_ERROR
						||	error.errorCode == MediaErrorCodes.HTTP_SECURITY_LOAD_ERROR
					  );
		}
		
		override public function testCanHandleResource():void
		{
			super.testCanHandleResource();
			
			// Verify some valid resources.
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/video.flv"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/script.php?param=value"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("https://example.com"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("https://example.com/video.flv"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("https://example.com/script.php?param=value"))));
			
			// And some invalid ones.
			assertFalse(loader.canHandleResource(new URLResource(new URL("file:///audio.mp3"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("assets/audio.mp3"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("audio.mp3"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("httpt://example.com"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL(""))));
			assertFalse(loader.canHandleResource(new URLResource(null)));
			assertFalse(loader.canHandleResource(new NullResource()));
			assertFalse(loader.canHandleResource(null));
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder
		}
		
		private static const TEST_TIME:int = 8000;
		
		private var httpLoader:HTTPLoader;
		private var eventDispatcher:EventDispatcher;
		
		private static const SUCCESSFUL_RESOURCE:URLResource = new URLResource(new URL(MASTTestConstants.MAST_DOCUMENT_URL));
		private static const FAILED_RESOURCE:URLResource = new URLResource(new URL(MASTTestConstants.MISSING_MAST_DOCUMENT_URL));
		private static const UNHANDLED_RESOURCE:URLResource = new URLResource(new URL("ftp://example.com"));
		
	}
}
