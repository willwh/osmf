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
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.MetadataEvent;
	import org.osmf.utils.OSMFStrings;

	public class TestMetadata extends TestCase
	{
		
		override public function setUp():void
		{
			super.setUp();			
			collection = new Metadata();				
		}
		
		public function testAddMetadata():void
		{				
			var addCalled:Boolean = false;	
			var testNs:String = "dfs3424f#@$@D";
			collection.addEventListener(MetadataEvent.FACET_ADD, onAdd);
			var value:Facet = new Facet(testNs);
			
			collection.addFacet(value);
			assertTrue(addCalled);
					
			var facet:Facet = 	collection.getFacet(testNs);
									
			assertEquals(value, facet, collection.getFacet("dfs3424f#@$@D"));		
			
			// Test the Catching of Errors
			try
			{
				collection.addFacet(null);
				
				fail();
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			function onAdd(event:MetadataEvent):void
			{
				addCalled = true;
				assertEquals(event.facet, value);				
			}				
		}
		
		public function testRemoveMetadata():void
		{		
			var removeCalled:Boolean = false;	
			var testNs:String = "dfs3424f#@$@D";
			var value:Facet = new Facet(testNs);
			collection.addEventListener(MetadataEvent.FACET_REMOVE, onRemove);
			collection.addFacet(value);
			assertEquals(value, collection.removeFacet(value));
			
			assertTrue(removeCalled);
					
			value = new Facet("dfs3424f#@$@D");
			
			removeCalled = false;			
			assertNull( collection.removeFacet(new Facet("unknown")));					
			assertFalse(removeCalled); // Make sure we didn't dispatch an event for an already removed item.
								
			var facet:Facet = 	collection.getFacet(testNs);
									
			assertEquals(value, facet, collection.getFacet("dfs3424f#@$@D"));		
			
			// Test the Catching of Errors
			try
			{
				collection.removeFacet(null);
				
				fail();
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			function onRemove(event:MetadataEvent):void
			{
				removeCalled = true;
				assertEquals(event.facet, value);				
			}				
		}
		
		public function testChangeMetadata():void
		{	
			var addCalled:Boolean = false;	
			var removeCalled:Boolean = false;	
			var testNs:String = "dfs3424f#@$@D";
		
			collection.addEventListener(MetadataEvent.FACET_ADD, onAdd);
			collection.addEventListener(MetadataEvent.FACET_REMOVE, onRemove);
			var value:Facet = new Facet(testNs);
			var value1:Facet = new Facet(testNs);
			var adds:Array = [value1,value];
			
			collection.addFacet(value);				
			assertTrue(addCalled);			
			addCalled = false;
			collection.addFacet(value1);
			assertTrue(removeCalled);	
			assertTrue(addCalled);				
								
			var facet:Facet = 	collection.getFacet(testNs);
									
			assertEquals(value1, facet, collection.getFacet("dfs3424f#@$@D"));		
			
			function onAdd(event:MetadataEvent):void
			{
				addCalled = true;
				assertEquals(event.facet, adds.pop());					
			}	
			
			function onRemove(event:MetadataEvent):void
			{
				removeCalled = true;
				assertEquals(event.facet, value);				
			}
			collection.removeEventListener(MetadataEvent.FACET_ADD, onAdd);
			collection.removeEventListener(MetadataEvent.FACET_REMOVE, onRemove);	
		}	
			
		public function testGetFacet():void
		{
			var adobe:String =  "http://www.adobe.com/";
			var example:String = "http://www.example.com/";
			var value:Facet = new Facet(adobe);
			var value2:Facet = new Facet(example);
			
			collection.addFacet(value);
			collection.addFacet(value2);
			
			var nameSpaces:Vector.<String> = collection.namespaceURLs;
						
			assertEquals(2, nameSpaces.length);
			
			assertTrue(adobe == nameSpaces[1] || example == nameSpaces[1] );
			assertTrue(example == nameSpaces[0] || adobe == nameSpaces[0]  );
			
			var facet:Facet = collection.getFacet(adobe);
			assertEquals(value, facet);
			
			facet = collection.getFacet(adobe);
			assertEquals(value, facet);
			
			facet = collection.getFacet("testNamespace");
			assertNull(facet);
			
			facet = collection.getFacet(example);
			assertEquals(value2, facet);
					
					
		}
		
		public function testGetNamespaces():void
		{
			var adobe:String =  "http://www.adobe.com/";
			var example:String = "http://www.example.com/";
			var value:Facet = new Facet(adobe);
			var value2:Facet = new Facet(example);
			var value3:CustomFacet = new CustomFacet(example);
			
			assertEquals(example, value3.namespaceURL)
						
			collection.addFacet(value);
			collection.addFacet(value2);
			collection.addFacet(value3);  //overwrites the second facet
			
			var nameSpaces:Vector.<String> = collection.namespaceURLs;
			
			assertEquals(2, nameSpaces.length); 
			// Can't predict the order of the facet types, so we need to check for both.
			assertTrue(value3 == collection.getFacet(nameSpaces[0]) || value3 == collection.getFacet(nameSpaces[1]));
			assertTrue(value == collection.getFacet(nameSpaces[0]) || value == collection.getFacet(nameSpaces[1]));
			assertTrue(collection.getFacet(nameSpaces[0]) != collection.getFacet(nameSpaces[1]));
						
			var facet:Facet = collection.getFacet(adobe);
			assertEquals(value, facet);
		
					
			collection.removeFacet(value2);
			
		}
		
		public function testNumFacets():void
		{
			var adobe:String =  "http://www.adobe.com/";
			var example:String = "http://www.example.com/";
			var value:Facet = new Facet(adobe);
			var value2:Facet = new Facet(example);
			var value3:CustomFacet = new CustomFacet(example);
			
			assertEquals(example, value3.namespaceURL)
						
			collection.addFacet(value);
			collection.addFacet(value2);
			collection.addFacet(value3);  //overwrites the second facet
						
		}
					
		// Utils
		//
		
		protected var collection:Metadata;	
	}
}


import org.osmf.metadata.Facet;

internal class CustomFacet extends Facet
{
		
	public function CustomFacet(ns:String)
	{
		super(ns);
	}

		
}