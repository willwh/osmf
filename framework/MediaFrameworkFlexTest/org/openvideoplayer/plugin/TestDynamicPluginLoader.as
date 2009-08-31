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
package org.openvideoplayer.plugin
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.metadata.KeyValueFacet;
	import org.openvideoplayer.metadata.MediaType;
	import org.openvideoplayer.metadata.ObjectIdentifier;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.URL;
	
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
			var metadata:KeyValueFacet = new KeyValueFacet();
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE), MediaType.SWF);
			var resource:URLResource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));
			
			metadata = new KeyValueFacet();
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MIME_TYPE), "application/x-shockwave-flash");
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			metadata = new KeyValueFacet();
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MIME_TYPE), "application/x-shockwave-flash");			
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE), MediaType.SWF);
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertTrue(loader.canHandleResource(resource));

			// Add some invalid cases based on metadata information
			metadata = new KeyValueFacet();
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE), MediaType.IMAGE);			
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));
			
			metadata = new KeyValueFacet();
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MIME_TYPE), "Invalid Mime Type");			
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new KeyValueFacet();
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MIME_TYPE), "Invalid Mime Type");			
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE), MediaType.SWF);
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new KeyValueFacet();
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MIME_TYPE), "application/x-shockwave-flash");			
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE), MediaType.IMAGE);
			resource = new URLResource(new URL("http://example.com/image"));
			resource.metadata.addFacet(metadata);
			assertFalse(loader.canHandleResource(resource));

			metadata = new KeyValueFacet();
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MIME_TYPE), "Invalid Mime Type");			
			metadata.addValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE), MediaType.IMAGE);
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