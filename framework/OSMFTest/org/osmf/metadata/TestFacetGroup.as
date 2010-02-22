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
	import flash.events.Event;
	
	import org.osmf.flexunit.TestCaseEx;

	public class TestFacetGroup extends TestCaseEx
	{
		public function testFacetGroup():void
		{
			var url:String = "url";
			var fg:FacetGroup = new FacetGroup(url);
			
			assertNotNull(fg);
			assertEquals(0, fg.length);
			assertEquals(url, fg.namespaceURL);
			assertThrows(fg.getFacetAt, 0);
			assertThrows(fg.getMetadataAt, 0);
			assertEquals(-1, fg.indexOf(null, null));	
			assertEquals(null, fg.removeFacet(null, null));
			
			var metadata1:Metadata = new Metadata();
			var metadata2:Metadata = new Metadata();
			var facet:Facet = new Facet(url);
			facet.addValue(new FacetKey(url),"hello");
			
			metadata1.addFacet(facet);
			metadata2.addFacet(facet);
			
			assertDispatches(fg, [Event.CHANGE], fg.addFacet, metadata1, facet);
			assertEquals(1, fg.length);
			assertEquals(facet, fg.getFacetAt(0));
			assertEquals(metadata1, fg.getMetadataAt(0));
			assertEquals(0, fg.indexOf(metadata1, facet));	
			
			assertDispatches(fg, [Event.CHANGE], fg.addFacet, metadata2, facet);
			assertEquals(2, fg.length);
			assertEquals(facet, fg.getFacetAt(1));
			assertEquals(metadata2, fg.getMetadataAt(1));
			assertEquals(1, fg.indexOf(metadata2, facet));
			
			assertEquals
				( facet
				, assertDispatches(fg, [Event.CHANGE], fg.removeFacet, metadata1, facet)
				);
				
			assertEquals(1, fg.length);
			assertEquals(facet, fg.getFacetAt(0));
			assertEquals(metadata2, fg.getMetadataAt(0));
			assertEquals(0, fg.indexOf(metadata2, facet));	
		}
	}
}