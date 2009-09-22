/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*
*  Contributor(s): Adobe Systems Inc.
*   
*****************************************************/
package org.openvideoplayer.vast.model
{
	/**
	 * Class representing a MediaFile element in a VAST document.
	 */
	public class VASTMediaFile
	{
		/**
		 * Constant for the delivery property, when the media file is
		 * delivered as a stream.
		 **/
		public static const DELIVERY_STREAMING:String 	= "streaming";

		/**
		 * Constant for the delivery property, when the media file is
		 * delivered progressively.
		 **/
		public static const DELIVERY_PROGRESSIVE:String = "progressive";		

		/**
		 * Constructor.
		 */			
		public function VASTMediaFile()
		{
			super();
			
			_bitrate = 0;
		}
		
		/**
		 * The URL of the media file.
		 */
		public function get url():String 
		{
			return _url;
		}
		
		public function set url(value:String):void 
		{
			_url = value;
		}

		/**
		 * The media file's identifier.
		 */
		public function get id():String 
		{
			return _id;
		}
		
		public function set id(value:String):void 
		{
			_id = value;
		}

		/**
		 * Method of delivery for the media file, usually "streaming" or "progressive".
		 */
		public function get delivery():String 
		{
			return _delivery;
		}
		
		public function set delivery(value:String):void 
		{
			_delivery = value;
		}
		
		/**
		 * The bitrate of the encoded media file in kilobits per second.
		 */
		public function get bitrate():Number 
		{
			return _bitrate;
		}
		
		public function set bitrate(value:Number):void 
		{
			_bitrate = value;
		}
		
		/**
		 * The width of the media in pixels.
		 */
		public function get width():int 
		{
			return _width;
		}
		
		public function set width(value:int):void 
		{
			_width = value;
		}
		
		/**
		 * The height of the media in pixels.
		 */
		public function get height():int 
		{
			return _height;
		}
		
		public function set height(value:int):void 
		{
			_height = value;
		}

		/**
		 * The MIME type of the media file.
		 */
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}

		private var _url:String;
		private var _id:String;
		private var _delivery:String;	// streaming or progressive
		private var _bitrate:Number;
		private var _width:int;
		private var _height:int;
		private var _type:String; 		// The MIME type of the video file asset, i.e.
										// video/x-flv, video/x-ms-wmv, video/x-ra		
	}
}
