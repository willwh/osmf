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
package org.openvideoplayer.events
{
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	
	/**
	 * The MediaErrorCodes class provides static constants for error codes,
	 * as well as a means for retrieving a description for a particular error
	 * code.
	 */ 
	public final class MediaErrorCodes
	{
		public static const IMAGE_IO_LOAD_ERROR:int 			= 1;
		public static const IMAGE_SECURITY_LOAD_ERROR:int		= 2;

		public static const SWF_IO_LOAD_ERROR:int 				= 31;
		public static const SWF_SECURITY_LOAD_ERROR:int			= 32;
		
		public static const INVALID_PLUGIN_VERSION:int			= 61;
		public static const INVALID_PLUGIN_IMPLEMENTATION:int	= 62;
		
		public static const INVALID_URL_PROTOCOL:int			= 120;
		public static const NETCONNECTION_REJECTED:int			= 121;
		public static const NETCONNECTION_INVALID_APP:int		= 122;
		public static const NETCONNECTION_FAILED:int			= 123;
		public static const NETCONNECTION_TIMEOUT:int			= 124;
		public static const NETCONNECTION_SECURITY_ERROR:int	= 125;
		public static const NETCONNECTION_ASYNC_ERROR:int		= 126;
		public static const NETCONNECTION_IO_ERROR:int			= 127;
		public static const NETCONNECTION_ARGUMENT_ERROR:int	= 128;

		public static const PLAY_FAILED:int 					= 131;
		public static const STREAM_NOT_FOUND:int 				= 132;
		public static const FILE_STRUCTURE_INVALID:int 			= 133;
		public static const NO_SUPPORTED_TRACK_FOUND:int 		= 134;
		
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
			  {code:IMAGE_IO_LOAD_ERROR,			description:MediaFrameworkStrings.IMAGE_IO_LOAD_ERROR}
			, {code:IMAGE_SECURITY_LOAD_ERROR,		description:MediaFrameworkStrings.IMAGE_SECURITY_LOAD_ERROR}
			, {code:SWF_IO_LOAD_ERROR,				description:MediaFrameworkStrings.SWF_IO_LOAD_ERROR}
			, {code:SWF_SECURITY_LOAD_ERROR,		description:MediaFrameworkStrings.SWF_SECURITY_LOAD_ERROR}
			, {code:INVALID_PLUGIN_VERSION,			description:MediaFrameworkStrings.INVALID_PLUGIN_VERSION}
			, {code:INVALID_PLUGIN_IMPLEMENTATION,	description:MediaFrameworkStrings.INVALID_PLUGIN_IMPLEMENTATION}
			, {code:INVALID_URL_PROTOCOL,			description:MediaFrameworkStrings.INVALID_URL_PROTOCOL}
			, {code:PLAY_FAILED, 					description:MediaFrameworkStrings.PLAY_FAILED}
			, {code:STREAM_NOT_FOUND,	 			description:MediaFrameworkStrings.STREAM_NOT_FOUND}
			, {code:FILE_STRUCTURE_INVALID,			description:MediaFrameworkStrings.FILE_STRUCTURE_INVALID}
			, {code:NO_SUPPORTED_TRACK_FOUND,		description:MediaFrameworkStrings.NO_SUPPORTED_TRACK_FOUND}
			, {code:NETCONNECTION_REJECTED,			description:MediaFrameworkStrings.NETCONNECTION_REJECTED}
			, {code:NETCONNECTION_INVALID_APP,		description:MediaFrameworkStrings.NETCONNECTION_INVALID_APP}
			, {code:NETCONNECTION_FAILED,			description:MediaFrameworkStrings.NETCONNECTION_FAILED}
			, {code:NETCONNECTION_TIMEOUT,			description:MediaFrameworkStrings.NETCONNECTION_TIMEOUT}
			, {code:NETCONNECTION_SECURITY_ERROR,	description:MediaFrameworkStrings.NETCONNECTION_SECURITY_ERROR}
			, {code:NETCONNECTION_ASYNC_ERROR,		description:MediaFrameworkStrings.NETCONNECTION_ASYNC_ERROR}
			, {code:NETCONNECTION_IO_ERROR,			description:MediaFrameworkStrings.NETCONNECTION_IO_ERROR}
			, {code:NETCONNECTION_ARGUMENT_ERROR,	description:MediaFrameworkStrings.NETCONNECTION_ARGUMENT_ERROR}
		];
	}
}