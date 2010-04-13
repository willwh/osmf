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
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.NetConnectionFactoryEvent;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetConnectionFactory;
	import org.osmf.net.NetStreamUtils;
	import org.osmf.net.StreamingURLResource;

	[ExcludeClass]

	/**
	 * @private
	 */	
	public class DVRCastNetConnectionFactory extends NetConnectionFactory
	{
		/**
		 * Constructor.
		 **/
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

		/**
		 * @private
		 **/
		override protected function createNetConnection():NetConnection
		{
			return new DVRCastNetConnection();
		}
		
		/**
		 * @private
		 **/
		override public function closeNetConnection(netConnection:NetConnection):void
		{
			var dvrCastNetConnection:DVRCastNetConnection = netConnection as DVRCastNetConnection;
			if (dvrCastNetConnection)
			{
				netConnection.call
					( DVRCastConstants.RPC_UNSUBSCRIBE
					, null
					, dvrCastNetConnection.streamInfo.streamName
					);	 
			}
			
			super.closeNetConnection(netConnection);
		}
		
		// Internals
		//

		private function onCreationComplete(event:NetConnectionFactoryEvent):void
		{
			var urlResource:URLResource = event.resource as URLResource;
			var netConnection:DVRCastNetConnection = event.netConnection as DVRCastNetConnection
			var streamName:String;
			
			// Capture this event, whithold it from the outside world until
			// we have succeeded subscribing to the DVRCast stream:
			event.stopImmediatePropagation();
			
			netConnection = event.netConnection as DVRCastNetConnection;
			
			var streamingResource:StreamingURLResource = urlResource as StreamingURLResource;
			
			var urlIncludesFMSApplicationInstance:Boolean
				= streamingResource
					? streamingResource.urlIncludesFMSApplicationInstance
					: false;
					
			streamName = NetStreamUtils.getStreamNameFromURL(urlResource.url, urlIncludesFMSApplicationInstance);
			
			var responder:Responder 
				= new Responder
					( onStreamSubscriptionResult
					, onServerCallError
					);
			
			event.netConnection.call(DVRCastConstants.RPC_SUBSCRIBE, responder, streamName);
			
			function onStreamSubscriptionResult(result:Object):void
			{
				var streamInfoRetriever:DVRCastStreamInfoRetriever
					= new DVRCastStreamInfoRetriever
						( netConnection
						, streamName
						);
				
				streamInfoRetriever.addEventListener(Event.COMPLETE, onStreamInfoRetrieverComplete);
				streamInfoRetriever.retrieve();
			}
			
			function onStreamInfoRetrieverComplete(event:Event):void
			{
				var streamInfoRetriever:DVRCastStreamInfoRetriever = event.target as DVRCastStreamInfoRetriever;
				
				if (streamInfoRetriever.streamInfo != null)
				{
					// Remove the completion listener:
					removeEventListener(NetConnectionFactoryEvent.CREATION_COMPLETE, onCreationComplete);
				
					if (streamInfoRetriever.streamInfo.offline == true)
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
						recordingInfo.startDuration = streamInfoRetriever.streamInfo.currentLength;
						recordingInfo.startOffset = calculateOffset(streamInfoRetriever.streamInfo);
						recordingInfo.startTime = new Date();
						
						// Add the stream info and recording info to the net connection:
						netConnection.streamInfo = streamInfoRetriever.streamInfo;	
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
					onServerCallError(streamInfoRetriever.error);
				}
			}
			
			function onServerCallError(error:Object):void
			{
				dispatchEvent
					( new NetConnectionFactoryEvent
						( NetConnectionFactoryEvent.CREATION_ERROR
						, false
						, false
						, netConnection
						, urlResource
						, new MediaError(MediaErrorCodes.DVRCAST_SUBSCRIBE_FAILED, error.message)
						)
					);
			}	
		}
		
		private function calculateOffset(streamInfo:DVRCastStreamInfo):Number
		{
			return DVRUtils.calculateOffset(streamInfo.beginOffset, streamInfo.endOffset, streamInfo.currentLength);
		}
	}
}