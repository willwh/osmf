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
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.traits.MediaTraitType;
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
		public function NetStreamPlayTrait(netStream:NetStream, resource:IMediaResource)
		{
			super();
			
			if (netStream == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_NETSTREAM));					
			}
			this.netStream = netStream;
			this.urlResource = resource as URLResource;
			this.dsResource = resource as DynamicStreamingResource;
			
			// Note that we add the listener with a slightly higher priority.
			// The reason for this is that we want to process any Play.Stop
			// events first, so that we can update our playing state before
			// the NetStreamTemporalTrait processes the event and dispatches
			// the DURATION_REACHED event.  Clients who register for the
			// DURATION_REACHED event will expect that the media is no longer
			// playing.
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 1, true);
			
			NetClient(netStream.client).addHandler(NetStreamCodes.ON_PLAY_STATUS, onPlayStatus);
		}
		
		/**
		 * @private
		 * Communicates a <code>playing</code> change to the media through the NetStream. 
		 * <p>For streaming media, parses the URL to extract the stream name.</p>
		 * @param newPlaying New <code>playing</code> value.
		 */								
		override protected function processPlayStateChange(newPlayState:String):void
		{
			if (newPlayState == PlayState.PLAYING)
			{
				if (streamStarted)
				{				
					netStream.resume();						
				}
				else if (dsResource != null)
				{
					doPlay(dsResource);
				}					
				else if (urlResource != null) 
				{
					// Map the resource to the NetStream.play arguments.
					var streamName:String = NetStreamUtils.getStreamNameFromURL(urlResource.url);
					var playArgs:Object = NetStreamUtils.getPlayArgsForResource(urlResource);
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
					if (urlResource != null && NetStreamUtils.isRTMPStream(urlResource.url) == false) 
					{
						// Explicitly stop to prevent the stream from restarting on seek();
						streamStarted = false;
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
					streamStarted = false;
					stop();
					break;
			}
		}

		protected function doPlay(...args):void
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
		
		private static const NETCONNECTION_FAILURE_ERROR_CODE:int = 2154;
		
		private var streamStarted:Boolean;
		private var netStream:NetStream;
		private var urlResource:URLResource;
		private var dsResource:DynamicStreamingResource;
	}
}
