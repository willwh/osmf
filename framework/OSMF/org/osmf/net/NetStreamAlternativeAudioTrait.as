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
	import flash.net.NetStreamPlayOptions;
	import flash.net.NetStreamPlayTransitions;
	
	import org.osmf.events.AlternativeAudioEvent;
	import org.osmf.traits.AlternativeAudioTrait;
	import org.osmf.utils.OSMFStrings;
	
	import spark.skins.spark.StackedFormHeadingSkin;
	
	CONFIG::LOGGING
	{
		import org.osmf.logging.Logger;
		import org.osmf.logging.Log;
	}


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
			var nso:NetStreamPlayOptions = new NetStreamPlayOptions();
			
			var playArgs:Object = NetStreamUtils.getPlayArgsForResource(_streamingResource);
			
			nso.start = playArgs.start;
			nso.len = playArgs.len;
			
			nso.streamName = _streamingResource.alternativeAudioItems[indexToChangeTo].stream;
			//
			// FM-925, it seems that the oldStreamName cannot contain parameters,
			// therefore we must remove them
			//
			var sn:String = oldStreamName;
			if (sn != null && sn.indexOf("?") >= 0)
			{
				nso.oldStreamName = sn.substr(0, sn.indexOf("?"));
			}
			else
			{
				nso.oldStreamName = oldStreamName;
			}
			
			nso.transition = NetStreamPlayTransitions.SWAP;
			
			CONFIG::LOGGING
			{
				debug("executeChange() - Changing audio to stream " + _streamingResource.alternativeAudioItems[indexToChangeTo].stream);
			}
			
			switching = true;
			
			_netStream.play2(nso);
		}
		
		private function getIndexForName(url:String):int
		{
			var length:int = _streamingResource.alternativeAudioItems.length;
			for (var  index:int  = 0; index < length; index++)
			{
				if (_streamingResource.alternativeAudioItems[index].stream == url)
					return index;
			}
			return -1;
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			CONFIG::LOGGING
			{
				debug("onNetStatus() - event.info.code=" + event.info.code);
			}
			
			switch (event.info.code) 
			{
				case NetStreamCodes.NETSTREAM_PLAY_START:
					break;
				case NetStreamCodes.NETSTREAM_PLAY_TRANSITION:
					switching  = false;
					actualIndex = getIndexForName(event.info.details);
					lastTransitionIndex = actualIndex;
					break;
				case NetStreamCodes.NETSTREAM_PLAY_FAILED:
					switching  = false;
					break;
				case NetStreamCodes.NETSTREAM_SEEK_NOTIFY:
					switching  = false;
					if (lastTransitionIndex >= 0)
					{
						_currentIndex = lastTransitionIndex;
					}					
					break;
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
					CONFIG::LOGGING
				{
					debug("onNetStatus() - Stopping rules since server has stopped sending data");
				}
					break;
			}			
		}
		
		private function onPlayStatus(info:Object):void
		{
			CONFIG::LOGGING
			{
				debug("onPlayStatus() - info.code=" + info.code);
			}
			
			switch (info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_TRANSITION_COMPLETE:
					if (lastTransitionIndex >= 0)
					{
						_currentIndex = lastTransitionIndex;
						lastTransitionIndex = -1;
					}
					
					CONFIG::LOGGING
				{
					debug("onPlayStatus() - Transition complete to index: " + currentIndex + " with url " + _streamingResource.alternativeAudioItems[currentIndex]);
				}
					
					break;
			}
		}

		CONFIG::LOGGING
		{
			private function debug(...args):void
			{
				logger.debug(new Date().toTimeString() + ">>> NetStreamAlternativeAudioTrait." + args);
			}
		}
		
		private var _netStream:NetStream;
		private var _streamingResource:StreamingURLResource;
		private var _indexToChangeTo:int;
		private var actualIndex:int = -1;
		private var oldStreamName:String;
		private var switching:Boolean;
		private var _currentIndex:int;
		private var lastTransitionIndex:int = -1;

		CONFIG::LOGGING
		{
			private static const logger:Logger = Log.getLogger("org.osmf.net.NetStreamAlternativeAudioTrait");
		}

	}
}
