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
package org.osmf.events
{
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * The MediaErrorCodes class provides static constants for error codes,
	 * as well as a means for retrieving a description for a particular error
	 * code.
	 */ 
	public final class MediaErrorCodes
	{
		public static const CONTENT_IO_LOAD_ERROR:int 					= 1;
		public static const CONTENT_SECURITY_LOAD_ERROR:int				= 2;
		public static const INVALID_SWF_AS_VERSION:int					= 3;

		public static const INVALID_PLUGIN_VERSION:int					= 61;
		public static const INVALID_PLUGIN_IMPLEMENTATION:int			= 62;
		
		public static const INVALID_URL_PROTOCOL:int					= 120;
		public static const NETCONNECTION_REJECTED:int					= 121;
		public static const NETCONNECTION_INVALID_APP:int				= 122;
		public static const NETCONNECTION_FAILED:int					= 123;
		public static const NETCONNECTION_TIMEOUT:int					= 124;
		public static const NETCONNECTION_SECURITY_ERROR:int			= 125;
		public static const NETCONNECTION_ASYNC_ERROR:int				= 126;
		public static const NETCONNECTION_IO_ERROR:int					= 127;
		public static const NETCONNECTION_ARGUMENT_ERROR:int			= 128;

		public static const PLAY_FAILED:int 							= 131;
		public static const STREAM_NOT_FOUND:int 						= 132;
		public static const FILE_STRUCTURE_INVALID:int 					= 133;
		public static const NO_SUPPORTED_TRACK_FOUND:int 				= 134;
		public static const PLAY_FAILED_NETCONNECTION_FAILURE:int 		= 135;
		
		public static const STREAMSWITCH_INVALID_INDEX:int				= 200;
		public static const STREAMSWITCH_STREAM_NOT_FOUND:int			= 201;
		public static const STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE:int	= 202;
		
		public static const AUDIO_IO_LOAD_ERROR:int 					= 301;
		public static const AUDIO_SECURITY_LOAD_ERROR:int				= 302;
		public static const PLAY_FAILED_NO_SOUND_CHANNELS:int			= 303;
		
		public static const HTTP_IO_LOAD_ERROR:int 						= 351;
		public static const HTTP_SECURITY_LOAD_ERROR:int				= 352;
		
		public static const BEACON_FAILURE_ERROR:int 					= 370;
		
		public static const DRM_AUTHENTICATION_FAILED:int				= 3301;
		public static const DRM_NEEDS_AUTHENTICATION:int				= 3330;
		public static const DRM_CONTENT_NOT_YET_VALID:int				= 3331;


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
					description = OSMFStrings.getString(errorMap[i].description);
					break;
				}
			}
			
			return description;
		}

		private static const errorMap:Array =
		[
			  {code:CONTENT_IO_LOAD_ERROR,					description:OSMFStrings.CONTENT_IO_LOAD_ERROR}
			, {code:CONTENT_SECURITY_LOAD_ERROR,			description:OSMFStrings.CONTENT_SECURITY_LOAD_ERROR}
			, {code:INVALID_SWF_AS_VERSION,					description:OSMFStrings.INVALID_SWF_AS_VERSION}
			, {code:INVALID_PLUGIN_VERSION,					description:OSMFStrings.INVALID_PLUGIN_VERSION}
			, {code:INVALID_PLUGIN_IMPLEMENTATION,			description:OSMFStrings.INVALID_PLUGIN_IMPLEMENTATION}
			, {code:INVALID_URL_PROTOCOL,					description:OSMFStrings.INVALID_URL_PROTOCOL}
			, {code:PLAY_FAILED, 							description:OSMFStrings.PLAY_FAILED}
			, {code:STREAM_NOT_FOUND,	 					description:OSMFStrings.STREAM_NOT_FOUND}
			, {code:FILE_STRUCTURE_INVALID,					description:OSMFStrings.FILE_STRUCTURE_INVALID}
			, {code:NO_SUPPORTED_TRACK_FOUND,				description:OSMFStrings.NO_SUPPORTED_TRACK_FOUND}
			, {code:PLAY_FAILED_NETCONNECTION_FAILURE, 		description:OSMFStrings.PLAY_FAILED_NETCONNECTION_FAILURE}
			, {code:NETCONNECTION_REJECTED,					description:OSMFStrings.NETCONNECTION_REJECTED}
			, {code:NETCONNECTION_INVALID_APP,				description:OSMFStrings.NETCONNECTION_INVALID_APP}
			, {code:NETCONNECTION_FAILED,					description:OSMFStrings.NETCONNECTION_FAILED}
			, {code:NETCONNECTION_TIMEOUT,					description:OSMFStrings.NETCONNECTION_TIMEOUT}
			, {code:NETCONNECTION_SECURITY_ERROR,			description:OSMFStrings.NETCONNECTION_SECURITY_ERROR}
			, {code:NETCONNECTION_ASYNC_ERROR,				description:OSMFStrings.NETCONNECTION_ASYNC_ERROR}
			, {code:NETCONNECTION_IO_ERROR,					description:OSMFStrings.NETCONNECTION_IO_ERROR}
			, {code:NETCONNECTION_ARGUMENT_ERROR,			description:OSMFStrings.NETCONNECTION_ARGUMENT_ERROR}
			, {code:STREAMSWITCH_INVALID_INDEX,				description:OSMFStrings.STREAMSWITCH_INVALID_INDEX}
			, {code:STREAMSWITCH_STREAM_NOT_FOUND,  		description:OSMFStrings.STREAMSWITCH_STREAM_NOT_FOUND}
			, {code:STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE,	description:OSMFStrings.STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE}			
			, {code:AUDIO_IO_LOAD_ERROR,					description:OSMFStrings.AUDIO_IO_LOAD_ERROR}
			, {code:AUDIO_SECURITY_LOAD_ERROR,				description:OSMFStrings.AUDIO_SECURITY_LOAD_ERROR}
			, {code:PLAY_FAILED_NO_SOUND_CHANNELS,			description:OSMFStrings.PLAY_FAILED_NO_SOUND_CHANNELS}
			, {code:HTTP_IO_LOAD_ERROR,						description:OSMFStrings.HTTP_IO_LOAD_ERROR}
			, {code:HTTP_SECURITY_LOAD_ERROR,				description:OSMFStrings.HTTP_SECURITY_LOAD_ERROR}
			, {code:BEACON_FAILURE_ERROR,					description:OSMFStrings.BEACON_FAILURE_ERROR}
			, {code:DRM_AUTHENTICATION_FAILED,				description:OSMFStrings.DRM_AUTHENTICATION_FAILED}
			, {code:DRM_NEEDS_AUTHENTICATION,				description:OSMFStrings.DRM_NEEDS_AUTHENTICATION}
			, {code:DRM_CONTENT_NOT_YET_VALID,				description:OSMFStrings.DRM_CONTENT_NOT_YET_VALID}
		];
	}
			
	
}