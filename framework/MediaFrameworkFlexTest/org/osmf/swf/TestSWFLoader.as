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
package org.osmf.swf
{
	import flexunit.framework.TestCase;
	
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MediaTypeFacet;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.utils.MediaFrameworkStrings;
	import org.osmf.utils.NullResource;
	import org.osmf.utils.URL;
	
	/**
	 * Note that because SWFLoader must make network calls and cannot be
	 * mocked (due to Flash API restrictions around LoaderInfo), we only
	 * test a subset of the functionality here.  The rest is tested in the
	 * integration test suite, under TestSWFLoaderIntegration.
	 * 
	 * Tests which do not require network access should be added here.
	 * 
	 * Tests which do should be added to TestSWFLoaderIntegration.
	 **/
	public class TestSWFLoader extends TestCase
	{
		public function testCanHandleResource():void
		{
			var loader:SWFLoader = new SWFLoader();
			
			// Verify some valid resources.
			assertTrue(loader.canHandleResource(new URLResource(new URL("file:///movie.swf"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("assets/movie.swf"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/movie.swf"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("http://example.com/movie.swf?param=value"))));
			assertTrue(loader.canHandleResource(new URLResource(new URL("movie.swf"))));
			
			// And some invalid ones.
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/movie.foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/movie"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/movie?param=.swf"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL(""))));
			assertFalse(loader.canHandleResource(new URLResource(null)));
			assertFalse(loader.canHandleResource(new NullResource()));
			assertFalse(loader.canHandleResource(null));

			// Verify some valid resources based on metadata information
			var metadata:MediaTypeFacet = new MediaTypeFacet(MediaType.SWF);
			var resource:URLResource = new URLResource(new URL("http://example.com/movie"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));
			
			metadata = new MediaTypeFacet();
			resource = new URLResource(new URL("http://example.com/movie.swf"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.SWF, "application/x-shockwave-flash");
			resource = new URLResource(new URL("http://example.com/movie"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			// Add some invalid cases based on metadata information
			metadata = new MediaTypeFacet(MediaType.IMAGE);
			resource = new URLResource(new URL("http://example.com/movie"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(null,  "Invalide MIME Type");
			resource = new URLResource(new URL("http://example.com/movie"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet();
			resource = new URLResource(new URL("http://example.com/movie"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.IMAGE, "application/x-shockwave-flash");
			resource = new URLResource(new URL("http://example.com/movie"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.IMAGE, "Invalid MIME Type");
			resource = new URLResource(new URL("http://example.com/movie"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));
		}
		
		public function testLoad():void
		{
			// See TestSWFLoaderIntegration for the actual tests.
		}

		public function testUnload():void
		{
			// See TestSWFLoaderIntegration for the actual tests.
		}
	}
}