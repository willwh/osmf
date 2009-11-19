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
	import __AS3__.vec.Vector;
	
	/**
	 * The Manifest Object represents the Manifest 
	 */ 
	internal class Manifest
	{			
		/**
		 * The id element represents a unique identifier for the media. It is optional.
		 */
		public var id:String;
		
		/**
		 * The <duration> element represents the duration of the media, in seconds. 
		 * It is assumed that all representations of the media have the same duration, 
		 * hence its placement under the document root. It is optional.
		 */ 
		public var duration:Number;
		
		/**
		 * The <mimeType> element represents the MIME type of the media file. It is assumed 
		 * that all representations of the media have the same MIME type, hence its 
		 * placement under the document root. It is optional.
		 */ 
		public var mimeType:String;
		
		/**
		 * The <streamType> element is a string representing the way in which the media is streamed. 
		 * Valid values include "live", "recorded", and "any". It is assumed that all representations 
		 * of the media have the same stream type, hence its placement under the document root.
		 */
		public var streamType:String;
	
		/**
		 * The set of different bitrate streams associated with this media.
		 */ 
		public var media:Vector.<Media> = new Vector.<Media>();
	}
}