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
	import flash.net.NetStream;
	
	import org.osmf.net.NetClient;
	import org.osmf.net.NetConnectionFactory;
	import org.osmf.net.NetLoader;
	import org.osmf.traits.LoadTrait;
	
	/**
	 * A NetLoader which outputs all NetStatusEvents to the console.
	 **/
	public class TracingNetLoader extends NetLoader
	{
		/**
		 * Constructor
		 * 
		 * @param allowConnectionSharing true if the NetLoader can invoke a NetConnectionFactory which
		 * re-uses (shares) an existing NetConnection. 
		 */
		public function TracingNetLoader()
		{
			var factory:NetConnectionFactory = new DefaultNetConnectionFactory();
			
			super(factory);
		}
	    
	    /**
	     * @inheritDoc
	     **/
	    override protected function createNetStream(connection:NetConnection, loadTrait:LoadTrait):NetStream
	    {
			var ns:NetStream = new NetStream(connection);
			ns.client = new NetClient();
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStreamNetStatusEvent);
			return ns;
	    }
	    
	    // Internals
	    //
	    
	    private function onNetStreamNetStatusEvent(event:NetStatusEvent):void
	    {
	    	trace("NetStream: " + event.info.code + ": " + event.info.level);
	    }
	}
}