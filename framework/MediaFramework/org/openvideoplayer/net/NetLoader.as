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

package org.openvideoplayer.net
{
	
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import org.openvideoplayer.loaders.LoaderBase;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.net.NetConnectionAttempt;

	/**
	 * The NetLoader class implements ILoader to provide
	 * loading support to the AudioElement and VideoElement classes.
	 * <p>Supports both streaming and progressive media resources.
	 * If the resource URL is RTMP, connects to an RTMP server.
	 * If the resource URL is HTTP, performs a <code>connect(null)</code>
	 * for progressive downloads.</p>
	 * <p>For streaming connections, port/protocol negotiation is automatically performed. This means
	 * that multiple NetConnection attempts are made with differing port/protocol combinations. The first 
	 * conection to succeed is accepted and any pending connection attempts are closed. The purpose of such
	 * a negotation scheme is to quickly find the best path through any firewalls and proxy servers which may sit
	 * between the client and server.</p>
	 * 
	 * @see NetLoadedContext
	 * @see flash.net.NetConnection
	 */
	public class NetLoader extends LoaderBase
	{
		/**
		 * Constructor
		**/
		public function NetLoader()
		{
			super();
		}
				
		/**
		 * 	For an HTTP URL, performs a <code>connect(null)</code> for progressive download.
	     *	<p>For an RTMP URL, creates a NetConnection and connects to the RTMP server. A port/protocol
	     *  negotiation process will be followed in order to find a good connection through a proxy server
	     *  and/or firewall.</p>
	     * 	<p>Parses the URL of the resource to be loaded obtained from the 
	     *	ILoadable's <code>resource</code> property.</p>
	     * 	<p>Creates a NetStream and loads the media to the specified ILoadable.
	     * 	Updates the load state of the ILoadable.
	     * 	Dispatches the loaderStateChange event with every state change.</p>
	     * 	<p>If the ILoadable's LoadState is LOADING or LOADED when the <code>load()</code>
	     * 	method is called, throws an error.</p>
	     * 	<p>Upon successful completion of the load operation, creates a new NetLoadedContext object
	     *  referencing the NetConnection and the NetStream.</p>
	     * 
	     *  @param ILoadable ILoadable trait requesting this load operation.
	     *  @see flash.net.NetConnection
	     * 	@see NetLoadedContext
	     * 	@see org.openvideoplayer.traits.ILoadable
	     * 	@see org.openvideoplayer.traits.LoadState
		 *  @inheritDoc
		**/
		override public function load(loadable:ILoadable):void
		{	
			validateLoad(loadable);
			updateLoadable(loadable, LoadState.LOADING);
			switch ((loadable.resource as IURLResource).url.protocol)
			{
				case PROTOCOL_RTMP:
				case PROTOCOL_RTMPS:
				case PROTOCOL_RTMPT:
				case PROTOCOL_RTMPE:
				case PROTOCOL_RTMPTE:
					startRTMPConnection(loadable);
					break;
				case PROTOCOL_HTTP:
				case PROTOCOL_HTTPS:
				case PROTOCOL_FILE:
				case PROTOCOL_EMPTY: 
					startHTTPConnection(loadable);
					break;
				default:
					updateLoadable(loadable, LoadState.LOAD_FAILED);
					break;
			}
		}
		
		/**
	     *  Unloads the media.
	     *  <p>For streaming URLs, closes the NetConnection's loader. </p>
	     * 	<p>Dispatches the loaderStateChange event with every state change.</p>
	     * 	@param ILoadable ILoadable to be unloaded.
	     * 	@see org.openvideoplayer.loaders.LoaderBase#event:loaderStateChange	
		**/
		override public function unload(loadable:ILoadable):void
		{
			validateUnload(loadable);	
			var ctx:NetLoadedContext = loadable.loadedContext as NetLoadedContext;
			if (ctx == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			else
			{
				updateLoadable(loadable, LoadState.UNLOADING, loadable.loadedContext);	
				ctx.stream.close();						
				ctx.connection.close();		
				updateLoadable(loadable, LoadState.CONSTRUCTED);	
			}		
		}
		
		/** 
		 * The server connection attempt timeout in milliseconds. If a successful connection has 
		 * not been established within this time period, the loader will be deemed to have failed.
		 * 
		 * @default 10000
		 * @returns the timeout value in milliseconds
		 */
		public function get timeout():Number 
		{
			return _timeout;
		}
		
		public function set timeout(value:Number):void 
		{
			_timeout = value;
			if (timeOutTimer != null && timeOutTimer.running)
			{
				timeOutTimer.delay = _timeout;
			}
		}
		
		/**
		 * The NetLoader returns true for IURLResources which implement one
		 * of the following schemes: http, https, file, rtmp, rtmpt, rtmps, rtmpe or rtmpte.
		 * 
		 * @param resource The URL of the source media.
		 * @return Returns <code>true</code> for IURLResources.
		 * @inheritDoc
		**/
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			
			var res:IURLResource = resource as IURLResource;
			if (res != null && 
				res.url != null && 
				res.url.rawUrl != null && 
				res.url.protocol == "")
			{
				return res.url.rawUrl.indexOf(MP3_EXTENSION) != -1;
			}
			else
			{
				return( res != null &&
						res.url != null && 
						res.url.protocol != null &&
						res.url.protocol.search(/file$|http$|https$|rtmp$|rtmp[tse]$|rtmpte$/i) != -1
						);	
			}
		}
		

		/**
		 *  The factory function for creating a NetConnection.  Allows third party plugins to create custom net connections.
		 *
		 *  @return An unconnected NetConnection.
	     * 	@see flash.net.NetConnection
		 **/
		protected function createNetConnection():NetConnection
		{
			return new NetConnection();
		}

		/**
		 *  The factory function for creating a NetStream.  Allows third party plugins to create custom net streams.
		 *
		 *  @param connection the NetConnnection to associate with the new NetStream.
		 *  @return a new NetStream associated with the NetConnection.
		**/
		protected function createNetStream(connection:NetConnection):NetStream
		{
			return new NetStream(connection);
		}
		
		/**
		 *  Establishes a new NetStream on the connected NetConnection and signals that loading is complete.
		 *
		 *  @param connection the connected NetConnnection to associate with the new NetStream.
		 *  @param loadable the loadable to update.
		 * 
		**/
		protected function finishConnection(connection:NetConnection, loadable:ILoadable):void
		{
			var stream:NetStream = createNetStream(connection);				
			stream.client = new NetClient();	
			loadable.loadedContext = new NetLoadedContext(connection, stream);					
			updateLoadable(loadable, LoadState.LOADED, loadable.loadedContext);		
		}	
		
		/** 
		 * Assembles a vector of NetConnection Objects to be used during the connection attempted.
		 * The default protocols attempted when a "rtmp" conection is specified are 
		 * "rtmp","rtmps", and "rtmpt". When a "rtmpe" connection is requested, both "rtmpe"
		 * and rtmpte" protocols are attempted. When "rtmps","rtmpt" or "rtmpte" are requested,
		 * only those protocls are attempted. The default ports are 1935, 443 and 80. If a specific port
		 * is specified in the URLResource, then only that port is used.  
		 * 
		 * @param url the URL to be loaded
		 * @returns a Vector of NetConnectionAttempt objects. 
		 */
		protected function buildPortProtocolSequence(url:URL):Vector.<NetConnectionAttempt>  {
			var portProtocols:Vector.<NetConnectionAttempt> = new Vector.<NetConnectionAttempt>;
			var allowedPorts:String = (url.port == "") ? DEFAULT_PORTS: url.port;
			var allowedProtocols:String;
			switch (url.protocol)
			{
				case PROTOCOL_RTMP:
					allowedProtocols = DEFAULT_PROTOCOLS_FOR_RTMP;
					break;
				case PROTOCOL_RTMPE:
					allowedProtocols = DEFAULT_PROTOCOLS_FOR_RTMPE;
					break;
				case PROTOCOL_RTMPS:
				case PROTOCOL_RTMPT:
				case PROTOCOL_RTMPTE:
					allowedProtocols = url.protocol;
					break;
			}
			var portArray:Array = allowedPorts.split(",");
			var protocolArray:Array = allowedProtocols.split(",");
			for (var i:int = 0; i < protocolArray.length; i++)
			{
				for (var j:int = 0; j < portArray.length; j++)
				{
					var attempt:NetConnectionAttempt = new NetConnectionAttempt();
					attempt.protocol = protocolArray[i];
					attempt.port = portArray[j];
					portProtocols.push(attempt);
				}
			} 
			return portProtocols;
		}
		
		/**
		 * Assembles a connection address. Note: this invocation of FMSURL will apply the default contructor argument of useInstance = false.
		 * This means that an instance name will not be extracted from the URLResource.
		 * If you are connecting to a FMS server which requires the use of named instances during connection,
		 * then modify this method to use <code>var fmsUrl:FMSURL = new FMSURL(url,true);</code>.
		 * 
		 * @param url the URL to be loaded
		 * @param protocol the protocol as a String
		 * @param port the port as a String
		 */
		protected function buildConnectionAddress(url:URL, protocol:String, port:String):String
		{
			var fmsUrl:FMSURL = new FMSURL(url);
			return protocol + "://" + url.host + ":" + port + "/" + fmsUrl.appName;
		}
		
		/**
		 * Initiates a RTMP connection using port/protocol negotiation.
		 * 
		 * @private
		 **/
		private function startRTMPConnection(loadable:ILoadable):void
		{
			_loadable = loadable;
			connectionAttempts = getConnectionSequence((loadable.resource as IURLResource).url);
			initializeConnectionAttempts();
			tryToConnect(null); 
		}
		
		/**
		 * Initiates a HTTP connection.
		 * 
		 * @private
		 * 
		 **/
		private function startHTTPConnection(loadable:ILoadable):void
		{
			var connection:NetConnection = createNetConnection();
			connection.client = new NetClient();
			connection.connect(null);
			finishConnection(connection,loadable);
		}
		
		/** 
		 * Initializers properties and timers used during rtmp connection attempts.
		 * @private
		 */
		private function initializeConnectionAttempts():void
		{
			// Master timeout
			timeOutTimer = new Timer(_timeout,1);
			timeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,masterTimeout);
			timeOutTimer.start();
			// Individual attempt sequencer
			connectionTimer = new Timer(CONNECTION_ATTEMPT_INTERVAL);
			connectionTimer.addEventListener(TimerEvent.TIMER,tryToConnect);
			connectionTimer.start();
			// Initialize counters and vectors
			failedConnectionCount = 0;
			attemptIndex = 0;
			netConnections = new Vector.<NetConnection>;
		}

		
		/** 
		 * Attempts to connect to FMS using a particular connection string
		 * @private
		 */
		private function tryToConnect(evt:TimerEvent):void 
		{
			netConnections[attemptIndex] = createNetConnection();
			netConnections[attemptIndex].addEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false,0,true);
    		netConnections[attemptIndex].addEventListener(SecurityErrorEvent.SECURITY_ERROR,onNetSecurityError,false,0,true);
    		netConnections[attemptIndex].addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncError,false,0,true);
			netConnections[attemptIndex].client = new NetClient();
			try 
			{
				netConnections[attemptIndex].connect((connectionAttempts[attemptIndex] as  NetConnectionAttempt).address);
				attemptIndex++;
				if (attemptIndex >= connectionAttempts.length) 
				{
					connectionTimer.stop();
				}
			}
			catch (error:Error) 
			{
				handleFailedConnectionSession();
			}
		}
		
		/** 
		 * Monitors status events from the NetConnections
		 * @private
		 */
		private function onNetStatus(event:NetStatusEvent):void 
		{
			switch (event.info.code) 
			{
				case NetConnectionCodes.CONNECT_INVALIDAPP:
				case NetConnectionCodes.CONNECT_REJECTED:
					handleFailedConnectionSession();
    				break;
    			case NetConnectionCodes.CONNECT_FAILED:
    				failedConnectionCount++;
    				if (failedConnectionCount >= connectionAttempts.length) 
    				{
    					handleFailedConnectionSession();
    				}
    				break;
				case NetConnectionCodes.CONNECT_SUCCESS:
					shutDownUnsuccessfullConnections();
					finishConnection(event.target as NetConnection,_loadable);
					break;
			}
		}

  		/** 
		 * Closes down all parallel connections in the netConnections vector which are not connected.
		 * Also shuts down the master timeout and attempt timers. 
		 * @private
		 */
		private function shutDownUnsuccessfullConnections():void
		{
			timeOutTimer.stop();
			connectionTimer.stop();
			for (var i:int = 0; i<netConnections.length; i++) 
			{
				var nc:NetConnection = netConnections[i];
				if (!nc.connected)
				{
					nc.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
					nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onNetSecurityError);
					nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncError);
					nc.close();
					nc = null;
				}
			}
		}

		/** 
		 * Handles a failed connection session.
		 * @private
		 */
		private function handleFailedConnectionSession():void
		{
			shutDownUnsuccessfullConnections();
			updateLoadable(_loadable, LoadState.LOAD_FAILED);
		}
		
		/** 
		 * Catches any netconnection net security errors
		 * @private
		 */
		private function onNetSecurityError(event:SecurityErrorEvent):void
		{
			handleFailedConnectionSession();
		}

    	/** 
    	 * Catches any async errors
    	 * @private
    	 */
		private function onAsyncError(event:AsyncErrorEvent):void 
		{
			handleFailedConnectionSession();
		}

		/** 
		 * Catches the master timeout when no connections have succeeded within _timeout.
		 * @private
		 */
		private function masterTimeout(event:TimerEvent):void 
		{
			handleFailedConnectionSession();
		}
		
		/** 
		 * Builds a vector of connection attempt objects
		 * 
		 * @private
		 */
		private function getConnectionSequence(url:URL):Vector.<NetConnectionAttempt> 
		{
			var portProtocols:Vector.<NetConnectionAttempt> = buildPortProtocolSequence(url);
			var connectionAttempts:Vector.<NetConnectionAttempt> = new Vector.<NetConnectionAttempt>();
			for (var i:int = 0; i<portProtocols.length; i++) 
			{
				var attempt:NetConnectionAttempt= new NetConnectionAttempt();
				attempt.address = buildConnectionAddress(url, portProtocols[i].protocol, portProtocols[i].port);
				attempt.port = portProtocols[i].port;
				attempt.protocol = portProtocols[i].protocol;
				connectionAttempts.push(attempt);
			}
			return connectionAttempts;
		}
		
		private var connectionAttempts:Vector.<NetConnectionAttempt>;
		private var netConnections:Vector.<NetConnection>;
		private var failedConnectionCount:int;
		private var timeOutTimer:Timer;
		private var connectionTimer:Timer;
		private var attemptIndex:int;
		private var _timeout:Number = DEFAULT_TIMEOUT;	
		private var _loadable:ILoadable;
		
		private static const DEFAULT_TIMEOUT:Number = 10000;
		private static const DEFAULT_PORTS:String = "1935,443,80";
		private static const DEFAULT_PROTOCOLS_FOR_RTMP:String = "rtmp,rtmps,rtmpt"
		private static const DEFAULT_PROTOCOLS_FOR_RTMPE:String = "rtmpe,rtmpte";
		private static const CONNECTION_ATTEMPT_INTERVAL:Number = 50;
		
		private static const PROTOCOL_RTMP:String = "rtmp";
		private static const PROTOCOL_RTMPS:String = "rtmps";
		private static const PROTOCOL_RTMPT:String = "rtmpt";
		private static const PROTOCOL_RTMPE:String = "rtmpe";
		private static const PROTOCOL_RTMPTE:String = "rtmpte";
		private static const PROTOCOL_HTTP:String = "http";
		private static const PROTOCOL_HTTPS:String = "https";
		private static const PROTOCOL_FILE:String = "file";
		private static const PROTOCOL_EMPTY:String = "";
		private static const MP3_EXTENSION:String = ".mp3";
	}
	
}
