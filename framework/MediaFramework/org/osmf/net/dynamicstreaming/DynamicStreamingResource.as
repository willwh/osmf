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

package org.osmf.net.dynamicstreaming
{
	import __AS3__.vec.Vector;
	
	import org.osmf.media.IMediaResource;
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.MediaFrameworkStrings;

	/**
	 * DynamicStreamingResource represents a dynamic streaming profile.
	 * This class provides an object representation of a dynamic streaming
	 * profile without any knowledge or assumption of any file format, 
	 * such as SMIL, Media RSS, etc.
	 */
	public class DynamicStreamingResource implements IMediaResource
	{
		/**
		 * Constructor.
		 * 
		 * @param hostURL This is the connection string for all of the streams
		 * in the profile.
		 */
		public function DynamicStreamingResource(hostURL:FMSURL)
		{
			_streamingItems = null;
			_initialIndex = 0;
			_hostName = hostURL;
			_start = START_EITHER_LIVE_OR_VOD;
			_len = DURATION_PLAY_UNTIL_END;
			_reset = true;			
		}
		
		/**
		 * The connection host name for the dynamic streaming profile.
		 */
		public function get hostName():FMSURL
		{
			return _hostName;
		}
		
		/**
		 * Add a DynamicStreamItem to the collection.
		 */
		public function addItem(item:DynamicStreamingItem):void
		{
			if (_streamingItems == null)
			{
				_streamingItems = new Vector.<DynamicStreamingItem>();
			}
			
			_streamingItems.push(item);
			_streamingItems.sort(this.compare);
		}
		
		/**
		 * The number of items in the DynamicStreamItem collection.
		 */
		public function get numItems():int
		{
			if (_streamingItems == null)
			{
				return 0;
			}
			
			return _streamingItems.length;
		}

		/**
		 * Get the DynamicStreamItem at the specified index in the 
		 * collection.
		 * 
		 * @throws RangeError If the index is out of range.
		 */
		public function getItemAt(index:int):DynamicStreamingItem
		{
			if ((_streamingItems == null) || (index >= _streamingItems.length))
			{
				throw new RangeError(MediaFrameworkStrings.INVALID_PARAM);				
			}

			return _streamingItems[index];				
		}
		
		/**
		 * The preferred starting index.
		 * 
		 * @throws RangeError If the index is out of range.
		 */
		public function get initialIndex():int
		{
			return _initialIndex;
		}
		
		public function set initialIndex(value:int):void
		{
			if ((_streamingItems == null) || (value >= _streamingItems.length))
			{
				throw new RangeError(MediaFrameworkStrings.INVALID_PARAM);				
			}
			
			_initialIndex = value;
		}
		    		
		/**
		 * Start time for the stream. 
		 * 
		 * <p>
		 * Valid values are:
		 * <ul>
		 * <li>DynamicStreamingResource.START_EITHER_LIVE_OR_VOD</li>
		 * <li>DynamicStreamingResource.START_LIVE</li>
		 * <li>DynamicStreamingResource.START_VOD</li>
		 * <li>A positive number, plays a recorded stream beginning this many seconds in.</li>
		 * </ul>
		 * </p>
		 *
		 * @see flash.net.NetStream
		 */
		public function get start():Number
		{
			return _start;
		}
		
		public function set start(value:Number):void
		{
			_start = value;
		}
		
		/**
		 * Duration of the playback.
		 * 
		 * <p>
		 * Valid values are:
		 * <ul>
		 * <li>DynamicStreamingResource.DURATION_PLAY_UNTIL_END</li>
		 * <li>DynamicStreamingResource.DURATION_PLAY_SINGLE_FRAME</li>
		 * <li>A positive number, plays a live or recorded stream for this many seconds.</li>
		 * </ul>
		 * </p>
		 *
		 * @see flash.net.NetStream
		 */
		public function get len():Number
		{
			return _len;
		}
		
		public function set len(value:Number):void
		{
			_len = value;
		}
    			
		/**
		 * @inheritDoc
		 */ 
		public function get metadata():Metadata
		{
			if(!metadataCollection)
			{
				metadataCollection = new Metadata();
			}
			return metadataCollection;
		}
		
		/**
		 * A comparison method that determines the behavior of the sort of the vector member variable.
		 * Given two elements a and b, the function returns one of the following three values:
		 * <ol>
	     * <li>a negative number, if a should appear before b in the sorted sequence</li>
    	 * <li>0, if a equals b</li>
    	 * <li>a positive number, if a should appear after b in the sorted sequence</li>
    	 * </ol>
    	 */
		private function compare(a:DynamicStreamingItem, b:DynamicStreamingItem):Number
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
    					
		/**
		 * Returns the index associated with a stream name. The match will be tried 
		 * both with and without a mp4: prefix. Returns -1 if no match is found.
		 * @private
		 */		
		internal function indexFromName(name:String):int 
		{
			for (var i:int = 0; i < _streamingItems.length; i++) 
			{
				if (name == _streamingItems[i].streamName || "mp4:" + name == _streamingItems[i].streamName) 
				{
					return i;
				}
			}
			return -1;
		}
											
		private var metadataCollection:Metadata;
		private var _hostName:FMSURL;
		private var _streamingItems:Vector.<DynamicStreamingItem>;
		private var _initialIndex:int;
		private var _start:Number;
		private var _len:Number;	// Duration of the playback	
		private var _reset:Boolean;	// Whether to clear a playlist		
		
		/**
		 * Valid value for the <code>start</code> property and
		 * corresponds to the NetStream.play() start argument.
		 * <p>
		 * Looks for a live stream, then a recorded stream, if it 
		 * finds neither, opens a live stream.
		 * </p>
		 */
		public static const START_EITHER_LIVE_OR_VOD:int = -2;
		
		/**
		 * Valid value for the <code>start</code> property and
		 * corresponds to the NetStream.play() start argument.
		 * <p>
		 * Plays only a live stream.
		 * </p>
		 */
		public static const START_LIVE:int = -1;
		
		/**
		 * Valid value for the <code>start</code> property and
		 * corresponds to the NetStream.play() start argument.
		 * <p>
		 * Plays a video on demand stream beginning 0 seconds in.
		 * </p>
		 */
		public static const START_VOD:int = 0;

		/**
		 * Valid value for the <code>len</code> property and
		 * corresponds to the NetStream.play() len argument.
		 * 
		 * <p>
		 * Plays a live or recorded stream until it ends.
		 * </p>
		 */		
		 public static const DURATION_PLAY_UNTIL_END:int = -1;
		 
		/**
		 * Valid value for the <code>len</code> property and
		 * corresponds to the NetStream.play() len argument.
		 * 
		 * <p>
		 * Plays a single frame that is <code>start</code> seconds
		 * from the beginning of a recorded stream.
		 * </p>
		 */
		 public static const DURATION_PLAY_SINGLE_FRAME:int = 0;
	}
}
