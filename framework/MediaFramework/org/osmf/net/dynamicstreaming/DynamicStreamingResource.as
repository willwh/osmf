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
*  Contributor: Adobe Systems Inc.
*  
*****************************************************/
package org.osmf.net.dynamicstreaming
{
	import __AS3__.vec.Vector;
	
	import org.osmf.media.IMediaResource;
	import org.osmf.metadata.Metadata;
	import org.osmf.net.StreamType;
	import org.osmf.utils.MediaFrameworkStrings;
	import org.osmf.utils.URL;

	/**
	 * DynamicStreamingResource represents a dynamic streaming profile.
	 * This class provides an object representation of a dynamic streaming
	 * profile without any knowledge or assumption of any file format, 
	 * such as SMIL, Media RSS, etc.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class DynamicStreamingResource implements IMediaResource
	{
		/**
		 * Constructor.
		 * 
		 * @param host A URL representing the host of the dynamic streaming resource.
		 * @param streamType The type of the stream.  If null, defaults to StreamType.ANY.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function DynamicStreamingResource(host:URL, streamType:String=null)
		{
			_host = host;
			_streamType = streamType || StreamType.ANY;
			_initialIndex = 0;
		}
		
		/**
		 * A URL representing the host of the dynamic streaming resource.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get host():URL
		{
			return _host;
		}
		
		/**
		 * The StreamType for this resource.
		 **/
		public function get streamType():String
		{
			return _streamType;
		}
		
		/**
		 * Vector of DynamicStreamingItems.  Each item represents a
		 * different bitrate stream.
		 **/
		public function get streamItems():Vector.<DynamicStreamingItem>
		{
			if (_streamItems == null)
			{
				_streamItems = new Vector.<DynamicStreamingItem>();
			}
			
			return _streamItems;
		}
		
		public function set streamItems(value:Vector.<DynamicStreamingItem>):void
		{
			_streamItems = value;
			
			if (value != null)
			{
				value.sort(compareStreamItems);
			}
		}
		
		/**
		 * The preferred starting index.
		 * 
		 * @throws RangeError If the index is out of range.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get initialIndex():int
		{
			return _initialIndex;
		}
		
		public function set initialIndex(value:int):void
		{
			if (_streamItems == null || value >= _streamItems.length)
			{
				throw new RangeError(MediaFrameworkStrings.INVALID_PARAM);				
			}
			
			_initialIndex = value;
		}
    			
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get metadata():Metadata
		{
			if (_metadata == null)
			{
				_metadata = new Metadata();
			}
			return _metadata;
		}

		// Internals
		//		
    					
		/**
		 * @private
		 * 
		 * Returns the index associated with a stream name. The match will be tried 
		 * both with and without a mp4: prefix. Returns -1 if no match is found.
		 */		
		internal function indexFromName(name:String):int 
		{
			for (var i:int = 0; i < _streamItems.length; i++) 
			{
				if (name == _streamItems[i].streamName || "mp4:" + name == _streamItems[i].streamName) 
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * A comparison method that determines the behavior of the sort of the vector member variable.
		 * Given two elements a and b, the function returns one of the following three values:
		 * <ol>
	     * <li>a negative number, if a should appear before b in the sorted sequence</li>
    	 * <li>0, if a equals b</li>
    	 * <li>a positive number, if a should appear after b in the sorted sequence</li>
    	 * </ol>
    	 *  
    	 *  @langversion 3.0
    	 *  @playerversion Flash 10
    	 *  @playerversion AIR 1.0
    	 *  @productversion OSMF 1.0
    	 */
		private function compareStreamItems(a:DynamicStreamingItem, b:DynamicStreamingItem):Number
		{
			var result:Number = -1;
			
			if (a.bitrate == b.bitrate)
			{
				result = 0;
			}
			else if (a.bitrate > b.bitrate)
			{
				result = 1;
			}
			
			return result;
		}

		private var _host:URL;
		private var _streamType:String; // StreamType
		private var _metadata:Metadata;

		private var _streamItems:Vector.<DynamicStreamingItem>;
		private var _initialIndex:int;
	}
}
