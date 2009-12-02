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
	import org.osmf.utils.URL;

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
			var testNs:URL = new URL("dfs3424f#@$@D");
			collection.addEventListener(MetadataEvent.FACET_ADD, onAdd);
			var value:KeyValueFacet = new KeyValueFacet(testNs);
			
			collection.addFacet(value);
			assertTrue(addCalled);
					
			var facet:IFacet = 	collection.getFacet(testNs);
									
			assertEquals(value, facet, collection.getFacet(new URL("dfs3424f#@$@D")));		
			
			//Test the Catching of Errors
			var nullThrown:Boolean = false;
			var nsThrown:Boolean = false;
			try
			{
				collection.addFacet(null);
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, OSMFStrings.getString(OSMFStrings.NULL_PARAM));
				nullThrown = true;
			}
			
			try
			{				
				collection.addFacet(new CustomFacet(null));
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, OSMFStrings.getString(OSMFStrings.NAMESPACE_MUST_NOT_BE_EMPTY));
				nsThrown = true;
			}			
			assertTrue(nullThrown);
			assertTrue(nsThrown);
			
			
			function onAdd(event:MetadataEvent):void
			{
				addCalled = true;
				assertEquals(event.facet, value);				
			}				
		}
		
		public function testRemoveMetadata():void
		{		
			var removeCalled:Boolean = false;	
			var testNs:URL = new URL("dfs3424f#@$@D");
			var value:KeyValueFacet = new KeyValueFacet(testNs);
			collection.addEventListener(MetadataEvent.FACET_REMOVE, onRemove);
			collection.addFacet(value);
			assertEquals(value, collection.removeFacet(value));
			
			assertTrue(removeCalled);
					
			value = new KeyValueFacet(new URL("dfs3424f#@$@D"));
			
			removeCalled = false;			
			assertNull( collection.removeFacet(new KeyValueFacet(new URL("unknown"))));					
			assertFalse(removeCalled); //Make sure we didn't dispatch an event for an already removed item.
								
			var facet:IFacet = 	collection.getFacet(testNs);
									
			assertEquals(value, facet, collection.getFacet(new URL("dfs3424f#@$@D")));		
			
			//Test the Catching of Errors
			var nullThrown:Boolean = false;
			var nsThrown:Boolean = false;
			try
			{
				collection.removeFacet(null);
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, OSMFStrings.getString(OSMFStrings.NULL_PARAM));
				nullThrown = true;
			}
			
			try
			{				
				collection.removeFacet(new CustomFacet(null));
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, OSMFStrings.getString(OSMFStrings.NAMESPACE_MUST_NOT_BE_EMPTY));
				nsThrown = true;
			}	
			
			assertTrue(nullThrown);
			assertTrue(nsThrown);
			
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
			var testNs:URL = new URL("dfs3424f#@$@D");
		
			collection.addEventListener(MetadataEvent.FACET_ADD, onAdd);
			collection.addEventListener(MetadataEvent.FACET_REMOVE, onRemove);
			var value:KeyValueFacet = new KeyValueFacet(testNs);
			var value1:KeyValueFacet = new KeyValueFacet(testNs);
			var adds:Array = [value1,value];
			
			collection.addFacet(value);				
			assertTrue(addCalled);			
			addCalled = false;
			collection.addFacet(value1);
			assertTrue(removeCalled);	
			assertTrue(addCalled);				
								
			var facet:IFacet = 	collection.getFacet(testNs);
									
			assertEquals(value1, facet, collection.getFacet(new URL("dfs3424f#@$@D")));		
			
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
			
		public function testgetFacet():void
		{
			var adobe:String =  "http://www.adobe.com/";
			var example:String = "http://www.example.com/";
			var value:KeyValueFacet = new KeyValueFacet(new URL(adobe));
			var value2:KeyValueFacet = new KeyValueFacet(new URL(example));
			
			collection.addFacet(value);
			collection.addFacet(value2);
			
			var nameSpaces:Vector.<String> = collection.namespaceURLs;
						
			assertEquals(2, nameSpaces.length);
			
			assertTrue(adobe == nameSpaces[1] || example == nameSpaces[1] );
			assertTrue(example == nameSpaces[0] || adobe == nameSpaces[0]  );
			
			var facet:IFacet = collection.getFacet(new URL(adobe));
			assertEquals(value, facet);
			
			facet = collection.getFacet(new URL(adobe));
			assertEquals(value, facet);
			
			facet = collection.getFacet(new URL("testNamespace"));
			assertNull(facet);
			
			facet = collection.getFacet(new URL(example));
			assertEquals(value2, facet);
					
					
		}
		
		public function testGetNamespaces():void
		{
			var adobe:String =  "http://www.adobe.com/";
			var example:String = "http://www.example.com/";
			var value:KeyValueFacet = new KeyValueFacet(new URL(adobe));
			var value2:KeyValueFacet = new KeyValueFacet(new URL(example));
			var value3:CustomFacet = new CustomFacet(new URL(example));
			
			assertEquals(example, value3.namespaceURL.rawUrl)
						
			collection.addFacet(value);
			collection.addFacet(value2);
			collection.addFacet(value3);  //overwrites the second facet
			
			var nameSpaces:Vector.<String> = collection.namespaceURLs;
			
			assertEquals(2, nameSpaces.length); 
			//Can't predict the order of the facet types, so we need to check for both.
			assertTrue(value3 == collection.getFacet(new URL(nameSpaces[0])) || value3 == collection.getFacet(new URL(nameSpaces[1])));
			assertTrue(value == collection.getFacet(new URL(nameSpaces[0])) || value == collection.getFacet(new URL(nameSpaces[1])));
			assertTrue(collection.getFacet(new URL(nameSpaces[0])) != collection.getFacet(new URL(nameSpaces[1])));
						
			var facet:IFacet = collection.getFacet(new URL(adobe));
			assertEquals(value, facet);
		
					
			collection.removeFacet(value2);
			
		}
		
		public function testNumFacets():void
		{
			var adobe:String =  "http://www.adobe.com/";
			var example:String = "http://www.example.com/";
			var value:KeyValueFacet = new KeyValueFacet(new URL(adobe));
			var value2:KeyValueFacet = new KeyValueFacet(new URL(example));
			var value3:CustomFacet = new CustomFacet(new URL(example));
			
			assertEquals(example, value3.namespaceURL.rawUrl)
						
			collection.addFacet(value);
			collection.addFacet(value2);
			collection.addFacet(value3);  //overwrites the second facet
						
		}
					
		// Utils
		//
		
		protected var collection:Metadata;
				
	}
}


import org.osmf.metadata.IFacet;
import org.osmf.metadata.Metadata
import org.osmf.utils.URL;
import flash.events.EventDispatcher;
import org.osmf.metadata.IIdentifier;
import org.osmf.metadata.FacetSynthesizer;

internal class CustomFacet extends EventDispatcher implements IFacet
{
		
	public function CustomFacet(ns:URL)
	{
		_ns = ns;
	}

	
	public function get namespaceURL():URL
	{
		return _ns;
	}
	
	public function getValue(identifier:IIdentifier):*
	{
		return undefined;
	}
	
	public function get synthesizer():FacetSynthesizer
	{
		return null;
	}
	
	private var _ns:URL;
}