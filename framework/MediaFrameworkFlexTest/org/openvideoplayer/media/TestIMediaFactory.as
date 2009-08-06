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
package org.openvideoplayer.media
{
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.InterfaceTestCase;
	import org.openvideoplayer.utils.SampleResourceHandler;
	import org.openvideoplayer.utils.URL;
	
	public class TestIMediaFactory extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			this.mediaFactory = createIMediaFactory();
		}
		
		public function testAddMediaInfo():void
		{
			var id:String = "a1";
			
			var mediaInfo:IMediaInfo = createMediaInfo(id);
			
			assertTrue(mediaFactory.getMediaInfoById(id) == null);
			
			mediaFactory.addMediaInfo(mediaInfo);
			assertTrue(mediaFactory.getMediaInfoById(id) == mediaInfo);
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
			
			var mediaInfo:IMediaInfo = createMediaInfo(id);
			
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
		
		public function testGetMediaInfoById():void
		{
			mediaFactory.addMediaInfo(createMediaInfo("a1"));
			mediaFactory.addMediaInfo(createMediaInfo("a2"));
			mediaFactory.addMediaInfo(createMediaInfo("a3"));
			
			assertTrue(mediaFactory.getMediaInfoById("a1") != null);
			assertTrue(mediaFactory.getMediaInfoById("a2") != null);
			assertTrue(mediaFactory.getMediaInfoById("a3") != null);
			assertTrue(mediaFactory.getMediaInfoById("a4") == null);
			assertTrue(mediaFactory.getMediaInfoById(null) == null);
		}

		public function testGetMediaInfoByResource():void
		{
			var a1:IMediaInfo = createMediaInfo("a1","http://www.example.com/a1");
			var a2:IMediaInfo = createMediaInfo("a2","http://www.example.com/a2");
			var a3:IMediaInfo = createMediaInfo("a3","http://www.example.com/a3");
			
			mediaFactory.addMediaInfo(a1);
			mediaFactory.addMediaInfo(a2);
			mediaFactory.addMediaInfo(a3);
			
			assertTrue(mediaFactory.getMediaInfoByResource(new URLResource(new URL("http://www.example.com"))) == null);
			assertTrue(mediaFactory.getMediaInfoByResource(new URLResource(new URL("http://www.example.com/a1"))) == a1);
			assertTrue(mediaFactory.getMediaInfoByResource(new URLResource(new URL("http://www.example.com/a2"))) == a2);
			assertTrue(mediaFactory.getMediaInfoByResource(new URLResource(new URL("http://www.example.com/a3"))) == a3);
			assertTrue(mediaFactory.getMediaInfoByResource(null) == null);
			
			// Once you remove an IMediaInfo, it can't handle the resource
			// anymore.
			mediaFactory.removeMediaInfo(a2);
			assertTrue(mediaFactory.getMediaInfoByResource(new URLResource(new URL("http://www.example.com/a2"))) == null);
		}
		
		public function testCreateMediaElement():void
		{
			var a1:IMediaInfo = createMediaInfo("a1","http://www.example.com/a1");
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

		//---------------------------------------------------------------------
		
		protected function createIMediaFactory():IMediaFactory
		{
			return createInterfaceObject() as IMediaFactory; 
		}

		private function createMediaInfo(id:String,urlToMatch:String=null,args:Array=null):IMediaInfo
		{
			return new MediaInfo
					( id
					, new SampleResourceHandler((urlToMatch ? null : canHandleResource), urlToMatch) 
					, DynamicMediaElement
					, args != null ? args : []
					);
		}
		
		private function canHandleResource(resource:IMediaResource):Boolean
		{
			return false;
		}
		
		private var mediaFactory:IMediaFactory;
	}
}