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
package org.osmf.net.httpstreaming.f4f
{
	import __AS3__.vec.Vector;
	
	import flash.utils.ByteArray;
	
	import org.osmf.net.httpstreaming.HTTPStreamingIndexInfoBase;
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * Info object which is used to initialize the F4F index.
	 **/
	public class HTTPStreamingF4FIndexInfo extends HTTPStreamingIndexInfoBase
	{
		public function HTTPStreamingF4FIndexInfo
			( bootstrapInfoURL:String
			, bootstrapInfoData:ByteArray
			, serverBaseURL:String=null
			, streamInfos:Vector.<HTTPStreamingF4FStreamInfo>=null
			)
		{
			super();
			
			_bootstrapInfoURL = bootstrapInfoURL;
			_bootstrapInfoData = bootstrapInfoData;
			_serverBaseURL = serverBaseURL;
			_streamInfos = streamInfos;
			
			if (	(bootstrapInfoURL == null || bootstrapInfoURL.length <= 0) 
				&& 	bootstrapInfoData == null
			   )
			{
				throw new Error("HTTPStreamingF4FIndexInfo requires a valid value for either the URL to bootstrap information or the bytes of bootstrap information");
			}
		}
		
		public function get bootstrapInfoURL():String
		{
			return _bootstrapInfoURL;
		}

		public function get bootstrapInfoData():ByteArray
		{
			return _bootstrapInfoData;
		}

		public function get serverBaseURL():String
		{
			return _serverBaseURL;
		}

		public function get streamInfos():Vector.<HTTPStreamingF4FStreamInfo>
		{
			return _streamInfos;
		}
		
		private var _bootstrapInfoURL:String;
		private var _bootstrapInfoData:ByteArray;
		private var _serverBaseURL:String;
		private var _streamInfos:Vector.<HTTPStreamingF4FStreamInfo>;
	}
}