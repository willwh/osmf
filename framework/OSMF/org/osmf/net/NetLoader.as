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
*  Contributor(s): Akamai Technologies
*  
*****************************************************/
package org.osmf.net
{
	import __AS3__.vec.Vector;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.NetConnectionFactoryEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.metadata.MimeTypes;
	import org.osmf.traits.DVRTrait;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;

	/**
	 * The NetLoader class extends LoaderBase to provide
	 * loading support to the AudioElement and VideoElement classes.
	 * <p>Supports both streaming and progressive media resources.
	 * If the resource URL is RTMP, connects to an RTMP server by invoking a NetConnectionFactory. 
	 * NetConnections may be shared between LoadTrait instances.
	 * If the resource URL is HTTP, performs a <code>connect(null)</code>
	 * for progressive downloads.</p>
	 * 
	 * @param allowConnectionSharing if true, the NetLoader will allow sharing. Note that this param implies
	 * that an already existing NetConnection may be used to satisfy this LoadTrait, as well as whether a
	 * new NetConnection established by this loader can be shared with future LoadTraits. 
	 * 
	 * @param factory the NetConnectionFactory instance to use for managing NetConnections. Since the NetConnectionFactory
	 * facilitates connection sharing, this is an easy way of enabling global sharing, by creating a single NetConnectionFactory
	 * instance within the player and then handing it to all NetLoader instances. 
	 * 
	 * @see NetConnectionFactory
	 * @see flash.net.NetConnection
	 * @see flash.net.NetStream
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class NetLoader extends LoaderBase
	{
		/**
		 * Constructor.
		 * 
		 * @param factory the NetConnectionFactoryBase instance to use for managing NetConnections.
		 * If factory is null, a NetConnectionFactory will be created and used. Since the
		 * NetConnectionFactory class facilitates connection sharing, this is an easy way of
		 * enabling global sharing, by creating a single NetConnectionFactory instance within
		 * the player and then handing it to all NetLoader instances.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function NetLoader(factory:NetConnectionFactoryBase = null)
		{
			super();

			netConnectionFactory = factory || new NetConnectionFactory();
			addListenersToFactory();
		}
		
		/**
		 * @private
		 * 
		 * The NetLoader returns true for URLResources which support the media and mime-types
		 * (or file extensions) for streaming audio and streaming or progressive video, or
		 * implement one of the following schemes: http, https, file, rtmp, rtmpt, rtmps,
		 * rtmpe or rtmpte.
		 * 
		 * @param resource The URL of the source media.
		 * @return Returns <code>true</code> for URLResources which it can load
		 * @inheritDoc
		**/
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			var rt:int = MetadataUtils.checkMetadataMatchWithResource(resource, MEDIA_TYPES_SUPPORTED, MimeTypes.SUPPORTED_VIDEO_MIME_TYPES);
			if (rt != MetadataUtils.METADATA_MATCH_UNKNOWN)
			{
				return rt == MetadataUtils.METADATA_MATCH_FOUND;
			}			

			/*
			 * The rules for URL checking is outlined as below:
			 * 
			 * If the URL is null or empty, we assume being unable to handle the resource
			 * If the URL has no protocol, we check for file extensions
			 * If the URL has protocol, we have to make a distinction between progressive and stream
			 * 		If the protocol is progressive (file, http, https), we check for file extension
			 *		If the protocol is stream (the rtmp family), we assume that we can handle the resource
			 *
			 * We assume being unable to handle the resource for conditions not mentioned above
			 */
			var res:URLResource = resource as URLResource;
			if (res == null || res.url == null || res.url.rawUrl == null || res.url.rawUrl.length <= 0)
			{
				return false;
			}
			if (res.url.protocol == "")
			{
				return res.url.path.search(/\.flv$|\.f4v$|\.mov$|\.mp4$|\.mp4v$|\.m4v$|\.3gp$|\.3gpp2$|\.3g2$/i) != -1;
			}
			if (NetStreamUtils.isRTMPStream(res.url))
			{
				return true;
			}
			if (res.url.protocol.search(/file$|http$|https$/i) != -1)
			{
				return (res.url.path == null ||
						res.url.path.length <= 0 ||
						res.url.path.indexOf(".") == -1 ||
						res.url.path.search(/\.flv$|\.f4v$|\.mov$|\.mp4$|\.mp4v$|\.m4v$|\.3gp$|\.3gpp2$|\.3g2$/i) != -1);
			}
			
			return false;
		}
		
		/**
		 *
		 * The factory function for creating a NetStream.
		 * 
		 * @param connection The NetConnnection to associate with the new NetStream.
		 * @param loadTrait The LoadTrait instance requesting this NetStream. Developers of custom NetStreams can use this 
		 * LoadTrait reference to dispatch custom media errors against the LoadTrait.
		 * 
		 * @return a new NetStream associated with the NetConnection.
		**/
		protected function createNetStream(connection:NetConnection, loadTrait:LoadTrait):NetStream
		{
			return new NetStream(connection);
		}

		/**
		 * The factory function for creating a NetStreamSwitchManager.
		 * 
		 * @param connection The NetConnection that's associated with the NetStreamSwitchManager.
		 * @param netStream The NetStream upon which the NetStreamSwitchManager will operate.
		 * @param loadTrait The LoadTrait instance requesting this NetStreamSwitchManager. Developers
		 * of custom NetStreamSwitchManagers can use this LoadTrait reference to dispatch custom media
		 * errors against the LoadTrait.
		 * 
		 * @return null if multi-bitrate switching is not enabled for the NetStream returned by
		 * createNetStream.
		 **/
		protected function createNetStreamSwitchManager(connection:NetConnection, netStream:NetStream, loadTrait:LoadTrait):NetStreamSwitchManager
		{
			return null;
		}
		
		/**
		 * The factory function for creating a DVRTrait
		 *
		 * @param resource 
		 * @param connection
		 * @param stream
		 * @return 
		 * 
		 */		 		
		protected function createDvrTrait(resource:MediaResourceBase, connection:NetConnection, stream:NetStream):DVRTrait
		{
			return null;
		}

		/**
		 * @private
		 * 
		 * Validates the LoadTrait to verify that this class can in fact load it. Examines the protocol
		 * associated with the LoadTrait's resource. If the protocol is HTTP, calls the <code>startLoadingHTTP()</code>
		 * method. If the protocol is RTMP-based, calls the  <code>startLoadingRTMP()</code> method. If the URL protocol is invalid,
		 * dispatches a mediaErroEvent against the LoadTrait and updates the LoadTrait's state to LoadState.LOAD_ERROR.
	     *
	     * @param loadTrait LoadTrait requesting this load operation.
	     * @see org.osmf.traits.LoadTrait
	     * @see org.osmf.traits.LoadState
	     * @see org.osmf.events.MediaErrorEvent
		 * @inheritDoc
		**/
		override protected function executeLoad(loadTrait:LoadTrait):void
		{	
			updateLoadTrait(loadTrait, LoadState.LOADING);
			switch ((loadTrait.resource as URLResource).url.protocol)
			{
				case PROTOCOL_RTMP:
				case PROTOCOL_RTMPS:
				case PROTOCOL_RTMPT:
				case PROTOCOL_RTMPE:
				case PROTOCOL_RTMPTE:
					startLoadingRTMP(loadTrait);
					break;
				case PROTOCOL_HTTP:
				case PROTOCOL_HTTPS:
				case PROTOCOL_FILE:
				case PROTOCOL_EMPTY: 
					startLoadingHTTP(loadTrait);
					break;
				default:
					updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
					loadTrait.dispatchEvent
						( new MediaErrorEvent
							( MediaErrorEvent.MEDIA_ERROR
							, false
							, false
							, new MediaError(MediaErrorCodes.INVALID_URL_PROTOCOL)
							)
						);
					break;
			}
		}
		
		/**
		 * @private
		 * 
	     * Unloads the media after validating the unload operation against the LoadTrait.
	     * Closes the NetStream defined within the NetStreamLoadTrait object. 
	     * If the shareable property of the object is true, calls the NetConnectionFactory to close() the NetConnection
	     * otherwise closes the NetConnection directly. Dispatches the loadStateChange event with every state change.
	     * 
	     * @throws IllegalOperationError if the parameter is <code>null</code>.
	     * @param loadTrait LoadTrait to be unloaded.
	     * @see org.osmf.loaders.LoaderBase#event:loadStateChange	
		**/
		override protected function executeUnload(loadTrait:LoadTrait):void
		{
			var netLoadTrait:NetStreamLoadTrait = loadTrait as NetStreamLoadTrait;			
			
			updateLoadTrait(loadTrait, LoadState.UNLOADING); 			
			netLoadTrait.netStream.close();
			if (netLoadTrait.shareable)
			{
				netLoadTrait.netConnectionFactory.closeNetConnectionByResource(netLoadTrait.resource as URLResource);
			}		
			else
			{
				netLoadTrait.connection.close();
			}	
			updateLoadTrait(loadTrait, LoadState.UNINITIALIZED); 				
		}
		
		/**
		 *  Establishes a new NetStream on the connected NetConnection and signals that loading is complete.
		 *
		 *  @private
		**/
		private function finishLoading(connection:NetConnection, loadTrait:LoadTrait, shareable:Boolean = false, factory:NetConnectionFactory = null):void
		{
			var netLoadTrait:NetStreamLoadTrait = loadTrait as NetStreamLoadTrait;
			
			netLoadTrait.connection = connection;
			var netStream:NetStream = createNetStream(connection, netLoadTrait);				
			netStream.client = new NetClient();
			netLoadTrait.netStream = netStream;
			netLoadTrait.switchManager = createNetStreamSwitchManager(connection, netStream, netLoadTrait);
			netLoadTrait.dvrTrait = createDvrTrait(loadTrait.resource, connection, netStream);
			netLoadTrait.shareable = shareable;
			netLoadTrait.netConnectionFactory = factory;
			
			updateLoadTrait(loadTrait, LoadState.READY);
		}	
		
		/**
		 * Initiates the process of creating a connected NetConnection
		 * 
		 * @private
		 */
		private function startLoadingRTMP(loadTrait:LoadTrait):void
		{
			addPendingLoad(loadTrait);
			
			netConnectionFactory.createNetConnection(loadTrait.resource as URLResource);
		}
		
		/**
		 * Called once the NetConnectionFactory has successfully created a NetConnection
		 * 
		 * @private
		 */
		private function onCreated(event:NetConnectionFactoryEvent):void
		{
			finishLoading
				( event.netConnection
				, findAndRemovePendingLoad(event.resource)
				, event.shareable
				, event.currentTarget as NetConnectionFactory
				);
		}
		
		/**
		 * Called once the NetConnectionFactory has failed to create a NetConnection
		 * TBD - error dispatched at lower level.
		 * 
		 * @private
		 */
		private function onCreationFailed(event:NetConnectionFactoryEvent):void
		{
			var loadTrait:LoadTrait = findAndRemovePendingLoad(event.resource);
			loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, event.mediaError));
			updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
		}
		
		/**
		 * Initiates a HTTP connection.
		 * 
		 * @private
		 * 
		 */
		private function startLoadingHTTP(loadTrait:LoadTrait):void
		{
			var connection:NetConnection = new NetConnection();
			connection.client = new NetClient();
			connection.connect(null);
			finishLoading(connection, loadTrait);
		}
		
		private function addListenersToFactory():void
		{
			netConnectionFactory.addEventListener(NetConnectionFactoryEvent.CREATED, onCreated);
			netConnectionFactory.addEventListener(NetConnectionFactoryEvent.CREATION_FAILED, onCreationFailed);
		}
		
		private function addPendingLoad(loadTrait:LoadTrait):void
		{
			// It's an edge case, but we don't want to assume that we'll never
			// have two LoadTraits that use the same URLResource, so we have to
			// maintain an Array.
			if (pendingLoads[loadTrait.resource] == null)
			{
				pendingLoads[loadTrait.resource] = [loadTrait];
			}
			else
			{
				pendingLoads[loadTrait.resource].push(loadTrait);
			}
		}
		
		private function findAndRemovePendingLoad(resource:URLResource):LoadTrait
		{
			var loadTrait:LoadTrait;
			
			var pendingLoadsArray:Array = pendingLoads[resource];
			if (pendingLoadsArray.length == 1)
			{
				loadTrait = pendingLoadsArray[0] as LoadTrait;
				delete pendingLoads[resource];
			}
			else
			{
				for (var i:int = 0; i < pendingLoadsArray.length; i++)
				{
					loadTrait = pendingLoadsArray[i];
					if (loadTrait.resource == resource)
					{
						pendingLoadsArray.splice(i, 1);
						break;
					}
				}
			}

			return loadTrait;
		}

		private var netConnectionFactory:NetConnectionFactoryBase;
		private var pendingLoads:Dictionary = new Dictionary();
		
		private static const PROTOCOL_RTMP:String = "rtmp";
		private static const PROTOCOL_RTMPS:String = "rtmps";
		private static const PROTOCOL_RTMPT:String = "rtmpt";
		private static const PROTOCOL_RTMPE:String = "rtmpe";
		private static const PROTOCOL_RTMPTE:String = "rtmpte";
		private static const PROTOCOL_HTTP:String = "http";
		private static const PROTOCOL_HTTPS:String = "https";
		private static const PROTOCOL_FILE:String = "file";
		private static const PROTOCOL_EMPTY:String = "";
				
		private static const MEDIA_TYPES_SUPPORTED:Vector.<String> = Vector.<String>([MediaType.VIDEO]);
	}
}

