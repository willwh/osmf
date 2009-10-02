package org.osmf.metadata
{
	import flexunit.framework.TestCase;
	
	import mx.messaging.management.ObjectInstance;
	
	public class TestObjectIdentifier extends TestCase
	{
		public function testEquality():void
		{
			var testKey:String = "testKey";
			var id3:ObjectIdentifier = new ObjectIdentifier("differentKey");
			var id:ObjectIdentifier = new ObjectIdentifier(testKey);
			var id2:ObjectIdentifier = new ObjectIdentifier(testKey);
			assertEquals(id.key, id2.key, testKey);
			assertTrue(id.equals(id2));			
			assertFalse(id.equals(id3));
		}

	}
}