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
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osmf.media.IURLResource;
	import org.osmf.net.NetConnectionFactory;
	import org.osmf.net.NetLoadedContext;
	import org.osmf.traits.LoadableTrait;

    /**
	 * The DynamicStreamingNetLoadedContext contains information about the output of a load operation
	 * performed by a DynamicStreamingNetLoader. 
	 * 
	 * @see DynamicStreamingNetLoader 
	 */
	public class DynamicStreamingNetLoadedContext extends NetLoadedContext
	{
		public function DynamicStreamingNetLoadedContext(connection:NetConnection, stream:NetStream, shareable:Boolean=false, 
															netConnectionFactory:NetConnectionFactory=null, resource:IURLResource=null,
															hostNameLoadable:LoadableTrait=null)
		{
			super(connection, stream, shareable, netConnectionFactory, resource);
			_hostNameLoadable = hostNameLoadable;
		}

		/**
		 * This is the loadable object representing the host name for the 
		 * dynamic streaming profile.
		 */
		public function get hostNameLoadable():LoadableTrait
		{
			return _hostNameLoadable;
		}
				
		private var _hostNameLoadable:LoadableTrait;		
	}
}
