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
package org.osmf.net
{
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.URL;
	
	/**
	 * @private
	 * 
	 **/
	internal class NetStreamUtils
	{
		/**
		 * Returns the stream name to be passed to NetStream for a given URL,
		 * the empty string if no such stream name can be extracted.
		 **/
		public static function getStreamNameFromURL(url:URL):String
		{
			var streamName:String = "";
			
			// The stream name varies based on RTMP vs. progressive.
			if (url != null)
			{
				if (isRTMPStream(url))
				{
					var fmsURL:FMSURL = url as FMSURL;
					if (fmsURL == null)
					{
						fmsURL = new FMSURL(url.rawUrl);
					}
	
					streamName = fmsURL.streamName;
	
					// Add optional query parameters to the stream name.
					if (url.query != null && url.query != "")
					{
						 streamName += "?" + url.query;
					}
				}
				else
				{
					streamName = url.rawUrl;
				}
			}
			
			return streamName;
		}
		
		/**
		 * Returns true if the given URL represents an RTMP stream, false otherwise.
		 **/
		public static function isRTMPStream(url:URL):Boolean
		{
			if (url == null) return false;
			
			var protocol:String = url.protocol;
			
			if (protocol == null || protocol.length <= 0)
			{
				return false;
			}
			
			return (protocol.search(/^rtmp$|rtmp[tse]$|rtmpte$/i) != -1);
		}
	}
}