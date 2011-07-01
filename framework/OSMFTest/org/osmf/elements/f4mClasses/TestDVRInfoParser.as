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
package org.osmf.elements.f4mClasses
{
	import flexunit.framework.TestCase;
	
	import org.osmf.events.ParseEvent;
	import org.osmf.net.httpstreaming.dvr.DVRInfo;

	public class TestDVRInfoParser extends TestCase
	{
		private var parser:DVRInfoParser;
		
		public function testDVRInfoParser():void
		{					
			var test:XML = <dvrInfo url="http://example.com/testInfo.xml"
									id="testInfo"
									beginOffset="20"
									endOffset="300"
									offline="false"/>;
			
			parser = new DVRInfoParser();
			parser.addEventListener(ParseEvent.PARSE_COMPLETE, addAsync(verifyParse, 1000));
			parser.parse(test.toXMLString());
		}
		
		private function verifyParse(event:ParseEvent):void
		{
			var dvrInfo:DVRInfo = event.data as DVRInfo;
			
			assertNotNull(dvrInfo);
			assertEquals("testInfo", dvrInfo.id);
			assertEquals("http://example.com/testInfo.xml", dvrInfo.url);
			assertEquals(20, dvrInfo.beginOffset);
			assertEquals(300, dvrInfo.endOffset);
			assertEquals(false, dvrInfo.offline);
		}
		
		public function ignore_testDVRInfoFailure():void
		{
			var test:XML = <dvrInfo url="GarbageURL"
									id="testInfo"
									beginOffset="-1"
									endOffset="NaN"
									offline="blah"/>;
			
			parser = new DVRInfoParser();
			parser.addEventListener(ParseEvent.PARSE_COMPLETE, addAsync(verifyDVRInfoFailure, 1000));
			parser.parse(test.toXMLString());
		}
		
		private function verifyDVRInfoFailure(event:ParseEvent):void
		{
			var dvrInfo:DVRInfo = event.data as DVRInfo;
			
			assertNotNull(dvrInfo);
			assertEquals("testInfo", dvrInfo.id);
			assertEquals("null/GarbageURL", dvrInfo.url);
			assertEquals(0, dvrInfo.beginOffset);
			assertEquals(0, dvrInfo.endOffset);
			assertEquals(false, dvrInfo.offline);
		}
	}
}