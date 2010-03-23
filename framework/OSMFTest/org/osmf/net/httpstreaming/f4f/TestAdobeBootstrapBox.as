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
package org.osmf.net.httpstreaming.f4f
{
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.utils.TestConstants;
	import org.osmf.net.httpstreaming.HTTPStreamingTestsHelper;
	
	public class TestAdobeBootstrapBox extends TestCase
	{
		override public function setUp():void
		{
			var bytes:ByteArray = HTTPStreamingTestsHelper.createAdobeBootstrapBox(false, false);

			var parser:BoxParser = new BoxParser();
			parser.init(bytes);
			var boxes:Vector.<Box> = parser.getBoxes();
			assertTrue(boxes.length == 1);
			
			abst = boxes[0] as AdobeBootstrapBox;
			assertTrue(abst != null);
		}
		
		public function testFindSegmentId():void
		{
			// Segment number increases every 15 fragments.
			assertTrue(abst.findSegmentId(0) == 0);
			for (var i:int = 1; i <= 16; i++)
			{			
				assertTrue(abst.findSegmentId(i) == 1);
			}
			for (i = 17; i <= 18; i++)
			{			
				assertTrue(abst.findSegmentId(i) == 2);
			}
		}
		
		public function testTotalDuration():void
		{
			assertTrue(abst.totalDuration == 22000);
		}

		public function testTotalFragments():void
		{
			assertTrue(abst.totalFragments == 15);
		}
		
		// Internals
		//
		
		private var abst:AdobeBootstrapBox;
	}
}