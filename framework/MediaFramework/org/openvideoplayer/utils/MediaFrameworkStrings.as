/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.utils
{
	/**
	 * Repository for all user-facing strings.  Currently just stored as static
	 * constants on the class.
	 **/
	public class MediaFrameworkStrings
	{
		// Runtime Errors
		//
		
		// General
		
		public static const INVALID_PARAM:String 						= "Invalid param passed to method";
		public static const NULL_PARAM:String 							= "Null param passed to method";
		public static const FUNCTION_MUST_BE_OVERRIDDEN:String			= "This function must be overridden";
				
		// MediaElement
		
		public static const TRAIT_INSTANCE_ALREADY_ADDED:String 		= "An instance of this trait class has already been added to this MediaElement";
		public static const INVALID_INITIALIZATION_ARGS:String			= "Invalid initialization arguments to MediaElement";
		
		// IMediaInfo
		
		public static const INVALID_MEDIAELEMENT_CONSTRUCTOR:String 	= "Unable to create MediaElement implementation, the class needs a default constructor.";
		public static const INVALID_MEDIAELEMENT_ARGUMENT:String 		= "Unable to create initialization argument for MediaElement, the argument needs a default constructor.";		
		
		// ILoadable
		
		public static const MUST_SET_ILOADER_FOR_LOAD:String 			= "Must set ILoader on an ILoadable before calling ILoader.load";
		public static const MUST_SET_ILOADER_FOR_UNLOAD:String 			= "Must set ILoader on an ILoadable before calling ILoader.unload";
		public static const ILOADER_CANT_HANDLER_RESOURCE:String 		= "ILoader unable to handle the given IMediaResource";
		
		// MediaTraitBase
		
		public static const OPERATION_REQUIRES_TRAIT_TO_BE_OWNED:String = "This operation requires the trait to be owned";
		
		// VideoLoader
		public static const INVALID_CONTENT_PATH:String 				= "The content path to this video stream is invalid";
		public static const NULL_NETSTREAM:String 						= "NetStream on trait is null";
		public static const ALREADY_LOADED:String 						= "VideoLoader - attempt to load an already loaded object";
		public static const ALREADY_LOADING:String 						= "VideoLoader - attempt to load a loading object";
		public static const ALREADY_UNLOADED:String 					= "VideoLoader - attempt to unload an already unloaded object";
		public static const ALREADY_UNLOADING:String 					= "VideoLoader - attempt to unload a unloading object";
		
		// MediaPlayer
		public static const TRAIT_NOT_SUPPORTED:String 					= "MediaPlayer - attempt to use a trait not on the media";		
	}
}
