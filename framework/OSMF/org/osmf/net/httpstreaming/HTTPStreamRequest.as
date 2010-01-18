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
package org.osmf.net.httpstreaming
{
	import flash.net.URLRequest;
	
	[ExcludeClass]
	
	/**
	 * @private
	 **/
	public class HTTPStreamRequest
	{
		/**
		 * Constructor.
		 * 
		 * quality of -1 means "same as was requested"
		 * truncateAt of -1 means "don't truncate" 
		 **/
		public function HTTPStreamRequest(url:String = null, quality:int = -1, truncateAt:Number = -1)
		{
			super();
			
			if (url)
			{
				_urlRequest = new URLRequest(url);
			}
			else
			{
				_urlRequest = null;
			}
			
			this.quality = quality;
			this.truncateAt = truncateAt;
		}
		
		public function get urlRequest():URLRequest
		{
			return _urlRequest;
		}

		private var _urlRequest:URLRequest;
		private var quality:int;
		private var truncateAt:Number;
	}
}