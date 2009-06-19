/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.utils
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.openvideoplayer.net.NetClient;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.netmocker.MockNetConnection;
	import org.openvideoplayer.netmocker.MockNetLoader;
	import org.openvideoplayer.netmocker.MockNetStream;
	
	/**
	 * Factory class for creating NetConnections and NetStreams.
	 * 
	 * By default, the class creates MockNetConnections and MockNetStreams.
	 * But a client can cause it to create true NetConnections and NetStreams
	 * simply by changing the constructor's useMockObjects parameter.
	 * 
	 * Note that useMockObjects is also exposed as a static getter/setter
	 * pair, so that it can be overridden for all tests with one call.
	 **/
	public class NetFactory
	{
		/**
		 * Constructor.
		 **/
		public function NetFactory(useMockObjects:Boolean=true)
		{
			_useMockObjects = useMockObjects;
		}
		
		/**
		 * Overrides the default behavior of using mock objects, so
		 * that mock objects are never used.
		 * 
		 * The default is false (use mock objects).
		 **/
		public static function set neverUseMockObjects(value:Boolean):void
		{
			_neverUseMockObjects = value;
		}
		
		public static function get neverUseMockObjects():Boolean
		{
			return _neverUseMockObjects;
		}
		
		/**
		 * Create and return a new NetLoader.
		 **/
		public function createNetLoader():NetLoader
		{
			return useMockObjects
						? new MockNetLoader()
						: new NetLoader();
		}
		
		/**
		 * Create and return a new NetConnection.
		 **/
		public function createNetConnection():NetConnection
		{
			return useMockObjects
						? new MockNetConnection()
						: new NetConnection();
		}

		/**
		 * Create and return a new NetStream.
		 **/
		public function createNetStream(netConnection:NetConnection):NetStream
		{
			var netStream:NetStream = 
					useMockObjects
						? new MockNetStream(netConnection)
						: new NetStream(netConnection);
			netStream.client = new NetClient();
			return netStream;
		}
		
		private function get useMockObjects():Boolean
		{
			return _useMockObjects && !_neverUseMockObjects;
		}
		
		private static var _neverUseMockObjects:Boolean = false;
		
		private var _useMockObjects:Boolean = true;
	}
}