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
	import flash.utils.Dictionary;
	
	/**
	 * Client class for accessing all user-facing strings.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class OSMFStrings
	{
		/**
		 * Returns the user-facing string for the given key.  All possible keys
		 * are defined as static constants on this class.  The parameters are
		 * optional substitution variables, formatted as {0}, {1}, etc.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function getString(key:String, params:Array=null):String
		{
			return resourceStringFunction(key, params);
		}
		
		/**
		 * Function that the getString methods uses to retrieve a user-facing string.
		 * This function takes a String parameter (which is expected to be one of
		 * the static consts on this class) and an optional Array of parameters
		 * which can be substituted into the String (formatted as {0}, {1}, etc.).
		 * 
		 * Clients can supply their own getString function to localize the strings.
		 * By default, the getString function returns an English-language String.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static function get resourceStringFunction():Function
		{
			return _resourceStringFunction;
		}

		public static function set resourceStringFunction(value:Function):void
		{
			_resourceStringFunction = value;
		}
		
		// Runtime Errors
		//
		
		// CompositeTraitFactory
		
		/**
		 * @private
		 **/
		public static const COMPOSITE_TRAIT_NOT_FOUND:String 			= "compositeTraitNotFound";
		
		// General
		
		/**
		 * @private
		 **/
		public static const INVALID_PARAM:String 						= "invalidParam";

		/**
		 * @private
		 **/
		public static const NULL_PARAM:String 							= "nullParam";

		/**
		 * @private
		 **/
		public static const FUNCTION_MUST_BE_OVERRIDDEN:String			= "functionMustBeOverridden";

		/**
		 * @private
		 **/
		public static const ALREADY_ADDED:String						= "alreadyAdded";

		/**
		 * @private
		 **/
		public static const UNSUPPORTED_MEDIA_ELEMENT_TYPE:String		= "unsupportedMediaElementType";

		// MediaElement
		
		/**
		 * @private
		 **/
		public static const TRAIT_INSTANCE_ALREADY_ADDED:String 		= "traitInstanceAlreadyAdded";

		/**
		 * @private
		 **/
		public static const TRAIT_RESOLVER_ALREADY_ADDED:String 		= "traitResolverAlreadyAdded";
		
		// MediaPlayer
		
		/**
		 * @private
		 **/
		public static const CAPABILITY_NOT_SUPPORTED:String				= "capabilityNotSupported";
		
				/**
		 * @private
		 **/
		public static const MEDIA_LOAD_FAILED:String 					= "mediaLoadFailed";

		// LoadTrait
		
		/**
		 * @private
		 **/
		public static const MUST_SET_LOADER:String 						= "mustSetLoader";

		/**
		 * @private
		 **/
		public static const LOADER_CANT_HANDLE_RESOURCE:String 			= "loaderCantHandleResource";
		
		// LoaderBase
		
		/**
		 * @private
		 **/
		public static const ALREADY_READY:String 						= "alreadyReady";

		/**
		 * @private
		 **/
		public static const ALREADY_LOADING:String 						= "alreadyLoading";

		/**
		 * @private
		 **/
		public static const ALREADY_UNLOADED:String 					= "alreadyUnloaded";

		/**
		 * @private
		 **/
		public static const ALREADY_UNLOADING:String 					= "alreadyUnloading";
		
		// CompositeDisplayObjectTrait
		
		/**
		 * @private
		 **/
		public static const INVALID_LAYOUT_RENDERER_CONSTRUCTOR:String 	= "invalidLayoutRendererConstructor";	
		
		// MediaElementLayoutTarget
		
		/**
		 * @private
		 **/
		public static const ILLEGAL_CONSTRUCTOR_INVOCATION:String		= "illegalConstructorInvocation";
		
		// MediaContainer
		
		/**
		 * @private
		 **/
		public static const DIRECT_DISPLAY_LIST_MOD_ERROR:String		= "directDisplayListModError";
		
		// HTMLLoadTrait
		
		/**
		 * @private
		 **/
		public static const NULL_SCRIPT_PATH:String						= "nullScriptPath";
		
		// DRM
		
		CONFIG::FLASH_10_1
		{
		/**
		 * @private
		 **/
		public static const DRM_METADATA_NOT_SET:String					= "drmMetadataNotSet";
		}
		
		// DVR
		
		/**
		 * @private
		 **/
		public static const DVR_MAXIMUM_RPC_ATTEMPTS:String				= "dvrMaximumRPCAttempts";
		
		/**
		 * @private
		 **/
		public static const DVR_UNEXPECTED_SERVER_RESPONSE:String		= "dvrUnexpectedServerResponse";
		
		// Flash Media Manifest Errors
		
		/**
		 * @private
		 **/
		public static const F4M_PARSE_PROFILE_MISSING:String			= "f4mProfileMissing";

		/**
		 * @private
		 **/
		public static const F4M_PARSE_MEDIA_URL_MISSING:String			= "f4mMediaURLMissing";

		/**
		 * @private
		 **/
		public static const F4M_PARSE_BITRATE_MISSING:String			= "f4mBitrateMissing";
		
		// MediaErrorCodes
		
		/**
		 * @private
		 **/
		public static const IMAGE_OR_SWF_IO_LOAD_ERROR:String			= "imageOrSWFIOLoadError";

		/**
		 * @private
		 **/
		public static const IMAGE_OR_SWF_SECURITY_LOAD_ERROR:String		= "imageOrSWFSecurityLoadError";

		/**
		 * @private
		 **/
		public static const SWF_IO_LOAD_ERROR:String					= "swfIOLoadError";

		/**
		 * @private
		 **/
		public static const SWF_SECURITY_LOAD_ERROR:String				= "swfSecurityError";

		/**
		 * @private
		 **/
		public static const INVALID_PLUGIN_VERSION:String				= "invalidPluginVersion";

		/**
		 * @private
		 **/
		public static const INVALID_PLUGIN_IMPLEMENTATION:String		= "invalidPluginImplementation";

		/**
		 * @private
		 **/
		public static const INVALID_URL_PROTOCOL:String					= "invalidURLProtocol";

		/**
		 * @private
		 **/
		public static const PLAY_FAILED:String 							= "playbackFailed";

		/**
		 * @private
		 **/
		public static const STREAM_NOT_FOUND:String	 					= "streamNotFound";

		/**
		 * @private
		 **/
		public static const FILE_STRUCTURE_INVALID:String				= "fileStructureInvalid";

		/**
		 * @private
		 **/
		public static const NO_SUPPORTED_TRACK_FOUND:String				= "noSupportedTrackFound";

		/**
		 * @private
		 **/
		public static const PLAY_FAILED_NETCONNECTION_FAILURE:String 	= "playFailedNetConnectionFailure";

		/**
		 * @private
		 **/
		public static const NETCONNECTION_REJECTED:String				= "netConnectionRejected";

		/**
		 * @private
		 **/
		public static const NETCONNECTION_INVALID_APP:String			= "netConnectionInvalidApp";

		/**
		 * @private
		 **/
		public static const NETCONNECTION_FAILED:String					= "netConnectionFailed";

		/**
		 * @private
		 **/
		public static const NETCONNECTION_TIMEOUT:String				= "netConnectionTimeout";

		/**
		 * @private
		 **/
		public static const NETCONNECTION_SECURITY_ERROR:String			= "netConnectionSecurityError";

		/**
		 * @private
		 **/
		public static const NETCONNECTION_ASYNC_ERROR:String			= "netConnectionAsyncError";

		/**
		 * @private
		 **/
		public static const NETCONNECTION_IO_ERROR:String				= "netConnectionIOError";

		/**
		 * @private
		 **/
		public static const NETCONNECTION_ARGUMENT_ERROR:String			= "netConnectionArgumentError";

		/**
		 * @private
		 **/
		public static const STREAMSWITCH_INVALID_INDEX:String			= "streamSwitchInvalidIndex";

		/**
		 * @private
		 **/
		public static const STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE:String = "streamSwitchStreamNotInManualMode";

		/**
		 * @private
		 **/
		public static const AUDIO_IO_LOAD_ERROR:String					= "audioIOLoadError";

		/**
		 * @private
		 **/
		public static const AUDIO_SECURITY_LOAD_ERROR:String			= "audioSecurityLoadError";

		/**
		 * @private
		 **/
		public static const PLAY_FAILED_NO_SOUND_CHANNELS:String		= "playFailedNoSoundChannels";

		/**
		 * @private
		 **/
		public static const HTTP_GET_IO_ERROR:String					= "httpGetIOError";

		/**
		 * @private
		 **/
		public static const HTTP_GET_SECURITY_ERROR:String				= "httpGetSecurityError";

		/**
		 * @private
		 **/
		public static const HTTP_GET_CLIENT_ERROR:String				= "httpGetClientError";

		/**
		 * @private
		 **/
		public static const DRM_SYSTEM_UPDATE_ERROR:String				= "drmSystemUpdateError";
		
		
		private static const resourceDict:Dictionary = new Dictionary();
		{
			resourceDict[COMPOSITE_TRAIT_NOT_FOUND]	 				= "There is no composite trait for the given trait type";
			resourceDict[INVALID_PARAM]								= "Invalid parameter passed to method";
			resourceDict[NULL_PARAM]								= "Unexpected null parameter passed to method";
			resourceDict[FUNCTION_MUST_BE_OVERRIDDEN]				= "Function must be overridden";
			resourceDict[ALREADY_ADDED]								= "Child has already been added";
			resourceDict[UNSUPPORTED_MEDIA_ELEMENT_TYPE]			= "The specified media element type is not supported";
			
			resourceDict[TRAIT_INSTANCE_ALREADY_ADDED]				= "An instance of this trait class has already been added to this MediaElement";
			resourceDict[TRAIT_RESOLVER_ALREADY_ADDED]				= "A trait resolver for the specified trait type has already been added to this MediaElement";
			
			resourceDict[CAPABILITY_NOT_SUPPORTED]					= "The specified capability is not currently supported";
			resourceDict[MEDIA_LOAD_FAILED]							= "The loading of a MediaElement failed";
			
			resourceDict[MUST_SET_LOADER] 							= "Must set LoaderBase on a LoadTrait before calling load or unload";
			resourceDict[LOADER_CANT_HANDLE_RESOURCE]				= "LoaderBase unable to handle the given MediaResourceBase";

			resourceDict[ALREADY_READY] 							= "Loader - attempt to load an already loaded object";
			resourceDict[ALREADY_LOADING] 							= "Loader - attempt to load a loading object";
			resourceDict[ALREADY_UNLOADED] 							= "Loader - attempt to unload an already unloaded object";
			resourceDict[ALREADY_UNLOADING] 						= "Loader - attempt to unload a unloading object";
			
			resourceDict[INVALID_LAYOUT_RENDERER_CONSTRUCTOR]		= "Unable to construct LayoutRenderer implementation";
			resourceDict[ILLEGAL_CONSTRUCTOR_INVOCATION]			= "Use the static getInstance method to obtain a class instance";
			resourceDict[DIRECT_DISPLAY_LIST_MOD_ERROR]				= "The direct addition or removal of display objects onto a MediaContainer is prohibited.";

			resourceDict[NULL_SCRIPT_PATH]							= "Operation requires a valid script path";
			
			CONFIG::FLASH_10_1
			{
			resourceDict[DRM_METADATA_NOT_SET]						= "Metadata not set on DRMServices";
			}	
			
			resourceDict[DVR_MAXIMUM_RPC_ATTEMPTS] 					= "Maximum DVRGetStreamInfo RPC attempts (%i) reached";
			resourceDict[DVR_UNEXPECTED_SERVER_RESPONSE]			= "Unexpected server response: ";
			
			resourceDict[F4M_PARSE_PROFILE_MISSING]					= "Profile missing from Bootstrap info tag";
			resourceDict[F4M_PARSE_MEDIA_URL_MISSING]				= "URL missing from Media tag";
			resourceDict[F4M_PARSE_BITRATE_MISSING]					= "Bitrate missing from Media tag";

			resourceDict[IMAGE_OR_SWF_IO_LOAD_ERROR]				= "I/O error when loading image or SWF";
			resourceDict[IMAGE_OR_SWF_SECURITY_LOAD_ERROR]			= "Security error when loading image or SWF";
			resourceDict[SWF_IO_LOAD_ERROR]							= "I/O error when loading SWF";
			resourceDict[SWF_SECURITY_LOAD_ERROR]					= "Security error when loading SWF";
			resourceDict[INVALID_PLUGIN_VERSION]					= "Plugin failed to load due to version mismatch";
			resourceDict[INVALID_PLUGIN_IMPLEMENTATION]				= "Plugin failed to load due to improper or missing implementation of PluginInfo";
			resourceDict[INVALID_URL_PROTOCOL]						= "Invalid URL protocol";
			resourceDict[PLAY_FAILED] 								= "Playback failed";
			resourceDict[STREAM_NOT_FOUND]	 						= "Stream not found";
			resourceDict[FILE_STRUCTURE_INVALID]					= "File has invalid structure";
			resourceDict[NO_SUPPORTED_TRACK_FOUND]					= "No supported track found";
			resourceDict[PLAY_FAILED_NETCONNECTION_FAILURE] 		= "Playback failed due to a NetConnection failure";
			resourceDict[NETCONNECTION_REJECTED]					= "Connection attempt rejected by FMS server";
			resourceDict[NETCONNECTION_INVALID_APP]					= "Attempting to connect to an invalid application";
			resourceDict[NETCONNECTION_FAILED]						= "All NetConnection attempts failed";
			resourceDict[NETCONNECTION_TIMEOUT]						= "Timed-out trying to establish a good NetConnection";
			resourceDict[NETCONNECTION_SECURITY_ERROR]				= "Received a net security error while attempting to establish a NetConnection";
			resourceDict[NETCONNECTION_ASYNC_ERROR]					= "Received an async error while attempting to establish a NetConnection";
			resourceDict[NETCONNECTION_IO_ERROR]					= "Received an IO error while attempting to establish a NetConnection";
			resourceDict[NETCONNECTION_ARGUMENT_ERROR]				= "Received an argument error while attempting to establish a NetConnection";
			resourceDict[STREAMSWITCH_INVALID_INDEX]				= "Dynamic Stream Switching - Invalid index requested";
			resourceDict[STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE]	= "Dynamic Stream Switching - stream is not in manual mode";
			resourceDict[AUDIO_IO_LOAD_ERROR]						= "I/O error when loading audio file";
			resourceDict[AUDIO_SECURITY_LOAD_ERROR]					= "Security error when loading audio file";
			resourceDict[PLAY_FAILED_NO_SOUND_CHANNELS]				= "Playback failed due to no sound channels being available";
			resourceDict[HTTP_GET_IO_ERROR]							= "I/O error when retrieving URL over HTTP";
			resourceDict[HTTP_GET_SECURITY_ERROR]					= "Security error when retrieving URL over HTTP";
			resourceDict[HTTP_GET_CLIENT_ERROR]						= "HTTP GET failed due to a Client Error";
			resourceDict[DRM_SYSTEM_UPDATE_ERROR]					= "The update of the DRM subsystem failed";
			
			resourceDict["missingStringResource"]					= "No string for resource {0}";
		}

		private static function defaultResourceStringFunction(resourceName:String, params:Array=null):String
		{
			var value:String = resourceDict.hasOwnProperty(resourceName) ? String(resourceDict[resourceName]) : null;
			
			if (value == null)
			{
				value = String(resourceDict["missingStringResource"]);
				params = [resourceName];
			}
			
			if (params)
			{
				value = substitute(value, params);
			}
			
			return value;
		}
		
		private static function substitute(value:String, ... rest):String
		{
			var result:String = "";

			if (value != null)
			{
				result = value;
				
				// Replace all of the parameters in the value string.
				var len:int = rest.length;
				var args:Array;
				if (len == 1 && rest[0] is Array)
				{
					args = rest[0] as Array;
					len = args.length;
				}
				else
				{
					args = rest;
				}
				
				for (var i:int = 0; i < len; i++)
				{
					result = result.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
				}
			}
			
			return result;
		}

		private static var _resourceStringFunction:Function = defaultResourceStringFunction;
	}
}
