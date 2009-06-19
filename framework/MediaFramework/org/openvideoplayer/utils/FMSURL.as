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
		 * Parse the path in the URL object into FMS specific properties.
		 */
		private function parsePath():void
		{
			if (!_url.path || !_url.path.length) {
				return;
			}

 			var pattern:RegExp = /(\/)/;
 			var result:Array = _url.path.split(pattern);
 			
 			if (result)
 			{
	 			_appName = result[0];
	 			_instanceName = "";
	 			_streamName = "";
	 			
	 			var streamStartNdx:uint = 2;
	 			
	 			// If "_definst_" is in the path and in the right place, we'll assume everything after that is the stream
	 			if (_url.path.search(/^.*\/_definst_/i) > -1)
	 			{
	 				_useInstance = true;
	 			}
	 			
	 			if (_useInstance) 
	 			{
	 				_instanceName = result[2];
	 				streamStartNdx = 4;
	 			}
	 			
	 			for (var i:int = streamStartNdx; i < result.length; i++)
	 			{
	 				_streamName += result[i];
	 			}
 				
 			}			
		}
	}
}
