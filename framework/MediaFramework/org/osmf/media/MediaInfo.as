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
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * Encapsulation of all information needed to dynamically create and
	 * initialize a MediaElement.
	 */
	public class MediaInfo implements IMediaResourceHandler
	{
		// Public interface
		//
		
		/**
		 * Constructor.
		 * @param id An identifier that represents this MediaInfo.
		 * @param resourceHandler The handler that will be used to determine
		 * whether this MediaInfo can handle a particular resource.
		 * @param mediaElementCreationFunction Function which creates a new instance
		 * of the desired MediaElement.  The function must take no params, and
		 * return a MediaElement.
		 * a default (empty) constructor.
		 * @param type The type of this MediaInfo.  If null, the default is
		 * <code>MediaInfoType.STANDARD</code>.
		 * 
		 * @throws ArgumentError If any argument (except type) is null.
		 **/
		public function MediaInfo
							( id:String,
							  resourceHandler:IMediaResourceHandler,
							  mediaElementCreationFunction:Function,
							  type:MediaInfoType=null
							)
		{
			if (	id == null
			     || resourceHandler == null
			     || mediaElementCreationFunction == null
			   )
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			// Make sure our type field has a valid value. 
			type ||= MediaInfoType.STANDARD;
			
			_id = id;
			_resourceHandler = resourceHandler;
			_mediaElementCreationFunction = mediaElementCreationFunction;
			_type = type;
		}
		
		/**
		 *  An identifier that represents this MediaInfo.
		 **/
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * The handler that determines whether this MediaInfo can handle a
		 * particular resource.
		 **/
		public function get resourceHandler():IMediaResourceHandler
		{
			return _resourceHandler;
		}

		/**
		 * Function which creates a new instance of the desired MediaElement.
		 * The function must take no params, and return a MediaElement.
		 **/
		public function get mediaElementCreationFunction():Function
		{
			return _mediaElementCreationFunction;
		}

		/**
		 * The type of this MediaInfo.
		 **/
		public function get type():MediaInfoType
		{
			return _type;
		}
		
		/**
		 * @inheritDoc
		 **/
		public function canHandleResource(resource:IMediaResource):Boolean
		{
			return _resourceHandler != null ? _resourceHandler.canHandleResource(resource) : false;
		}
		
		// Internals
		//
		
		private var _id:String;
		private var _resourceHandler:IMediaResourceHandler;
		private var _mediaElementCreationFunction:Function;
		private var _type:MediaInfoType;
	}
}