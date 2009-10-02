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
package org.osmf.net.dynamicstreaming
{
	import flexunit.framework.TestCase;

	public class TestBandwidthRule extends TestCase
	{
		public function testGetNewIndex():void
		{
			var metrics:MockNetStreamMetrics = new MockNetStreamMetrics(null);
			
			var bwRule:InsufficientBandwidthRule = new InsufficientBandwidthRule(metrics);
			
			var result:int;
			
			// Test with an empty metrics object
			result = bwRule.getNewIndex();
			assertEquals(-1, result);
			
			// Test with bandwidth higher than the current stream
			var dsResource:DynamicStreamingResource = new DynamicStreamingResource(null);
			dsResource.addItem(new DynamicStreamingItem("stream1_300kbps", 300));
			
			metrics.avgMaxBitrate = 5000;
			metrics.dynamicStreamingResource = dsResource;
			result = bwRule.getNewIndex();
			assertEquals(-1, result);
			
			// Test with bandwidth lower than the current stream
			dsResource.addItem(new DynamicStreamingItem("stream2_500kbps", 500));
			dsResource.addItem(new DynamicStreamingItem("stream3_1000kbps", 1000));
			dsResource.addItem(new DynamicStreamingItem("stream4_3000kpbs", 3000));
			
			metrics.avgMaxBitrate = 1234;
			metrics.currentIndex = 3;
			result = bwRule.getNewIndex();
			assertEquals(2, result);
			assertNotNull(bwRule.detail);
			
			// Another test with very low bandwidth
			metrics.avgMaxBitrate = 500;
			result = bwRule.getNewIndex();
			assertEquals(0, result);
			
			// Another test with ridiculously low bandwidth
			metrics.avgMaxBitrate = 1;
			result = bwRule.getNewIndex();
			assertEquals(-1, result);
		}
	}
}
