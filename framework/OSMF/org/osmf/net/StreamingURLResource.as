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
	 * A URLResource which is capable of being streamed. StreamingURLResource adds a streamType property. 
	 * This property allows player code to specify whether the resource being streamed is live or recorded.
	 * 
	 * It is possible for live and recorded streams to have identical URLs.
	 * This subclass was added to support this unusual case. 
	 * When necessary, the streamType property should be used to disambiguate live and recorded streams.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class StreamingURLResource extends URLResource
	{
		/**
		 * Constructor.
		 * 
		 * @param url The URL of the resource.
		 * @param streamType The type of the stream. If null, defaults to StreamType.ANY.
		 * @param dvrProtocol The server side DVR protocol to use. Null by default.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function StreamingURLResource
							( url:URL
							, streamType:String = null
							)
		{
			_streamType = streamType || StreamType.ANY;
			
			super(url);
		}

		/**
         * <p>The StreamType for this resource. The default value is <code>StreamType.ANY</code>.
		 * The StreamType class enumerates the valid stream types.</p>
		 * <p/>
         * <p>This property may return the following string values:</p> 
		 * <table class="innertable" width="640">
		 *   <tr>
		 *     <th>String value</th>
		 *     <th>Description</th>
		 *   </tr>
		 *   <tr>
		 * 	<td><code>StreamType.ANY</code></td>
		 * 	<td>The StreamingURLResource represents a any possible stream type.</td>
		 *   </tr>
		 *   <tr>
		 * 	<td><code>StreamType.LIVE</code></td>
		 * 	<td>The StreamingURLResource represents a live stream.</td>
		 *   </tr>
		 *   <tr>
		 * 	<td><code>StreamType.RECORDED</code></td>
		 * 	<td>The StreamingURLResource represents a recorded stream.</td>
		 *   </tr>
		 * </table>
		 * 
		 * @see StreamType
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get streamType():String
		{
			return _streamType;
		}
		
		private var _streamType:String; // StreamType
	}
}
