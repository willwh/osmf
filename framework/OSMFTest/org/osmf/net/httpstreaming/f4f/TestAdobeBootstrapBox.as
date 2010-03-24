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
	import __AS3__.vec.Vector;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.net.httpstreaming.AdobeBootstrapBoxDescriptor;
	import org.osmf.net.httpstreaming.AdobeFragmentRunTableDescriptor;
	import org.osmf.net.httpstreaming.AdobeSegmentRunTableDescriptor;
	import org.osmf.net.httpstreaming.HTTPStreamingTestsHelper;
	
	public class TestAdobeBootstrapBox extends TestCase
	{
		override public function setUp():void
		{
			abstDescriptor = new AdobeBootstrapBoxDescriptor();
			abstDescriptor.bootstrapInfoVersion = 100;
			abstDescriptor.live = false;
			abstDescriptor.update = false;
			abstDescriptor.timeScale = 1000;
			abstDescriptor.currentMediaTimeH = 0;
			abstDescriptor.currentMediaTimeL = 22000;
			abstDescriptor.smpteTimeCodeOffsetH = 0;
			abstDescriptor.smpteTimeCodeOffsetL = 0;
			abstDescriptor.movieIdentifier = "movie";
			abstDescriptor.addServerBaseUrl("http://www.httpstreaming.net/server_base_url");

			var segmentRunTable:AdobeSegmentRunTableDescriptor = new AdobeSegmentRunTableDescriptor();
			segmentRunTable.addEntry(1, 16);
			abstDescriptor.addSegmentRunTable(segmentRunTable);
			
			var fragmentRunTable:AdobeFragmentRunTableDescriptor = new AdobeFragmentRunTableDescriptor();
			fragmentRunTable.timeScale = 1000;
			//
			//	Fragment runtable entries
			//  
			//  first_fragment		first_fragment_time_stamp		fragment_duration		discontinuity_indicator
			//  	1					0								4000					-
			// 		5					16000							0						1
			// 		6					16000							0						2
			// 		7					16000							500						-
			// 		11					18000							0						3
			// 		12					18000							1000					-
			// 		16					22000							0						0 
			//
			fragmentRunTable.addEntry(1, 0, 0, 4000, 0);
			fragmentRunTable.addEntry(5, 0, 16000, 0, 1);
			fragmentRunTable.addEntry(6, 0, 16000, 0, 2);
			fragmentRunTable.addEntry(7, 0, 16000, 500, 0);
			fragmentRunTable.addEntry(11, 0, 18000, 0, 3);
			fragmentRunTable.addEntry(12, 0, 18000, 1000, 0);
			fragmentRunTable.addEntry(16, 0, 22000, 0, 0);
			abstDescriptor.addFragmentRunTable(fragmentRunTable);
						
			var bytes:ByteArray = HTTPStreamingTestsHelper.createAdobeBootstrapBox(abstDescriptor);

			var parser:BoxParser = new BoxParser();
			parser.init(bytes);
			var boxes:Vector.<Box> = parser.getBoxes();
			assertTrue(boxes.length == 1);
			
			abst = boxes[0] as AdobeBootstrapBox;
			assertTrue(abst != null);
		}

		public function testBasicAttributes():void
		{
			assertTrue(abst.bootstrapVersion == abstDescriptor.bootstrapInfoVersion);
			assertTrue(abst.currentMediaTime == abstDescriptor.currentMediaTimeL);
			assertTrue(abst.contentComplete());
			assertTrue(abst.live == abstDescriptor.live);
			assertTrue(abst.update == abstDescriptor.update);
			assertTrue(abst.movieIdentifier == abstDescriptor.movieIdentifier);
			assertTrue(abst.drmData == abstDescriptor.drmData);
			assertTrue(abst.metadata == abstDescriptor.metadata);
			assertTrue(abst.smpteTimeCodeOffset == abstDescriptor.smpteTimeCodeOffsetL);
			assertTrue(abst.timeScale == abstDescriptor.timeScale);
			assertTrue(abst.profile == abstDescriptor.profile);
		}
		
		public function testServerBaseUrls():void
		{
			compareStrings(abst.serverBaseURLs, abstDescriptor.serverBaseUrls);
		}
		
		public function testQualitySegmentUrlModifiers():void
		{
			compareStrings(abst.qualitySegmentURLModifiers, abstDescriptor.qualitySegmentUrlModifiers);
		}
		
		public function testSegmentRunTables():void
		{
			assertTrue(
				((abst.segmentRunTables == null || abst.segmentRunTables.length == 0) && abstDescriptor.segmentRunTables.length == 0) ||
				(abst.segmentRunTables.length == abstDescriptor.segmentRunTables.length));
			if (abst.segmentRunTables != null)
			{
				for (var i:int = 0; i < abst.segmentRunTables.length; i++)
				{
					compareSegmentRunTable(abst.segmentRunTables[i], abstDescriptor.segmentRunTables[i]);
				}
			}
		}
		
		private function compareSegmentRunTable(asrt:AdobeSegmentRunTable, asrtd:AdobeSegmentRunTableDescriptor):void
		{
			compareStrings(asrt.qualitySegmentURLModifiers, asrtd.qualitySegmentUrlModifiers);
			assertTrue(
				((asrt.segmentFragmentPairs == null || asrt.segmentFragmentPairs.length == 0) && asrtd.segmentRunTableEntries .length == 0) ||
				(asrt.segmentFragmentPairs.length == asrtd.segmentRunTableEntries.length));
			if (asrt.segmentFragmentPairs != null)
			{
				for (var i:int = 0; i < asrt.segmentFragmentPairs.length; i++)
				{
					assertTrue(asrt.segmentFragmentPairs[i].firstSegment == asrtd.segmentRunTableEntries[i].firstSegment);
					assertTrue(asrt.segmentFragmentPairs[i].fragmentsPerSegment == asrtd.segmentRunTableEntries[i].fragmentsPerSegment);
				}
			} 
		}
		
		private function compareStrings(strs1:Vector.<String>, strs2:Vector.<String>):void
		{
			assertTrue(
				((strs1 == null || strs1.length == 0) && (strs2 == null || strs2.length == 0)) ||
				(strs1.length == strs2.length));
			if (strs1 != null && strs1.length > 0)
			{
				for (var i:int = 0; i < strs1.length; i++)
				{
					assertTrue(strs1[i] == strs2[i]);
				}
			}
		}
		
		public function testFragmentRunTables():void
		{
			assertTrue(
				((abst.fragmentRunTables == null || abst.fragmentRunTables.length == 0) && abstDescriptor.fragmentRunTables.length == 0) ||
				(abst.fragmentRunTables.length == abstDescriptor.fragmentRunTables.length));
			if (abst.fragmentRunTables != null)
			{
				for (var i:int = 0; i < abst.fragmentRunTables.length; i++)
				{
					compareFragmentRunTable(abst.fragmentRunTables[i], abstDescriptor.fragmentRunTables[i]);
				}
			}
		}
				
		private function compareFragmentRunTable(afrt:AdobeFragmentRunTable, afrtd:AdobeFragmentRunTableDescriptor):void
		{
			assertTrue(afrt.timeScale == afrtd.timeScale);
			compareStrings(afrt.qualitySegmentURLModifiers, afrtd.qualitySegmentUrlModifiers);
			assertTrue(
				((afrt.fragmentDurationPairs == null || afrt.fragmentDurationPairs.length == 0) && afrtd.fragmentRunTableEntries.length == 0) ||
				(afrt.fragmentDurationPairs.length == afrtd.fragmentRunTableEntries.length));
			if (afrt.fragmentDurationPairs != null)
			{
				for (var i:int = 0; i < afrt.fragmentDurationPairs.length; i++)
				{
					assertTrue(afrt.fragmentDurationPairs[i].firstFragment == afrtd.fragmentRunTableEntries[i].firstFragment);
					assertTrue(afrt.fragmentDurationPairs[i].durationAccrued == afrtd.fragmentRunTableEntries[i].firstFragmentTimeStampL);
					assertTrue(afrt.fragmentDurationPairs[i].duration == afrtd.fragmentRunTableEntries[i].duration);
					if (afrt.fragmentDurationPairs[i].duration == 0)
					{
						assertTrue(afrt.fragmentDurationPairs[i].discontinuityIndicator == afrtd.fragmentRunTableEntries[i].discontinuityIndicator);
					}
				}
			} 
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
		private var abstDescriptor:AdobeBootstrapBoxDescriptor;
	}
}