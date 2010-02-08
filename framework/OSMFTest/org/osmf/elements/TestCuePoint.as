/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.elements
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
