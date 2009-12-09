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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osmf.events.ViewEvent;
	import org.osmf.netmocker.MockNetStream;
	import org.osmf.traits.TestViewTrait;
	import org.osmf.utils.NetFactory;
	import org.osmf.utils.TestConstants;
	import org.osmf.utils.URL;
	
	public class TestNetStreamViewTrait extends TestViewTrait
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

		override protected function createInterfaceObject(... args):Object
		{
			return new NetStreamViewTrait(createStream(), args.length > 0 ? args[0] : null, args.length > 1 ? args[1] : 0, args.length > 2 ? args[2] : 0);
		}
		
		public function testOnMetadata():void
		{
			var stream:NetStream = createStream();
			
			var sprite:Sprite = new Sprite();
			var viewTrait:NetStreamViewTrait = new NetStreamViewTrait(stream, sprite);
			assertTrue(viewTrait.mediaWidth == 0);
			assertTrue(viewTrait.mediaHeight == 0);
			
			viewTrait.addEventListener(ViewEvent.DIMENSION_CHANGE, addAsync(onTestOnMetadata, 5000));
			
			stream.play(NetStreamUtils.getStreamNameFromURL(new URL(TestConstants.REMOTE_PROGRESSIVE_VIDEO)));
		
			function onTestOnMetadata(event:ViewEvent):void
			{
				assertTrue(viewTrait.mediaWidth == TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_WIDTH);
				assertTrue(viewTrait.mediaHeight == TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_HEIGHT);
			}
		}
		
		// Internals
		//
		
		private function createStream():NetStream
		{
			var connection:NetConnection = netFactory.createNetConnection();
			connection.connect(null);
			var stream:NetStream = netFactory.createNetStream(connection);
			
			if (stream is MockNetStream)
			{
				MockNetStream(stream).expectedDuration = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_DURATION;
				MockNetStream(stream).expectedWidth = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_WIDTH;
				MockNetStream(stream).expectedHeight = TestConstants.REMOTE_PROGRESSIVE_VIDEO_EXPECTED_HEIGHT;
			}
			
			return stream;
		}
		
		private var netFactory:NetFactory;
	}
}