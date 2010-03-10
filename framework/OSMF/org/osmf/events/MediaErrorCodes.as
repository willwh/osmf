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
	 * ID.  Error IDs zero through 999 are reserved for use by the
	 * framework.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	public final class MediaErrorCodes
	{
		/**
		 * Error constant for when a SWF or image fails to load due to an I/O error.
		 **/
		public static const IMAGE_OR_SWF_IO_LOAD_ERROR:int 				= 1;
		
		/**
		 * Error constant for when a SWF or image fails to load due to a security error.
		 **/
		public static const IMAGE_OR_SWF_SECURITY_LOAD_ERROR:int		= 2;

		/**
		 * Error constant for when a progressive audio file fails to load due to an I/O error.
		 **/
		public static const AUDIO_IO_LOAD_ERROR:int 					= 3;

		/**
		 * Error constant for when a progressive audio file fails to load due to an I/O error.
		 **/
		public static const AUDIO_SECURITY_LOAD_ERROR:int				= 4;

		/**
		 * Error constant for when an audio file fails to play due to no sound channels being
		 * available.
		 **/
		public static const PLAY_FAILED_NO_SOUND_CHANNELS:int			= 5;
		
		/**
		 * Error constant for when the NetLoader is unable to load a resource because
		 * of an unknown or invalid URL protocol.
		 **/
		public static const INVALID_URL_PROTOCOL:int					= 6;
		
		/**
		 * Error constant that corresponds to the NetConnection.Connect.Rejected status code.
		 **/
		public static const NETCONNECTION_REJECTED:int					= 7;

		/**
		 * Error constant that corresponds to the NetConnection.Connect.InvalidApp status code.
		 **/
		public static const NETCONNECTION_INVALID_APP:int				= 8;

		/**
		 * Error constant that corresponds to the NetConnection.Connect.Failed status code.
		 **/
		public static const NETCONNECTION_FAILED:int					= 9;

		/**
		 * Error constant for when a NetConnection cannot connect due to a timeout.
		 * period.
		 **/
		public static const NETCONNECTION_TIMEOUT:int					= 10;

		/**
		 * Error constant for when a NetConnection cannot connect due to a security error. 
		 **/
		public static const NETCONNECTION_SECURITY_ERROR:int			= 11;

		/**
		 * Error constant for when a NetConnection cannot connect due to an asynchronous error.
		 **/
		public static const NETCONNECTION_ASYNC_ERROR:int				= 12;

		/**
		 * Error constant for when a NetConnection cannot connect due to an I/O error.
		 **/
		public static const NETCONNECTION_IO_ERROR:int					= 13;

		/**
		 * Error constant for when a NetConnection cannot connect due to an argument error (typically
		 * an invalid connection URL).
		 **/
		public static const NETCONNECTION_ARGUMENT_ERROR:int			= 14;

		/**
		 * Error constant for when a NetStream cannot be played.
		 **/
		public static const PLAY_FAILED:int 							= 15;

		/**
		 * Error constant that corresponds to the NetStream.Play.StreamNotFound status code.
		 **/
		public static const STREAM_NOT_FOUND:int 						= 16;
		
		/**
		 * Error constant that corresponds to the NetStream.Play.FileStructureInvalid status code.
		 **/
		public static const FILE_STRUCTURE_INVALID:int 					= 17;

		/**
		 * Error constant that corresponds to the NetStream.Play.NoSupportedTrackFound status code.
		 **/
		public static const NO_SUPPORTED_TRACK_FOUND:int 				= 18;

		/**
		 * Error constant for when a NetStream cannot be played due to a NetConnection failure.
		 **/
		public static const PLAY_FAILED_NETCONNECTION_FAILURE:int 		= 19;

		/**
		 * Error constant for when a DRM system update fails.
		 **/
		public static const DRM_SYSTEM_UPDATE_ERROR:int					= 20;

		/**
		 * Error constant for when a DVRCast NetConnection cannot connect because the attempt
		 * to subscribe to the DVRCast stream fails.
		 **/
		public static const DVRCAST_SUBSCRIPTION_FAILED:int				= 21;
		
		/**
		 * Error constant for when a DVRCast NetConnection cannot connect because the DVRCast
		 * application is offline.
		 **/
		public static const DVRCAST_CONTENT_OFFLINE:int					= 22;
		
		/**
		 * Error constant for when information about the DVRCast stream cannot be retrieved.
		 **/
		public static const DVRCAST_FAILED_RETREIVING_STREAM_INFO:int	= 23;

		/**
		 * Error constant for when a plugin fails to load due to a version mismatch.
		 **/
		public static const INVALID_PLUGIN_VERSION:int					= 24;
				
		/**
		 * Error constant for when a plugin fails to load due to the PluginInfo not
		 * being exposed on the root Sprite of the plugin.
		 **/
		public static const INVALID_PLUGIN_IMPLEMENTATION:int			= 25;

		/**
		 * Error constant for when an HTTP GET request fails due to a client error
		 * (i.e. returns a 4xx status code).
		 **/
		public static const HTTP_GET_CLIENT_ERROR:int 					= 26;

		/**
		 * Error constant for when an HTTP GET request fails due to an I/O error.
		 **/
		public static const HTTP_GET_IO_ERROR:int 						= 27;
		
		/**
		 * Error constant for when an HTTP GET request fails due to a security error.
		 **/
		public static const HTTP_GET_SECURITY_ERROR:int					= 28;
						
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
			  {errorID:IMAGE_OR_SWF_IO_LOAD_ERROR,				message:OSMFStrings.IMAGE_OR_SWF_IO_LOAD_ERROR}
			, {errorID:IMAGE_OR_SWF_SECURITY_LOAD_ERROR,		message:OSMFStrings.IMAGE_OR_SWF_SECURITY_LOAD_ERROR}
			, {errorID:AUDIO_IO_LOAD_ERROR,						message:OSMFStrings.AUDIO_IO_LOAD_ERROR}
			, {errorID:AUDIO_SECURITY_LOAD_ERROR,				message:OSMFStrings.AUDIO_SECURITY_LOAD_ERROR}
			, {errorID:PLAY_FAILED_NO_SOUND_CHANNELS,			message:OSMFStrings.PLAY_FAILED_NO_SOUND_CHANNELS}
			, {errorID:INVALID_URL_PROTOCOL,					message:OSMFStrings.INVALID_URL_PROTOCOL}
			, {errorID:NETCONNECTION_REJECTED,					message:OSMFStrings.NETCONNECTION_REJECTED}
			, {errorID:NETCONNECTION_INVALID_APP,				message:OSMFStrings.NETCONNECTION_INVALID_APP}
			, {errorID:NETCONNECTION_FAILED,					message:OSMFStrings.NETCONNECTION_FAILED}
			, {errorID:NETCONNECTION_TIMEOUT,					message:OSMFStrings.NETCONNECTION_TIMEOUT}
			, {errorID:NETCONNECTION_SECURITY_ERROR,			message:OSMFStrings.NETCONNECTION_SECURITY_ERROR}
			, {errorID:NETCONNECTION_ASYNC_ERROR,				message:OSMFStrings.NETCONNECTION_ASYNC_ERROR}
			, {errorID:NETCONNECTION_IO_ERROR,					message:OSMFStrings.NETCONNECTION_IO_ERROR}
			, {errorID:NETCONNECTION_ARGUMENT_ERROR,			message:OSMFStrings.NETCONNECTION_ARGUMENT_ERROR}
			, {errorID:PLAY_FAILED, 							message:OSMFStrings.PLAY_FAILED}
			, {errorID:STREAM_NOT_FOUND,	 					message:OSMFStrings.STREAM_NOT_FOUND}
			, {errorID:FILE_STRUCTURE_INVALID,					message:OSMFStrings.FILE_STRUCTURE_INVALID}
			, {errorID:NO_SUPPORTED_TRACK_FOUND,				message:OSMFStrings.NO_SUPPORTED_TRACK_FOUND}
			, {errorID:PLAY_FAILED_NETCONNECTION_FAILURE, 		message:OSMFStrings.PLAY_FAILED_NETCONNECTION_FAILURE}
			, {errorID:DRM_SYSTEM_UPDATE_ERROR,					message:OSMFStrings.DRM_SYSTEM_UPDATE_ERROR}
			, {errorID:INVALID_PLUGIN_VERSION,					message:OSMFStrings.INVALID_PLUGIN_VERSION}
			, {errorID:INVALID_PLUGIN_IMPLEMENTATION,			message:OSMFStrings.INVALID_PLUGIN_IMPLEMENTATION}
			, {errorID:HTTP_GET_CLIENT_ERROR,					message:OSMFStrings.HTTP_GET_CLIENT_ERROR}
			, {errorID:HTTP_GET_IO_ERROR,						message:OSMFStrings.HTTP_GET_IO_ERROR}
			, {errorID:HTTP_GET_SECURITY_ERROR,					message:OSMFStrings.HTTP_GET_SECURITY_ERROR}
		];
	}
}