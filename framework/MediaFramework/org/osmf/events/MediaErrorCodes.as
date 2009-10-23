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
			, {code:3300,	description:"InvalidVoucher	  SWF should reacquire license from the server"}
			, {code:3301,	description:"AuthenticationFailed	  SWF should ask user to reenter user credentials and retry license acquisition"}
			, {code:3302,	description:"RequireSSL	 	 This should no longer be thrown for 2.0 content. Still relevant for 1.x content using 1.x stack in AIR."}
			, {code:3303,	description:"ContentExpired	  SWF should reacquire license from the server, if server says content expired, tough luck."}
			, {code:3304,	description:"AuthorizationFailed	  Current user not authorized to view content, login as a different user"}
			, {code:3305,	description:"ServerConnectionFailed	  Check network connection"}
			, {code:3306,	description:"ClientUpdateRequired	  Both DRM and FP needs to be upgraded."}
			, {code:3307,	description:"InternalFailure	  Self explanatory, do we need to say more"}
			, {code:3308,	description:"WrongLicenseKey	  Reacquire license from the server"}
			, {code:3309,	description:"CorruptedFLV	  Redownload the content"}
			, {code:3310,	description:"AppIDMismatch	  Not using the correct AIR App or Flash SWF"}
			, {code:3311,	description:"AppVersionMismatch	  Not in use. Might still be generated by the 1.x stack in AIR."}
			, {code:3312,	description:"LicenseIntegrity	  Reacquire license from the server"}
			, {code:3314,	description:"FlvHeaderIntegrityFailed	  Redownload the DRMContentData"}
			, {code:3315,	description:"PermissionDenied	 AIR Remote	 SWF loaded by AIR isn't allowed access to Flash Access functionality"}
			, {code:3316,	description:"MissingAdobeCPModule	  Reinstall FP/AIR"}
			, {code:3317,	description:"LoadAdobeCPFailed	  Reinstall FP/AIR. Hard to get this error to fire though through normal usage."}
			, {code:3318,	description:"IncompatibleAdobeCPVersion	  Reinstall FP/AIR"}
			, {code:3319,	description:"MissingAdobeCPGetAPI	  Reinstall FP/AIR. Hard to get this error to fire though through normal usage."}
			, {code:3320,	description:"HostAuthenticateFailed	  Reinstall FP/AIR. Hard to get this error to fire though through normal usage."}
			, {code:3321,	description:"I15nFailed	  Remedy is to retry the operation, hopefully Adobe run Indiv server is functional again"}
			, {code:3322,	description:"DeviceBindingFailed	  Remedy is either undo device changes or factory reset, and AdobeCP will re-indiv automatically"}
			, {code:3323,	description:"CorruptGlobalStateStore	  Remedy is to retry the operation atleast once and if that gives the same error, then factory reset, AdobeCP will auto re-indiv"}
			, {code:3325,	description:"CorruptServerStateStore	  Remedy is to try the operation again, AdobeCP has deleted the offending server store internally"}
			, {code:3326,	description:"StoreTamperingDetected	  Remedy is to ask user to call customer support. Or a factory reset will work, followed by internal re-indiv"}
			, {code:3327,	description:"ClockTamperingDetected	  Remedy is to fix the clock or reacquire license Authn/Lic/Domain server error"}
			, {code:3328,	description:"ServerErrorTryAgain	  Server is misbehaving, try the request again"}
			, {code:3329,	description:"ApplicationSpecificError	  Server returned an error in application specific namespace. Sub error code is application specific, not FAXS known"}
			, {code:3330,	description:"NeedAuthentication	  Remedy is to authenticate the user and then redo license acquisition"}
			, {code:3331,	description:"ContentNotYetValid	  The acquired license is not yet valid"}
			, {code:3332,	description:"CachedLicenseExpired	  Reacquire license from the server"}
			, {code:3333,	description:"PlaybackWindowExpired	  Tell the user that they can no longer play this content till the policy expires"}
			, {code:3334,	description:"InvalidDRMPlatform	  This platform is not allowed to playback the content, too bad!"}
			, {code:3335,	description:"InvalidDRMVersion	  Upgrade the AdobeCP module and retry playback"}
			, {code:3336,	description:"InvalidRuntimePlatform	  This platform is not allowed to playback the content, too bad!"}
			, {code:3337,	description:"InvalidRuntimeVersion	  Upgrade the Flash Player/AIR and retry playback"}
			, {code:3338,	description:"UnknownConnectionType	  Unable to detect the connection type, and the policy requires to turn on Output Protection. Ask use to connect another device."}
			, {code:3339,	description:"NoAnalogPlaybackAllowed	  Can't playback on analog device, connect a digital device"}
			, {code:3340,	description:"NoAnalogProtectionAvail	  Can't play back because connected analog device doesn't have the correct capabilities"}
			, {code:3341,	description:"NoDigitalPlaybackAllowed	  Can't playback on digital device, should never happen in real life."}
			, {code:3342,	description:"NoDigitalProtectionAvail	  The connected digital device doesn't have the correct capabilities"}
		];
	}
}