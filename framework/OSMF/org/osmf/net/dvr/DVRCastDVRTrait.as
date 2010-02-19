/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.net.dvr
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.NullFacetSynthesizer;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.traits.DVRTrait;
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * Defines a DVRTrait subclass that interacts with a DVRCast equiped
	 * FMS server.
	 */	
	public class DVRCastDVRTrait extends DVRTrait
	{
		/**
		 * @inherited
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function DVRCastDVRTrait(streamInfo:KeyValueFacet, connection:NetConnection, stream:NetStream)
		{
			this.connection = connection;
			this.stream = DVRCastNetStream(stream);
			
			updateProperties(streamInfo);
			
			calculateOffset();
			
			streamInfoRetreiver = new DVRCastStreamInfoRetreiver(connection, streamName); 
			streamInfoRetreiver.addEventListener(Event.COMPLETE, onStreamInfoRetreiverComplete);
			
			configurateStreamInfoUpdateTimer(); 
		}
		
		// Overrides
		//
		
		/**
		 * @inherited
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function get livePosition():Number
		{
			return _livePosition;
		}
		
		/**
		 * @inherited
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override protected function isRecordingChangeEnd():void
		{
			configurateStreamInfoUpdateTimer();
			
			super.isRecordingChangeEnd();
		}
		
		// Internals
		//
		
		private var connection:NetConnection;
		private var stream:DVRCastNetStream;
		private var streamInfoUpdateTimer:Timer;
		private var streamInfoRetreiver:DVRCastStreamInfoRetreiver; 
		
		private var streamName:String;
		private var beginOffset:Number;
		private var endOffset:Number;
		private var currentDuration:Number;
		private var maxDuration:Number;
		
		private var _livePosition:Number;
		
		private var offset:Number;
		
		private static const STREAM_INFO_UPDATE_DELAY:Number		= 3000;
		
		private static const KEY_CALL_TIME:ObjectIdentifier 		= new ObjectIdentifier("callTime");
		private static const KEY_OFFLINE:ObjectIdentifier 			= new ObjectIdentifier("offline");
		private static const KEY_BEGIN_OFFSET:ObjectIdentifier 		= new ObjectIdentifier("beginOffset");
		private static const KEY_END_OFFSET:ObjectIdentifier 		= new ObjectIdentifier("endOffset");
		private static const KEY_RECORDING_START:ObjectIdentifier 	= new ObjectIdentifier("startRec");
		private static const KEY_RECORDING_STOP:ObjectIdentifier 	= new ObjectIdentifier("stopRec");
		private static const KEY_IS_RECORDING:ObjectIdentifier 		= new ObjectIdentifier("isRec");
		private static const KEY_STREAM_NAME:ObjectIdentifier 		= new ObjectIdentifier("streamName");
		private static const KEY_LAST_UPDATE:ObjectIdentifier 		= new ObjectIdentifier("lastUpdate");
		private static const KEY_CURRENT_LENGTH:ObjectIdentifier 	= new ObjectIdentifier("currLen");
		private static const KEY_MAX_LENGTH:ObjectIdentifier 		= new ObjectIdentifier("maxLen");
		
		private static const DVRCAST_GET_STREAM_INFO_RPC:String		= "DVRGetStreamInfo";
		
		private function updateProperties(streamInfo:KeyValueFacet):void
		{
			trace("updateProperties!");
			
			streamName 			= streamInfo.getValue(KEY_STREAM_NAME);
			beginOffset 		= streamInfo.getValue(KEY_BEGIN_OFFSET) || 0;
			endOffset 			= streamInfo.getValue(KEY_END_OFFSET) || 0;
			currentDuration		= streamInfo.getValue(KEY_CURRENT_LENGTH) || 0;
			maxDuration			= streamInfo.getValue(KEY_MAX_LENGTH) || 0;
			
			setIsRecording(streamInfo.getValue(KEY_IS_RECORDING));
		}
		
		private function calculateOffset():void
		{
			offset = 0;
			
			if (endOffset != 0)
			{
				if (currentDuration > endOffset)
				{
					offset = currentDuration - endOffset;
				}
				else
				{
					offset
						= currentDuration > beginOffset
							? beginOffset
							: currentDuration;
				}
			}
			else if (beginOffset != 0)
			{
				offset
					= currentDuration > beginOffset
						? beginOffset
						: currentDuration;
			}
		}
		
		private function configurateStreamInfoUpdateTimer():void
		{
			if (isRecording)
			{
				if (streamInfoUpdateTimer == null)
				{
					streamInfoUpdateTimer = new Timer(STREAM_INFO_UPDATE_DELAY);
					streamInfoUpdateTimer.addEventListener(TimerEvent.TIMER, onStreamInfoUpdateTimer);
					streamInfoUpdateTimer.start();
				}
			}
			else
			{
				if (streamInfoUpdateTimer != null)
				{
					streamInfoUpdateTimer.removeEventListener(TimerEvent.TIMER, onStreamInfoUpdateTimer);
					streamInfoUpdateTimer.stop();
					streamInfoUpdateTimer = null;
				}
			}
		}
		
		private function onStreamInfoUpdateTimer(event:TimerEvent):void
		{
			streamInfoRetreiver.retreive();
		}
		
		private function onStreamInfoRetreiverComplete(event:Event):void
		{
			if (streamInfoRetreiver.streamInfo != null)
			{
				var streamInfo:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.DVRCAST_METADATA, NullFacetSynthesizer);
				for (var key:String in streamInfoRetreiver.streamInfo)
				{
					streamInfo.addValue(new ObjectIdentifier(key), streamInfoRetreiver.streamInfo[key]);
				}
				
				updateProperties(streamInfo);
			}
			else
			{
				dispatchEvent
					( new MediaErrorEvent
						( MediaErrorEvent.MEDIA_ERROR
						, false, false
						, new MediaError(MediaErrorCodes.DVRCAST_FAILED_RETREIVING_STREAM_INFO)
						)
					);
			}
		}
		
	}
}