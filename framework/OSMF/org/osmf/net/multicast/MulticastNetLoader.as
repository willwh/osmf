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
	import org.osmf.traits.LoadTrait;
	import org.osmf.net.StreamingURLResource;
	import __AS3__.vec.Vector;

	/**
	 * The MulticastNetLoader class extends NetLoader to provide
	 * loading support to multicast video playback.
	 * 
	 * <p> It expects the media resource to be StreamingURLResource, in which
	 * rtmfpGroupspec and rtmfpStreamName are specified.</p>
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
		 * @inheritDoc
		**/
		public function MulticastNetLoader(factory:NetConnectionFactoryBase=null)
		{
			super(factory);
			
			CONFIG::FLASH_10_1	
			{
				netGroups = new Vector.<NetGroup>();
			}
		}
		
		CONFIG::FLASH_10_1	
		{
			/**
			 * The factory function for creating a NetGroup.
			 * 
			 * @param connection The NetConnection that's associated with the NetStreamSwitchManagerBase.
			 * @param rtmfpGroupspec The rtmfp GroupSpec that is used to create the NetGroup.
			 * 
			 * @return The NetGroup.
			 **/
			public function createNetGroup(connection:NetConnection, rtmfpGroupspec:String):NetGroup
			{
				CONFIG::LOGGING
				{
					logger.info("Creating NetGroup with rtmfpGroupspec " + rtmfpGroupspec);
				}
				
				var ng:NetGroup = new NetGroup(connection, rtmfpGroupspec);
				netGroups.push(ng);
				
				return ng;
			}
		}
		
		/**
		 * @private
		 * 
		 * The MulticastNetLoader returns true if the resource is an instance of StreamingURLResource with
		 * both rtmfpGroupspec and rtmfpStreamName set.
		 * 
		 * @param resource The URL of the source media.
		 * @return Returns <code>true</code> for StreamingURLResource which it can load
		 * @inheritDoc
		**/
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			var rs:StreamingURLResource = resource as StreamingURLResource;

            return rs != null && rs.rtmfpGroupspec != null && rs.rtmfpGroupspec.length > 0 && rs.rtmfpStreamName != null && rs.rtmfpStreamName.length > 0;
        }

		/**
		 * @private
		 * @inheritDoc
		**/
		override protected function executeLoad(loadTrait:LoadTrait):void
		{
			loadTrait.resource.addMetadataValue(MetadataNamespaces.MULTICAST_NET_LOADER, this);
			super.executeLoad(loadTrait);
		}
		
		/**
		 * @private
		 * @inheritDoc
		**/
		override protected function createNetStream(connection:NetConnection, resource:URLResource):NetStream
		{
			
			var rs:StreamingURLResource = resource as StreamingURLResource;

			CONFIG::LOGGING	
			{
				logger.info("Creating multicast NetStream with rtmfpGroupspec " + rs.rtmfpGroupspec);
			}

			var ns:NetStream = new NetStream(connection, rs.rtmfpGroupspec);
			if (ns != null)
			{
				CONFIG::LOGGING	
				{
					logger.info("Multicast NetStream created.");
				}
				ns.bufferTime = 5.0;
			}
			
			return ns;
		}
		
		CONFIG::FLASH_10_1	
		{
			private var netGroups:Vector.<NetGroup>;
		}
		
		CONFIG::LOGGING
		{
			private static var logger:Logger = org.osmf.logging.Log.getLogger("org.osmf.net.multicast.MulticastNetLoader");
		}	
	}
}
