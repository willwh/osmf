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
	
	import flash.errors.IOError;
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.NetNegotiatorEvent;
	import org.osmf.media.IURLResource;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.URL;
	
	/**
	 * Dispatched when the negotiator has successfully connected
	 *
	 * @eventType org.osmf.events.NetNegotiatorEvent.CONNECTED
	 * 
	 **/
	[ Event( name="connected", type="org.osmf.events.NetNegotiatorEvent") ]
	
	/**
	 * Dispatched when the negotiator has failed to connect
	 *
	 * @eventType org.osmf.events.NetNegotiatorEvent.CONNECTION_FAILED
	 * 
	 **/
	[ Event( name="connectionfailed", type="org.osmf.events.NetNegotiatorEvent") ]
	
	
	/**
	 * The NetNegotiator class attempts to negotiate its way through firewalls and proxy
	 * servers, by trying multiple parallel connection attempts on differing port and protocol combinations.
	 * The first connection to succeed is kept and those still pending are shut down. In the connect() method, 
	 * the class can accept any resource that extends IURLResource although it would expect to receive a FMSURL since
	 * its purpose is specifically connecting to Flash Media Server. 
	 * 
	 */
	public class NetNegotiator extends EventDispatcher 
	{
		
		/**
		 * Constructor
		 * 
		 */
		public function NetNegotiator(target:IEventDispatcher=null):void
		{
			super(target);
		}
		
		/**
		 * Accepts a IURLResource and begins the process of finding a good connection. 
		 * 
		 * @param urlResource a IURLResource, usually a FMSURL
		 * 
		 * @see org.osmf.utils.FMSURL
		 **/
		public function connect(urlResource:IURLResource):void
		{
			connectionAttempts = getConnectionSequence(urlResource.url);
			initializeConnectionAttempts();
			tryToConnect(null); 
		}  
		
		/** 
		 * Assembles a vector of NetConnection Objects to be used during the connection attempted.
		 * The default protocols attempted when a "rtmp" connection is specified are 
		 * "rtmp","rtmps", and "rtmpt". When a "rtmpe" connection is requested, both "rtmpe"
		 * and rtmpte" protocols are attempted. When "rtmps","rtmpt" or "rtmpte" are requested,
		 * only those protocols are attempted. The default ports are 1935, 443 and 80. If a specific port
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
		 * Assembles a connection address. 
		 * 
		 * @param url the URL to be loaded
		 * @param protocol the protocol as a String
		 * @param port the port as a String
		 */
		protected function buildConnectionAddress(url:URL, protocol:String, port:String):String
		{
			var fmsURL:FMSURL = url is FMSURL ? url as FMSURL : new FMSURL(url.rawUrl);
			return protocol + "://" + fmsURL.host + ":" + port + "/" + fmsURL.appName + (fmsURL.useInstance ? "/" + fmsURL.instanceName:"");
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
			catch (ioError:IOError) 
			{
				handleFailedConnectionSession(new MediaError(MediaErrorCodes.NETCONNECTION_IO_ERROR,ioError.message));
			}
			catch (argumentError:ArgumentError) 
			{
				handleFailedConnectionSession(new MediaError(MediaErrorCodes.NETCONNECTION_ARGUMENT_ERROR,argumentError.message));
			}
			catch (securityError:SecurityError) 
			{
				handleFailedConnectionSession(new MediaError(MediaErrorCodes.NETCONNECTION_SECURITY_ERROR,securityError.message));
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
					handleFailedConnectionSession(new MediaError(MediaErrorCodes.NETCONNECTION_INVALID_APP,event.info.description));
					break;
				case NetConnectionCodes.CONNECT_REJECTED:
					handleFailedConnectionSession(new MediaError(MediaErrorCodes.NETCONNECTION_REJECTED,event.info.description));
    				break;
    			case NetConnectionCodes.CONNECT_FAILED:
    				failedConnectionCount++;
    				if (failedConnectionCount >= connectionAttempts.length) 
    				{
    					handleFailedConnectionSession(new MediaError(MediaErrorCodes.NETCONNECTION_FAILED));
    				}
    				break;
				case NetConnectionCodes.CONNECT_SUCCESS:
					shutDownUnsuccessfullConnections();
					dispatchEvent(new NetNegotiatorEvent(NetNegotiatorEvent.CONNECTED,event.currentTarget as NetConnection));
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
					delete netConnections[i];
				}
			}
		}

		/** 
		 * Handles a failed connection session and dispatches a CONNECTION_FAILED event
		 * @private
		 */
		private function handleFailedConnectionSession(mediaError:MediaError = null):void
		{
			shutDownUnsuccessfullConnections();
			dispatchEvent(new NetNegotiatorEvent(NetNegotiatorEvent.CONNECTION_FAILED,null,mediaError));
		}
		
		/** 
		 * Catches any netconnection net security errors
		 * @private
		 */
		private function onNetSecurityError(event:SecurityErrorEvent):void
		{
			handleFailedConnectionSession(new MediaError(MediaErrorCodes.NETCONNECTION_SECURITY_ERROR,event.text));
		}

    	/** 
    	 * Catches any async errors
    	 * @private
    	 */
		private function onAsyncError(event:AsyncErrorEvent):void 
		{
			handleFailedConnectionSession(new MediaError(MediaErrorCodes.NETCONNECTION_ASYNC_ERROR,event.text));
		}

		/** 
		 * Catches the master timeout when no connections have succeeded within _timeout.
		 * @private
		 */
		private function masterTimeout(event:TimerEvent):void 
		{
			handleFailedConnectionSession(new MediaError(MediaErrorCodes.NETCONNECTION_TIMEOUT,"Failed to establish a NetConnection within the timeout period of " + DEFAULT_TIMEOUT + " ms."));
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
		private var mediaError:MediaError;
		private var _timeout:Number = DEFAULT_TIMEOUT;
		
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
	
