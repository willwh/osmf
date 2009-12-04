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
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.utils.URL;

	public class TestFacetGroup extends TestCase
	{
		public function testFacetGroup():void
		{
			var url:URL = new URL("url");
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
			var facet:ObjectFacet = new ObjectFacet(url,"hello");
			
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
			
			assertDispatches
				( fg, [Event.CHANGE]
				, function():void{facet.object = "hello world"}
				);
			
			assertEquals
				( facet
				, assertDispatches(fg, [Event.CHANGE], fg.removeFacet, metadata1, facet)
				);
				
			assertEquals(1, fg.length);
			assertEquals(facet, fg.getFacetAt(0));
			assertEquals(metadata2, fg.getMetadataAt(0));
			assertEquals(0, fg.indexOf(metadata2, facet));	
		}
		
		// Utils
		//
	
		private function assertThrows(f:Function, ...arguments):*
		{
			var result:*;
			
			try
			{
				result = f.apply(null,arguments);
				fail();
			}
			catch(e:Error)
			{	
			}
			
			return result;
		}
		
		private function assertDispatches(dispatcher:EventDispatcher, types:Array, f:Function, ...arguments):*
		{
			var result:*;
			var dispatched:Dictionary = new Dictionary();
			function handler(event:Event):void
			{
				dispatched[event.type] = true;
			}
			
			var type:String;
			for each (type in types)
			{
				dispatcher.addEventListener(type, handler);
			}
			
			result = f.apply(null, arguments);
			
			for each (type in types)
			{
				dispatcher.removeEventListener(type, handler);
			}
			
			for each (type in types)
			{
				if (dispatched[type] != true)
				{
					fail("Event of type " + type + " was not fired.");
				}
			}
			
			return result;
		}
	}
}