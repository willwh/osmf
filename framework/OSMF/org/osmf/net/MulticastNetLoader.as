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
	import org.osmf.traits.LoadTrait;
	import org.osmf.net.StreamingURLResource;
	import __AS3__.vec.Vector;

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
		 * @inheritDoc
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
		
		CONFIG::LOGGING
		{
			private static var logger:Logger = org.osmf.logging.Log.getLogger("org.osmf.net.multicast.MulticastNetLoader");
		}	
	}
}
