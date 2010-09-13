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

	CONFIG::LOGGING
	{
		import org.osmf.logging.Logger;
		import org.osmf.logging.Log;
	}
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.net.NetConnectionFactoryBase;
	import org.osmf.net.NetLoader;
	import org.osmf.net.NetStreamLoadTrait;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoadState;
	import org.osmf.net.StreamingURLResource;
	import __AS3__.vec.Vector;
	import flash.events.NetStatusEvent;
	import flash.net.NetGroup;

	/**
	 * Extends NetLoader to provide
	 * loading support for multicast video playback.
	 * 
	 * <p> MulticastNetLoader expects the media resource to be a StreamingURLResource,
	 * in which rtmfpGroupspec and rtmfpStreamName are specified.</p>
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.5
	 */
	public class MulticastNetLoader extends NetLoader
	{
		/**
		 * @private
		**/
		public function MulticastNetLoader(factory:NetConnectionFactoryBase=null)
		{
			super(factory, false);
		}
		
		/**
		 * @private
		 * 
		 * MulticastNetLoader returns true if the resource is an instance of StreamingURLResource with
		 * both rtmfpGroupspec and rtmfpStreamName set.
		 * 
		 * @param resource The URL of the source media.
		 * @return Returns <code>true</code> for resouces of type StreamingURLResource.
		**/
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			var rs:StreamingURLResource = resource as StreamingURLResource;

            return rs != null && rs.rtmfpGroupspec != null && rs.rtmfpGroupspec.length > 0 && rs.rtmfpStreamName != null && rs.rtmfpStreamName.length > 0;
        }

		/**
		 * @private
		**/
		override protected function createNetStream(connection:NetConnection, resource:URLResource):NetStream
		{
			
			var rs:StreamingURLResource = resource as StreamingURLResource;

			CONFIG::LOGGING	
			{
				logger.info("Creating multicast NetStream with rtmfpGroupspec " + rs.rtmfpGroupspec);
			}

			var ns:NetStream = new NetStream(connection, rs.rtmfpGroupspec);
			CONFIG::LOGGING	
			{
				if (ns != null)
				{
					logger.info("Multicast NetStream created.");
				}
			}
			
			return ns;
		}
		
		/**
		 *  Things become a little complex here. For multicast, the first time user will encounter a
		 *  pop up dialog box for Peer Assited Network setting. The user may choose either to allow and deny.
		 *  Also, the user may choose to remember the decision. If the user chooses to "allow", the client 
		 *  can proceed to receive multicast contents. Otherwise, the client cannot proceed. 
		 * 
		 *  In terms of OSMF and Flex class, OSMF should not proceed until it receives either 
		 *  "NetGroup.Connect.Success" or "NetStream.Connect.Success". Otherwise, multicast will not work and
		 *  any attempt to access net stream or net group will incur exception (RTE). 
		 *
		 *  Therefore, the code here takes this scenario into consideration and wait for the "NetGroup.Connect.Success"
		 *  before it proceeds.
		 *
		 *  @private
		**/
		CONFIG::FLASH_10_1	
		{						 
			override protected function processCreationComplete(connection:NetConnection, loadTrait:LoadTrait, factory:NetConnectionFactoryBase = null):void
			{
				var netLoadTrait:NetStreamLoadTrait = loadTrait as NetStreamLoadTrait;
				/**
				 * Normally, it would not even get here if it is not NetStreamLoadTrait or the rtmfpGroupspec
				 * is empty. But it is alway good to be cautious and defensive.
				 */
				if (netLoadTrait == null || !isMulticast(netLoadTrait.resource as StreamingURLResource))
				{
					super.processCreationComplete(connection, loadTrait, factory);
					return;
				}
				
				var streamURLResource:StreamingURLResource = netLoadTrait.resource as StreamingURLResource;
				connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				var netGroup:NetGroup = new NetGroup(connection, streamURLResource.rtmfpGroupspec);
				
				function onNetStatus(event:NetStatusEvent):void
				{
					switch(event.info.code)
					{
						case "NetGroup.Connect.Success":
							connection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
							netLoadTrait.netGroup = netGroup;
							doProcessCreationComplete(connection, loadTrait, factory);
							break;
						
						case "NetGroup.Connect.Failed":
						case "NetGroup.Connect.Rejected":
							connection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
							updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
							break;
					}
				}
			}
		}
		
		/**
		 * Help the enclosed onNetStatus function to call super.processCreationComplete.
		 * 
		 *  @private
		 */
		private function doProcessCreationComplete(connection:NetConnection, loadTrait:LoadTrait, factory:NetConnectionFactoryBase = null):void
		{
			super.processCreationComplete(connection, loadTrait, factory);			
		}
		
		/**
		 * It checks whether this is multicast.
		 * 
		 *  @private
		 */
		private function isMulticast(streamURLResource:StreamingURLResource):Boolean
		{
			return (streamURLResource != null 
				&& streamURLResource.rtmfpGroupspec != null 
				&& streamURLResource.rtmfpGroupspec.length > 0);
		}

		CONFIG::LOGGING
		{
			private static var logger:Logger = org.osmf.logging.Log.getLogger("org.osmf.net.multicast.MulticastNetLoader");
		}	
	}
}
