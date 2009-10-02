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
package org.osmf.media
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.utils.MediaFrameworkStrings;
	
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
		 * @param type The type of this MediaInfo.  If null, then defaults
		 * to <code>MediaInfoType.STANDARD</code>.
		 * 
		 * @throws ArgumentError If any argument (except type) is null.
		 **/
		public function MediaInfo
							( id:String,
							  resourceHandler:IMediaResourceHandler,
							  mediaElementType:Class,
							  mediaElementInitializationArgs:Array,
							  type:MediaInfoType=null
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
			
			// Make sure our type field has a valid value. 
			type ||= MediaInfoType.STANDARD;
			
			_id = id;
			this.resourceHandler = resourceHandler;
			this.mediaElementType = mediaElementType;
			this.mediaElementInitializationArgs = mediaElementInitializationArgs;
			_type = type;
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
		public function get type():MediaInfoType
		{
			return _type;
		}
		
		/**
		 * @inheritDoc
		 **/
		public function createMediaElement():MediaElement
		{
			var result:MediaElement = null;
			
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

			result.initialize(initializationObjects);
			
			return result;
		}
		
		// Internals
		//
		
		private var _id:String;
		private var resourceHandler:IMediaResourceHandler;
		private var mediaElementType:Class;
		private var mediaElementInitializationArgs:Array;
		private var _type:MediaInfoType;
	}
}