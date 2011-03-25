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
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.osmf.events.AlternativeAudioEvent;
	import org.osmf.traits.AlternativeAudioTrait;
	import org.osmf.utils.OSMFStrings;

	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * The NetStreamalternativeAudioTrait class extends AlternativeAudioTrait for NetStream-based
	 * alternative audio support.
	 */   
	public class NetStreamAlternativeAudioTrait extends AlternativeAudioTrait
	{
		/**
		 * Constructor.
		 * 
		 * @param netStream The NetStream object the class will work with.
		 * @param dsResource The DynamicStreamingResource the class will use.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function NetStreamAlternativeAudioTrait(netStream:NetStream, streamingResource:StreamingURLResource)
		{
			super(streamingResource.alternativeAudioItems.length, streamingResource.initialAlternativeAudioIndex);	
			
			_netStream = netStream;
			_streamingResource = streamingResource;
		}
		
		override public function dispose():void
		{
			_netStream = null;
		}
		
		/**
		 * @private
		 */
		override public function getMediaItemForIndex(index:int):MediaItem
		{
			if (index < 0 || index >= numAlternativeAudioStreams)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.ALTERNATIVEAUDIO_INVALID_INDEX));
			}

			return _streamingResource.alternativeAudioItems[index];
		}	
				
		/**
		 * @private
		 */
		override protected function beginChangingStream(newChangingStream:Boolean, index:int):void
		{
			if (newChangingStream /*&& !inSetSwitching*/)
			{
				// Keep track of the target index, we don't want to begin
				// the switch now since our switching state won't be
				// updated until the switchingChangeEnd method is called.
				_indexToChangeTo = index;
			}
		}
		
		/**
		 * @private
		 */
		override protected function endChangingStream(index:int):void
		{
			super.endChangingStream(index)
			
			if (changingStream /*&& !inSetSwitching*/)
			{
				executeChangeStream(_indexToChangeTo);
			}
		}
		
		/**
		 * @private
		 */
		protected function executeChangeStream(indexToChangeTo:int):void
		{
		}
		
		private var _netStream:NetStream;
		private var _streamingResource:StreamingURLResource;
		private var _indexToChangeTo:int;
	}
}
