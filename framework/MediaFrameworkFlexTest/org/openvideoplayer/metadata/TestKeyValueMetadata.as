package org.openvideoplayer.metadata
{
	import __AS3__.vec.Vector;
	
	import flash.utils.Dictionary;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.utils.URL;

	public class TestKeyValueMetadata extends TestCase
	{
		private static const testData:String = "sdlkjlkj432423423$@#$@#$#@$234";
		private static const testKey:String = "342dsds4rknfn34$%^%^tef44";
		private static const testData2:String = "98798797879";
		private static const testKey2:String = "QWEWRE";
			
			
		public function testConstructor():void
		{			
			var seed:Dictionary = new Dictionary();
			seed[testKey] = testData;
			var keyValueMeta:KeyValueFacet = new KeyValueFacet(new URL(""), seed);
			
			assertEquals(testData, keyValueMeta.getValue(testKey));
			
			//Ensure it works will a null URL, KeyValueMetadata's ctor should make a dictionary if param is null or not present.
			keyValueMeta = new KeyValueFacet(new URL(""));
			
			keyValueMeta.addValue(testKey,testData);
			assertEquals(testData, keyValueMeta.getValue(testKey));
		}
		
		public function testNamespace():void
		{
			var ns:URL = new URL("http://www.example.com") 
			var keyValueMeta:KeyValueFacet = new KeyValueFacet(ns);
			assertEquals(ns, keyValueMeta.nameSpace);			
		}
		
		public function testData():void
		{
			var keyValueMeta:KeyValueFacet = new KeyValueFacet();			
			
			keyValueMeta.addValue(testKey, testData);
			assertEquals(testData, keyValueMeta.getValue(testKey));				
			assertNull(keyValueMeta.getValue(testKey2));		
			
			keyValueMeta.addValue(testKey2, testData2);			
			assertEquals(testData2, keyValueMeta.getValue(testKey2));
			assertEquals(testData, keyValueMeta.getValue(testKey));		
			
			assertTrue(arrayHasValues(keyValueMeta.keys, testKey, testKey2));
					
			assertEquals(testData, keyValueMeta.removeValue(testKey));	
					
			assertTrue(arrayHasValues(keyValueMeta.keys, testKey2));	
			
			assertEquals(testData2, keyValueMeta.removeValue(testKey2));	
			
			assertTrue(arrayHasValues(keyValueMeta.keys));							
		}
		
		private function arrayHasValues(values:Vector.<Object>, ...testValues):Boolean
		{	
			for each( var value:Object in values)
			{
				var testIndex:int = testValues.indexOf(value);
			
				if(testValues.indexOf(value) >= 0)
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


		
	}
}