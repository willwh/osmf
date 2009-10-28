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
package org.osmf.utils
{
	/**
	 * Repository for all user-facing strings.  Currently just stored as static
	 * constants on the class.
	 **/
	public class MediaFrameworkStrings
	{
		// Runtime Errors
		//
		
		// CompositeTraitFactory
		
		public static const COMPOSITE_TRAIT_NOT_FOUND:String 			= "A composite trait was not found for the given trait";
		
		// General
		
		public static const INVALID_PARAM:String 						= "Invalid param passed to method";
		public static const NULL_PARAM:String 							= "Null param passed to method";
		public static const FUNCTION_MUST_BE_OVERRIDDEN:String			= "This function must be overridden";
				
		// MediaElement
		
		public static const TRAIT_INSTANCE_ALREADY_ADDED:String 		= "An instance of this trait class has already been added to this MediaElement";
		public static const INVALID_INITIALIZATION_ARGS:String			= "Invalid initialization arguments to MediaElement";
				
		// ProxyElement
		
		public static const NULL_WRAPPED_ELEMENT:String					= "The ProxyElement's wrappedElement must have a non-null value";
		public static const WRAPPED_ELEMENT_SET_TWICE:String			= "Cannot set the ProxyElement's wrappedElement value twice";
				
		// ILoadable
		
		public static const MUST_SET_ILOADER_FOR_LOAD:String 			= "Must set ILoader on an ILoadable before calling ILoader.load";
		public static const MUST_SET_ILOADER_FOR_UNLOAD:String 			= "Must set ILoader on an ILoadable before calling ILoader.unload";
		public static const ILOADER_CANT_HANDLER_RESOURCE:String 		= "ILoader unable to handle the given IMediaResource";
		public static const LOADED_CONTEXT_NULL:String 					= "LoadedContext is null for LoadState.LOADED";
		public static const LOADED_CONTEXT_NOT_NULL:String 				= "LoadedContext is non-null for LoadState.CONSTRUCTED";
		
		// LoaderBase
		
		public static const ALREADY_LOADED:String 						= "Loader - attempt to load an already loaded object";
		public static const ALREADY_LOADING:String 						= "Loader - attempt to load a loading object";
		public static const ALREADY_UNLOADED:String 					= "Loader - attempt to unload an already unloaded object";
		public static const ALREADY_UNLOADING:String 					= "Loader - attempt to unload a unloading object";
		
		// MediaTraitBase
		
		public static const OPERATION_REQUIRES_TRAIT_TO_BE_OWNED:String = "This operation requires the trait to be owned";
		
		// VideoLoader
		
		public static const INVALID_CONTENT_PATH:String 				= "The content path to this video stream is invalid";
		public static const NULL_NETSTREAM:String 						= "NetStream on trait is null";
		
		// MediaPlayer
		
		public static const TRAIT_NOT_SUPPORTED:String 					= "MediaPlayer - attempt to use a trait not on the media";		
		
		// Metadata
		
		public static const METADATA_KEY_MEDIA_TYPE:String				= "media type";
		public static const METADATA_KEY_MIME_TYPE:String				= "MIME type";
		public static const NAMESPACE_MUST_NOT_BE_EMPTY:String			= "The namespace string must not be empty";
		
		// MediaErrorCodes
		
		public static const CONTENT_IO_LOAD_ERROR:String				= "I/O error when loading image or SWF";
		public static const CONTENT_SECURITY_LOAD_ERROR:String			= "Security error when loading image or SWF";
		public static const INVALID_SWF_AS_VERSION:String				= "Loading pre-AS3 (AVM1) content is not supported"
		public static const SWF_IO_LOAD_ERROR:String					= "I/O error when loading SWF";
		public static const SWF_SECURITY_LOAD_ERROR:String				= "Security error when loading SWF";
		public static const INVALID_PLUGIN_VERSION:String				= "Plugin failed to load due to version mismatch";
		public static const INVALID_PLUGIN_IMPLEMENTATION:String		= "Plugin failed to load due to improper or missing implementation of IPluginInfo";
		public static const INVALID_URL_PROTOCOL:String					= "Invalid URL protocol";
		public static const PLAY_FAILED:String 							= "Playback failed";
		public static const STREAM_NOT_FOUND:String	 					= "Stream not found";
		public static const FILE_STRUCTURE_INVALID:String				= "File has invalid structure";
		public static const NO_SUPPORTED_TRACK_FOUND:String				= "No supported track found";
		public static const PLAY_FAILED_NETCONNECTION_FAILURE:String 	= "Playback failed due to a NetConnection failure";
		public static const NETCONNECTION_REJECTED:String				= "Connection attempt rejected by FMS server";
		public static const NETCONNECTION_INVALID_APP:String			= "Attempting to connect to an invalid application";
		public static const NETCONNECTION_FAILED:String					= "All NetConnection attempts failed";
		public static const NETCONNECTION_TIMEOUT:String				= "Timed-out trying to establish a good NetConnection";
		public static const NETCONNECTION_SECURITY_ERROR:String			= "Received a net security error while attempting to establish a NetConnection";
		public static const NETCONNECTION_ASYNC_ERROR:String			= "Received an async error while attempting to establish a NetConnection";
		public static const NETCONNECTION_IO_ERROR:String				= "Received an IO error while attempting to establish a NetConnection";
		public static const NETCONNECTION_ARGUMENT_ERROR:String			= "Received an argument error while attempting to establish a NetConnection";
		public static const STREAMSWITCH_INVALID_INDEX:String			= "Dynamic Stream Switching - Invalid index requested";
		public static const STREAMSWITCH_STREAM_NOT_FOUND:String		= "Dynamic Stream Switching - stream not found";
		public static const STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE:String = "Dynamic Stream Switching - stream is not in manual mode";
		public static const AUDIO_IO_LOAD_ERROR:String					= "I/O error when loading audio file";
		public static const AUDIO_SECURITY_LOAD_ERROR:String			= "Security error when loading audio file";
		public static const PLAY_FAILED_NO_SOUND_CHANNELS:String		= "Playback failed due to no sound channels being available";
		public static const HTTP_IO_LOAD_ERROR:String					= "I/O error when loading URL over HTTP";
		public static const HTTP_SECURITY_LOAD_ERROR:String				= "Security error when loading URL over HTTP";
		public static const BEACON_FAILURE_ERROR:String					= "Beacon failed to successfully ping its HTTP URL";
		
		// SwitchingDetailCodes
		
		public static const SWITCHING_UP_BANDWIDTH_SUFFICIENT:String	= "Switching up since average bandwidth is sufficient";
		public static const SWITCHING_DOWN_BANDWIDTH_INSUFFICIENT:String= "Average bandwith is insufficient for the current stream's bitrate";
		public static const SWITCHING_DOWN_BUFFER_INSUFFICIENT:String	= "Buffer length is insufficient";
		public static const SWITCHING_DOWN_FRAMEDROP_UNACCETPABLE:String= "Average dropped Frames per Second is unacceptable for the current stream";
		public static const SWITCHING_DOWN_OTHER:String					= "Switching down";
		public static const SWITCHING_UP_OTHER:String					= "Switching up";
		public static const SWITCHING_MANUAL:String						= "Switching Manual";
				
		// CompositeViewableTrait
		
		public static const INVALID_LAYOUTRENDERER_CONSTRUCTOR:String 	= "Unable to construct ILayoutRenderer implementation";	
		
		// MediaElementLayoutTarget
		
		public static const ILLEGAL_CONSTRUCTOR_INVOKATION:String		= "Use the static getInstance method to obtain a class instance.";
		
		// HTMLElement
		
		public static const UNSUPPORTED_TRAIT_TYPE:String				= "The specified trait type is not supported";
		
		// HTMLLoadableTrait
		
		public static const NULL_SCRIPT_PATH:String						= "Operation requires a valid script path to be set";
		
		// DRM
		
		public static const DRM_CONTENT_METADATA_KEY:String				= "DRMContentMetadata";
		public static const DRM_METADATA_NOT_SET:String					= "Metadata not set on DRMServies";
		public static const DRM_STATUS_CODE:String 						= "DRM.encryptedFLV";
		
		//DRM Errors

		public static const DRM_INVAID_VOUCHER:String					= "InvalidVoucher	  SWF should reacquire license from the server";
		public static const DRM_AUTHENTICATION_FAILED:String			= "AuthenticationFailed	  SWF should ask user to reenter user credentials and retry license acquisition";
		public static const DRM_REQUIRE_SSL:String						= "RequireSSL	 	 This should no longer be thrown for 2.0 content. Still relevant for 1.x content using 1.x stack in AIR.";
		public static const DRM_CONTENT_EXPIRED:String					= "ContentExpired	  SWF should reacquire license from the server:String if server says content expired:String tough luck.";
		public static const DRM_AUTHORIZATION_FAILED:String				= "AuthorizationFailed	  Current user not authorized to view content:String login as a different user";
		public static const DRM_SERVER_CONNECTION_FAILED:String			= "ServerConnectionFailed	  Check network connection";
		public static const DRM_CLIENT_UPDATE_REQUIRED:String			= "ClientUpdateRequired	  Both DRM and FP needs to be upgraded.";
		public static const DRM_INTERNAL_FAILURE:String					= "InternalFailure	  Self explanatory, do we need to say more";
		public static const DRM_WRONG_LICENSE_KEY:String				= "WrongLicenseKey	  Reacquire license from the server";
		public static const DRM_CORRUPTED_FLV:String					= "CorruptedFLV	  Redownload the content";
		public static const DRM_APP_ID_MISMATCH:String					= "AppIDMismatch	  Not using the correct AIR App or Flash SWF";
		public static const DRM_APP_VERSION_MISMATCH:String				= "AppVersionMismatch	  Not in use. Might still be generated by the 1.x stack in AIR.";
		public static const DRM_LICENSE_INTEGRITY:String				= "LicenseIntegrity	  Reacquire license from the server";
		public static const DRM_FLV_HEADER_INTEGRITY_FAILED:String		= "FlvHeaderIntegrityFailed	  Redownload the DRMContentData";
		public static const DRM_PERMISSION_DENIED:String				= "PermissionDenied	 AIR Remote	 SWF loaded by AIR isn't allowed access to Flash Access functionality";
		public static const DRM_MISSING_ADOBE_CP_MODULE:String			= "MissingAdobeCPModule	  Reinstall FP/AIR";
		public static const DRM_LOAD_ADOBE_CP_FAILED:String				= "LoadAdobeCPFailed	  Reinstall FP/AIR. Hard to get this error to fire though through normal usage.";
		public static const DRM_INCOMPATIBLE_ADOBE_CP_VERSION:String	= "IncompatibleAdobeCPVersion	  Reinstall FP/AIR";
		public static const DRM_MISSING_ADOBE_CP_GET_API:String			= "MissingAdobeCPGetAPI	  Reinstall FP/AIR. Hard to get this error to fire though through normal usage.";
		public static const DRM_HOST_AUTHENTICATE_FAILED:String			= "HostAuthenticateFailed	  Reinstall FP/AIR. Hard to get this error to fire though through normal usage.";
		public static const DRM_I15n_FAILED:String						= "I15nFailed	  Remedy is to retry the operation, hopefully Adobe run Indiv server is functional again";
		public static const DRM_DEVICE_BINDING_FAILED:String			= "DeviceBindingFailed	  Remedy is either undo device changes or factory reset, and AdobeCP will re-indiv automatically";
		public static const DRM_CORRUPT_GLOBAL_STATE_STORE:String		= "CorruptGlobalStateStore	  Remedy is to retry the operation atleast once and if that gives the same error, then factory reset, AdobeCP will auto re-indiv";
		public static const DRM_CORRUPT_SERVER_STATE_STORE:String		= "CorruptServerStateStore	  Remedy is to try the operation again, AdobeCP has deleted the offending server store internally";
		public static const DRM_STORE_TAMPERING_DETECTED:String			= "StoreTamperingDetected	  Remedy is to ask user to call customer support. Or a factory reset will work, followed by internal re-indiv";
		public static const DRM_CLOCK_TAMPERING_DETECTED:String			= "ClockTamperingDetected	  Remedy is to fix the clock or reacquire license Authn/Lic/Domain server error";
		public static const DRM_SERVER_ERROR_TRY_AGAIN:String			= "ServerErrorTryAgain	  Server is misbehaving, try the request again";
		public static const DRM_APPLICATION_SPECIFIC_ERROR:String		= "ApplicationSpecificError	  Server returned an error in application specific namespace. Sub error code is application specific, not FAXS known";
		public static const DRM_NEEDS_AUTHENTICATION:String				= "NeedAuthentication	  Remedy is to authenticate the user and then redo license acquisition";
		public static const DRM_CONTENT_NOT_YET_VALID:String			= "ContentNotYetValid	  The acquired license is not yet valid";
		public static const DRM_CACHE_LICENSE_EXPIRED:String			= "CachedLicenseExpired	  Reacquire license from the server";
		public static const DRM_PLAYBACK_WINDOW_EXPIRED:String			= "PlaybackWindowExpired	  Tell the user that they can no longer play this content till the policy expires";
		public static const DRM_INVALID_DRM_PLATFORM:String				= "InvalidDRMPlatform	  This platform is not allowed to playback the content, too bad!";
		public static const DRM_INVALID_DRM_VERSION:String				= "InvalidDRMVersion	  Upgrade the AdobeCP module and retry playback";
		public static const DRM_INVALID_RUNTIME_PLATFORM:String			= "InvalidRuntimePlatform	  This platform is not allowed to playback the content, too bad!";
		public static const DRM_INVALID_RUNTIME_VERSION:String			= "InvalidRuntimeVersion	  Upgrade the Flash Player/AIR and retry playback";
		public static const DRM_UNKNOWN_CONNECTION_TYPE:String			= "UnknownConnectionType	  Unable to detect the connection type, and the policy requires to turn on Output Protection. Ask use to connect another device.";
		public static const DRM_NO_ANALOG_PLAYBACK_ALLOWED:String		= "NoAnalogPlaybackAllowed	  Can't playback on analog device, connect a digital device";
		public static const DRM_NO_ANALOG_PROTECTION_AVAIL:String		= "NoAnalogProtectionAvail	  Can't play back because connected analog device doesn't have the correct capabilities";
		public static const DRM_NO_DIGITAL_PLAYBACK_ALLOWED:String		= "NoDigitalPlaybackAllowed	  Can't playback on digital device, should never happen in real life.";
		public static const DRM_NO_DIGITAL_PROTECTION_AVAIL:String		= "NoDigitalProtectionAvail	  The connected digital device doesn't have the correct capabilities";
				
		// Downloadable
		
		public static const BYTES_DOWNLOADED:String						= "bytesDownloaded";
		public static const BYTES_TOTAL:String							= "bytesTotal";
	}
}
