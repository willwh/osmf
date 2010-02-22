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
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.traits.DVRTrait;
	
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
			this.connection = connection;
			this.stream = DVRCastNetStream(stream);
			this.resource = resource;
			
			streamInfo 
				= resource.metadata.getFacet(MetadataNamespaces.DVRCAST_METADATA)
				. getValue(DVRCastConstants.KEY_STREAM_INFO);
			
			streamInfoRetreiver = new DVRCastStreamInfoRetreiver(connection, streamInfo.streamName); 
			streamInfoRetreiver.addEventListener(Event.COMPLETE, onStreamInfoRetreiverComplete);
			
			streamInfoUpdateTimer = new Timer(DVRCastConstants.STREAM_INFO_UPDATE_DELAY);
			streamInfoUpdateTimer.addEventListener(TimerEvent.TIMER, onStreamInfoUpdateTimer);
			streamInfoUpdateTimer.start(); 
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			super(streamInfo.isRecording);
			updateProperties();
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
			return 0;
		}
		
		override protected function isRecordingChangeStart(value:Boolean):void
		{
			var recordingInfo:DVRCastRecordingInfo
					=	resource.metadata.getFacet(MetadataNamespaces.DVRCAST_METADATA)
					.	getValue(DVRCastConstants.KEY_RECORDING_INFO)
					as 	DVRCastRecordingInfo;
					
			if (value)
			{
				// We're going into recording mode.
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
		private var stream:DVRCastNetStream;
		private var resource:MediaResourceBase;
		
		private var streamInfo:DVRCastStreamInfo;
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
				//trace(streamInfoRetreiver.streamInfo);
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
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				//case NetStreamCodes.NETSTREAM_PLAY_STOP:
			//		break;	
			}
		}
		
	}
}