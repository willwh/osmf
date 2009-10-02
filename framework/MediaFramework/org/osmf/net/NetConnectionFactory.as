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
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.NetConnection;
	import flash.utils.Dictionary;
	
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.NetConnectionFactoryEvent;
	import org.osmf.events.NetNegotiatorEvent;
	import org.osmf.media.IURLResource;
	import org.osmf.traits.ILoadable;
	import org.osmf.utils.FMSURL;

	/**
	 * Dispatched when the factory has successfully created and connected a NetConnection
	 *
	 * @eventType org.osmf.events.NetConnectionFactoryEvent.CREATED
	 * 
	 **/
	[Event(name="created", type="org.osmf.events.NetConnectionFactoryEvent")]
	
	/**
	 * Dispatched when the factory has failed to create and connect a NetConnection
	 *
	 * @eventType org.osmf.events.NetConnectionFactoryEvent.CREATION_FAILED
	 * 
	 **/
	[Event(name="creationfailed", type="org.osmf.events.NetConnectionFactoryEvent")]
	
	/**
	 * The NetConnectionFactory class is used to generate connected NetConnection instances
	 * and to manage sharing of these instances between multiple ILoadables. This class is stateless. 
	 * Multiple parallel create() requests may be made. Concurrent requests to the same URL by disparate ILoadables
	 * are handled efficiently with only a single NetNegotiation instance being used. A hash of the resource URL is used as a key
	 * to determine which NetConnections may be shared. 
	 * 
	 * @see NetNegotiator
	 * 
	 */
	public class NetConnectionFactory extends EventDispatcher
	{
		/**
		 * Constructor
		 * 
		 */
		public function NetConnectionFactory(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * Begins the process of creating a new NetConnection.  The method creates two dictionaries to help it 
		 * manage previously shared connections as well as pending connections. Only if a NetConenction is not shareable
		 * and not pending is a new connection sequence initiated via a new NetNegotiator instance.
		 * <p/>
		 * If this method receives a CONNECTION_FAILED event back from a NetNegotiator, it will dispatch the appropriate 
		 * MediaErrorEvent against the associated ILoadable.
		 * 
		 * @param loadable the ILoadable that requires the NetConnection
		 * @param allowNetConnectionSharing Boolean specifying whether the NetConnection may be shared or not
		 * 
		 * @see org.osmf.events.MediaErrorEvent;
		 * @see org.osmf.events.MediaError
		 * @see NetNegotiator
		 */
		public function create(loadable:ILoadable,allowNetConnectionSharing:Boolean):void
		{
			var urlResource:IURLResource = loadable.resource as IURLResource;
			var key:String = extractKey(urlResource);
			// The first time this method is called, we create our dictionaries.
			if (connectionDictionary == null)
			{
				connectionDictionary = new Dictionary();
				pendingDictionary = new Dictionary();
			}
			var sharedConnection:SharedConnection = connectionDictionary[key] as SharedConnection;
			var connectionsUnderway:Vector.<PendingConnection> = pendingDictionary[key] as Vector.<PendingConnection>;
			// Check to see if we already have this connection ready to be shared.
			if ( sharedConnection != null && allowNetConnectionSharing)
			{
				sharedConnection.count++;
				dispatchEvent(new NetConnectionFactoryEvent(NetConnectionFactoryEvent.CREATED, sharedConnection.netConnection, loadable, true));
			} 
			// Check to see if there is already a connection attempt pending on this resource.
			else if (connectionsUnderway != null)
			{
				// Add this loadable to the vector of loadables to be notified once the connection has either succeeded or failed
				connectionsUnderway.push(new PendingConnection(loadable,allowNetConnectionSharing));
			}
			// If no connection is shareable or pending, then initiate a new connection attempt.
			else
			{
				// Add this connection to the list of pending connections
				var pendingConnections:Vector.<PendingConnection> = new Vector.<PendingConnection>();
				pendingConnections.push(new PendingConnection(loadable,allowNetConnectionSharing));
				pendingDictionary[key] = pendingConnections;
				
				// Create a new NetNegotiator to perform the connection attempts
				var negotiator:NetNegotiator  = createNetNegotiator();
				negotiator.addEventListener(NetNegotiatorEvent.CONNECTED, onConnected);
				negotiator.addEventListener(NetNegotiatorEvent.CONNECTION_FAILED, onConnectionFailed);
				negotiator.connect(urlResource);
	
				// Catch the connected event coming back from the NetNegotiator
				function onConnected(event:NetNegotiatorEvent):void
				{
					negotiator.removeEventListener(NetNegotiatorEvent.CONNECTED, onConnected);
					negotiator.removeEventListener(NetNegotiatorEvent.CONNECTION_FAILED, onConnectionFailed);
					// Dispatch an event for each pending loadable
					var pendingConnections:Vector.<PendingConnection> = pendingDictionary[key];
					for (var i:Number=0; i< pendingConnections.length; i++)
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
						dispatchEvent(new NetConnectionFactoryEvent(NetConnectionFactoryEvent.CREATED,event.netConnection,pendingConnection.loadable,pendingConnection.shareable));
					}
					delete pendingDictionary[key];
				}
				
				// Catch the failed event coming back from the NetNegotiator
				function onConnectionFailed(event:NetNegotiatorEvent):void
				{
					negotiator.removeEventListener(NetNegotiatorEvent.CONNECTED, onConnected);
					negotiator.removeEventListener(NetNegotiatorEvent.CONNECTION_FAILED, onConnectionFailed);
					// Dispatch an event for each pending loadable
					var pendingConnections:Vector.<PendingConnection> = pendingDictionary[key];
					for (var i:Number=0; i< pendingConnections.length; i++)
					{
						if (event.mediaError != null)
						{
							loadable.dispatchEvent(new MediaErrorEvent(event.mediaError));
						}
						dispatchEvent(new NetConnectionFactoryEvent(NetConnectionFactoryEvent.CREATION_FAILED,null,loadable));
					}
					delete pendingDictionary[key];
				}
			}
		}
		
		/**
		 * Manages the closing of a shared NetConnection using the resource as the key. NetConnections
		 * are only physically closed after the last sharer has requested a close().
		 * 
		 * @param resource the IURLresource originally used to establish the NetConenction
		 */
		public function closeNetConnectionByResource(resource:IURLResource):void
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
		 */
		protected function createNetNegotiator():NetNegotiator
		{
			return new NetNegotiator();
		}
		
		/**
		 * Generates a key to uniquely identify each connection. 
		 * 
		 * @param resource a IURLResource
		 * @return a String hash that uniquely identifies the NetConnection
		 */
		protected function extractKey(resource:IURLResource):String
		{
			var fmsURL:FMSURL = resource is FMSURL ? resource as FMSURL : new FMSURL(resource.url.rawUrl);
			return fmsURL.protocol + fmsURL.host + fmsURL.port + fmsURL.appName;
		}
		
		private var connectionDictionary:Dictionary;
		private var pendingDictionary:Dictionary;
	}
}

import flash.net.NetConnection;
import org.osmf.traits.ILoadable;

/**
 * Utility class for structuring shared connection data
 *
 */
class SharedConnection
{
	public var count:Number;
	public var netConnection:NetConnection	
}

/**
 * Utility class for structuring pending connection data
 *
 */
class PendingConnection
{
	public function PendingConnection(loadable:ILoadable,shareable:Boolean)
	{
		_loadable = loadable;
		_shareable = shareable;
	}
	public function get loadable():ILoadable
	{
		return _loadable;
	}
	public function get shareable():Boolean
	{
		return _shareable;
	}
	private var _loadable:ILoadable;
	private  var _shareable:Boolean;	
}
