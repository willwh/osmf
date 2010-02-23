/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.net.dvr
{
	import org.osmf.flexunit.TestCaseEx;
	import org.osmf.metadata.Facet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.netmocker.MockNetConnection;
	import org.osmf.netmocker.MockNetStream;
	import org.osmf.netmocker.NetConnectionExpectation;

	public class TestDVRCastDVRTrait extends TestCaseEx
	{
		public function testDVRCastDVRTrait():void
		{
			var nc:MockNetConnection = new MockNetConnection();
			nc.expectation = NetConnectionExpectation.VALID_CONNECTION;
			nc.connect(null);
			
			var stream:MockNetStream = new MockNetStream(nc);
			
			var resource:StreamingURLResource = new StreamingURLResource("");
			
			assertThrows(function():void{new DVRCastDVRTrait(nc, stream, resource);});
			
			var now:Date;
			var facet:Facet = new Facet(MetadataNamespaces.DVRCAST_METADATA);
			resource.metadata.addFacet(facet);
			facet.addValue
				( DVRCastConstants.KEY_STREAM_INFO
				, new DVRCastStreamInfo
					(	{ callTime: now
						, offline: false
						, begOffset: 0
						, endOffset: 0
						, startRec: now
						, stopRec: now
						, isRec: false
						, streamName: "test"
						, lastUpdate: now
						, currLen: 0
						, maxLen: 0
						}
					)
				);
			facet.addValue(DVRCastConstants.KEY_RECORDING_INFO, new DVRCastRecordingInfo());
			
			var dt:DVRCastDVRTrait = new DVRCastDVRTrait(nc, stream, resource);
			
			assertNotNull(dt);
			assertEquals(NaN, dt.livePosition);
			assertEquals(false, dt.isRecording);
		}
	}
}