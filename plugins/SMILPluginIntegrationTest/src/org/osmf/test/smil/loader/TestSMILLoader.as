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
package org.osmf.test.smil.loader
{
	import flash.events.*;
	
	import org.osmf.elements.proxyClasses.LoadFromDocumentLoadTrait;
	import org.osmf.events.LoaderEvent;
	import org.osmf.events.MediaError;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.smil.loader.*;
	import org.osmf.smil.model.*;
	import org.osmf.test.smil.SMILTestConstants;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.TestLoaderBase;
	import org.osmf.utils.NullResource;
	import org.osmf.utils.URL;
	
	public class TestSMILLoader extends TestLoaderBase
	{
		override public function setUp():void
		{
			eventDispatcher = new EventDispatcher();
			
			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			eventDispatcher = null;
		}
		
		
		override protected function createLoadTrait(loader:LoaderBase, resource:MediaResourceBase):LoadTrait
		{
			return new LoadFromDocumentLoadTrait(loader, resource);
		}
		
		public function testLoadWithValidSMILDocument():void
		{
			eventDispatcher.addEventListener("testComplete",addAsync(mustReceiveEvent,TEST_TIME));
			
			loader.addEventListener(LoaderEvent.LOAD_STATE_CHANGE, onTestLoadWithValidSMILDocument);
			loader.load(createLoadTrait(loader, SUCCESSFUL_MBR_RESOURCE));
		}
		
		public function testLoadWithValidSMILDocument2():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TEST_TIME));
			loader.addEventListener(LoaderEvent.LOAD_STATE_CHANGE, onTestLoadWithValidSMILDocument);
			loader.load(createLoadTrait(loader, SUCCESSFUL_PAR_RESOURCE));
		}

		public function testLoadWithValidMBRDocument():void
		{
			eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TEST_TIME));
			loader.addEventListener(LoaderEvent.LOAD_STATE_CHANGE, onTestLoadWithValidSMILDocument);
			loader.load(createLoadTrait(loader, SUCCESSFUL_SEQ_RESOURCE));
		}

		
		private function onTestLoadWithValidSMILDocument(event:LoaderEvent):void
		{
			if (event.newState == LoadState.READY)
			{
				var trait:LoadFromDocumentLoadTrait = event.loadTrait as LoadFromDocumentLoadTrait;
				assertTrue(trait != null);
				
				// Just check that we got a valid MediaElement
				var element:MediaElement = trait.mediaElement;
				assertTrue(element != null);
				
				eventDispatcher.dispatchEvent(new Event("testComplete"));
			}
		}
		
		//---------------------------------------------------------------------
		
		override protected function createInterfaceObject(... args):Object
		{
			return new SMILLoader();
		}

		override protected function get successfulResource():MediaResourceBase
		{
			return SUCCESSFUL_SEQ_RESOURCE;
		}
		
		override protected function get failedResource():MediaResourceBase
		{
			return FAILED_RESOURCE;
		}

		override protected function get unhandledResource():MediaResourceBase
		{
			return UNHANDLED_RESOURCE;
		}
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
		}
		
		override public function testCanHandleResource():void
		{
			super.testCanHandleResource();
			
			// Verify some valid resources.
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/myfile.smil"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/playlist.smi"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/script.smil?param=value"))));
			
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
		
		private var eventDispatcher:EventDispatcher;
		
		private static const SUCCESSFUL_SEQ_RESOURCE:URLResource = new URLResource(new URL(SMILTestConstants.SMIL_DOCUMENT_SEQ_URL));
		private static const SUCCESSFUL_PAR_RESOURCE:URLResource = new URLResource(new URL(SMILTestConstants.SMIL_DOCUMENT_PAR_URL));		
		private static const SUCCESSFUL_MBR_RESOURCE:URLResource = new URLResource(new URL(SMILTestConstants.SMIL_DOCUMENT_MBR_URL));
		private static const FAILED_RESOURCE:URLResource = new URLResource(new URL(SMILTestConstants.MISSING_SMIL_DOCUMENT_URL));
		private static const UNHANDLED_RESOURCE:URLResource = new URLResource(new URL("ftp://example.com"));
		
	}
}
