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
	import org.osmf.media.URLResource;
	import org.osmf.utils.URL;
	
	/**
	 * A URLResource which is capable of being streamed.
	 **/
	public class StreamingURLResource extends URLResource
	{
		/**
		 * Constructor.
		 * 
		 * @param url The URL of the resource.
		 * @param streamType The type of the stream.  If null, defaults to StreamType.ANY.
		 **/
		public function StreamingURLResource(url:URL, streamType:String=null)
		{
			super(url);
			
			_streamType = streamType || StreamType.ANY;
		}

		/**
		 * The StreamType for this resource.
		 **/
		public function get streamType():String
		{
			return _streamType;
		}
		
		private var _streamType:String; // StreamType
	}
}