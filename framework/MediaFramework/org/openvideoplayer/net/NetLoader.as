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

	
	/**
	 * The NetLoader class implements ILoader to provide
	 * loading support to the AudioElement and VideoElement classes.
	 * <p>Supports both streaming and progressive media resources.
	 * If the resource URL is RTMP, connects to an RTMP server.
	 * If the resource URL is HTTP, performs a <code>connect(null)</code>
	 * for progressive downloads.</p>
	 * 
	 * @see NetLoadedContext
	 * @see flash.net.NetConnection
	 */
	public class NetLoader extends LoaderBase
	{
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
			switch ((loadable.resource as IURLResource).url.protocol){
				case "rtmp":
				case "rtmps":
				case "rtmpt":
				case "rtmpe":
				case "rtmpte":
					startRTMPConnection(loadable);
				break;
				case "https":
				case "http":
				case "": 
					startHTTPConnection(loadable);
				break;
				default:
					updateLoadable(_loadable, LoadState.LOAD_FAILED);
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
			if (!ctx)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
				return;
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
			return timeOutTimerDelay;
		}
		public function set timeout(value:Number):void 
		{
			timeOutTimerDelay = value;
		}
		
		/** 
		 * Defines whether an instance name should be extracted from the URL resource
		 * when connecting to Flash Media Server. 
		 * 
		 * @default false
		 * @returns true if an instance name should be used.
		 */
		public function get useInstance():Boolean
		{
			return _useInstance;
		}
		public function set useInstance(value:Boolean):void 
		{
			_useInstance = value;
		}
		
		/**
		 * The NetLoader returns true for IURLResources which implement one
		 * of the following schemes: http, https, rtmp, rtmpt, rtmps, rtmpe or rtmpte.
		 * 
		 * @param resource The URL of the source media.
		 * @return Returns <code>true</code> for IURLResources.
		 *  @inheritDoc
		**/
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			
			var res:IURLResource = resource as IURLResource;
			if (res && 
				res.url && 
				res.url.rawUrl && 
				res.url.protocol == "")
			{
				// The only local file type we are required to handle is .mp3
				return res.url.rawUrl.indexOf(".mp3") > 0;
			}
			else
			{
				return( res &&
						res.url && 
						res.url.protocol &&
						res.url.protocol.search(/http$|https$|rtmp$|rtmp[tse]$|rtmpte$/i) != -1
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
		 * Assembles the array of ports and protocols to be attempted.
		 * 
		 * @param url the URL to be loaded
		 * @returns a Vector of ConnectionAttempt objects. 
		 */
		protected function buildPortProtocolSequence(url:URL):Vector.<ConnectionAttempt>  {
			var vPortProtocol:Vector.<ConnectionAttempt> = new Vector.<ConnectionAttempt> ;
			var allowedPorts:String = (url.port == "") ? "1935,443,80": url.port;
			var allowedProtocols:String;
			 switch (url.protocol)
			{
				case "rtmp":
					allowedProtocols = "rtmp,rtmps,rtmpt";
				break;
				case "rtmpe":
					allowedProtocols = "rtmpe,rtmpte";
				break;
				case "rtmps":
				case "rtmpt":
				case "rtmpte":
					allowedProtocols = url.protocol;
				break;
			}
			for (var q:int = 0; q < allowedProtocols.split(",").length;q++)
			{
				for (var w:int = 0; w < allowedPorts.split(",").length;w++)
				{
					var connectionAttempt:ConnectionAttempt = new ConnectionAttempt();
					connectionAttempt.port = allowedPorts.split(",")[w];
					connectionAttempt.protocol = allowedProtocols.split(",")[q];
					vPortProtocol.push(connectionAttempt);
				}
			} 
	
			return vPortProtocol;
		}
		
		/**
		 * Assembles a connection address.
		 * 
		 * @param url the URL to be loaded
		 * @param protocol the protocol as a String
		 * @param port the port as a String
		 * @private
		 */
		protected function buildConnectionAddress(url:URL, protocol:String, port:String, useInstance:Boolean = false):String
		{
			var fmsUrl:FMSURL = new FMSURL(url,useInstance);
			return protocol+"://"+url.host+":"+port+"/"+fmsUrl.appName;
			
		}
		
		/**
		 * Initiates a RTMP connection using port/protocol negotiation.
		 * 
		 * @private
		 * 
		 **/
		private function startRTMPConnection(loadable:ILoadable):void
		{
			_loadable = loadable;
			vConnections = getConnectionSequence((loadable.resource as IURLResource).url);
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
			timeOutTimer = new Timer(timeOutTimerDelay,1);
			timeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,masterTimeout);
			timeOutTimer.start();
			// Individual attempt sequencer
			connectionTimer = new Timer(CONNECTION_ATTEMPT_INTERVAL);
			connectionTimer.addEventListener(TimerEvent.TIMER,tryToConnect);
			connectionTimer.start();
			// Initialize counters and vectors
			failedConnectionCount = 0;
			attemptIndex = 0;
			vNC = new Vector.<NetConnection>;
		}

		
		/** 
		 * Attempts to connect to FMS using a particular connection string
		 * @private
		 */
		private function tryToConnect(evt:TimerEvent):void {
			
			vNC[attemptIndex] = createNetConnection();
			vNC[attemptIndex].addEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false,0,true);
    		vNC[attemptIndex].addEventListener(SecurityErrorEvent.SECURITY_ERROR,onNetSecurityError,false,0,true);
    		vNC[attemptIndex].addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncError,false,0,true);
			vNC[attemptIndex].client = new NetClient();
			try 
			{
				vNC[attemptIndex].connect((vConnections[attemptIndex] as  ConnectionAttempt).address);
				attemptIndex++;
				if (attemptIndex >= vConnections.length) {
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
			switch (event.info.code) {
				case NetConnectionCodes.CONNECT_INVALIDAPP:
				case NetConnectionCodes.CONNECT_REJECTED:
					handleFailedConnectionSession();
    				break;
    			case NetConnectionCodes.CONNECT_FAILED:
    				failedConnectionCount++;
    				if (failedConnectionCount >= vConnections.length) {
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
		 * Closes down all parallel connections in the vNC vector which are not connected.
		 * Also shuts down the master timeout and attempt timers. 
		 * @private
		 */
		private function shutDownUnsuccessfullConnections():void
		{
			timeOutTimer.stop();
			connectionTimer.stop();
			for (var i:uint = 0; i<vNC.length; i++) 
			{
				var nc:NetConnection = vNC[i];
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
		 * Catches the master timeout when no connections have succeeded within timeOutTimerDelay.
		 * @private
		 */
		private function masterTimeout(event:TimerEvent):void {
			handleFailedConnectionSession();
		}
		
		/** 
		 * Builds a vector of connection attempt objects
		 * 
		 * @private
		 */
		private function getConnectionSequence(url:URL):Vector.<ConnectionAttempt> {
			var vPortProtocol:Vector.<ConnectionAttempt> = buildPortProtocolSequence(url);
			var vConnections:Vector.<ConnectionAttempt> = new Vector.<ConnectionAttempt>();
			for (var a:uint = 0; a<vPortProtocol.length; a++) {
				var connectionObject:ConnectionAttempt= new ConnectionAttempt();
				connectionObject.address = buildConnectionAddress(url, vPortProtocol[a].protocol, vPortProtocol[a].port, _useInstance);
				connectionObject.port = vPortProtocol[a].port;
				connectionObject.protocol = vPortProtocol[a].protocol;
				vConnections.push(connectionObject);
			}
			return vConnections;
		}
		

		private var vConnections:Vector.<ConnectionAttempt>;
		private var vNC:Vector.<NetConnection>;
		private var _loadable:ILoadable;
		private var _useInstance:Boolean = DEFAULT_USE_INSTANCE;
		private var timeOutTimer:Timer;
		private var connectionTimer:Timer;
		private var attemptIndex:uint;
		private var timeOutTimerDelay:Number = DEFAULT_TIMEOUT;	
		private var failedConnectionCount:uint;
		
		private const DEFAULT_TIMEOUT:Number = 10000;
		private const CONNECTION_ATTEMPT_INTERVAL:Number = 50;
		private const DEFAULT_USE_INSTANCE:Boolean = false;
	
	}
	
}
	
/**
* Utility class for defining the data structure for a connection attempt.
*/
class ConnectionAttempt
{
	public var port:String;
	public var address:String;
	public var protocol:String;		
}
