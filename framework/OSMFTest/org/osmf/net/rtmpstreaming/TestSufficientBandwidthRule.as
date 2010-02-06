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
package org.osmf.net.rtmpstreaming
{
	import flash.net.NetConnection;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.net.dynamicstreaming.DynamicStreamingItem;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.netmocker.MockMetricsProvider;
	import org.osmf.utils.NetFactory;

	public class TestSufficientBandwidthRule extends TestCase
	{
		public function testGetNewIndex():void
		{
			var netFactory:NetFactory = new NetFactory();
			var connection:NetConnection = netFactory.createNetConnection();
			connection.connect(null);
			
			var metrics:MockMetricsProvider = new MockMetricsProvider(netFactory.createNetStream(connection));
			
			var suRule:SufficientBandwidthRule = new SufficientBandwidthRule();
			suRule.metrics = metrics;
			
			var result:int;
			
			// Test with an empty metrics object
			result = suRule.getNewIndex();
			assertEquals(-1, result);
			
			// Test with bandwidth higher than the current stream
			var dsResource:DynamicStreamingResource = new DynamicStreamingResource(null);
			dsResource.streamItems.push(new DynamicStreamingItem("stream1_300kbps", 300));
			dsResource.streamItems.push(new DynamicStreamingItem("stream2_500kbps", 500));
			dsResource.streamItems.push(new DynamicStreamingItem("stream3_1000kbps", 1000));
			dsResource.streamItems.push(new DynamicStreamingItem("stream4_3000kpbs", 3000));

			// Test with lots of bandwidth, but insufficient buffer	
			metrics.avgMaxBitrate = 5000;
			metrics.bufferLength = 0;
			metrics.dynamicStreamingResource = dsResource;
			result = suRule.getNewIndex();
			assertEquals(-1, result);
			
			// Test with bandwidth lower than the current stream		
			metrics.avgMaxBitrate = 1234;
			metrics.currentIndex = 3;
			result = suRule.getNewIndex();
			assertEquals(-1, result);
			
			// Test with lots of bandwidth and a stable buffer
			metrics.avgMaxBitrate = 5000;
			metrics.frameDropRate = 0;
			metrics.bufferLength = 10;
			metrics.currentIndex = 0;
			metrics.dynamicStreamingResource = dsResource;
			result = suRule.getNewIndex();
			assertEquals(3, result);

			// Test with lots of bandwidth, a stable buffer, but too many dropped frames
			metrics.avgMaxBitrate = 5000;
			metrics.frameDropRate = 10;
			metrics.bufferLength = 10;
			metrics.currentIndex = 0;
			metrics.dynamicStreamingResource = dsResource;
			result = suRule.getNewIndex();
			assertEquals(-1, result);	
		}		
	}
}
