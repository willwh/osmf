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
	import org.openvideoplayer.metadata.KeyValueFacet;
	import org.openvideoplayer.utils.InterfaceTestCase;
	import org.openvideoplayer.utils.URL;
	
	public class TestIURLResource extends InterfaceTestCase
	{
		public function testGetURL():void
		{
			// Simple URL
			var resource:IURLResource = createIURLResource(new URL("http://www.example.com"));
			assertTrue(resource != null);
			assertTrue(resource.url.toString() == "http://www.example.com");
			assertTrue(resource.url.protocol == "http");
			assertTrue(resource.url.host == "www.example.com");
			
			// Empty URL
			resource = createIURLResource(new URL(""));
			assertTrue(resource != null);
			assertTrue(resource.url.toString() == "");

			// null URL
			resource = createIURLResource(null);
			assertTrue(resource != null);
			assertTrue(resource.url.toString() == null);			
		}
		
		public function testMetadata():void
		{
			// Simple URL
			var resource:IURLResource = createIURLResource(new URL("http://www.example.com"));
			
			//Test metadata list is valid, and empty.
			assertNotNull(resource.metadata);
			
		}
				
		protected function createIURLResource(url:URL):IURLResource
		{
			return createInterfaceObject(url) as IURLResource; 
		}
	}
}