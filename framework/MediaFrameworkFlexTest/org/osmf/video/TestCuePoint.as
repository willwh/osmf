package org.osmf.video
{
	import flexunit.framework.TestCase;

	public class TestCuePoint extends TestCase
	{
		public function testCuePoint():void
		{
			var testArray:Array = [{key:100, value:"a"}, {key:101, value:"b"}];
			var cuePoint:CuePoint = new CuePoint(CuePointType.ACTIONSCRIPT, 120, "test cue point", testArray, 5);
			
			assertEquals(CuePointType.ACTIONSCRIPT, cuePoint.type);
			assertEquals(120, cuePoint.time);
			assertEquals("test cue point", cuePoint.name);
			
			var params:Array = cuePoint.parameters;
			assertEquals(100, params[0].key);
			assertEquals("a", params[0].value);
			assertEquals(101, params[1].key);
			assertEquals("b", params[1].value);
			
			assertEquals(5, cuePoint.duration);
		}
		
		public function testEquals():void
		{
			var cuePoint1:CuePoint = new CuePoint(CuePointType.ACTIONSCRIPT, 99, "cue point 1", null);
			var cuePoint2:CuePoint = new CuePoint(CuePointType.ACTIONSCRIPT, 99, "cue point 2", null);
			
			assertTrue(cuePoint1.equals(cuePoint2));
		}
		
		public function testCuePointType():void
		{
			var cuePointType:CuePointType = CuePointType.fromString("actionscript");
			assertEquals(cuePointType, CuePointType.ACTIONSCRIPT);
			
			cuePointType = CuePointType.fromString(null);
			assertNull(cuePointType);
		}
	}
}
