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