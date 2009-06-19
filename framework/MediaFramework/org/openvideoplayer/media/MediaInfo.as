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
package org.openvideoplayer.media
{
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	
	import flash.errors.IllegalOperationError;
	
	/**
	 * Default implementation of IMediaInfo.
	 * 
	 * <p>Each MediaElement which is represented by an instance of this
	 * class must have a default (empty) constructor to support dynamic
	 * instantiation.</p>  
	 */
	public class MediaInfo implements IMediaInfo
	{
		// Public interface
		//
		
		/**
		 * Constructor.
		 * @param id An identifier that represents this IMediaInfo.
		 * @param resourceHandler The handler that will be used to determine
		 * whether this MediaInfo can handle a particular resource.
		 * @param mediaElementType The class of the MediaElement.  Must have
		 * a default (empty) constructor.
		 * @param mediaElementInitializationArgs An array of Objects or Classes
		 * representing the initialization arguments for the media element.
		 * When a media element is dynamically generated, these arguments
		 * will be passed to its initialize() method.  If an argument is a
		 * Class, it will be converted into an instance of that class before
		 * being passed to initialize().  If an argument is not a Class, it
		 * will be passed to initialize() as is.  The latter approach can be
		 * useful for allowing multiple instances of MediaInfo to share
		 * information.
		 * 
		 * @throws ArgumentError If any argument is null.
		 **/
		public function MediaInfo
							( id:String,
							  resourceHandler:IMediaResourceHandler,
							  mediaElementType:Class,
							  mediaElementInitializationArgs:Array
							)
		{
			if (	id == null
			     || resourceHandler == null
			     || mediaElementType == null
			     || mediaElementInitializationArgs == null
			   )
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			_id = id;
			this.resourceHandler = resourceHandler;
			this.mediaElementType = mediaElementType;
			this.mediaElementInitializationArgs = mediaElementInitializationArgs;
		}

		// IMediaResourceHandler
		//
		
		/**
		 * @inheritDoc
		 **/
		public function canHandleResource(resource:IMediaResource):Boolean
		{
			return resourceHandler.canHandleResource(resource);
		}

		// IMediaInfo
		//
		
		/**
		 * @inheritDoc
		 **/
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * @inheritDoc
		 **/
		public function createMediaElement(resource:IMediaResource):MediaElement
		{
			var result:MediaElement = null;
			
			if (canHandleResource(resource))
			{
				result = null;
				
				try
				{
					result = new mediaElementType();
				}
				catch (error:Error)
				{
					throw new IllegalOperationError(MediaFrameworkStrings.INVALID_MEDIAELEMENT_CONSTRUCTOR);
				}
				
				// Apply the initialization arguments.
				var initializationObjects:Array = [];
				for each (var argType:Object in mediaElementInitializationArgs)
				{
					try
					{
						initializationObjects.push
												( argType is Class
													? new argType()
													: argType
												);
					}
					catch (error:Error)
					{
						throw new IllegalOperationError(MediaFrameworkStrings.INVALID_MEDIAELEMENT_ARGUMENT);
					}
				}

				result.resource = resource;
				
				result.initialize(initializationObjects);
					
			}
			
			return result;
		}
		
		// Internals
		//
		
		private var _id:String;
		private var resourceHandler:IMediaResourceHandler;
		private var mediaElementType:Class;
		private var mediaElementInitializationArgs:Array;
	}
}