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
package org.openvideoplayer.netmocker
{
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.openvideoplayer.net.NetClient;
	import org.openvideoplayer.net.NetLoader;
	
	/**
	 * A NetLoader which outputs all NetStatusEvents to the console.
	 **/
	public class TracingNetLoader extends NetLoader
	{
	    /**
	     *  @inheritDoc
	     **/
	    override protected function createNetConnection():NetConnection
	    {
			var netConnection:NetConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetConnectionNetStatusEvent);
			return netConnection;
	    }
	    
	    /**
	     *  @inheritDoc
	     **/
	    override protected function createNetStream(connection:NetConnection):NetStream
	    {
			var ns:NetStream = new NetStream(connection);
			ns.client = new NetClient();
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStreamNetStatusEvent);
			return ns;
	    }
	    
	    protected function onNetConnectionNetStatusEvent(event:NetStatusEvent):void
	    {
	    	trace("NetConnection: " + event.info.code + ": " + event.info.level);
	    }

	    protected function onNetStreamNetStatusEvent(event:NetStatusEvent):void
	    {
	    	trace("NetStream: " + event.info.code + ": " + event.info.level);
	    }
	}
}