/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.netmocker
{
	import flash.errors.IllegalOperationError;
	import flash.net.NetConnection;
	import flash.net.Responder;

	import org.openvideoplayer.net.NetConnectionCodes;
	
	/**
	 * NetConnection which can be used for mocking the connection to FMS (or
	 * to a progressive piece of content).  Intercepts all calls to the base
	 * NetConnection (thus preventing any network activity), and dispatches
	 * the appropriate events based on a predefined expectation.
	 * 
	 * Clients should set the <code>expectation</code> property before
	 * interacting with the NetConnection, and then listen for the events that
	 * they would expect to get when interacting with a real NetConnection.
	 **/
	public class MockNetConnection extends NetConnection
	{
		/**
		 * Constructor.
		 **/
		public function MockNetConnection()
		{
			_expectation = NetConnectionExpectation.VALID_CONNECTION;
			
			// Intercept all NetStatusEvents dispatched from the base class.
			eventInterceptor = new NetStatusEventInterceptor(this);
		}
		
		/**
		 * The client's expectation for how this NetConnection will
		 * behave after connect() is called.
		 **/ 
		public function set expectation(value:NetConnectionExpectation):void
		{
			this._expectation = value;
		}
		
		public function get expectation():NetConnectionExpectation
		{
			return _expectation;
		}
		
		// Overrides
		//
		
		override public function addHeader(operation:String, mustUnderstand:Boolean=false, param:Object=null):void
		{
			// Swallow.
			trace("MockNetConnection.addHeader");
		}
		
		override public function call(command:String, responder:Responder, ...parameters):void
		{
			// Swallow.
			//trace("MockNetConnection.call(" + command + ")");
		}
		
		override public function close():void
		{
			eventInterceptor.dispatchNetStatusEvent(NetConnectionCodes.CONNECT_CLOSED, LEVEL_STATUS);
		}
		
		override public function connect(command:String, ...parameters):void
		{
			switch (_expectation)
			{
				case NetConnectionExpectation.VALID_CONNECTION:
					connectToValidServer(command);
					break;
				case NetConnectionExpectation.INVALID_FMS_SERVER:
					connectToInvalidServer();
					break;
				case NetConnectionExpectation.REJECTED_CONNECTION:
					connectToRejectingServer();
					break;
				case NetConnectionExpectation.INVALID_FMS_APPLICATION:
					connectToInvalidApplication();
					break;
				default:
					throw new IllegalOperationError();
			}
		}

		// Internals
		//
		
		private function connectToValidServer(command:String):void
		{
			if (command == null)
			{
				// Progressive
				// Connect to null, so that NetStreams can use this NetConnection.
				super.connect(null);
				eventInterceptor.dispatchNetStatusEvent(NetConnectionCodes.CONNECT_SUCCESS, LEVEL_STATUS);
			}
			else
			{
				// Streaming
				// Pass a reference to this NetConnection, so that the connection can be established just prior
				// to dispatching the delayed event.
				eventInterceptor.dispatchNetStatusEvent(NetConnectionCodes.CONNECT_SUCCESS, LEVEL_STATUS, EVENT_DELAY, this);
			}
		}

		private function connectToInvalidServer():void
		{
			eventInterceptor.dispatchNetStatusEvent(NetConnectionCodes.CONNECT_FAILED, LEVEL_ERROR, EVENT_DELAY);
		}

		private function connectToRejectingServer():void
		{
			var infos:Array =
					[ {"code":NetConnectionCodes.CONNECT_REJECTED, 	"level":LEVEL_ERROR}
					, {"code":NetConnectionCodes.CONNECT_CLOSED, 	"level":LEVEL_STATUS}
					];
			eventInterceptor.dispatchNetStatusEvents(infos, EVENT_DELAY);
		}

		private function connectToInvalidApplication():void
		{
			var infos:Array =
					[ {"code":NetConnectionCodes.CONNECT_INVALIDAPP, 	"level":LEVEL_ERROR}
					, {"code":NetConnectionCodes.CONNECT_CLOSED, 		"level":LEVEL_STATUS}
					];
			eventInterceptor.dispatchNetStatusEvents(infos, EVENT_DELAY);
		}
		
		private static const EVENT_DELAY:int = 100;
		
		private static const LEVEL_STATUS:String = "status";
		private static const LEVEL_ERROR:String = "error";
		
		private var eventInterceptor:NetStatusEventInterceptor;
		private var _expectation:NetConnectionExpectation;
	}
}