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
	 * error codes, as well as a means for retrieving a description for a particular error
	 * code.
	 */ 
	public final class AkamaiMediaErrorCodes
	{
		/**
		 * Returns a description of the error for the specified error code.  If
		 * the error code is unknown, returns the empty string.
		 * 
		 * @param errorCode The error code for the error.
		 * 
		 * @return A description of the error with the specified error code.
		 **/
		public static function getDescriptionForErrorCode(errorCode:int):String
		{
			var description:String = "";
			
			for (var i:int = 0; i < errorMap.length; i++)
			{
				if (errorMap[i].code == errorCode)
				{
					description = errorMap[i].description;
					break;
				}
			}
			
			return description;
		}

		private static const errorMap:Array =
		[
			{code:LIVE_SUBSCRIBE_TIMEOUT,		description:"Unable to subscribe to the live stream."},
			{code:LIVE_FCSUBSCRIBE_NO_RESPONSE,	description:"No response from the FCSubscribe call, unable to subscribe to the live stream."}
		];
		
		// Akamai-specific error codes start at 1000
		public static const LIVE_SUBSCRIBE_TIMEOUT:int			= 1000;
		public static const LIVE_FCSUBSCRIBE_NO_RESPONSE:int	= 1001;		
	}		
}
