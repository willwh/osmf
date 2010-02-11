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
	CONFIG::LOGGING 
	{	
		import org.osmf.logging.ILogger;
	}
	
	import __AS3__.vec.Vector;
	
	import flash.net.NetConnection;
	import flash.utils.Dictionary;
	
	import org.osmf.events.NetConnectionFactoryEvent;
	import org.osmf.events.NetNegotiatorEvent;
	import org.osmf.media.URLResource;
	import org.osmf.utils.FMSURL;
	
	/**
	 * The NetConnectionFactory class is used to generate connected NetConnection
	 * instances and to manage sharing of these instances.  The NetConnectionFactory
	 * uses a NetNegotiator to handle port/protocol negotiation.
	 * 
	 * <p>NetConnectionFactory is stateless. Multiple parallel createNetConnection()
	 * requests may be made. Concurrent requests to the same URL are handled
	 * efficiently by a single NetNegotiatior per request.  A hash of the resource
	 * URL is used as a key to determine which NetConnections may be shared.</p>
	 * 
	 * @see NetNegotiator
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class NetConnectionFactory extends NetConnectionFactoryBase
	{
		/**
		 * Constructor.
		 * 
		 * @param allowNetConnectionSharing Boolean specifying whether created NetConnections
		 * may be shared or not.  The default is true.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function NetConnectionFactory(allowNetConnectionSharing:Boolean=true)
		{
			super();
			
			this.allowNetConnectionSharing = allowNetConnectionSharing;
		}
		
		/**
		 * @private
		 * 
		 * Begins the process of creating a new NetConnection.  The method creates two dictionaries to help it 
		 * manage previously shared connections as well as pending connections. Only if a NetConnection is not shareable
		 * and not pending is a new connection sequence initiated via a new NetNegotiator instance.
		 * <p/>
		 * 
		 * @see NetNegotiator
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function createNetConnection(resource:URLResource):void
		{
			var key:String = extractKey(resource);
			
			// The first time this method is called, we create our dictionaries.
			if (connectionDictionary == null)
			{
				connectionDictionary = new Dictionary();
				pendingDictionary = new Dictionary();
			}
			var sharedConnection:SharedConnection = connectionDictionary[key] as SharedConnection;
			var connectionsUnderway:Vector.<PendingConnection> = pendingDictionary[key] as Vector.<PendingConnection>;
			
			// Check to see if we already have this connection ready to be shared.
			if (sharedConnection != null && allowNetConnectionSharing)
			{
				CONFIG::LOGGING
				{
					logger.info("Reusing shared NetConnection: " + sharedConnection.netConnection.uri);
				}

				sharedConnection.count++;
				dispatchEvent
					( new NetConnectionFactoryEvent
						( NetConnectionFactoryEvent.CREATED
						, false
						, false
						, sharedConnection.netConnection
						, resource
						, true
						)
					);
			} 
			// Check to see if there is already a connection attempt pending on this resource.
			else if (connectionsUnderway != null)
			{
				// Add this resource to the vector of resources to be notified once the
				// connection has either succeeded or failed.
				connectionsUnderway.push(new PendingConnection(resource, allowNetConnectionSharing));
			}
			// If no connection is shareable or pending, then initiate a new connection attempt.
			else
			{
				// Add this connection to the list of pending connections
				var pendingConnections:Vector.<PendingConnection> = new Vector.<PendingConnection>();
				pendingConnections.push(new PendingConnection(resource, allowNetConnectionSharing));
				pendingDictionary[key] = pendingConnections;
				
				// Perform the connection attempt
				var negotiator:NetNegotiator = createNetNegotiator();
				negotiator.addEventListener(NetNegotiatorEvent.CONNECTED, onConnected);
				negotiator.addEventListener(NetNegotiatorEvent.CONNECTION_FAILED, onConnectionFailed);
				negotiator.connect(resource);
				
				function onConnected(event:NetNegotiatorEvent):void
				{
					CONFIG::LOGGING 
					{	
						logger.info("NetConnection established with: " + event.netConnection.uri);
					}

					negotiator.removeEventListener(NetNegotiatorEvent.CONNECTED, onConnected);
					negotiator.removeEventListener(NetNegotiatorEvent.CONNECTION_FAILED, onConnectionFailed);
					
					var pendingEvents:Vector.<NetConnectionFactoryEvent> = new Vector.<NetConnectionFactoryEvent>();
					
					// Dispatch an event for each pending LoadTrait.
					var pendingConnections:Vector.<PendingConnection> = pendingDictionary[key];
					for (var i:Number = 0; i < pendingConnections.length; i++)
					{
						var pendingConnection:PendingConnection = pendingConnections[i] as PendingConnection;
						if (pendingConnection.shareable)
						{
							var alreadyShared:SharedConnection = connectionDictionary[key] as SharedConnection;
							if (alreadyShared != null)
							{
								alreadyShared.count++;
							}
							else
							{
								var obj:SharedConnection = new SharedConnection();
								obj.count = 1;
								obj.netConnection = event.netConnection;
								connectionDictionary[key] = obj;
							}
						} 
						
						// We don't dispatch immediately, but add it to a queue.  It's important
						// that we delete the key first, since this event could trigger a subsequent
						// request.
						pendingEvents.push
							( new NetConnectionFactoryEvent
								( NetConnectionFactoryEvent.CREATED
								, false
								, false
								, event.netConnection
								, pendingConnection.resource
								, pendingConnection.shareable
								)
							);
					}
					
					delete pendingDictionary[key];
					
					// Now we're safe, dispatch the events.
					for each (var pendingEvent:NetConnectionFactoryEvent in pendingEvents)
					{
						dispatchEvent(pendingEvent);
					}
				}
				
				function onConnectionFailed(event:NetNegotiatorEvent):void
				{
					CONFIG::LOGGING 
					{
						var fmsURL:FMSURL = resource.url is FMSURL ? resource.url as FMSURL : new FMSURL(resource.url.rawUrl);
						logger.info("NetConnection failed for: " + fmsURL.protocol + "://" + fmsURL.host + (fmsURL.port.length > 0 ? ":" + fmsURL.port : "" ) + "/" + fmsURL.appName + (fmsURL.useInstance ? "/" + fmsURL.instanceName:""));
					}

					negotiator.removeEventListener(NetNegotiatorEvent.CONNECTED, onConnected);
					negotiator.removeEventListener(NetNegotiatorEvent.CONNECTION_FAILED, onConnectionFailed);
		
					// Dispatch an event for each pending resource.
					var pendingConnections:Vector.<PendingConnection> = pendingDictionary[key];
					for (var i:Number=0; i < pendingConnections.length; i++)
					{
						dispatchEvent
							( new NetConnectionFactoryEvent
								( NetConnectionFactoryEvent.CREATION_FAILED
								, false
								, false
								, null
								, resource
								, false
								, event.mediaError
								)
							);
					}
					delete pendingDictionary[key];
				}
			}
		}
		
		/**
		 * Manages the closing of a shared NetConnection using the resource as the key. NetConnections
		 * are only physically closed after the last sharer has requested a close().
		 * 
		 * @param resource the URLResource originally used to establish the NetConenction
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function closeNetConnectionByResource(resource:URLResource):void
		{
			var key:String = extractKey(resource);
			var obj:SharedConnection = connectionDictionary[key] as SharedConnection;
			obj.count--;
			if (obj.count == 0)
			{
				obj.netConnection.close();
				delete connectionDictionary[key];
			}
		}
		
		/**
		 * Override this method to allow the use of a custom NetNegotiator
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function createNetNegotiator():NetNegotiator
		{
			return new NetNegotiator();
		}

		/**
		 * Generates a key to uniquely identify each connection. 
		 * 
		 * @param resource a URLResource
		 * @return a String hash that uniquely identifies the NetConnection
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function extractKey(resource:URLResource):String
		{
			var fmsURL:FMSURL = resource is FMSURL ? resource as FMSURL : new FMSURL(resource.url.rawUrl);
			return fmsURL.protocol + fmsURL.host + fmsURL.port + fmsURL.appName;
		}
		
		private var allowNetConnectionSharing:Boolean;
		private var negotiator:NetNegotiator;
		private var connectionDictionary:Dictionary;
		private var pendingDictionary:Dictionary;
		
		CONFIG::LOGGING
		private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("org.osmf.net.NetConnectionFactory");
	}
}

import flash.net.NetConnection;
import org.osmf.media.URLResource;

/**
 * Utility class for structuring shared connection data.
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion OSMF 1.0
 */
class SharedConnection
{
	public var count:Number;
	public var netConnection:NetConnection;
}

/**
 * Utility class for structuring pending connection data.
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion OSMF 1.0
 */
class PendingConnection
{
	public function PendingConnection(resource:URLResource, shareable:Boolean)
	{
		_resource = resource;
		_shareable = shareable;
	}
	
	public function get resource():URLResource
	{
		return _resource;
	}
	
	public function get shareable():Boolean
	{
		return _shareable;
	}
	
	private var _resource:URLResource;
	private var _shareable:Boolean;
}
