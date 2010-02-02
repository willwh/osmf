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
package org.osmf.media
{
	import flexunit.framework.TestCase;
	
	import org.osmf.proxies.ProxyElement;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.DynamicReferenceMediaElement;
	import org.osmf.utils.SampleResourceHandler;
	import org.osmf.utils.URL;
	
	public class TestMediaFactory extends TestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			this.mediaFactory = new MediaFactory();
		}
		
		public function testAddMediaFactoryItem():void
		{
			var id:String = "a1";
			
			var item1:MediaFactoryItem = createMediaFactoryItem(id);
			
			assertTrue(mediaFactory.getItemById(id) == null);
			
			mediaFactory.addItem(item1);
			assertTrue(mediaFactory.getItemById(id) == item1);
			assertTrue(mediaFactory.numItems == 1);
			
			// Adding a second one with the same ID should cause the first
			// to be replaced.
			var item2:MediaFactoryItem = createMediaFactoryItem(id);
			mediaFactory.addItem(item2);
			assertTrue(mediaFactory.getItemById(id) == item2);
			assertTrue(mediaFactory.numItems == 1);
		}

		public function testAddItemWithInvalidParam():void
		{
			try
			{
				mediaFactory.addItem(null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
			}
		}

		public function testRemoveItem():void
		{
			var id:String = "a1";
			
			var item:MediaFactoryItem = createMediaFactoryItem(id);

			// Calling it on an empty factory is a no-op.
			mediaFactory.removeItem(item);
			
			mediaFactory.addItem(item);
			assertTrue(mediaFactory.getItemById(id) == item);
			
			mediaFactory.removeItem(item);
			assertTrue(mediaFactory.getItemById(id) == null);
			
			// Calling it twice is a no-op.
			mediaFactory.removeItem(item);
		}

		public function testRemoveItemWithInvalidParam():void
		{
			try
			{
				mediaFactory.removeItem(null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
			}
		}
		
		public function testGetNumItems():void
		{
			assertTrue(mediaFactory.numItems == 0);
			
			var info1:MediaFactoryItem = createMediaFactoryItem("a1");
			var info2:MediaFactoryItem = createMediaFactoryItem("a2");
			var info3:MediaFactoryItem = createMediaFactoryItem("b3", null, null, MediaFactoryItemType.PROXY);
			var info4:MediaFactoryItem = createMediaFactoryItem("b4", null, null, MediaFactoryItemType.PROXY);
			
			mediaFactory.addItem(info1);
			assertTrue(mediaFactory.numItems == 1);
			mediaFactory.addItem(info2);
			assertTrue(mediaFactory.numItems == 2);

			mediaFactory.addItem(info3);
			assertTrue(mediaFactory.numItems == 3);
			mediaFactory.addItem(info4);
			assertTrue(mediaFactory.numItems == 4);

			mediaFactory.removeItem(info1);
			assertTrue(mediaFactory.numItems == 3);
			mediaFactory.removeItem(info2);
			assertTrue(mediaFactory.numItems == 2);
			
			mediaFactory.removeItem(info3);
			assertTrue(mediaFactory.numItems == 1);
			mediaFactory.removeItem(info4);
			assertTrue(mediaFactory.numItems == 0);
		}
		
		public function testGetItemAt():void
		{
			var a1:MediaFactoryItem = createMediaFactoryItem("a1","http://www.example.com/a1");
			var a2:MediaFactoryItem = createMediaFactoryItem("a2","http://www.example.com/a2");
			var a3:MediaFactoryItem = createMediaFactoryItem("a3","http://www.example.com/a3");
			var b1:MediaFactoryItem = createMediaFactoryItem("b1","http://www.example.com/b1", null, MediaFactoryItemType.PROXY);
			var b2:MediaFactoryItem = createMediaFactoryItem("b2","http://www.example.com/b2", null, MediaFactoryItemType.PROXY);
			var b3:MediaFactoryItem = createMediaFactoryItem("b3","http://www.example.com/b3", null, MediaFactoryItemType.PROXY);
			
			mediaFactory.addItem(a1);
			mediaFactory.addItem(b1);
			mediaFactory.addItem(a2);
			mediaFactory.addItem(b2);
			mediaFactory.addItem(a3);
			mediaFactory.addItem(b3);
			
			assertTrue(mediaFactory.getItemAt(-1) == null);
			assertTrue(mediaFactory.getItemAt(0) == a1);
			assertTrue(mediaFactory.getItemAt(1) == a2);
			assertTrue(mediaFactory.getItemAt(2) == a3);
			assertTrue(mediaFactory.getItemAt(3) == b1);
			assertTrue(mediaFactory.getItemAt(4) == b2);
			assertTrue(mediaFactory.getItemAt(5) == b3);
			assertTrue(mediaFactory.getItemAt(6) == null);
		}
		
		public function testGetItemById():void
		{
			mediaFactory.addItem(createMediaFactoryItem("a1"));
			mediaFactory.addItem(createMediaFactoryItem("a2"));
			mediaFactory.addItem(createMediaFactoryItem("a3"));
			mediaFactory.addItem(createMediaFactoryItem("b1", null, null, MediaFactoryItemType.PROXY));
			mediaFactory.addItem(createMediaFactoryItem("b2", null, null, MediaFactoryItemType.PROXY));
			mediaFactory.addItem(createMediaFactoryItem("b3", null, null, MediaFactoryItemType.PROXY));
			
			assertTrue(mediaFactory.getItemById("a1") != null);
			assertTrue(mediaFactory.getItemById("a2") != null);
			assertTrue(mediaFactory.getItemById("a3") != null);
			assertTrue(mediaFactory.getItemById("a4") == null);
			assertTrue(mediaFactory.getItemById("b1") != null);
			assertTrue(mediaFactory.getItemById("b2") != null);
			assertTrue(mediaFactory.getItemById("b3") != null);
			assertTrue(mediaFactory.getItemById("b4") == null);
			assertTrue(mediaFactory.getItemById(null) == null);
		}

		public function testCreateMediaElement():void
		{
			var a1:MediaFactoryItem = createMediaFactoryItem("a1","http://www.example.com/a1");
			mediaFactory.addItem(a1);
			
			assertTrue(mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com"))) == null);
			assertTrue(mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/a2"))) == null);
			assertTrue(mediaFactory.createMediaElement(null) == null);
			
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/a1")));
			assertTrue(mediaElement != null);
			assertTrue(mediaElement.resource != null);
			assertTrue(mediaElement.resource is URLResource);
			assertTrue(URLResource(mediaElement.resource).url.toString() == "http://www.example.com/a1");
		}
		
		public function testCreateMediaElementWithInvalidMediaElementCreationFunctionReturnType():void
		{
			var a1:MediaFactoryItem = new MediaFactoryItem
				( "a1"
				, new SampleResourceHandler(null, "http://www.example.com/a1").canHandleResource
				, invalidReturnType
				);
			mediaFactory.addItem(a1);
			
			function invalidReturnType():String
			{
				return "hi";
			}

			assertTrue(mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/a1"))) == null);
		}
		
		public function testCreateMediaElementWithInvalidMediaElementCreationFunctionParams():void
		{
			var a1:MediaFactoryItem = new MediaFactoryItem
				( "a1"
					, new SampleResourceHandler(null, "http://www.example.com/a1").canHandleResource
					, invalidParams
				);
			mediaFactory.addItem(a1);
			
			function invalidParams(i:int,s:String):MediaElement
			{
				return new MediaElement();
			}
			
			assertTrue(mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/a1"))) == null);
		}
			
		public function testCreateMediaElementWithInvalidMediaElementCreationFunctionNullReturnValue():void
		{
			var a1:MediaFactoryItem = new MediaFactoryItem
				( "a1"
				, new SampleResourceHandler(null, "http://www.example.com/a1").canHandleResource
				, nullReturnValue
				);
			mediaFactory.addItem(a1);
			
			function nullReturnValue():MediaElement
			{
				return null;
			}
			
			assertTrue(mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/a1"))) == null);
		}

		public function testCreateMediaElementWithProxy():void
		{
			var standardInfo:MediaFactoryItem = createMediaFactoryItem("standardInfo", "http://www.example.com/standardInfo");
			mediaFactory.addItem(standardInfo);
						
			// By default, createMediaElement creates standard media elements.
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/standardInfo")));
			assertTrue(!(mediaElement is ProxyElement));
			assertTrue(mediaElement is DynamicMediaElement);

			// If we add a proxy media info whose media element is not a proxy,
			// then createMediaElement should return the standard media element.
			var invalidProxyInfo:MediaFactoryItem = createMediaFactoryItem("invalidProxyInfo", "http://www.example.com/standardInfo", null, MediaFactoryItemType.PROXY);
			mediaFactory.addItem(invalidProxyInfo);

			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/standardInfo")));
			assertTrue(!(mediaElement is ProxyElement));
			
			// If we add a proxy media info whose media element is a proxy, then
			// createMediaElement should return a proxy that wraps the standard
			// media element.
			var validProxyInfo:MediaFactoryItem = createProxyMediaFactoryItem("validProxyInfo", "http://www.example.com/standardInfo");
			mediaFactory.addItem(validProxyInfo);

			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/standardInfo")));
			assertTrue(mediaElement is ProxyElement);
			assertTrue((mediaElement as ProxyElement).proxiedElement is DynamicMediaElement);
			
			// Proxies can go many levels deep.
			var deepProxyInfo:MediaFactoryItem = createProxyMediaFactoryItem("deepProxyInfo", "http://www.example.com/standardInfo");
			mediaFactory.addItem(deepProxyInfo);

			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/standardInfo")));
			assertTrue(mediaElement is ProxyElement);
			assertTrue((mediaElement as ProxyElement).proxiedElement is ProxyElement);
			assertTrue(((mediaElement as ProxyElement).proxiedElement as ProxyElement).proxiedElement is DynamicMediaElement);
		}
		
		public function testCreateMediaElementWithReference():void
		{
			var standardInfo:MediaFactoryItem = createMediaFactoryItem("standardInfo","http://www.example.com/standardInfo");
			mediaFactory.addItem(standardInfo);
			var otherStandardInfo:MediaFactoryItem = createMediaFactoryItem("otherStandardInfo","http://www.example.com/otherStandardInfo");
			mediaFactory.addItem(otherStandardInfo);
			
			// Create some standard media elements through the factory so that we
			// have things to reference.
			var createdElement1:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/standardInfo")));
			assertTrue(createdElement1 is DynamicMediaElement);
			var createdElement2:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/otherStandardInfo")));
			assertTrue(createdElement2 is DynamicMediaElement);
			var createdElement3:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/otherStandardInfo")));
			assertTrue(createdElement3 is DynamicMediaElement);

			// If we add a media info whose media element is not a reference,
			// then createMediaElement should return an unreferencing element.
			var invalidReferenceInfo:MediaFactoryItem = createMediaFactoryItem("invalidReferenceInfo", "http://www.example.com/invalidReferenceInfo");
			mediaFactory.addItem(invalidReferenceInfo);
			
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/invalidReferenceInfo")));
			assertTrue(mediaElement != null);
			assertTrue(!(mediaElement is IMediaReferrer));
			
			// Now create a referencing element that should match a previously
			// created one.
			var referenceInfo:MediaFactoryItem = createReferenceMediaFactoryItem("referenceInfo1","http://www.example.com/referenceInfo1", "http://www.example.com/standardInfo");
			mediaFactory.addItem(referenceInfo);
			
			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/referenceInfo1")));
			assertTrue(mediaElement != null);
			assertTrue(mediaElement is IMediaReferrer);
			var dynamicElement:DynamicReferenceMediaElement = mediaElement as DynamicReferenceMediaElement;
			assertTrue(dynamicElement);
			assertTrue(dynamicElement.references.length == 1);
			assertTrue(dynamicElement.references[0] == createdElement1);
			
			// It's possible to have multiple references too.
			referenceInfo = createReferenceMediaFactoryItem("referenceInfo2","http://www.example.com/referenceInfo2", "http://www.example.com/otherStandardInfo");
			mediaFactory.addItem(referenceInfo);
			
			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/referenceInfo2")));
			assertTrue(mediaElement != null);
			assertTrue(mediaElement is IMediaReferrer);
			dynamicElement = mediaElement as DynamicReferenceMediaElement;
			assertTrue(dynamicElement);
			assertTrue(dynamicElement.references.length == 2);
			assertTrue(dynamicElement.references[0] == createdElement2 ||
					   dynamicElement.references[0] == createdElement3);
			assertTrue(dynamicElement.references[1] == createdElement2 ||
					   dynamicElement.references[1] == createdElement3);
			assertTrue(dynamicElement.references[0] != dynamicElement.references[1]);
			
			var referenceElement:DynamicReferenceMediaElement = dynamicElement;
			
			// It's possible for a reference element to reference another
			// reference element.
			referenceInfo = createReferenceMediaFactoryItem("referenceInfo3","http://www.example.com/referenceInfo3", "http://www.example.com/referenceInfo2");
			mediaFactory.addItem(referenceInfo);
			
			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/referenceInfo3")));
			assertTrue(mediaElement != null);
			assertTrue(mediaElement is IMediaReferrer);
			dynamicElement = mediaElement as DynamicReferenceMediaElement;
			assertTrue(dynamicElement);
			assertTrue(dynamicElement.references.length == 1);
			assertTrue(dynamicElement.references[0] == referenceElement);
			
			// Creating a new element will result in it being added to any
			// existing reference that matches it.
			var createdElement4:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/otherStandardInfo")));
			assertTrue(createdElement4 is DynamicMediaElement);
			assertTrue(referenceElement.references.length == 3);
			assertTrue(referenceElement.references[0] == createdElement4 ||
					   referenceElement.references[1] == createdElement4 ||
					   referenceElement.references[2] == createdElement4);
			
			// Creating a non-matching element will not add a new reference.
			var yetAnotherStandardInfo:MediaFactoryItem = createMediaFactoryItem("yetAnotherStandardInfo","http://www.example.com/yetAnotherStandardInfo");
			mediaFactory.addItem(yetAnotherStandardInfo);
			
			var createdElement5:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/yetAnotherStandardInfo")));
			assertTrue(createdElement5 is DynamicMediaElement);
			assertTrue(referenceElement.references.length == 3);
		}

		//---------------------------------------------------------------------
		
		private function createMediaFactoryItem(id:String, urlToMatch:String=null, args:Array=null, type:String=null):MediaFactoryItem
		{
			return new MediaFactoryItem
					( id
					, new SampleResourceHandler((urlToMatch ? null : canHandleResource), urlToMatch).canHandleResource
					, createDynamicMediaElement
					, type != null ? type : MediaFactoryItemType.STANDARD
					);
		}
		
		private function createDynamicMediaElement():MediaElement
		{
			return new DynamicMediaElement();
		}

		private function createProxyMediaFactoryItem(id:String, urlToMatch:String=null, args:Array=null):MediaFactoryItem
		{
			return new MediaFactoryItem
					( id
					, new SampleResourceHandler((urlToMatch ? null : canHandleResource), urlToMatch).canHandleResource
					, createProxyElement
					, MediaFactoryItemType.PROXY
					);
		}
		
		private function createProxyElement():MediaElement
		{
			return new ProxyElement(null);
		}
		
		private function createReferenceMediaFactoryItem(id:String, urlToMatch:String=null, referenceUrlToMatch:String=null, type:String=null):MediaFactoryItem
		{
			function createDynamicReferenceMediaElement():MediaElement
			{
				return new DynamicReferenceMediaElement(referenceUrlToMatch);
			}

			return new MediaFactoryItem
					( id
					, new SampleResourceHandler((urlToMatch ? null : canHandleResource), urlToMatch).canHandleResource
					, createDynamicReferenceMediaElement
					, type != null ? type : MediaFactoryItemType.STANDARD
					);
		}

		private function canHandleResource(resource:MediaResourceBase):Boolean
		{
			return false;
		}
		
		private var mediaFactory:MediaFactory;
	}
}