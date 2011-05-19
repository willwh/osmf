/*****************************************************
 *  
 *  Copyright 2011 Adobe Systems Incorporated.  All Rights Reserved.
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
 *  Portions created by Adobe Systems Incorporated are Copyright (C) 2011 Adobe Systems 
 *  Incorporated. All Rights Reserved. 
 *  
 *****************************************************/
package org.osmf.net
{
	/**
	 * StreamingItem represents a part for representing a piece of media
	 * inside a StreamingURLResource.
	 * 
	 * @see org.osmf.net.StreamingURLResource
	 * @see org.osmf.net.StreamingItem
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.6
	 */	
	public class StreamingItem
	{
		/**
		 * Default constructor
		 * 
		 * @param type The type of the stream. 
		 * @param streamName The name that will be used to identify this stream.
		 * @param bitrate The stream's encoded bitrate in kbps.
		 * @param info  The custom information associated with this stream. Usually this object contains
		 * 			    information about width and height of the video, but could also contain user 
		 * 				friendly description of the stream.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function StreamingItem(type:String, streamName:String, bitrate:Number = 0, info:Object = null )
		{
			_type 		= type;
			_streamName	= streamName;
			_bitrate 	= bitrate;
			
			_info 		= info == null ? new Object() : info;
		}

		/**
		 * The stream type.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.6
		 */			
		public function get type():String
		{
			return _type;	
		}

		/**
		 * The name which is used to identify this stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.6
		 */			
		public function get streamName():String
		{
			return _streamName;	
		}
		
		/**
		 * The stream's bitrate, specified in kilobits per second (kbps).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get bitrate():Number
		{
			return _bitrate;
		}

		/**
		 * The custom information associated with this stream. Usually this object contains
		 * information about width and height of the video, but could also contain user 
		 * friendly description of the stream.
		 */
		public function get info():Object
		{
			return _info;
		}
		
		// Internals
		private var _type:String = null;
		private var _streamName:String = null;
		private var _bitrate:Number;
		private var _info:Object = null;
	}
}