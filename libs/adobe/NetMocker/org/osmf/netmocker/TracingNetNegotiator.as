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
package org.osmf.netmocker
{
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	
	import org.osmf.net.NetNegotiator;
	
	internal class TracingNetNegotiator extends NetNegotiator
	{
	    /**
	     * @inheritDoc
	     **/
	    override protected function createNetConnection():NetConnection
	    {
			var netConnection:NetConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetConnectionNetStatusEvent);
			return netConnection;
	    }
	    
	    // Internals
	    //
	    
	    private function onNetConnectionNetStatusEvent(event:NetStatusEvent):void
	    {
	    	trace("NetConnection: " + event.info.code + ": " + event.info.level);
	    }
	}
}