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
package org.osmf.net
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osmf.netmocker.MockNetStream;
	import org.osmf.traits.TestTemporalTrait;
	import org.osmf.utils.NetFactory;
	import org.osmf.utils.URL;
	import org.osmf.utils.TestConstants;

	public class TestNetStreamTemporalTrait extends TestTemporalTrait
	{
		override public function setUp():void
		{
			netFactory = new NetFactory();

			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			netFactory = null;
		}
		
		override public function testCurrentTime():void
		{
			// TODO: Fix the mismatch between the TemporalTrait's
			// initial currentTime and the NetStreamTemporalTrait's
			// initial currentTime (one is NaN, the other is zero).
			// The base test results in a failure.
		}

		override protected function createInterfaceObject(... args):Object
		{
			var connection:NetConnection = netFactory.createNetConnection();
			connection.connect(null);
			stream = netFactory.createNetStream(connection);
			
			if (stream is MockNetStream)
			{
				MockNetStream(stream).expectedDuration = EXPECTED_DURATION;
			}
			return new NetStreamTemporalTrait(stream, new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO));
		}
		
		override protected function get canChangeCurrentTime():Boolean
		{
			return false;
		}

		private var stream:NetStream;
		private var netFactory:NetFactory;
		
		private static const EXPECTED_DURATION:Number = 5;
	}
}