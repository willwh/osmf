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
*****************************************************/
package org.osmf.metadata
{
	import flash.events.EventDispatcher;
	
	import org.osmf.utils.URL;

	/**
	 * Facet class for representing media and MIME types.
	 **/
	public class MediaTypeFacet extends Facet
	{
		public function MediaTypeFacet(mediaType:String = null, mimeType:String = null)
		{			
			super(MetadataNamespaces.MEDIATYPE_METADATA);
			_mediaType = mediaType;
			_mimeType = mimeType;			
		}
		
		/**
		 * The type of media, corresponding to the enumeration
		 * org.osmf.metadata.MediaType. 
		 */ 
		public function get mediaType():String
		{
			return _mediaType;
		}
		
		/**
		 * The IANA mime type as defined in the constructor.
		 */ 
		public function get mimeType():String
		{
			return _mimeType;
		}
			
		private var _mediaType:String;
		private var _mimeType:String;	
	}
}