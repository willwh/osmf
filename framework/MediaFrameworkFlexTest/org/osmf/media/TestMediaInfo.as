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
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.SampleResourceHandler;
	import org.osmf.utils.URL;
	
	public class TestMediaInfo extends TestCase
	{
		public function testConstructor():void
		{
			var mediaInfo:IMediaInfo = new MediaInfo
										( "foo"
										, new SampleResourceHandler(canHandleResource)
										, DynamicMediaElement
										, []
										);
			assertTrue(mediaInfo != null);
			
			// Verify that any null param triggers an exception.
			//
			
			try
			{
				mediaInfo = new MediaInfo
								( null
								, new SampleResourceHandler(canHandleResource)
								, DynamicMediaElement
								, []
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
								, DynamicMediaElement
								, []
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
								, []
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
								, DynamicMediaElement
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
			var mediaInfo:IMediaInfo = createMediaInfo("anId");
			assertTrue(mediaInfo.id == "anId");
		}
		
		public function testCanHandleResource():void
		{
			var mediaInfo:IMediaInfo = createMediaInfo("id");
			
			assertTrue(mediaInfo.canHandleResource(VALID_RESOURCE) == true);
			assertTrue(mediaInfo.canHandleResource(INVALID_RESOURCE) == false);
		}
		
		public function testCreateMediaElement():void
		{
			var mediaInfo:IMediaInfo = createMediaInfo("id");
			
			// Try the simple case.
			//
			
			var mediaElement:MediaElement = mediaInfo.createMediaElement();
			assertTrue(mediaElement != null);
			var args:Array = DynamicMediaElement(mediaElement).args;
			assertTrue(args.length == 0);
			
			// Try a case with initialization arguments.
			//
			
			mediaInfo = createMediaInfo("id",[String,"foo",Array]);
			
			mediaElement = mediaInfo.createMediaElement();
			assertTrue(mediaElement != null);
			args = DynamicMediaElement(mediaElement).args;
			assertTrue(args.length == 3);
			assertTrue(args[0] is String && args[0] == "");
			assertTrue(args[1] is String && args[1] == "foo");
			assertTrue(args[2] is Array);

			// Try a couple of error cases.
			//
			
			mediaInfo = new MediaInfo("id",
								new SampleResourceHandler(canHandleResource),
								IMediaInfo, // can't create an interface
								[]);
			assertTrue(mediaInfo != null);
			
			try
			{
				mediaElement = mediaInfo.createMediaElement();
				
				fail();
			}
			catch (e1:IllegalOperationError)
			{
			}

			mediaInfo = new MediaInfo("id",
								new SampleResourceHandler(canHandleResource),
								MediaInfo, // no default constructor
								[]);
			assertTrue(mediaInfo != null);
			
			try
			{
				mediaElement = mediaInfo.createMediaElement();
				
				fail();
			}
			catch (e2:IllegalOperationError)
			{
			}

			mediaInfo = new MediaInfo("id",
								new SampleResourceHandler(canHandleResource),
								DynamicMediaElement,
								[MediaInfo]); // no default constructor for an arg.
			assertTrue(mediaInfo != null);
			
			try
			{
				mediaElement = mediaInfo.createMediaElement();
				
				fail();
			}
			catch (e3:IllegalOperationError)
			{
			}
		}
		
		private function createMediaInfo(id:String,args:Array=null):IMediaInfo
		{
			return new MediaInfo
					( id
					, new SampleResourceHandler(canHandleResource)
					, DynamicMediaElement
					, args != null ? args : []
					);
		}
		
		private function canHandleResource(resource:IMediaResource):Boolean
		{
			return resource == VALID_RESOURCE ? true : false;
		}
		
		private static const VALID_RESOURCE:URLResource = new URLResource(new URL("http://www.example.com/valid"));
		private static const INVALID_RESOURCE:URLResource = new URLResource(new URL("http://www.example.com/invalid"));
	}
}