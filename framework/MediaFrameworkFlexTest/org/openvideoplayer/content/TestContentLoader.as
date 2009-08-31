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
package org.openvideoplayer.content
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.metadata.KeyValueFacet;
	import org.openvideoplayer.metadata.MediaType;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.NullResource;
	import org.openvideoplayer.utils.URL;
	
	/**
	 * Note that because ContentLoader must make network calls and cannot be
	 * mocked (due to Flash API restrictions around LoaderInfo), we only
	 * test a subset of the functionality here.  The rest is tested in the
	 * integration test suite, under TestContentLoaderIntegration.
	 * 
	 * Tests which do not require network access should be added here.
	 * 
	 * Tests which do should be added to TestContentLoaderIntegration.
	 **/
	public class TestContentLoader extends TestCase
	{
		public function testCanHandleResource():void
		{
			var loader:ContentLoader = new ContentLoader();
			
			// Should return false for everything.
			assertFalse(loader.canHandleResource(new URLResource(new URL("assets/image.gif"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/image.gif"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/image.jpg"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/image.png"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/image.foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("http://example.com/image"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL("foo"))));
			assertFalse(loader.canHandleResource(new URLResource(new URL(""))));
			assertFalse(loader.canHandleResource(new URLResource(null)));
			assertFalse(loader.canHandleResource(new NullResource()));
			assertFalse(loader.canHandleResource(null));
		}
		
		public function testLoad():void
		{
			// See TestContentLoaderIntegration for the actual tests.
		}

		public function testUnload():void
		{
			// See TestContentLoaderIntegration for the actual tests.
		}
	}
}