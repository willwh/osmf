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
package org.osmf.metadata
{
	import flexunit.framework.TestCase;
	
	public class TestMetadataWatcher extends TestCase
	{
		public function testWatchFacet():void
		{
			var callbackArgument:Facet = null;
			var callbackCount:int = 0;
			function facetChangeCallback(facet:Facet):void
			{
				callbackArgument = facet;
				callbackCount++;
			}
			
			var facet1NS:String = new String("http://www.facet1NS.com");
			var facet2NS:String = new String("http://www.facet2NS.com");
			var metaData:Metadata = new Metadata();
			var watcher:MetadataWatcher = new MetadataWatcher(metaData, facet1NS, null, facetChangeCallback);
			watcher.watch();
			
			assertEquals(1,callbackCount);
			assertNull(callbackArgument);
			
			var facet1:Facet = new Facet(facet1NS);
			metaData.addFacet(facet1);
			
			assertEquals(2, callbackCount);
			assertEquals(callbackArgument, facet1);
			
			metaData.removeFacet(facet1);
			
			assertEquals(3, callbackCount);
			assertNull(callbackArgument);
			
			var facet2:Facet = new Facet(facet2NS);
			metaData.addFacet(facet2);
			
			assertEquals(3, callbackCount);
			assertNull(callbackArgument);
			
			metaData.addFacet(facet1);
			
			assertEquals(4, callbackCount);
			assertEquals(callbackArgument, facet1);
			
			facet1.addValue(new FacetKey("myKey"),"someValue");
			
			assertEquals(5, callbackCount);
			assertEquals(callbackArgument, facet1);
		}
		
		public function testWatchFacetValue():void
		{
			var callbackArgument:* = null;
			var callbackCount:int = 0;
			function facetValueChangeCallback(value:*):void
			{
				callbackArgument = value;
				callbackCount++;
			}
			
			var facet1NS:String = new String("http://www.facet1NS.com");
			var facet2NS:String = new String("http://www.facet2NS.com");
			var metaData:Metadata = new Metadata();
			var watcher:MetadataWatcher
				= new MetadataWatcher
					( metaData
					, facet1NS
					, new FacetKey("myKey")
					, facetValueChangeCallback
					);
			watcher.watch();
			
			assertEquals(1,callbackCount);
			assertNull(callbackArgument);
			
			var facet1:Facet = new Facet(facet1NS);
			metaData.addFacet(facet1);
			
			assertEquals(2, callbackCount);
			
			metaData.removeFacet(facet1);
			
			assertEquals(3, callbackCount);
			
			var facet2:Facet = new Facet(facet2NS);
			metaData.addFacet(facet2);
			
			assertEquals(3, callbackCount);
			
			metaData.addFacet(facet1);
			
			assertEquals(4, callbackCount);
			
			facet1.addValue(new FacetKey("myKey"),"someValue");
			
			assertEquals(5, callbackCount);
			assertEquals(callbackArgument, "someValue");
			
			facet1.addValue(new FacetKey("myKey"),23);
			
			assertEquals(6, callbackCount);
			assertEquals(callbackArgument,23);
			
			facet1.removeValue(new FacetKey("myKey"));
			
			assertEquals(7, callbackCount);
			assertNull(callbackArgument);
		}
	}
}