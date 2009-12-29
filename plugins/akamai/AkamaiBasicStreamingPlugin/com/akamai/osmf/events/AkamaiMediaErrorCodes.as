/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/

package com.akamai.osmf.events
{
	
	/**
	 * The AkamaiMediaErrorCodes class provides static constants for Akamai-specific
	 * error IDs, as well as a means for retrieving a message for a particular error
	 * ID.
	 */ 
	public final class AkamaiMediaErrorCodes
	{
		/**
		 * Returns a message for the error of the specified ID.  If the error ID
		 * is unknown, returns the empty string.
		 * 
		 * @param errorID The ID for the error.
		 * 
		 * @return The message for the error with the specified ID.
		 **/
		public static function getMessageForErrorID(errorID:int):String
		{
			var message:String = "";
			
			for (var i:int = 0; i < errorMap.length; i++)
			{
				if (errorMap[i].errorID == errorID)
				{
					message = errorMap[i].message;
					break;
				}
			}
			
			return message;
		}

		private static const errorMap:Array =
		[
			{errorID:LIVE_SUBSCRIBE_TIMEOUT,		message:"Unable to subscribe to the live stream."},
			{errorID:LIVE_FCSUBSCRIBE_NO_RESPONSE,	message:"No response from the FCSubscribe call, unable to subscribe to the live stream."}
		];
		
		// Akamai-specific error IDs start at 1000
		public static const LIVE_SUBSCRIBE_TIMEOUT:int			= 1000;
		public static const LIVE_FCSUBSCRIBE_NO_RESPONSE:int	= 1001;		
	}		
}
