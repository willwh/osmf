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
package org.osmf.net.dvr
{
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.NetConnectionFactoryEvent;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.NullFacetSynthesizer;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.net.NetConnectionFactory;
	import org.osmf.net.NetNegotiator;
	import org.osmf.net.NetStreamUtils;

	/**
	 * @private
	 */	
	internal class DVRCastNetConnectionFactory extends NetConnectionFactory
	{
		public function DVRCastNetConnectionFactory()
		{
			addEventListener(NetConnectionFactoryEvent.CREATION_COMPLETE, onCreationComplete, false, Number.MAX_VALUE);
			
			super();
		}

		override public function createNetConnection(resource:URLResource):void
		{
			this.urlResource = urlResource;
			
			super.createNetConnection(urlResource);
		}
		
		// Internals
		//

		private var urlResource:URLResource;
		private var netConnection:NetConnection;
		private var streamName:String;
		
		private function onCreationComplete(event:NetConnectionFactoryEvent):void
		{
			// Capture this event, whithold it from the outside world until
			// we have succeeded subscribing to the DVRCast stream:
			event.stopImmediatePropagation();
			
			netConnection = event.netConnection;
			
			streamName = NetStreamUtils.getStreamNameFromURL(urlResource.url);
			var responder:Responder 
				= new Responder
					( onStreamSubscriptionResult
					, onServerCallError
					);
			
			event.netConnection.call("DVRSubscribe", responder, streamName); 	
		}
		
		private function onStreamSubscriptionResult(result:Object):void
		{
			trace("onStreamSubscriptionResult: result.code", result ? result.code : "null");
			
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
			var streamInfoRetreiver:DVRCastStreamInfoRetreiver 
				= event.target as DVRCastStreamInfoRetreiver;
			
			if (streamInfoRetreiver.streamInfo != null)
			{
				removeEventListener(NetConnectionFactoryEvent.CREATION_COMPLETE, onCreationComplete);
			
				var dvrcastFacet:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.DVRCAST_METADATA, NullFacetSynthesizer);
				for (var key:String in streamInfoRetreiver.streamInfo)
				{
					dvrcastFacet.addValue(new ObjectIdentifier(key), streamInfoRetreiver.streamInfo[key]);
				}
				urlResource.metadata.addFacet(dvrcastFacet);
				
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
	}
}