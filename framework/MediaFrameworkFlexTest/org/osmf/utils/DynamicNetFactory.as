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
package org.osmf.utils
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osmf.net.NetLoader;
	import org.osmf.net.dynamicstreaming.DynamicNetStream;
	import org.osmf.net.dynamicstreaming.DynamicStreamingNetLoader;
	import org.osmf.netmocker.MockDynamicNetStream;
	import org.osmf.netmocker.MockDynamicStreamingNetLoader;
	
	public class DynamicNetFactory extends NetFactory
	{
		public function DynamicNetFactory(useMockObjects:Boolean=true)
		{
			super(useMockObjects);
		}
		
		override public function createNetLoader():NetLoader
		{
			return useMockObjects ? new MockDynamicStreamingNetLoader() : new DynamicStreamingNetLoader();
		}
		
		override public function createNetStream(netConnection:NetConnection):NetStream
		{
			return useMockObjects ? new MockDynamicNetStream(netConnection) : new DynamicNetStream(netConnection);
		}
	}
}
