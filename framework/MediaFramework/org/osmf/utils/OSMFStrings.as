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
	 * Repository for all user-facing strings.  Currently just stored as static
	 * constants on the class.
	 **/
	public class OSMFStrings
	{
		/**
		 * Returns the user-facing string for the given key.  All possible keys
		 * are defined as static constants on this class.  The parameters are
		 * optional substitution variables, formatted as {0}, {1}, etc.
		 **/
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
		 **/
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
		
		public static const COMPOSITE_TRAIT_NOT_FOUND:String 			= "compositeTraitNotFound";
		
		// General
		
		public static const INVALID_PARAM:String 						= "invalidParam";
		public static const NULL_PARAM:String 							= "nullParam";
		public static const FUNCTION_MUST_BE_OVERRIDDEN:String			= "functionMustBeOverridden";
		public static const ALREADY_LISTED:String						= "alreadyListed";
				
		// MediaElement
		
		public static const TRAIT_INSTANCE_ALREADY_ADDED:String 		= "traitInstanceAlreadyAdded";
		public static const TRAIT_RESOLVER_ALREADY_ADDED:String 		= "traitResolverAlreadyAdded";
		public static const TRAIT_TYPE_MISMATCH:String					= "traitTypeMismatch";
								
		// ILoadable
		
		public static const MUST_SET_ILOADER_FOR_LOAD:String 			= "mustSetILoaderForLoad"
		public static const MUST_SET_ILOADER_FOR_UNLOAD:String 			= "mustSetILoaderForUnload";
		public static const ILOADER_CANT_HANDLE_RESOURCE:String 		= "iLoaderCantHandleResource";
		public static const LOADED_CONTEXT_NULL:String 					= "loadedContextNull";
		public static const LOADED_CONTEXT_NOT_NULL:String 				= "loadedContextNonNull";
		
		// LoaderBase
		
		public static const ALREADY_READY:String 						= "alreadyReady";
		public static const ALREADY_LOADING:String 						= "alreadyLoading";
		public static const ALREADY_UNLOADED:String 					= "alreadyUnloaded";
		public static const ALREADY_UNLOADING:String 					= "alreadyUnloading";
		
		// NetLoader
		
		public static const NULL_NETSTREAM:String 						= "nullNetStream";
		
		// MediaPlayer
		
		public static const TRAIT_NOT_SUPPORTED:String 					= "traitNotSupported";		
		
		// Metadata
		
		public static const NAMESPACE_MUST_NOT_BE_EMPTY:String			= "namespaceMustNotBeEmpty";
		public static const NAMESPACE_MUST_BE_UNIQUE:String				= "namespaceMustBeUnique";
		public static const NAMESPACE_MUST_EQUAL_GROUP_NS:String		= "namespaceMustEqualGroupNS";		
		
		// MediaErrorCodes
		
		public static const CONTENT_IO_LOAD_ERROR:String				= "contentIOLoadError";
		public static const CONTENT_SECURITY_LOAD_ERROR:String			= "contentSecurityLoadError";
		public static const INVALID_SWF_AS_VERSION:String				= "invalidSwfASVersion"
		public static const SWF_IO_LOAD_ERROR:String					= "swfIOLoadError";
		public static const SWF_SECURITY_LOAD_ERROR:String				= "swfSecurityError";
		public static const INVALID_PLUGIN_VERSION:String				= "invalidPluginVersion";
		public static const INVALID_PLUGIN_IMPLEMENTATION:String		= "invalidPluginImplementation";
		public static const INVALID_URL_PROTOCOL:String					= "invalidURLProtocol";
		public static const PLAY_FAILED:String 							= "playbackFailed";
		public static const STREAM_NOT_FOUND:String	 					= "streamNotFound";
		public static const FILE_STRUCTURE_INVALID:String				= "fileStructureInvalid";
		public static const NO_SUPPORTED_TRACK_FOUND:String				= "noSupportedTrackFound";
		public static const PLAY_FAILED_NETCONNECTION_FAILURE:String 	= "playFailedNetConnectionFailure";
		public static const NETCONNECTION_REJECTED:String				= "netConnectionRejected";
		public static const NETCONNECTION_INVALID_APP:String			= "netConnectionInvalidApp";
		public static const NETCONNECTION_FAILED:String					= "netConnectionFailed";
		public static const NETCONNECTION_TIMEOUT:String				= "netConnectionTimeout";
		public static const NETCONNECTION_SECURITY_ERROR:String			= "netConnectionSecurityError";
		public static const NETCONNECTION_ASYNC_ERROR:String			= "netConnectionAsyncError";
		public static const NETCONNECTION_IO_ERROR:String				= "netConnectionIOError";
		public static const NETCONNECTION_ARGUMENT_ERROR:String			= "netConnectionArgumentError";
		public static const STREAMSWITCH_INVALID_INDEX:String			= "streamSwitchInvalidIndex";
		public static const STREAMSWITCH_STREAM_NOT_FOUND:String		= "streamSwitchStreamNotFound";
		public static const STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE:String = "streamSwitchStreamNotInManualMode";
		public static const AUDIO_IO_LOAD_ERROR:String					= "audioIOLoadError";
		public static const AUDIO_SECURITY_LOAD_ERROR:String			= "audioSecurityLoadError";
		public static const PLAY_FAILED_NO_SOUND_CHANNELS:String		= "playFailedNoSoundChannels";
		public static const HTTP_IO_LOAD_ERROR:String					= "httpIOLoadError";
		public static const HTTP_SECURITY_LOAD_ERROR:String				= "httpSecurityLoadError";
		public static const BEACON_FAILURE_ERROR:String					= "beaconFailureError";
		
		// SwitchingDetailCodes
		
		public static const SWITCHING_UP_BANDWIDTH_SUFFICIENT:String	= "switchingUpBandwidthSufficient";
		public static const SWITCHING_DOWN_BANDWIDTH_INSUFFICIENT:String= "switchingDownBandwidthInsufficient";
		public static const SWITCHING_DOWN_BUFFER_INSUFFICIENT:String	= "switchingDownBufferInsufficient";
		public static const SWITCHING_DOWN_FRAMEDROP_UNACCEPTABLE:String= "switchingDownFrameDropUnacceptable";
		public static const SWITCHING_DOWN_OTHER:String					= "switchingDownOther";
		public static const SWITCHING_UP_OTHER:String					= "switchingUpOther";
		public static const SWITCHING_MANUAL:String						= "switchingManual";
				
		// CompositeViewableTrait
		
		public static const INVALID_LAYOUTRENDERER_CONSTRUCTOR:String 	= "invalidLayoutRendererConstructor";	
		
		// MediaElementLayoutTarget
		
		public static const ILLEGAL_CONSTRUCTOR_INVOKATION:String		= "illegalConstructorInvocation";
		
		// HTMLElement
		
		public static const UNSUPPORTED_TRAIT_TYPE:String				= "unsupportedTraitType";
		
		// HTMLLoadableTrait
		
		public static const NULL_SCRIPT_PATH:String						= "nullScriptPath";
		
		// DRM
		
		public static const DRM_METADATA_NOT_SET:String					= "drmMetadataNotSet";
		
		// DRM Errors

		public static const DRM_AUTHENTICATION_FAILED:String			= "drmAuthenticationFailed";
		public static const DRM_NEEDS_AUTHENTICATION:String				= "drmNeedsAuthentication";
		public static const DRM_CONTENT_NOT_YET_VALID:String			= "drmContentNotYetValid";
		
		// Flash Media Manifest Errors
		public static const F4M_PARSE_NO_ID:String						= "f4mParseNoId";
		
		private static const resourceDict:Dictionary = new Dictionary();
		{
			resourceDict[COMPOSITE_TRAIT_NOT_FOUND]	 				= "A composite trait was not found for the given trait";
			resourceDict[INVALID_PARAM]								= "Invalid param passed to method";
			resourceDict[NULL_PARAM]								= "Null param passed to method";
			resourceDict[FUNCTION_MUST_BE_OVERRIDDEN]				= "This function must be overridden";
			resourceDict[ALREADY_LISTED]							= "The item is already listed";
			
			resourceDict[TRAIT_INSTANCE_ALREADY_ADDED]				= "An instance of this trait class has already been added to this MediaElement";
			resourceDict[TRAIT_RESOLVER_ALREADY_ADDED]				= "A trait resolver for the specified trait type has already been added to this MediaElement";
			resourceDict[TRAIT_TYPE_MISMATCH]						= "The specified trait instance is of an unexpectted type";
			
			resourceDict[MUST_SET_ILOADER_FOR_LOAD] 				= "Must set ILoader on an ILoadable before calling ILoader.load";
			resourceDict[MUST_SET_ILOADER_FOR_UNLOAD] 				= "Must set ILoader on an ILoadable before calling ILoader.unload";
			resourceDict[ILOADER_CANT_HANDLE_RESOURCE]				= "ILoader unable to handle the given IMediaResource";
			resourceDict[LOADED_CONTEXT_NULL] 						= "LoadedContext is null for LoadState.READY";
			resourceDict[LOADED_CONTEXT_NOT_NULL] 					= "LoadedContext is non-null for LoadState.UNINITIALIZED";

			resourceDict[ALREADY_READY] 							= "Loader - attempt to load an already loaded object";
			resourceDict[ALREADY_LOADING] 							= "Loader - attempt to load a loading object";
			resourceDict[ALREADY_UNLOADED] 							= "Loader - attempt to unload an already unloaded object";
			resourceDict[ALREADY_UNLOADING] 						= "Loader - attempt to unload a unloading object";
			
			resourceDict[NULL_NETSTREAM]							= "NetStream on trait is null";
			
			resourceDict[TRAIT_NOT_SUPPORTED]						= "MediaPlayer - method called on null media or media that isn't *trait*";
			resourceDict[NAMESPACE_MUST_NOT_BE_EMPTY]				= "The namespace string must not be empty";
			resourceDict[NAMESPACE_MUST_BE_UNIQUE]					= "The namespace string must be unique";
			resourceDict[NAMESPACE_MUST_EQUAL_GROUP_NS]				= "The namespace string must be equal to the group namespace";		

			resourceDict[SWITCHING_UP_BANDWIDTH_SUFFICIENT]			= "Switching up since average bandwidth is sufficient";
			resourceDict[SWITCHING_DOWN_BANDWIDTH_INSUFFICIENT]		= "Average bandwith is insufficient for the current stream's bitrate";
			resourceDict[SWITCHING_DOWN_BUFFER_INSUFFICIENT]		= "Buffer length is insufficient";
			resourceDict[SWITCHING_DOWN_FRAMEDROP_UNACCEPTABLE]		= "Average dropped Frames per Second is unacceptable for the current stream";
			resourceDict[SWITCHING_DOWN_OTHER]						= "Switching down";
			resourceDict[SWITCHING_UP_OTHER]						= "Switching up";
			resourceDict[SWITCHING_MANUAL]							= "Switching Manual";

			resourceDict[INVALID_LAYOUTRENDERER_CONSTRUCTOR]		= "Unable to construct ILayoutRenderer implementation";
			
			resourceDict[UNSUPPORTED_TRAIT_TYPE]					= "The specified trait type is not supported";

			resourceDict[DRM_METADATA_NOT_SET]						= "Metadata not set on DRMServices";	
			resourceDict[DRM_AUTHENTICATION_FAILED]					= "AuthenticationFailed	  SWF should ask user to reenter user credentials and retry license acquisition";
			resourceDict[DRM_NEEDS_AUTHENTICATION]					= "NeedAuthentication	  Remedy is to authenticate the user and then redo license acquisition";
			resourceDict[DRM_CONTENT_NOT_YET_VALID]					= "ContentNotYetValid	  The acquired license is not yet valid";
		
			resourceDict[NULL_SCRIPT_PATH]							= "Operation requires a valid script path to be set";
			
			resourceDict[ILLEGAL_CONSTRUCTOR_INVOKATION]			= "Use the static getInstance method to obtain a class instance.";
			
			resourceDict[CONTENT_IO_LOAD_ERROR]						= "I/O error when loading image or SWF";
			resourceDict[CONTENT_SECURITY_LOAD_ERROR]				= "Security error when loading image or SWF";
			resourceDict[INVALID_SWF_AS_VERSION]					= "Loading pre-AS3 (AVM1) content is not supported"
			resourceDict[SWF_IO_LOAD_ERROR]							= "I/O error when loading SWF";
			resourceDict[SWF_SECURITY_LOAD_ERROR]					= "Security error when loading SWF";
			resourceDict[INVALID_PLUGIN_VERSION]					= "Plugin failed to load due to version mismatch";
			resourceDict[INVALID_PLUGIN_IMPLEMENTATION]				= "Plugin failed to load due to improper or missing implementation of IPluginInfo";
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
			resourceDict[STREAMSWITCH_STREAM_NOT_FOUND]				= "Dynamic Stream Switching - stream not found";
			resourceDict[STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE]	= "Dynamic Stream Switching - stream is not in manual mode";
			resourceDict[AUDIO_IO_LOAD_ERROR]						= "I/O error when loading audio file";
			resourceDict[AUDIO_SECURITY_LOAD_ERROR]					= "Security error when loading audio file";
			resourceDict[PLAY_FAILED_NO_SOUND_CHANNELS]				= "Playback failed due to no sound channels being available";
			resourceDict[HTTP_IO_LOAD_ERROR]						= "I/O error when loading URL over HTTP";
			resourceDict[HTTP_SECURITY_LOAD_ERROR]					= "Security error when loading URL over HTTP";
			resourceDict[BEACON_FAILURE_ERROR]						= "Beacon failed to successfully ping its HTTP URL";
			
			resourceDict[F4M_PARSE_NO_ID]							= "Missing id tag from manifest";

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
