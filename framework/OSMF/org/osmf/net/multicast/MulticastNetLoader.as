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
package org.osmf.net.multicast
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	CONFIG::FLASH_10_1	
	{
		import flash.net.NetGroup;
	}
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.net.NetConnectionFactoryBase;
	import org.osmf.net.NetLoader;
	import org.osmf.traits.LoadTrait;
	import org.osmf.net.StreamingURLResource;

	public class MulticastNetLoader extends NetLoader
	{
		public function MulticastNetLoader(factory:NetConnectionFactoryBase=null)
		{
			super(factory);
		}
		
		CONFIG::FLASH_10_1	
		{
			public function createNetGroup(connection:NetConnection, rtmfpGroupspec:String):NetGroup
			{
				return new NetGroup(connection, rtmfpGroupspec);
			}
		}
		
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			var rs:StreamingURLResource = resource as StreamingURLResource;

			return rs != null && rs.rtmfpGroupspec != null && rs.rtmfpGroupspec.length > 0 && rs.rtmfpStreamName != null && rs.rtmfpStreamName.length > 0;
		}

		override protected function executeLoad(loadTrait:LoadTrait):void
		{
			loadTrait.resource.addMetadataValue(MetadataNamespaces.MULTICAST_NET_LOADER, this);
			super.executeLoad(loadTrait);
		}
		
		override protected function createNetStream(connection:NetConnection, resource:URLResource):NetStream
		{
			var rs:StreamingURLResource = resource as StreamingURLResource;
			var ns:NetStream = new NetStream(connection, rs.rtmfpGroupspec);
			ns.bufferTime = 5.0;
			
			return ns;
		}
	}
}