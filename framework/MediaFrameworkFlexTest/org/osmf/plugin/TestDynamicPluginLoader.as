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
package org.osmf.plugin
{
	import flexunit.framework.TestCase;
	
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MediaTypeFacet;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.URL;
	
	/**
	 * Note that because DynamicPluginLoader must make network calls and cannot
	 * be mocked (due to Flash API restrictions around LoaderInfo), we only
	 * test a subset of the functionality here.  The rest is tested in the
	 * integration test suite, under TestDynamicPluginLoaderIntegration.
	 * 
	 * Tests which do not require network access should be added here.
	 * 
	 * Tests which do should be added to TestDynamicPluginLoaderIntegration.
	 **/
	public class TestDynamicPluginLoader extends TestCase
	{
		public function testCanHandleResource():void
		{
			var loader:DynamicPluginLoader = new DynamicPluginLoader(new MediaFactory());

			// Verify some valid resources based on metadata information
			var metadata:MediaTypeFacet = new MediaTypeFacet(MediaType.SWF);
			var resource:URLResource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));
			
			metadata = new MediaTypeFacet(null, "application/x-shockwave-flash");			
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet( MediaType.SWF, "application/x-shockwave-flash");			
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			// Add some invalid cases based on metadata information
			metadata = new MediaTypeFacet(MediaType.IMAGE);
			
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));
			
			metadata = new MediaTypeFacet(null, "Invalid Mime Type");
					
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet( MediaType.SWF, "Invalid Mime Type");
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.IMAGE, "application/x-shockwave-flash");
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new MediaTypeFacet(MediaType.IMAGE, "Invalid Mime Type");
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));
		}
		
		public function testLoad():void
		{
			// See TestDynamicPluginLoaderIntegration for the actual tests.
		}

		public function testUnload():void
		{
			// See TestDynamicPluginLoaderIntegration for the actual tests.
		}
	}
}