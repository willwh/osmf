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
	
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.SampleResourceHandler;
	import org.osmf.utils.URL;
	
	public class TestMediaInfo extends TestCase
	{
		public function testConstructor():void
		{
			var mediaInfo:MediaInfo = new MediaInfo
										( "foo"
										, new SampleResourceHandler(canHandleResource)
										, function ():MediaElement { return null; }
										);
			assertTrue(mediaInfo != null);
			
			// Verify that any null param triggers an exception.
			//
			
			try
			{
				mediaInfo = new MediaInfo
								( null
								, new SampleResourceHandler(canHandleResource)
								, function ():MediaElement { return null; }
								);
				fail();
			}
			catch (error:ArgumentError)
			{
			}

			try
			{
				mediaInfo = new MediaInfo
								( "foo"
								, null
								, function ():MediaElement { return null; }
								);
				fail();
			}
			catch (error:ArgumentError)
			{
			}

			try
			{
				mediaInfo = new MediaInfo
								( "foo"
								, new SampleResourceHandler(canHandleResource)
								, null
								);
				fail();
			}
			catch (error:ArgumentError)
			{
			}
		}
		
		public function testGetId():void
		{
			var mediaInfo:MediaInfo = createMediaInfo("anId");
			assertTrue(mediaInfo.id == "anId");
		}
		
		public function testGetResourceHandler():void
		{
			var mediaInfo:MediaInfo = createMediaInfo("id");
			var handler:IMediaResourceHandler = mediaInfo.resourceHandler;
			assertTrue(handler != null);
			
			assertTrue(handler.canHandleResource(VALID_RESOURCE) == true);
			assertTrue(handler.canHandleResource(INVALID_RESOURCE) == false);
		}
		
		public function testGetMediaElementCreationFunction():void
		{
			var mediaInfo:MediaInfo = createMediaInfo("id");
			var func:Function = mediaInfo.mediaElementCreationFunction;
			assertTrue(func != null);
			
			var element1:MediaElement = func.call();
			assertTrue(element1 != null);
			assertTrue(element1 is DynamicMediaElement);
			var element2:MediaElement = func.call();
			assertTrue(element2 != null);
			assertTrue(element2 is DynamicMediaElement);
			assertTrue(element1 != element2);
		}
		
		public function testGetType():void
		{
			var mediaInfo:MediaInfo = createMediaInfo("id");
			assertTrue(mediaInfo.type == MediaInfoType.STANDARD);
		}
		
		private function createMediaInfo(id:String):MediaInfo
		{
			return new MediaInfo
					( id
					, new SampleResourceHandler(canHandleResource)
					, createDynamicMediaElement
					);
		}
		
		private function canHandleResource(resource:IMediaResource):Boolean
		{
			return resource == VALID_RESOURCE ? true : false;
		}
		
		private function createDynamicMediaElement():MediaElement
		{
			return new DynamicMediaElement();
		}
		
		private static const VALID_RESOURCE:URLResource = new URLResource(new URL("http://www.example.com/valid"));
		private static const INVALID_RESOURCE:URLResource = new URLResource(new URL("http://www.example.com/invalid"));
	}
}