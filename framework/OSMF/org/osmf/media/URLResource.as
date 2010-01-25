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
package org.osmf.media
{
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.URL;
	
	/**
	 * URLResource is a media resource that has a URL. It serves as a context object for MediaElements that expect a URL as input.	 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class URLResource extends MediaResourceBase
	{		
		// Public interface
		//
		
		/**
		 * Constructor.
		 * 
		 * @param url The URL of the resource.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function URLResource(url:URL)
		{
			_url = (url == null) ? new URL(null) : url;	
		}
		
		/**
		 * Required by the URLResource constructor, returns a URL object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get url():URL
		{
			return _url;
		}
		
		private var _url:URL;	
	}
}
