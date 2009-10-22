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
package org.osmf.audio
{
	import org.osmf.events.MediaError;
	import org.osmf.loaders.TestILoader;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MediaTypeFacet;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.utils.MediaFrameworkStrings;
	import org.osmf.utils.NullResource;
	import org.osmf.utils.TestConstants;
	import org.osmf.utils.URL;
	
	public class TestSoundLoader extends TestILoader
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new SoundLoader();
		}

		override protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			return new LoadableTrait(loader, resource);
		}
		
		override protected function get successfulResource():IMediaResource
		{
			return new URLResource(new URL(TestConstants.LOCAL_SOUND_FILE));
		}

		override protected function get failedResource():IMediaResource
		{
			return new URLResource(new URL(TestConstants.LOCAL_INVALID_SOUND_FILE));
		}

		override protected function get unhandledResource():IMediaResource
		{
			return new URLResource(new URL("http://example.com"));
		}
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
		}
		
		override public function testCanHandleResource():void
		{
			super.testCanHandleResource();
			
			// Verify some valid resources.
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///audio.mp3"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("assets/audio.mp3"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/audio.mp3"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/audio.mp3?param=value"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("audio.mp3"))));
			
			// And some invalid ones.
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/audio.foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/audio"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/audio.mp31"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/audio?param=.mp3"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL(""))));
			assertFalse(loader.canHandleResource(new URLResource(null)));
			assertFalse(loader.canHandleResource(new NullResource()));
			assertFalse(loader.canHandleResource(null));
					
			// Verify some valid resources based on metadata information
			var metadata:MediaTypeFacet = new MediaTypeFacet(MediaType.AUDIO);
			var resource:URLResource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));
			
			metadata = new MediaTypeFacet(null, "audio/mpeg");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.AUDIO, "audio/mpeg");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			// Add some invalid cases based on metadata information
			//
			
			
			metadata = new MediaTypeFacet(MediaType.VIDEO);
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null, "video/x-flv");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));
			
			metadata = new MediaTypeFacet(MediaType.VIDEO, "video/x-flv");
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.SWF);	
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null, "Invalid Mime Type");	
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.IMAGE, "Invalid Mime Type");	
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.VIDEO, "Invalid Mime Type");	
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.AUDIO, "Invalid Mime Type");	
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.IMAGE,  "video/x-flv");	
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.IMAGE, "audio/mpeg");	
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.VIDEO, "audio/mpeg");	
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.AUDIO, "video/x-flv");	
			resource = new URLResource(new URL("http://example.com/test"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));
		}
	}
}