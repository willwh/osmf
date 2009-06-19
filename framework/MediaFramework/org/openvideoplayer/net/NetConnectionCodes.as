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
package org.openvideoplayer.net
{
	/**
	 * The NetConnectionCodes class provides static constants for event types
	 * that a NetConnection dispatches as NetStatusEvents.
	 * @see flash.net.NetConnection
	 * @see flash.events.NetStatusEvent    
	 */ 
	public class NetConnectionCodes
	{
		/**
		 * "error"	Packet encoded in an unidentified format.
		 */
		public static const CALL_BADVERSION:String = "NetConnection.Call.BadVersion";  		
		
		/**
		 * "error"	The NetConnection.call method was not able to invoke the server-side method or command.
		 * */
		public static const CALL_FAILED:String = "NetConnection.Call.Failed";	    	
	
		/**
		 * "error"	An Action Message Format (AMF) operation is prevented for security reasons. 
		 * Either the AMF URL is not in the same domain as the file containing the code calling the NetConnection.call() method, 
		 * or the AMF server does not have a policy file that trusts the domain of the the
		 * file containing the code calling the NetConnection.call() method.		
		 */
		public static const CALL_PROHIBITED:String = "NetConnection.Call.Prohibited"; 	
		
		/** 
		 * "status"	The connection was closed successfully.	
		 */
		public static const CONNECT_CLOSED:String = "NetConnection.Connect.Closed"; 	
		
		/**			
		 * "error"	The connection attempt failed.
		 */ 
		public static const CONNECT_FAILED:String = "NetConnection.Connect.Failed"		
		
		/**
		 * "status"	The connection attempt succeeded.
		 */ 
		public static const CONNECT_SUCCESS:String = "NetConnection.Connect.Success";		
		
		/**
		 * "error"	The connection attempt did not have permission to access the application.			
		 */
		public static const CONNECT_REJECTED:String = "NetConnection.Connect.Rejected";		
		
		/**
		 * 	"error"	The specified application is shutting down.
		 */ 
		public static const CONNECT_APPSHUTDOWN:String = "NetConnection.Connect.AppShutdown";
		
		/** 
		 * "error"	The application name specified during connect is invalid.
		 */
		public static const CONNECT_INVALIDAPP:String = "NetConnection.Connect.InvalidApp";	
	}
}