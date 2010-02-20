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
	 * The MediaErrorCodes class provides static constants for error IDs,
	 * as well as a means for retrieving a message for a particular error
	 * ID.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	public final class MediaErrorCodes
	{
		public static const CONTENT_IO_LOAD_ERROR:int 					= 1;
		public static const CONTENT_SECURITY_LOAD_ERROR:int				= 2;

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
		
		public static const DRM_UPDATE_ERROR:int						= 380;
		
		public static const DRM_AUTHENTICATION_FAILED:int				= 401;
		public static const DRM_NEEDS_AUTHENTICATION:int				= 402;
		public static const DRM_CONTENT_NOT_YET_VALID:int				= 403;
		
		public static const DVRCAST_SUBSCRIPTION_FAILED:int				= 501;
		public static const DVRCAST_CONTENT_OFFLINE:int					= 502;
		public static const DVRCAST_FAILED_RETREIVING_STREAM_INFO:int	= 503;

		/**
		 * @private
		 * 
		 * Returns a message for the error of the specified ID.  If the error ID
		 * is unknown, returns the empty string.
		 * 
		 * @param errorID The ID for the error.
		 * 
		 * @return The message for the error with the specified ID.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static function getMessageForErrorID(errorID:int):String
		{
			var message:String = "";
			
			for (var i:int = 0; i < errorMap.length; i++)
			{
				if (errorMap[i].errorID == errorID)
				{
					message = OSMFStrings.getString(errorMap[i].message);
					break;
				}
			}
			
			return message;
		}

		private static const errorMap:Array =
		[
			  {errorID:CONTENT_IO_LOAD_ERROR,					message:OSMFStrings.CONTENT_IO_LOAD_ERROR}
			, {errorID:CONTENT_SECURITY_LOAD_ERROR,				message:OSMFStrings.CONTENT_SECURITY_LOAD_ERROR}
			, {errorID:INVALID_PLUGIN_VERSION,					message:OSMFStrings.INVALID_PLUGIN_VERSION}
			, {errorID:INVALID_PLUGIN_IMPLEMENTATION,			message:OSMFStrings.INVALID_PLUGIN_IMPLEMENTATION}
			, {errorID:INVALID_URL_PROTOCOL,					message:OSMFStrings.INVALID_URL_PROTOCOL}
			, {errorID:PLAY_FAILED, 							message:OSMFStrings.PLAY_FAILED}
			, {errorID:STREAM_NOT_FOUND,	 					message:OSMFStrings.STREAM_NOT_FOUND}
			, {errorID:FILE_STRUCTURE_INVALID,					message:OSMFStrings.FILE_STRUCTURE_INVALID}
			, {errorID:NO_SUPPORTED_TRACK_FOUND,				message:OSMFStrings.NO_SUPPORTED_TRACK_FOUND}
			, {errorID:PLAY_FAILED_NETCONNECTION_FAILURE, 		message:OSMFStrings.PLAY_FAILED_NETCONNECTION_FAILURE}
			, {errorID:NETCONNECTION_REJECTED,					message:OSMFStrings.NETCONNECTION_REJECTED}
			, {errorID:NETCONNECTION_INVALID_APP,				message:OSMFStrings.NETCONNECTION_INVALID_APP}
			, {errorID:NETCONNECTION_FAILED,					message:OSMFStrings.NETCONNECTION_FAILED}
			, {errorID:NETCONNECTION_TIMEOUT,					message:OSMFStrings.NETCONNECTION_TIMEOUT}
			, {errorID:NETCONNECTION_SECURITY_ERROR,			message:OSMFStrings.NETCONNECTION_SECURITY_ERROR}
			, {errorID:NETCONNECTION_ASYNC_ERROR,				message:OSMFStrings.NETCONNECTION_ASYNC_ERROR}
			, {errorID:NETCONNECTION_IO_ERROR,					message:OSMFStrings.NETCONNECTION_IO_ERROR}
			, {errorID:NETCONNECTION_ARGUMENT_ERROR,			message:OSMFStrings.NETCONNECTION_ARGUMENT_ERROR}
			, {errorID:STREAMSWITCH_INVALID_INDEX,				message:OSMFStrings.STREAMSWITCH_INVALID_INDEX}
			, {errorID:STREAMSWITCH_STREAM_NOT_FOUND,  			message:OSMFStrings.STREAMSWITCH_STREAM_NOT_FOUND}
			, {errorID:STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE,	message:OSMFStrings.STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE}			
			, {errorID:AUDIO_IO_LOAD_ERROR,						message:OSMFStrings.AUDIO_IO_LOAD_ERROR}
			, {errorID:AUDIO_SECURITY_LOAD_ERROR,				message:OSMFStrings.AUDIO_SECURITY_LOAD_ERROR}
			, {errorID:PLAY_FAILED_NO_SOUND_CHANNELS,			message:OSMFStrings.PLAY_FAILED_NO_SOUND_CHANNELS}
			, {errorID:HTTP_IO_LOAD_ERROR,						message:OSMFStrings.HTTP_IO_LOAD_ERROR}
			, {errorID:HTTP_SECURITY_LOAD_ERROR,				message:OSMFStrings.HTTP_SECURITY_LOAD_ERROR}
			, {errorID:BEACON_FAILURE_ERROR,					message:OSMFStrings.BEACON_FAILURE_ERROR}
			, {errorID:DRM_AUTHENTICATION_FAILED,				message:OSMFStrings.DRM_AUTHENTICATION_FAILED}
			, {errorID:DRM_NEEDS_AUTHENTICATION,				message:OSMFStrings.DRM_NEEDS_AUTHENTICATION}
			, {errorID:DRM_CONTENT_NOT_YET_VALID,				message:OSMFStrings.DRM_CONTENT_NOT_YET_VALID}
			, {errorID:DRM_UPDATE_ERROR,						message:OSMFStrings.DRM_UPDATE_ERROR}
		];
	}
}