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

package org.openvideoplayer.utils
{
	/**
	 * Parses an instance of the URL Class into properties specific to Flash Media Server.
	 * 
	 * @see URL
	 */
	public class FMSURL
	{
		private var _url:URL;
		private var _useInstance:Boolean;
		private var _appName:String;
		private var _instanceName:String;
		private var _streamName:String;
		private var _streamType:String;
		private var _extensionStripping:Boolean;
		
		private static const APPNAME_START_INDEX:uint = 0;
		private static const INSTANCENAME_START_INDEX:uint = 2;
		private static const STREAMNAME_START_INDEX:uint = 4;
		
		public static const MP4_STREAM:String = "mp4:";
		public static const MP3_STREAM:String = "mp3:";
						
		/**
		 * Set the URL object this class will work with.
		 * 
		 * @param url The URL object this class will use to provide FMS-specific information such as app name and instance name.
		 * @param useInstance If true, then the second part of the URL path is considered the instance name,
		 * such as <code>rtmp://host/app/foo/bar/stream</code>. In this case the instance name would be 'foo' and the stream would
		 * be 'bar/stream'.
		 * If false, then the second part of the URL path is considered to be the stream name, 
		 * such as <code>rtmp://host/app/foo/bar/stream</code>. In this case there is no instance name and the stream would 
		 * be 'foo/bar/stream'.
		 * 
		 */
		public function FMSURL(url:URL, useInstance:Boolean=false)
		{
			_url = url;
			_useInstance = useInstance;
			parsePath();
		}
		
		/**
		 * The FMS application name.
		 */
		public function get appName():String
		{
			return _appName;
		}
		
		/** 
		 * The FMS instance name.
		 */
		public function get instanceName():String
		{
			return _instanceName;
		}
		
		/**
		 * The FMS stream name.
		 */
		public function get streamName():String
		{
			return _streamName;
		}
		
		/**
		 * The type of streaming media.  Correspons to one of the constants MP4_STREAM or MP3_STREAM, or the blank stream for 
		 * flv media streams.
		 */
		public function get streamType():String
		{
			return _streamType;
		}
				
		/** 
		 * Parse the path in the URL object into FMS specific properties.
		 */
		private function parsePath():void
		{
			if ((_url.path == null) || (_url.path.length == 0)) {
				return;
			}

 			var pattern:RegExp = /(\/)/;
 			var result:Array = _url.path.split(pattern);
 			
 			if (result != null)
 			{
	 			_appName = result[APPNAME_START_INDEX];
	 			_instanceName = "";
	 			_streamName = "";
	 			
	 			
	 			// If "_definst_" is in the path and in the right place, we'll assume everything after that is the stream
	 			if (_url.path.search(/^.*\/_definst_/i) > -1)
	 			{
	 				_useInstance = true;
	 			}
	 			
	 			var streamStartNdx:uint = STREAMNAME_START_INDEX;

	 			if (_useInstance) 
	 			{
	 				_instanceName = result[INSTANCENAME_START_INDEX];
	 			}
	 			else
	 			{
	 				streamStartNdx = INSTANCENAME_START_INDEX;
	 			}
	 			
	 			for (var i:int = streamStartNdx; i < result.length; i++)
	 			{
	 				_streamName += result[i];
	 			}
	 			
	 			if (_url.path.indexOf(MP4_STREAM) >= 0)  //Don't touch MP4 or MP3 extensions.
	 			{
	 				_streamType = MP4_STREAM;
	 			}
	 			else if (_url.path.indexOf(MP3_STREAM) >= 0)
	 			{
	 				_streamType = MP3_STREAM;
	 			} 	 						 		
 			}			
		}
	}
}
