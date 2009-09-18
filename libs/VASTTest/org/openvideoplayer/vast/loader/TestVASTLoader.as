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
package org.openvideoplayer.vast.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.events.LoaderEvent;
	import org.openvideoplayer.events.MediaError;
	import org.openvideoplayer.events.MediaErrorCodes;
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.loaders.TestILoader;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.HTTPLoader;
	import org.openvideoplayer.utils.MockHTTPLoader;
	import org.openvideoplayer.utils.NullResource;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.vast.VASTTestConstants;
	import org.openvideoplayer.vast.model.VASTAd;
	import org.openvideoplayer.vast.model.VASTDocument;
		
	public class TestVASTLoader extends TestILoader
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
		
		//---------------------------------------------------------------------
		
		// Success cases
		//

		public function testLoadWithValidVASTDocument():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onTestLoadWithValidVASTDocument);
			loader.load(createILoadable(SUCCESSFUL_RESOURCE));
		}
		
		private function onTestLoadWithValidVASTDocument(event:LoaderEvent):void
		{
			if (event.newState == LoadState.LOADED)
			{
				var loadedContext:VASTLoadedContext = event.loadedContext as VASTLoadedContext;
				assertTrue(loadedContext != null);
				
				// Just check that we got an inline ad back.
				var document:VASTDocument = loadedContext.vastDocument;
				assertTrue(document != null);
				assertTrue(document.ads.length == 1);
				var ad:VASTAd = document.ads[0] as VASTAd;
				assertTrue(ad.inlineAd != null);
				assertTrue(ad.wrapperAd == null);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testLoadWithDefaultMaxNumWrapperRedirects():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onTestLoadWithDefaultMaxNumWrapperRedirects);
			loader.load(createILoadable(OUTER_WRAPPER_RESOURCE));
		}
		
		private function onTestLoadWithDefaultMaxNumWrapperRedirects(event:LoaderEvent):void
		{
			if (event.newState == LoadState.LOADED)
			{
				var loadedContext:VASTLoadedContext = event.loadedContext as VASTLoadedContext;
				assertTrue(loadedContext != null);
				
				// Verify that the result has an inline ad (which would have
				// come from the nested VAST document) and that the wrapper ad
				// (which would have come from the original VAST document) has
				// been merged and remove.
				var document:VASTDocument = loadedContext.vastDocument;
				assertTrue(document != null);
				assertTrue(document.ads.length == 1);
				var ad:VASTAd = document.ads[0] as VASTAd;
				assertTrue(ad.inlineAd != null);
				assertTrue(ad.wrapperAd == null);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}

		public function testLoadWithZeroMaxNumWrapperRedirects():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			setOverriddenLoader(createInterfaceObject(0) as ILoader);
			
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onTestLoadWithZeroMaxNumWrapperRedirects);
			loader.load(createILoadable(OUTER_WRAPPER_RESOURCE));
		}
		
		private function onTestLoadWithZeroMaxNumWrapperRedirects(event:LoaderEvent):void
		{
			if (event.newState == LoadState.LOADED)
			{
				var loadedContext:VASTLoadedContext = event.loadedContext as VASTLoadedContext;
				assertTrue(loadedContext != null);
				
				// Verify that the result has a wrapper ad (indicating that
				// a reference to a nested VAST document exists) but no inline
				// ad (which would show that the nested VAST document was not
				// retrieved).
				var document:VASTDocument = loadedContext.vastDocument;
				assertTrue(document != null);
				assertTrue(document.ads.length == 1);
				var ad:VASTAd = document.ads[0] as VASTAd;
				assertTrue(ad.inlineAd == null);
				assertTrue(ad.wrapperAd != null);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		// Failure cases
		//
		
		public function testLoadWithInvalidXMLVASTDocument():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onTestLoadWithInvalidXMLVASTDocument);
			loader.load(createILoadable(INVALID_XML_RESOURCE));
		}
		
		private function onTestLoadWithInvalidXMLVASTDocument(event:LoaderEvent):void
		{
			if (event.newState == LoadState.LOAD_FAILED)
			{
				assertTrue(event.loadedContext == null);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testLoadWithInvalidVASTDocument():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onTestLoadWithInvalidVASTDocument);
			loader.load(createILoadable(INVALID_RESOURCE));
		}
		
		private function onTestLoadWithInvalidVASTDocument(event:LoaderEvent):void
		{
			if (event.newState == LoadState.LOAD_FAILED)
			{
				assertTrue(event.loadedContext == null);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		public function testLoadWithInvalidWrapperRedirect():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			loader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onTestLoadWithInvalidWrapperRedirect);
			loader.load(createILoadable(WRAPPER_WITH_INVALID_WRAPPED_RESOURCE));
		}
		
		private function onTestLoadWithInvalidWrapperRedirect(event:LoaderEvent):void
		{
			if (event.newState == LoadState.LOAD_FAILED)
			{
				assertTrue(event.loadedContext == null);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		//---------------------------------------------------------------------
		
		override protected function createInterfaceObject(... args):Object
		{
			return new VASTLoader
				( args != null && args.length == 1 ? args[0] as int : -1
				, httpLoader
				);
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
						, VASTTestConstants.VAST_DOCUMENT_CONTENTS
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
				else if (resource == INVALID_XML_RESOURCE)
				{
					mockLoader.setExpectationForURL
						( URLResource(resource).url.rawUrl
						, true
						, VASTTestConstants.INVALID_XML_VAST_DOCUMENT_CONTENTS
						);
				}
				else if (resource == INVALID_RESOURCE)
				{
					mockLoader.setExpectationForURL
						( URLResource(resource).url.rawUrl
						, true
						, VASTTestConstants.INVALID_VAST_DOCUMENT_CONTENTS
						);
				}
				else if (resource == OUTER_WRAPPER_RESOURCE)
				{
					mockLoader.setExpectationForURL
						( URLResource(resource).url.rawUrl
						, true
						, VASTTestConstants.OUTER_WRAPPER_VAST_DOCUMENT_CONTENTS
						);

					mockLoader.setExpectationForURL
						( INNER_WRAPPER_RESOURCE.url.rawUrl
						, true
						, VASTTestConstants.INNER_WRAPPER_VAST_DOCUMENT_CONTENTS
						);

					mockLoader.setExpectationForURL
						( SUCCESSFUL_RESOURCE.url.rawUrl
						, true
						, VASTTestConstants.VAST_DOCUMENT_CONTENTS
						);
				}
				else if (resource == WRAPPER_WITH_INVALID_WRAPPED_RESOURCE)
				{
					mockLoader.setExpectationForURL
						( URLResource(resource).url.rawUrl
						, true
						, VASTTestConstants.WRAPPER_WITH_INVALID_WRAPPED_VAST_DOCUMENT_CONTENTS
						);

					mockLoader.setExpectationForURL
						( FAILED_RESOURCE.url.rawUrl
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
		
		private static const SUCCESSFUL_RESOURCE:URLResource = new URLResource(new URL(VASTTestConstants.VAST_DOCUMENT_URL));
		private static const FAILED_RESOURCE:URLResource = new URLResource(new URL(VASTTestConstants.MISSING_VAST_DOCUMENT_URL));
		private static const UNHANDLED_RESOURCE:URLResource = new URLResource(new URL("ftp://example.com"));
		
		private static const INVALID_XML_RESOURCE:URLResource = new URLResource(new URL(VASTTestConstants.INVALID_XML_VAST_DOCUMENT_URL));
		private static const INVALID_RESOURCE:URLResource = new URLResource(new URL(VASTTestConstants.INVALID_VAST_DOCUMENT_URL));
		private static const OUTER_WRAPPER_RESOURCE:URLResource = new URLResource(new URL(VASTTestConstants.OUTER_WRAPPER_VAST_DOCUMENT_URL));
		private static const INNER_WRAPPER_RESOURCE:URLResource = new URLResource(new URL(VASTTestConstants.INNER_WRAPPER_VAST_DOCUMENT_URL));
		private static const WRAPPER_WITH_INVALID_WRAPPED_RESOURCE:URLResource = new URLResource(new URL(VASTTestConstants.WRAPPER_WITH_INVALID_WRAPPED_VAST_DOCUMENT_URL)); 
	}
}