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
	
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.FacetValueChangeEvent;
	import org.osmf.events.FacetValueEvent;

	public class TestKeyValueFacet extends TestCase
	{
		private static const testData:String = "sdlkjlkj432423423$@#$@#$#@$234";
		private static const testKey:ObjectIdentifier = new ObjectIdentifier("342dsds4rknfn34$%^%^tef44");
		private static const testData2:String = "98798797879";
		private static const testKey2:ObjectIdentifier = new ObjectIdentifier("QWEWRE");
			
			
		public function testConstructor():void
		{				
			var keyValueMeta:KeyValueFacet = new KeyValueFacet("");
									
			assertEquals(undefined, keyValueMeta.getValue(testKey));
			
			//Ensure it works will a null URL, KeyValueMetadata's ctor should make a dictionary if param is null or not present.
			keyValueMeta = new KeyValueFacet("");
			
			keyValueMeta.addValue(testKey,testData);
			var gottenValue:* = keyValueMeta.getValue(testKey);
			assertEquals(testData, gottenValue);
		}
		
		public function testNamespace():void
		{
			var ns:String = "http://www.example.com"; 
			var keyValueMeta:KeyValueFacet = new KeyValueFacet(ns);
			assertEquals(ns, keyValueMeta.namespaceURL);			
		}
		
		public function testDataFunc():void
		{
			var keyValueMeta:KeyValueFacet = new KeyValueFacet();			
			
			keyValueMeta.addValue(testKey, testData);
			assertEquals(testData, keyValueMeta.getValue(testKey));				
			assertNull(keyValueMeta.getValue(testKey2));		
			
			keyValueMeta.addValue(testKey2, testData2);			
			assertEquals(testData2, keyValueMeta.getValue(testKey2));
			assertEquals(testData, keyValueMeta.getValue(testKey));		
			
			assertTrue(arrayHasValues(Vector.<IIdentifier>(keyValueMeta.keys), [testKey.key, testKey2.key]));
					
			assertEquals(testData, keyValueMeta.removeValue(testKey));	
					
			assertTrue(arrayHasValues(Vector.<IIdentifier>(keyValueMeta.keys), [testKey2.key]));	
			
			assertEquals(testData2, keyValueMeta.removeValue(testKey2));	
			
			assertTrue(arrayHasValues(Vector.<IIdentifier>(keyValueMeta.keys),[]));							
		}
		
		private function arrayHasValues(values:Vector.<IIdentifier>, testValues:Array):Boolean
		{	
			for each( var value:ObjectIdentifier in values)
			{
				var testIndex:int = testValues.indexOf(value.key);
			
				if(testValues.indexOf(value.key) >= 0)
				{
					testValues.splice(testIndex,1);
				}
				else
				{
					return false;
				}				
			}
			return testValues.length <= 0;
		}
		
		private var addsCaught:Number = 0;
		private var removesCaught:Number = 0;
		private var changesCaught:Number = 0;
		
		private function eventCatcher(event:Event):void
		{
			switch(event.type)
			{
				case FacetValueEvent.VALUE_ADD:
					addsCaught++;
					break;
				case FacetValueEvent.VALUE_REMOVE:
					removesCaught++;
					break;
				case FacetValueChangeEvent.VALUE_CHANGE:
					changesCaught++;
					break;
			}			
		}
		
		private function testEvents():void
		{			
			var kv:KeyValueFacet = new KeyValueFacet("http:/tes.com/");
			kv.addEventListener(FacetValueEvent.VALUE_ADD, onAdd);
			kv.addEventListener(FacetValueChangeEvent.VALUE_CHANGE, onChange);
			kv.addEventListener(FacetValueEvent.VALUE_REMOVE, onRemove);
			kv.addEventListener(FacetValueEvent.VALUE_ADD, eventCatcher);
			kv.addEventListener(FacetValueChangeEvent.VALUE_CHANGE, eventCatcher);
			kv.addEventListener(FacetValueEvent.VALUE_REMOVE, eventCatcher);
			
			kv.addValue(new ObjectIdentifier("key1"), "value1");
			kv.addValue(new ObjectIdentifier("key1"), "valueChange");
			kv.removeValue(new ObjectIdentifier("key1"));		
			assertEquals(undefined, kv.removeValue(new ObjectIdentifier("key1")));						
						
			function onAdd(event:FacetValueEvent):void
			{
				assertEquals(event.value, "value1");
				assertTrue(event.identifier.equals(new ObjectIdentifier("key1")));
			}
			
			function onRemove(event:FacetValueEvent):void
			{
				assertEquals(event.value, "valueChange");
				assertTrue(event.identifier.equals(new ObjectIdentifier("key1")));
			}
			
			function onChange(event:FacetValueChangeEvent):void
			{
				assertEquals(event.value, "valueChange");
				assertEquals(event.oldValue, "value1");
				assertTrue(event.identifier.equals(new ObjectIdentifier("key1")));
			}
			
			assertEquals(1, addsCaught);
			assertEquals(1, removesCaught);
			assertEquals(1, changesCaught);							
		}
		


		
	}
}