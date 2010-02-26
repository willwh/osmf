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
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.getTimer;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.NetConnectionFactoryEvent;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.Facet;
	import org.osmf.metadata.LocalFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.net.NetConnectionFactory;
	import org.osmf.net.NetStreamUtils;

	[ExcludeClass]

	/**
	 * @private
	 */	
	internal class DVRCastNetConnectionFactory extends NetConnectionFactory
	{
		public function DVRCastNetConnectionFactory()
		{
			addEventListener
				( NetConnectionFactoryEvent.CREATION_COMPLETE
				, onCreationComplete
				, false
				, Number.MAX_VALUE
				);
			
			super();
		}

		override protected function createNetConnection():NetConnection
		{
			return new DVRCastNetConnection();
		}

		override public function create(resource:URLResource):void
		{
			urlResource = resource;
			
			super.create(urlResource);
		}
		
		override public function closeNetConnection(netConnection:NetConnection):void
		{
			if (this.netConnection == netConnection)
			{
				netConnection.call(DVRCastConstants.RPC_UNSUBSCRIBE, null, streamName); 
			}
			
			super.closeNetConnection(netConnection);
		}
		
		// Internals
		//

		private var urlResource:URLResource;
		private var netConnection:DVRCastNetConnection;
		private var streamName:String;
			
		private function onCreationComplete(event:NetConnectionFactoryEvent):void
		{
			// Capture this event, whithold it from the outside world until
			// we have succeeded subscribing to the DVRCast stream:
			event.stopImmediatePropagation();
			
			netConnection = event.netConnection as DVRCastNetConnection;
			
			streamName = NetStreamUtils.getStreamNameFromURL(urlResource.url);
			var responder:Responder 
				= new Responder
					( onStreamSubscriptionResult
					, onServerCallError
					);
			
			event.netConnection.call(DVRCastConstants.RPC_SUBSCRIBE, responder, streamName); 	
		}
		
		private function onStreamSubscriptionResult(result:Object):void
		{
			var streamInfoRetreiver:DVRCastStreamInfoRetreiver
				= new DVRCastStreamInfoRetreiver
					( netConnection
					, streamName
					);
			
			streamInfoRetreiver.addEventListener(Event.COMPLETE, onStreamInfoRetreiverComplete);
			streamInfoRetreiver.retreive();
		}
		
		private function onStreamInfoRetreiverComplete(event:Event):void
		{
			var streamInfoRetreiver:DVRCastStreamInfoRetreiver = event.target as DVRCastStreamInfoRetreiver;
			
			if (streamInfoRetreiver.streamInfo != null)
			{
				// Remove the completion listener:
				removeEventListener(NetConnectionFactoryEvent.CREATION_COMPLETE, onCreationComplete);
			
				if (streamInfoRetreiver.streamInfo.offline == true)
				{
					// The content is offline, signal this as a media error:
					dispatchEvent
						( new NetConnectionFactoryEvent
							( NetConnectionFactoryEvent.CREATION_ERROR 
							, false
							, false
							, netConnection
							, urlResource
							, new MediaError(MediaErrorCodes.DVRCAST_CONTENT_OFFLINE)
							)
						);
						
					// Unsubscribe:
					netConnection.call(DVRCastConstants.RPC_UNSUBSCRIBE, null, streamName);
					netConnection = null;
				}
				else
				{
					// Instantiate a new recording info object:
					var recordingInfo:DVRCastRecordingInfo = new DVRCastRecordingInfo();
					recordingInfo.startDuration = streamInfoRetreiver.streamInfo.currentLength;
					recordingInfo.startOffset = calculateOffset(streamInfoRetreiver.streamInfo);
					recordingInfo.startTimer = flash.utils.getTimer();
					
					// Add the stream info and recording info to the net connection:
					netConnection.streamInfo = streamInfoRetreiver.streamInfo;	
					netConnection.recordingInfo = recordingInfo;
						
					// Now that we're done, signal completion, so the VideoElement will
					// continue its loading process:
					dispatchEvent
						( new NetConnectionFactoryEvent
							( NetConnectionFactoryEvent.CREATION_COMPLETE 
							, false
							, false
							, netConnection
							, urlResource
							)
						);
				}
			}
			else
			{
				onServerCallError(streamInfoRetreiver.error);
			}
		}
		
		private function onServerCallError(error:Object):void
		{
			dispatchEvent
				( new NetConnectionFactoryEvent
					( NetConnectionFactoryEvent.CREATION_ERROR
					, false
					, false
					, netConnection
					, urlResource
					, new MediaError(MediaErrorCodes.DVRCAST_SUBSCRIPTION_FAILED, error.message)
					)
				);
		}
		
		private function calculateOffset(streamInfo:DVRCastStreamInfo):Number
		{
			var offset:Number = 0;
			var endOffset:Number = streamInfo.endOffset;
			var beginOffset:Number = streamInfo.beginOffset;
			var currentDuration:Number = streamInfo.currentLength;
			
			if (endOffset != 0)
			{
				// If an end-offset is set ...
				if (currentDuration > endOffset)
				{
					// ... and more is recorded that the end offset allows
					// to be exposed, than start playing as far back as
					// is allowed:
					offset = currentDuration - endOffset;
				}
				else
				{
					// ... but no the recording is shorter than the 
					// amount of time that is allowed to be viewed, then
					// use the begin offset:
					offset = Math.min(beginOffset, currentDuration);
				}
			}
			else if (beginOffset != 0)
			{
				// The starting point is whatever is lowest: the point from
				// where the viewer is allowed to view the stream, or the
				// available recorded time, so far:
				offset = Math.min(beginOffset, currentDuration);
			}
			
			return offset;
		}
		
	
	}
}