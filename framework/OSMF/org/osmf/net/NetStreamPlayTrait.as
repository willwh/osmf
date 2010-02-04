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
	import __AS3__.vec.Vector;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	import flash.net.NetStreamPlayOptions;
	import flash.net.NetStreamPlayTransitions;
	import flash.utils.ByteArray;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.Facet;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.net.dynamicstreaming.DynamicStreamingItem;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.net.httpstreaming.HTTPStreamingUtils;
	import org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FIndexInfo;
	import org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FStreamInfo;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.utils.OSMFStrings;

	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * The NetStreamPlayTrait class extends PlayTrait for NetStream-based playback.
	 * 
	 * @see flash.net.NetStream
	 */   
	public class NetStreamPlayTrait extends PlayTrait
	{
		/**
		 * 	Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function NetStreamPlayTrait(netStream:NetStream, resource:MediaResourceBase)
		{
			super();
			
			if (netStream == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_NETSTREAM));					
			}
			this.netStream = netStream;
			this.urlResource = resource as URLResource;
			this.hsFacet = HTTPStreamingUtils.getHTTPStreamingMetadataFacet(resource);

			// Note that we add the listener (and handler) with a slightly
			// higher priority.  The reason for this is that we want to process
			// any Play.Stop (and Play.Complete) events first, so that we can
			// update our playing state before the NetStreamTemporalTrait
			// processes the event and dispatches the COMPLETE event.  Clients
			// who register for the COMPLETE event will expect that the media
			// is no longer playing.
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 1, true);
			NetClient(netStream.client).addHandler(NetStreamCodes.ON_PLAY_STATUS, onPlayStatus, 1);
		}
		
		/**
		 * @private
		 * Communicates a <code>playing</code> change to the media through the NetStream. 
		 * <p>For streaming media, parses the URL to extract the stream name.</p>
		 * @param newPlaying New <code>playing</code> value.
		 */								
		override protected function playStateChangeStart(newPlayState:String):void
		{
			if (newPlayState == PlayState.PLAYING)
			{
				var playArgs:Object;
				
				if (streamStarted)
				{				
					netStream.resume();						
				}
				else if (hsFacet != null)
				{
					doPlayHTTPStream();
				}
				// TODO: Refactor DynamicNetStream so that we can code to the
				// base NetStream API (play2).
				else if (urlResource is DynamicStreamingResource)
				{
					var dsResource:DynamicStreamingResource = urlResource as DynamicStreamingResource;
					var nso:NetStreamPlayOptions = new NetStreamPlayOptions();

					playArgs = NetStreamUtils.getPlayArgsForResource(urlResource);

					nso.start = playArgs.start;
					nso.len = playArgs.len;
					nso.streamName = dsResource.streamItems[dsResource.initialIndex].streamName;
					nso.transition = NetStreamPlayTransitions.RESET;
					
					doPlay2(nso);
				}
				else if (urlResource != null) 
				{
					// Map the resource to the NetStream.play arguments.
					var streamName:String = NetStreamUtils.getStreamNameFromURL(urlResource.url);
					
					playArgs = NetStreamUtils.getPlayArgsForResource(urlResource);
					
					var startTime:Number = playArgs.start;
					var len:Number = playArgs.len;
					
					// Play the clip (or the requested portion of the clip).
					doPlay(streamName, startTime, len);
				}
			}
			else // PAUSED || STOPPED
			{
				netStream.pause();
			}
		}
		
		// Needed to detect when the stream didn't play:  i.e. complete or error cases.
		private function onNetStatus(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_FAILED:
				case NetStreamCodes.NETSTREAM_PLAY_FILESTRUCTUREINVALID:
				case NetStreamCodes.NETSTREAM_PLAY_STREAMNOTFOUND:
				case NetStreamCodes.NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:				
				case NetStreamCodes.NETSTREAM_FAILED:
					netStream.pause();
					streamStarted = false;
					stop();
					break;
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
					// Fired when streaming connections buffer, but also when
					// progressive connections finish.  In the latter case, we
					// halt playback.
					if (urlResource != null && NetStreamUtils.isStreamingResource(urlResource) == false) 
					{
						// Explicitly stop to prevent the stream from restarting on seek();
						stop();
					}
					break;
			}
		}
		
		private function onPlayStatus(event:Object):void
		{
			switch (event.code)
			{
				// Fired when streaming connections finish.  Doesn't fire for
				// Progressive connections.  
				case NetStreamCodes.NETSTREAM_PLAY_COMPLETE:
					// Explicitly stop to prevent the stream from restarting on seek();
					stop();
					break;
			}
		}

		private function doPlay(...args):void
		{
			try
			{
				netStream.play.apply(this, args);
				
				streamStarted = true;
			}
			catch (error:Error)
			{
				streamStarted = false;
				stop();
				
				// There's one specific error that may have happened.  Any
				// other errors will be treated generically.
				var mediaErrorCode:int =
						error.errorID == NETCONNECTION_FAILURE_ERROR_CODE
					?	MediaErrorCodes.PLAY_FAILED_NETCONNECTION_FAILURE
					:	MediaErrorCodes.PLAY_FAILED;
				
				dispatchEvent
					( new MediaErrorEvent
						( MediaErrorEvent.MEDIA_ERROR
						, false
						, false
						, new MediaError(mediaErrorCode)
						)
					);
			}
		}
		
		private function doPlay2(nspo:NetStreamPlayOptions):void
		{
			netStream.play2(nspo);
				
			streamStarted = true;
		}
		
		private function doPlayHTTPStream():void
		{
			var abstURL:String
				= hsFacet.getValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_ABST_URL_KEY)) as String;
			var abstData:ByteArray
				= hsFacet.getValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_ABST_DATA_KEY)) as ByteArray;
			var serverBaseURLs:Vector.<String>
				= hsFacet.getValue(new ObjectIdentifier(MetadataNamespaces.HTTP_STREAMING_SERVER_BASE_URLS_KEY)) as Vector.<String>;
			
			var streamInfos:Vector.<HTTPStreamingF4FStreamInfo> = generateStreamInfos(urlResource);
			
			var indexInfo:HTTPStreamingF4FIndexInfo =
				new HTTPStreamingF4FIndexInfo
					( abstURL
					, abstData
					, serverBaseURLs != null && serverBaseURLs.length > 0 ? serverBaseURLs[0] : null
					, streamInfos
					);
					 
			doPlay(indexInfo);
		}
		
		private function generateStreamInfos(resource:URLResource):Vector.<HTTPStreamingF4FStreamInfo>
		{
			var streamInfos:Vector.<HTTPStreamingF4FStreamInfo> = new Vector.<HTTPStreamingF4FStreamInfo>();
			
			var drmFacet:KeyValueFacet 
				= resource.metadata.getFacet(MetadataNamespaces.DRM_METADATA) as KeyValueFacet;
			var additionalHeader:ByteArray = null;
			var dsResource:DynamicStreamingResource = resource as DynamicStreamingResource;
			if (dsResource != null)
			{
				for each (var streamItem:DynamicStreamingItem in dsResource.streamItems)
				{
					if (drmFacet != null)
					{
						additionalHeader = drmFacet.getValue(
							new ObjectIdentifier(MetadataNamespaces.DRM_ADDITIONAL_HEADER_KEY + streamItem.streamName)) as ByteArray;
					}
					
					streamInfos.push(new HTTPStreamingF4FStreamInfo(streamItem.streamName, streamItem.bitrate, additionalHeader));
				}
			}
			else
			{
				if (drmFacet != null)
				{
					additionalHeader 
						= drmFacet.getValue(new ObjectIdentifier(MetadataNamespaces.DRM_ADDITIONAL_HEADER_KEY)) as ByteArray;
				}
				
				var streamName:String = resource.url.rawUrl.substr(resource.url.rawUrl.lastIndexOf("/")+1);
				streamInfos.push(new HTTPStreamingF4FStreamInfo(streamName, NaN, additionalHeader));
			}

			return streamInfos;
		}
		
		private static const NETCONNECTION_FAILURE_ERROR_CODE:int = 2154;
		
		private var streamStarted:Boolean;
		private var netStream:NetStream;
		private var urlResource:URLResource;
		private var hsFacet:Facet;
	}
}
