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

package org.osmf.manifest
{
	import __AS3__.vec.Vector;
	
	import org.osmf.utils.URL;
	
	[ExcludeClass]
	
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
		 * The &lt;baseURL&gt; element contains the base URL for all relative (HTTP-based) URLs 
		 * in the manifest. It is optional. When specified, its value is prepended to all 
		 * relative URLs (i.e. those URLs that don't begin with "http://" or "https://" 
		 * within the manifest file. (Such URLs may include &lt;media&gt; URLs, &lt;bootstrapInfo&gt; 
		 * URLs, and &lt;drmMetadata&gt; URLs.) 
		 */ 
		public var baseURL:URL;
				
		/**
		 * The &lt;duration&gt; element represents the duration of the media, in seconds. 
		 * It is assumed that all representations of the media have the same duration, 
		 * hence its placement under the document root. It is optional.
		 */ 
		public var duration:Number;
		
		/**
		 * The &lt;mimeType&gt; element represents the MIME type of the media file. It is assumed 
		 * that all representations of the media have the same MIME type, hence its 
		 * placement under the document root. It is optional.
		 */ 
		public var mimeType:String;
		
		/**
		 * The &lt;streamType&gt; element is a string representing the way in which the media is streamed.
		 * Valid values include "live", "recorded", and "any". It is assumed that all representations 
		 * of the media have the same stream type, hence its placement under the document root. 
		 * It is optional.
		 */
		public var streamType:String;
			
		/**
		 * Indicates the means by which content is delivered to the player.  Valid values include 
		 * "streaming" and "progressive". It is optional. If unspecified, then the delivery 
		 * type is inferred from the media protocol. For media with an RTMP protocol, 
		 * the default deliveryType is "streaming". For media with an HTTP protocol, the default 
		 * deliveryType is also "streaming". In the latter case, the &lt;bootstrapInfo&gt; field must be 
		 * present.
		 */ 
		public var deliveryType:String;
		
		/**
		 * Represents the date/time at which the media was first (or will first be) made available. 
		 * It is assumed that all representations of the media have the same start time, hence its 
		 * placement under the document root. The start time must conform to the "date-time" production 
		 * in RFC3339. It is optional.
		 */ 
		public var startTime:Date;
			
		/**
		 * The set of different bitrate streams associated with this media.
		 */ 
		public var media:Vector.<Media> = new Vector.<Media>();
	}
}