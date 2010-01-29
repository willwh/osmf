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
		
		public function testAddMediaInfo():void
		{
			var id:String = "a1";
			
			var mediaInfo1:MediaInfo = createMediaInfo(id);
			
			assertTrue(mediaFactory.getMediaInfoById(id) == null);
			
			mediaFactory.addMediaInfo(mediaInfo1);
			assertTrue(mediaFactory.getMediaInfoById(id) == mediaInfo1);
			assertTrue(mediaFactory.numMediaInfos == 1);
			
			// Adding a second one with the same ID should cause the first
			// to be replaced.
			var mediaInfo2:MediaInfo = createMediaInfo(id);
			mediaFactory.addMediaInfo(mediaInfo2);
			assertTrue(mediaFactory.getMediaInfoById(id) == mediaInfo2);
			assertTrue(mediaFactory.numMediaInfos == 1);
		}

		public function testAddMediaInfoWithInvalidParam():void
		{
			try
			{
				mediaFactory.addMediaInfo(null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
			}
		}

		public function testRemoveMediaInfo():void
		{
			var id:String = "a1";
			
			var mediaInfo:MediaInfo = createMediaInfo(id);

			// Calling it on an empty factory is a no-op.
			mediaFactory.removeMediaInfo(mediaInfo);
			
			mediaFactory.addMediaInfo(mediaInfo);
			assertTrue(mediaFactory.getMediaInfoById(id) == mediaInfo);
			
			mediaFactory.removeMediaInfo(mediaInfo);
			assertTrue(mediaFactory.getMediaInfoById(id) == null);
			
			// Calling it twice is a no-op.
			mediaFactory.removeMediaInfo(mediaInfo);
		}

		public function testRemoveMediaInfoWithInvalidParam():void
		{
			try
			{
				mediaFactory.removeMediaInfo(null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
			}
		}
		
		public function testGetNumMediaInfos():void
		{
			assertTrue(mediaFactory.numMediaInfos == 0);
			
			var info1:MediaInfo = createMediaInfo("a1");
			var info2:MediaInfo = createMediaInfo("a2");
			var info3:MediaInfo = createMediaInfo("b3", null, null, MediaInfoType.PROXY);
			var info4:MediaInfo = createMediaInfo("b4", null, null, MediaInfoType.PROXY);
			
			mediaFactory.addMediaInfo(info1);
			assertTrue(mediaFactory.numMediaInfos == 1);
			mediaFactory.addMediaInfo(info2);
			assertTrue(mediaFactory.numMediaInfos == 2);

			mediaFactory.addMediaInfo(info3);
			assertTrue(mediaFactory.numMediaInfos == 3);
			mediaFactory.addMediaInfo(info4);
			assertTrue(mediaFactory.numMediaInfos == 4);

			mediaFactory.removeMediaInfo(info1);
			assertTrue(mediaFactory.numMediaInfos == 3);
			mediaFactory.removeMediaInfo(info2);
			assertTrue(mediaFactory.numMediaInfos == 2);
			
			mediaFactory.removeMediaInfo(info3);
			assertTrue(mediaFactory.numMediaInfos == 1);
			mediaFactory.removeMediaInfo(info4);
			assertTrue(mediaFactory.numMediaInfos == 0);
		}
		
		public function testGetMediaInfoAt():void
		{
			var a1:MediaInfo = createMediaInfo("a1","http://www.example.com/a1");
			var a2:MediaInfo = createMediaInfo("a2","http://www.example.com/a2");
			var a3:MediaInfo = createMediaInfo("a3","http://www.example.com/a3");
			var b1:MediaInfo = createMediaInfo("b1","http://www.example.com/b1", null, MediaInfoType.PROXY);
			var b2:MediaInfo = createMediaInfo("b2","http://www.example.com/b2", null, MediaInfoType.PROXY);
			var b3:MediaInfo = createMediaInfo("b3","http://www.example.com/b3", null, MediaInfoType.PROXY);
			
			mediaFactory.addMediaInfo(a1);
			mediaFactory.addMediaInfo(b1);
			mediaFactory.addMediaInfo(a2);
			mediaFactory.addMediaInfo(b2);
			mediaFactory.addMediaInfo(a3);
			mediaFactory.addMediaInfo(b3);
			
			assertTrue(mediaFactory.getMediaInfoAt(-1) == null);
			assertTrue(mediaFactory.getMediaInfoAt(0) == a1);
			assertTrue(mediaFactory.getMediaInfoAt(1) == a2);
			assertTrue(mediaFactory.getMediaInfoAt(2) == a3);
			assertTrue(mediaFactory.getMediaInfoAt(3) == b1);
			assertTrue(mediaFactory.getMediaInfoAt(4) == b2);
			assertTrue(mediaFactory.getMediaInfoAt(5) == b3);
			assertTrue(mediaFactory.getMediaInfoAt(6) == null);
		}
		
		public function testGetMediaInfoById():void
		{
			mediaFactory.addMediaInfo(createMediaInfo("a1"));
			mediaFactory.addMediaInfo(createMediaInfo("a2"));
			mediaFactory.addMediaInfo(createMediaInfo("a3"));
			mediaFactory.addMediaInfo(createMediaInfo("b1", null, null, MediaInfoType.PROXY));
			mediaFactory.addMediaInfo(createMediaInfo("b2", null, null, MediaInfoType.PROXY));
			mediaFactory.addMediaInfo(createMediaInfo("b3", null, null, MediaInfoType.PROXY));
			
			assertTrue(mediaFactory.getMediaInfoById("a1") != null);
			assertTrue(mediaFactory.getMediaInfoById("a2") != null);
			assertTrue(mediaFactory.getMediaInfoById("a3") != null);
			assertTrue(mediaFactory.getMediaInfoById("a4") == null);
			assertTrue(mediaFactory.getMediaInfoById("b1") != null);
			assertTrue(mediaFactory.getMediaInfoById("b2") != null);
			assertTrue(mediaFactory.getMediaInfoById("b3") != null);
			assertTrue(mediaFactory.getMediaInfoById("b4") == null);
			assertTrue(mediaFactory.getMediaInfoById(null) == null);
		}

		public function testCreateMediaElement():void
		{
			var a1:MediaInfo = createMediaInfo("a1","http://www.example.com/a1");
			mediaFactory.addMediaInfo(a1);
			
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
			var a1:MediaInfo = new MediaInfo
				( "a1"
				, new SampleResourceHandler(null, "http://www.example.com/a1") 
				, invalidReturnType
				);
			mediaFactory.addMediaInfo(a1);
			
			function invalidReturnType():String
			{
				return "hi";
			}

			assertTrue(mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/a1"))) == null);
		}
		
		public function testCreateMediaElementWithInvalidMediaElementCreationFunctionParams():void
		{
			var a1:MediaInfo = new MediaInfo
				( "a1"
					, new SampleResourceHandler(null, "http://www.example.com/a1") 
					, invalidParams
				);
			mediaFactory.addMediaInfo(a1);
			
			function invalidParams(i:int,s:String):MediaElement
			{
				return new MediaElement();
			}
			
			assertTrue(mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/a1"))) == null);
		}
			
		public function testCreateMediaElementWithInvalidMediaElementCreationFunctionNullReturnValue():void
		{
			var a1:MediaInfo = new MediaInfo
				( "a1"
				, new SampleResourceHandler(null, "http://www.example.com/a1") 
				, nullReturnValue
				);
			mediaFactory.addMediaInfo(a1);
			
			function nullReturnValue():MediaElement
			{
				return null;
			}
			
			assertTrue(mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/a1"))) == null);
		}

		public function testCreateMediaElementWithProxy():void
		{
			var standardInfo:MediaInfo = createMediaInfo("standardInfo", "http://www.example.com/standardInfo");
			mediaFactory.addMediaInfo(standardInfo);
						
			// By default, createMediaElement creates standard media elements.
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/standardInfo")));
			assertTrue(!(mediaElement is ProxyElement));
			assertTrue(mediaElement is DynamicMediaElement);

			// If we add a proxy media info whose media element is not a proxy,
			// then createMediaElement should return the standard media element.
			var invalidProxyInfo:MediaInfo = createMediaInfo("invalidProxyInfo", "http://www.example.com/standardInfo", null, MediaInfoType.PROXY);
			mediaFactory.addMediaInfo(invalidProxyInfo);

			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/standardInfo")));
			assertTrue(!(mediaElement is ProxyElement));
			
			// If we add a proxy media info whose media element is a proxy, then
			// createMediaElement should return a proxy that wraps the standard
			// media element.
			var validProxyInfo:MediaInfo = createProxyMediaInfo("validProxyInfo", "http://www.example.com/standardInfo");
			mediaFactory.addMediaInfo(validProxyInfo);

			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/standardInfo")));
			assertTrue(mediaElement is ProxyElement);
			assertTrue((mediaElement as ProxyElement).proxiedElement is DynamicMediaElement);
			
			// Proxies can go many levels deep.
			var deepProxyInfo:MediaInfo = createProxyMediaInfo("deepProxyInfo", "http://www.example.com/standardInfo");
			mediaFactory.addMediaInfo(deepProxyInfo);

			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/standardInfo")));
			assertTrue(mediaElement is ProxyElement);
			assertTrue((mediaElement as ProxyElement).proxiedElement is ProxyElement);
			assertTrue(((mediaElement as ProxyElement).proxiedElement as ProxyElement).proxiedElement is DynamicMediaElement);
		}
		
		public function testCreateMediaElementWithReference():void
		{
			var standardInfo:MediaInfo = createMediaInfo("standardInfo","http://www.example.com/standardInfo");
			mediaFactory.addMediaInfo(standardInfo);
			var otherStandardInfo:MediaInfo = createMediaInfo("otherStandardInfo","http://www.example.com/otherStandardInfo");
			mediaFactory.addMediaInfo(otherStandardInfo);
			
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
			var invalidReferenceInfo:MediaInfo = createMediaInfo("invalidReferenceInfo", "http://www.example.com/invalidReferenceInfo");
			mediaFactory.addMediaInfo(invalidReferenceInfo);
			
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/invalidReferenceInfo")));
			assertTrue(mediaElement != null);
			assertTrue(!(mediaElement is IMediaReferrer));
			
			// Now create a referencing element that should match a previously
			// created one.
			var referenceInfo:MediaInfo = createReferenceMediaInfo("referenceInfo1","http://www.example.com/referenceInfo1", "http://www.example.com/standardInfo");
			mediaFactory.addMediaInfo(referenceInfo);
			
			mediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/referenceInfo1")));
			assertTrue(mediaElement != null);
			assertTrue(mediaElement is IMediaReferrer);
			var dynamicElement:DynamicReferenceMediaElement = mediaElement as DynamicReferenceMediaElement;
			assertTrue(dynamicElement);
			assertTrue(dynamicElement.references.length == 1);
			assertTrue(dynamicElement.references[0] == createdElement1);
			
			// It's possible to have multiple references too.
			referenceInfo = createReferenceMediaInfo("referenceInfo2","http://www.example.com/referenceInfo2", "http://www.example.com/otherStandardInfo");
			mediaFactory.addMediaInfo(referenceInfo);
			
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
			referenceInfo = createReferenceMediaInfo("referenceInfo3","http://www.example.com/referenceInfo3", "http://www.example.com/referenceInfo2");
			mediaFactory.addMediaInfo(referenceInfo);
			
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
			var yetAnotherStandardInfo:MediaInfo = createMediaInfo("yetAnotherStandardInfo","http://www.example.com/yetAnotherStandardInfo");
			mediaFactory.addMediaInfo(yetAnotherStandardInfo);
			
			var createdElement5:MediaElement = mediaFactory.createMediaElement(new URLResource(new URL("http://www.example.com/yetAnotherStandardInfo")));
			assertTrue(createdElement5 is DynamicMediaElement);
			assertTrue(referenceElement.references.length == 3);
		}

		//---------------------------------------------------------------------
		
		private function createMediaInfo(id:String, urlToMatch:String=null, args:Array=null, type:MediaInfoType=null):MediaInfo
		{
			return new MediaInfo
					( id
					, new SampleResourceHandler((urlToMatch ? null : canHandleResource), urlToMatch) 
					, createDynamicMediaElement
					, type != null ? type : MediaInfoType.STANDARD
					);
		}
		
		private function createDynamicMediaElement():MediaElement
		{
			return new DynamicMediaElement();
		}

		private function createProxyMediaInfo(id:String, urlToMatch:String=null, args:Array=null):MediaInfo
		{
			return new MediaInfo
					( id
					, new SampleResourceHandler((urlToMatch ? null : canHandleResource), urlToMatch) 
					, createProxyElement
					, MediaInfoType.PROXY
					);
		}
		
		private function createProxyElement():MediaElement
		{
			return new ProxyElement(null);
		}
		
		private function createReferenceMediaInfo(id:String, urlToMatch:String=null, referenceUrlToMatch:String=null, type:MediaInfoType=null):MediaInfo
		{
			function createDynamicReferenceMediaElement():MediaElement
			{
				return new DynamicReferenceMediaElement(referenceUrlToMatch);
			}

			return new MediaInfo
					( id
					, new SampleResourceHandler((urlToMatch ? null : canHandleResource), urlToMatch) 
					, createDynamicReferenceMediaElement
					, type != null ? type : MediaInfoType.STANDARD
					);
		}

		private function canHandleResource(resource:MediaResourceBase):Boolean
		{
			return false;
		}
		
		private var mediaFactory:MediaFactory;
	}
}