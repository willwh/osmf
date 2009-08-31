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
package org.openvideoplayer.net.dynamicstreaming
{
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.metadata.Metadata;
	import org.openvideoplayer.netmocker.MockDynamicStreamingNetLoader;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.URL;

	public class TestDynamicStreamingResource extends TestCase
	{
		override public function setUp():void
		{
			
		}	
			
		public function testDynamicStreamingResource():void
		{
			var dsr:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL(HOSTNAME));
			
			// Test hostName property
			assertEquals(HOSTNAME, dsr.hostName);
			
			assertEquals(0, dsr.numItems);
			
			// Try an index out of range, since we haven't added any items yet
			try
			{
				var item:DynamicStreamingItem = dsr.getItemAt(5);
				fail("DynamicStreamingResource.getItemAt() should have thrown a RangeError");
			}
			catch(e:RangeError)
			{
				assertEquals(e.message, MediaFrameworkStrings.INVALID_PARAM);
			}
			
			// Try an index out of range for the intial index
			try
			{
				dsr.initialIndex = 1;
				fail("DynamicStreamingResource.initialIndex should have thrown a RangeError");
			}
			catch(e:RangeError)
			{
				assertEquals(e.message, MediaFrameworkStrings.INVALID_PARAM);
			}
			
			
			// Test addItem method. 
			dsr.addItem(new DynamicStreamingItem("stream_1", bitrates[3]));
			dsr.addItem(new DynamicStreamingItem("stream_2", bitrates[5]));
			dsr.addItem(new DynamicStreamingItem("stream_3", bitrates[0]));
			dsr.addItem(new DynamicStreamingItem("stream_4", bitrates[2]));
			dsr.addItem(new DynamicStreamingItem("stream_5", bitrates[4]));
			dsr.addItem(new DynamicStreamingItem("stream_6", bitrates[1]));
			
			assertEquals(bitrates.length, dsr.numItems);
			
			// Test getItemAt method. No matter what order they were added, they should be in 
			// ascending bitrate order when we iterate over them.
			for (var i:int = 0; i < dsr.numItems; i++)
			{
				var bitrate:int = dsr.getItemAt(i).bitrate;
				assertEquals(bitrates[i], bitrate);
			}
			
			// Try an index out of range
			try
			{
				var item2:DynamicStreamingItem = dsr.getItemAt(dsr.numItems + 1);
				fail("DynamicStreamingResource.getItemAt() should have thrown a RangeError");
			}
			catch(e:RangeError)
			{
				assertEquals(e.message, MediaFrameworkStrings.INVALID_PARAM);
			}
			
			// Test initialIndex property
			assertEquals(0, dsr.initialIndex);
			dsr.initialIndex = 3;
			assertEquals(3, dsr.initialIndex);
			
			// Try an index out of range
			try
			{
				dsr.initialIndex = dsr.numItems + 1;
				fail("DynamicStreamingResource.initialIndex should have thrown a RangeError");
			}
			catch(e:RangeError)
			{
				assertEquals(e.message, MediaFrameworkStrings.INVALID_PARAM);
			}
			
			
			// Test start properties
			assertEquals(DynamicStreamingResource.START_EITHER_LIVE_OR_VOD, dsr.start);
			dsr.start = DynamicStreamingResource.START_VOD;
			assertEquals(DynamicStreamingResource.START_VOD, dsr.start);
			
			// Test len property
			assertEquals(DynamicStreamingResource.DURATION_PLAY_UNTIL_END, dsr.len);
			dsr.len = DynamicStreamingResource.DURATION_PLAY_SINGLE_FRAME;
			assertEquals(DynamicStreamingResource.DURATION_PLAY_SINGLE_FRAME, dsr.len);
			
			// Test Metadata property
			var metadata:Metadata = dsr.metadata;
			assertNotNull(metadata);
			assertNotNull(dsr.metadata);
			
			// Test indexFromName
			assertEquals(5, dsr.indexFromName("stream_2"));
			var index:int = dsr.indexFromName("bogus name");
			assertEquals(-1, index);
		}
		
		private var bitrates:Array = [400, 900, 900, 1200, 3000, 3500]; 
		private const HOSTNAME:String = "rtmp://hostname.com/ondemand";
	}
}
