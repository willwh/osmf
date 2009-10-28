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
	import org.osmf.utils.MediaFrameworkStrings;
	
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
		
		public static const DRM_INVAID_VOUCHER:int						= 3300;
		public static const DRM_AUTHENTICATION_FAILED:int				= 3301;
		public static const DRM_REQUIRE_SSL:int							= 3302;
		public static const DRM_CONTENT_EXPIRED:int						= 3303;
		public static const DRM_AUTHORIZATION_FAILED:int				= 3304;
		public static const DRM_SERVER_CONNECTION_FAILED:int			= 3305;
		public static const DRM_CLIENT_UPDATE_REQUIRED:int				= 3306;
		public static const DRM_INTERNAL_FAILURE:int					= 3307;
		public static const DRM_WRONG_LICENSE_KEY:int					= 3308;
		public static const DRM_CORRUPTED_FLV:int						= 3309;
		public static const DRM_APP_ID_MISMATCH:int						= 3310;
		public static const DRM_APP_VERSION_MISMATCH:int				= 3311;
		public static const DRM_LICENSE_INTEGRITY:int					= 3312;
		public static const DRM_FLV_HEADER_INTEGRITY_FAILED:int			= 3314;
		public static const DRM_PERMISSION_DENIED:int					= 3315;
		public static const DRM_MISSING_ADOBE_CP_MODULE:int				= 3316;
		public static const DRM_LOAD_ADOBE_CP_FAILED:int				= 3317;
		public static const DRM_INCOMPATIBLE_ADOBE_CP_VERSION:int		= 3318;
		public static const DRM_MISSING_ADOBE_CP_GET_API:int			= 3319;
		public static const DRM_HOST_AUTHENTICATE_FAILED:int			= 3320;
		public static const DRM_I15n_FAILED:int							= 3321;
		public static const DRM_DEVICE_BINDING_FAILED:int				= 3322;
		public static const DRM_CORRUPT_GLOBAL_STATE_STORE:int			= 3323;
		public static const DRM_CORRUPT_SERVER_STATE_STORE:int			= 3325;
		public static const DRM_STORE_TAMPERING_DETECTED:int			= 3326;
		public static const DRM_CLOCK_TAMPERING_DETECTED:int			= 3327;
		public static const DRM_SERVER_ERROR_TRY_AGAIN:int				= 3328;	
		public static const DRM_APPLICATION_SPECIFIC_ERROR:int			= 3329;
		public static const DRM_NEEDS_AUTHENTICATION:int				= 3330;

		public static const DRM_CONTENT_NOT_YET_VALID:int				= 3331;									
		public static const DRM_CACHE_LICENSE_EXPIRED:int				= 3332;								
		public static const DRM_PLAYBACK_WINDOW_EXPIRED:int				= 3333;									
		public static const DRM_INVALID_DRM_PLATFORM:int				= 3334;									
		public static const DRM_INVALID_DRM_VERSION:int					= 3335;								
		public static const DRM_INVALID_RUNTIME_PLATFORM:int			= 3336;									
		public static const DRM_INVALID_RUNTIME_VERSION:int				= 3337;									
		public static const DRM_UNKNOWN_CONNECTION_TYPE:int				= 3338;								
		public static const DRM_NO_ANALOG_PLAYBACK_ALLOWED:int			= 3339;								
		public static const DRM_NO_ANALOG_PROTECTION_AVAIL:int			= 3340;									
		public static const DRM_NO_DIGITAL_PLAYBACK_ALLOWED:int			= 3341;									
		public static const DRM_NO_DIGITAL_PROTECTION_AVAIL:int			= 3342;									


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
			  {code:CONTENT_IO_LOAD_ERROR,					description:MediaFrameworkStrings.CONTENT_IO_LOAD_ERROR}
			, {code:CONTENT_SECURITY_LOAD_ERROR,			description:MediaFrameworkStrings.CONTENT_SECURITY_LOAD_ERROR}
			, {code:INVALID_SWF_AS_VERSION,					description:MediaFrameworkStrings.INVALID_SWF_AS_VERSION}
			, {code:INVALID_PLUGIN_VERSION,					description:MediaFrameworkStrings.INVALID_PLUGIN_VERSION}
			, {code:INVALID_PLUGIN_IMPLEMENTATION,			description:MediaFrameworkStrings.INVALID_PLUGIN_IMPLEMENTATION}
			, {code:INVALID_URL_PROTOCOL,					description:MediaFrameworkStrings.INVALID_URL_PROTOCOL}
			, {code:PLAY_FAILED, 							description:MediaFrameworkStrings.PLAY_FAILED}
			, {code:STREAM_NOT_FOUND,	 					description:MediaFrameworkStrings.STREAM_NOT_FOUND}
			, {code:FILE_STRUCTURE_INVALID,					description:MediaFrameworkStrings.FILE_STRUCTURE_INVALID}
			, {code:NO_SUPPORTED_TRACK_FOUND,				description:MediaFrameworkStrings.NO_SUPPORTED_TRACK_FOUND}
			, {code:PLAY_FAILED_NETCONNECTION_FAILURE, 		description:MediaFrameworkStrings.PLAY_FAILED_NETCONNECTION_FAILURE}
			, {code:NETCONNECTION_REJECTED,					description:MediaFrameworkStrings.NETCONNECTION_REJECTED}
			, {code:NETCONNECTION_INVALID_APP,				description:MediaFrameworkStrings.NETCONNECTION_INVALID_APP}
			, {code:NETCONNECTION_FAILED,					description:MediaFrameworkStrings.NETCONNECTION_FAILED}
			, {code:NETCONNECTION_TIMEOUT,					description:MediaFrameworkStrings.NETCONNECTION_TIMEOUT}
			, {code:NETCONNECTION_SECURITY_ERROR,			description:MediaFrameworkStrings.NETCONNECTION_SECURITY_ERROR}
			, {code:NETCONNECTION_ASYNC_ERROR,				description:MediaFrameworkStrings.NETCONNECTION_ASYNC_ERROR}
			, {code:NETCONNECTION_IO_ERROR,					description:MediaFrameworkStrings.NETCONNECTION_IO_ERROR}
			, {code:NETCONNECTION_ARGUMENT_ERROR,			description:MediaFrameworkStrings.NETCONNECTION_ARGUMENT_ERROR}
			, {code:STREAMSWITCH_INVALID_INDEX,				description:MediaFrameworkStrings.STREAMSWITCH_INVALID_INDEX}
			, {code:STREAMSWITCH_STREAM_NOT_FOUND,  		description:MediaFrameworkStrings.STREAMSWITCH_STREAM_NOT_FOUND}
			, {code:STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE,	description:MediaFrameworkStrings.STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE}			
			, {code:AUDIO_IO_LOAD_ERROR,					description:MediaFrameworkStrings.AUDIO_IO_LOAD_ERROR}
			, {code:AUDIO_SECURITY_LOAD_ERROR,				description:MediaFrameworkStrings.AUDIO_SECURITY_LOAD_ERROR}
			, {code:PLAY_FAILED_NO_SOUND_CHANNELS,			description:MediaFrameworkStrings.PLAY_FAILED_NO_SOUND_CHANNELS}
			, {code:HTTP_IO_LOAD_ERROR,						description:MediaFrameworkStrings.HTTP_IO_LOAD_ERROR}
			, {code:HTTP_SECURITY_LOAD_ERROR,				description:MediaFrameworkStrings.HTTP_SECURITY_LOAD_ERROR}
			, {code:BEACON_FAILURE_ERROR,					description:MediaFrameworkStrings.BEACON_FAILURE_ERROR}
			, {code:DRM_INVAID_VOUCHER,						description:MediaFrameworkStrings.DRM_INVAID_VOUCHER}
			, {code:DRM_AUTHENTICATION_FAILED,				description:MediaFrameworkStrings.DRM_AUTHENTICATION_FAILED}
			, {code:DRM_REQUIRE_SSL,						description:MediaFrameworkStrings.DRM_REQUIRE_SSL}
			, {code:DRM_CONTENT_EXPIRED,					description:MediaFrameworkStrings.DRM_CONTENT_EXPIRED}
			, {code:DRM_AUTHORIZATION_FAILED,				description:MediaFrameworkStrings.DRM_AUTHORIZATION_FAILED}
			, {code:DRM_SERVER_CONNECTION_FAILED,			description:MediaFrameworkStrings.DRM_SERVER_CONNECTION_FAILED}
			, {code:DRM_CLIENT_UPDATE_REQUIRED,				description:MediaFrameworkStrings.DRM_CLIENT_UPDATE_REQUIRED}
			, {code:DRM_INTERNAL_FAILURE,					description:MediaFrameworkStrings.DRM_INTERNAL_FAILURE}
			, {code:DRM_WRONG_LICENSE_KEY,					description:MediaFrameworkStrings.DRM_WRONG_LICENSE_KEY}
			, {code:DRM_CORRUPTED_FLV,						description:MediaFrameworkStrings.DRM_CORRUPTED_FLV}
			, {code:DRM_APP_ID_MISMATCH,					description:MediaFrameworkStrings.DRM_APP_ID_MISMATCH}
			, {code:DRM_APP_VERSION_MISMATCH,				description:MediaFrameworkStrings.DRM_APP_VERSION_MISMATCH}
			, {code:DRM_LICENSE_INTEGRITY,					description:MediaFrameworkStrings.DRM_LICENSE_INTEGRITY}
			, {code:DRM_FLV_HEADER_INTEGRITY_FAILED,		description:MediaFrameworkStrings.DRM_FLV_HEADER_INTEGRITY_FAILED}
			, {code:DRM_PERMISSION_DENIED,					description:MediaFrameworkStrings.DRM_PERMISSION_DENIED}
			, {code:DRM_MISSING_ADOBE_CP_MODULE,			description:MediaFrameworkStrings.DRM_MISSING_ADOBE_CP_MODULE}
			, {code:DRM_LOAD_ADOBE_CP_FAILED,				description:MediaFrameworkStrings.DRM_LOAD_ADOBE_CP_FAILED}
			, {code:DRM_INCOMPATIBLE_ADOBE_CP_VERSION,		description:MediaFrameworkStrings.DRM_INCOMPATIBLE_ADOBE_CP_VERSION}
			, {code:DRM_MISSING_ADOBE_CP_GET_API,			description:MediaFrameworkStrings.DRM_MISSING_ADOBE_CP_GET_API}
			, {code:DRM_HOST_AUTHENTICATE_FAILED,			description:MediaFrameworkStrings.DRM_HOST_AUTHENTICATE_FAILED}
			, {code:DRM_I15n_FAILED,						description:MediaFrameworkStrings.DRM_I15n_FAILED}
			, {code:DRM_DEVICE_BINDING_FAILED,				description:MediaFrameworkStrings.DRM_DEVICE_BINDING_FAILED}
			, {code:DRM_CORRUPT_GLOBAL_STATE_STORE,			description:MediaFrameworkStrings.DRM_CORRUPT_GLOBAL_STATE_STORE}
			, {code:DRM_CORRUPT_SERVER_STATE_STORE,			description:MediaFrameworkStrings.DRM_CORRUPT_SERVER_STATE_STORE}
			, {code:DRM_STORE_TAMPERING_DETECTED,			description:MediaFrameworkStrings.DRM_STORE_TAMPERING_DETECTED}
			, {code:DRM_CLOCK_TAMPERING_DETECTED,			description:MediaFrameworkStrings.DRM_CLOCK_TAMPERING_DETECTED}
			, {code:DRM_SERVER_ERROR_TRY_AGAIN,				description:MediaFrameworkStrings.DRM_SERVER_ERROR_TRY_AGAIN}
			, {code:DRM_APPLICATION_SPECIFIC_ERROR,			description:MediaFrameworkStrings.DRM_APPLICATION_SPECIFIC_ERROR}
			, {code:DRM_NEEDS_AUTHENTICATION,				description:MediaFrameworkStrings.DRM_NEEDS_AUTHENTICATION}
			, {code:DRM_CONTENT_NOT_YET_VALID,				description:MediaFrameworkStrings.DRM_CONTENT_NOT_YET_VALID}
			, {code:DRM_CACHE_LICENSE_EXPIRED,				description:MediaFrameworkStrings.DRM_CACHE_LICENSE_EXPIRED}
			, {code:DRM_PLAYBACK_WINDOW_EXPIRED,			description:MediaFrameworkStrings.DRM_PLAYBACK_WINDOW_EXPIRED}
			, {code:DRM_INVALID_DRM_PLATFORM,				description:MediaFrameworkStrings.DRM_INVALID_DRM_PLATFORM}
			, {code:DRM_INVALID_DRM_VERSION,				description:MediaFrameworkStrings.DRM_INVALID_DRM_VERSION}
			, {code:DRM_INVALID_RUNTIME_PLATFORM,			description:MediaFrameworkStrings.DRM_INVALID_RUNTIME_PLATFORM}
			, {code:DRM_INVALID_RUNTIME_VERSION,			description:MediaFrameworkStrings.DRM_INVALID_RUNTIME_VERSION}
			, {code:DRM_UNKNOWN_CONNECTION_TYPE,			description:MediaFrameworkStrings.DRM_UNKNOWN_CONNECTION_TYPE}
			, {code:DRM_NO_ANALOG_PLAYBACK_ALLOWED,			description:MediaFrameworkStrings.DRM_NO_ANALOG_PLAYBACK_ALLOWED}
			, {code:DRM_NO_ANALOG_PROTECTION_AVAIL,			description:MediaFrameworkStrings.DRM_NO_ANALOG_PROTECTION_AVAIL}
			, {code:DRM_NO_DIGITAL_PLAYBACK_ALLOWED,		description:MediaFrameworkStrings.DRM_NO_DIGITAL_PLAYBACK_ALLOWED}
			, {code:DRM_NO_DIGITAL_PROTECTION_AVAIL,		description:MediaFrameworkStrings.DRM_NO_DIGITAL_PROTECTION_AVAIL}
		];
	}
			
	
}