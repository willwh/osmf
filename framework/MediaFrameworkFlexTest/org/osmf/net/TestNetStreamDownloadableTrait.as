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
	
	import org.osmf.netmocker.MockNetConnection;
	import org.osmf.traits.TestDownloadableTrait;
	import org.osmf.utils.MockNetStream;

	public class TestNetStreamDownloadableTrait extends TestDownloadableTrait
	{		
		override protected function createInterfaceObject(... args):Object
		{
			var connection:NetConnection = new NetConnection();
			connection.connect(null);
			_netStream = new MockNetStream(connection);
			_initBytesLoaded = 50;
			_initBytesTotal = 100;
			
			_netStream.bytesLoaded = _initBytesLoaded;
			_netStream.bytesTotal = _initBytesTotal;

			return new NetStreamDownloadableTrait(_netStream);
		}
		
		override public function testInitialProperties():void
		{
			assertTrue(downloadable.bytesLoaded == _initBytesLoaded);
			assertTrue(downloadable.bytesTotal == _initBytesTotal);
		}	
		
		override public function testProperties():void
		{
			_netStream.bytesTotal = 200;
			_netStream.bytesLoaded = 150;
			
			assertTrue(downloadable.bytesLoaded == 150);
			assertTrue(downloadable.bytesTotal == 200);
		}
			
		// Utils
		//
		
		private var _netStream:MockNetStream;
		private var _initBytesLoaded:uint;
		private var _initBytesTotal:uint;
	}
}