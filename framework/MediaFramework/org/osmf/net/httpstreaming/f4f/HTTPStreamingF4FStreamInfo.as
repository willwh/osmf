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
	import flash.utils.ByteArray;
	
	[ExcludeClass]
	
	/**
	 * @private
	 **/
	public class HTTPStreamingF4FStreamInfo
	{
		public function HTTPStreamingF4FStreamInfo(streamName:String, bitrate:Number=NaN, additionalHeader:ByteArray=null)
		{
			super();
			
			_streamName = streamName;
			_bitrate = bitrate;
			_additionalHeader = additionalHeader;
		}
		
		public function get streamName():String
		{
			return _streamName;
		}

		public function get bitrate():Number
		{
			return _bitrate;
		}
		
		public function get additionalHeader():ByteArray
		{
			return _additionalHeader;
		}
		
		private var _streamName:String;
		private var _bitrate:Number;
		private var _additionalHeader:ByteArray;
	}
}