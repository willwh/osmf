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
package org.openvideoplayer.media
{
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.InterfaceTestCase;
	import org.openvideoplayer.utils.SampleResourceHandler;
	
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
			
			assertTrue(mediaFactory.getMediaInfoByResource(new URLResource("http://www.example.com")) == null);
			assertTrue(mediaFactory.getMediaInfoByResource(new URLResource("http://www.example.com/a1")) == a1);
			assertTrue(mediaFactory.getMediaInfoByResource(new URLResource("http://www.example.com/a2")) == a2);
			assertTrue(mediaFactory.getMediaInfoByResource(new URLResource("http://www.example.com/a3")) == a3);
			assertTrue(mediaFactory.getMediaInfoByResource(null) == null);
			
			// Once you remove an IMediaInfo, it can't handle the resource
			// anymore.
			mediaFactory.removeMediaInfo(a2);
			assertTrue(mediaFactory.getMediaInfoByResource(new URLResource("http://www.example.com/a2")) == null);
		}
		
		public function testCreateMediaElement():void
		{
			var a1:IMediaInfo = createMediaInfo("a1","http://www.example.com/a1");
			mediaFactory.addMediaInfo(a1);
			
			assertTrue(mediaFactory.createMediaElement(new URLResource("http://www.example.com")) == null);
			assertTrue(mediaFactory.createMediaElement(new URLResource("http://www.example.com/a2")) == null);
			assertTrue(mediaFactory.createMediaElement(null) == null);
			
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource("http://www.example.com/a1"));
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