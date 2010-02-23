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
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.metadata.Facet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.traits.DVRTrait;
	import org.osmf.utils.OSMFStrings;
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * Defines a DVRTrait subclass that interacts with a DVRCast equiped
	 * FMS server.
	 */	
	internal class DVRCastDVRTrait extends DVRTrait
	{
		/**
		 * @inherited
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		

		public function DVRCastDVRTrait(connection:NetConnection, stream:NetStream, resource:MediaResourceBase)
		{
			var dvrCastMetadata:Facet = resource.metadata.getFacet(MetadataNamespaces.DVRCAST_METADATA);
			if (dvrCastMetadata != null)
			{
				this.connection = connection;
				this.stream = stream;
				this.resource = resource;
				
				streamInfo = dvrCastMetadata.getValue(DVRCastConstants.KEY_STREAM_INFO);
				recordingInfo = dvrCastMetadata.getValue(DVRCastConstants.KEY_RECORDING_INFO);
				
				// Setup 
				streamInfoRetreiver = new DVRCastStreamInfoRetreiver(connection, streamInfo.streamName); 
				streamInfoRetreiver.addEventListener(Event.COMPLETE, onStreamInfoRetreiverComplete);
				
				streamInfoUpdateTimer = new Timer(DVRCastConstants.STREAM_INFO_UPDATE_DELAY);
				streamInfoUpdateTimer.addEventListener(TimerEvent.TIMER, onStreamInfoUpdateTimer);
				streamInfoUpdateTimer.start(); 
				
				super(streamInfo.isRecording);
				
				updateProperties();
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
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
			var result:Number;
			
			if (streamInfo.isRecording)
			{
				// When the stream is being recorded:
				result 
					= Math.max
						(	0
						,	// Initial duration available on play start:
							( (recordingInfo.startDuration - recordingInfo.startOffset)
							// Plus the timer measured elapsed time since play start:
							+ (getTimer() - recordingInfo.startTimer) / 1000
							// Substract the time needed in order to keep a buffer:
							- stream.bufferTime
							// Add an additional delta for network lag:
							- DVRCastConstants.LIVE_POSITION_SEEK_DELAY
							)
						,	recordingInfo.startOffset
						);
			} // else, return NaN.
			
			return result;
		}
		
		override protected function isRecordingChangeStart(value:Boolean):void
		{
			if (value)
			{
				// We're going into recording mode: update the start duration, and timer:
				recordingInfo.startDuration = streamInfo.currentLength - recordingInfo.startOffset;
				recordingInfo.startTimer = flash.utils.getTimer();
			}
			else
			{
				// We're leaving recording mode: nothing to do.
			}
		}
		
		// Internals
		//
		
		private var connection:NetConnection;
		private var stream:NetStream;
		private var resource:MediaResourceBase;
		
		private var streamInfo:DVRCastStreamInfo;
		private var recordingInfo:DVRCastRecordingInfo;
		
		private var streamInfoUpdateTimer:Timer;
		private var streamInfoRetreiver:DVRCastStreamInfoRetreiver; 
		
		private var offset:Number;
		
		private function updateProperties():void
		{
			setIsRecording(streamInfo.isRecording);
		}
		
		private function onStreamInfoUpdateTimer(event:TimerEvent):void
		{
			streamInfoRetreiver.retreive();
		}
		
		private function onStreamInfoRetreiverComplete(event:Event):void
		{
			if (streamInfoRetreiver.streamInfo != null)
			{
				streamInfo.readFromDVRCastStreamInfo(streamInfoRetreiver.streamInfo);
				updateProperties();
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