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
	/**
	 * Enumeration of expected behavior when using a NetConnection.
	 **/
	public class NetConnectionExpectation
	{
		/** Expect the connection to succeed. */
		public static const VALID_CONNECTION:NetConnectionExpectation = new NetConnectionExpectation("validConnection");
		
		/** Expect the connection to fail due to an invalid server name */
		public static const INVALID_FMS_SERVER:NetConnectionExpectation = new NetConnectionExpectation("invalidFMSServer");

		/** Expect the connection to fail due to the request being rejected on a valid server. */
		public static const REJECTED_CONNECTION:NetConnectionExpectation = new NetConnectionExpectation("rejectedConnection");
		
		/** Expect the connection to fail due to an invalid application on a valid server. */
		public static const INVALID_FMS_APPLICATION:NetConnectionExpectation = new NetConnectionExpectation("invalidFMSApplication");

		/**
		 * @private
		 **/
		public function NetConnectionExpectation(name:String)
		{
			this.name = name;
		}
		
		private var name:String;
	}
}