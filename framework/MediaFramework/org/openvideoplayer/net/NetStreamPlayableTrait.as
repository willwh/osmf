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
package org.openvideoplayer.net
{
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.traits.PlayableTrait;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.URL;
	
	/**
	 * The NetStreamPlayableTrait class implements an IPlayable interface that uses a NetStream.
	 * This trait is used by AudioElements and VideoElements.
	 * @private
	 * @see flash.net.NetStream
	 */   
	public class NetStreamPlayableTrait extends PlayableTrait
	{
		/**
		 * 	Constructor.
		 * 	@param netStream NetStream created for the ILoadable that belongs to the media element
		 *	that uses this trait.
		 *  @param url URL of the media resource. Required for progressive and streaming connections. 
		 *  For a progressive connection the URL should be a fully qualified path to a resource.  
		 *  For streaming rtmp:// connections, the stream name is parsed from the URL.
		 * 	@see NetLoader
		 */ 
		public function NetStreamPlayableTrait(netStream:NetStream, urlResource:IURLResource)
		{
			super();
			
			if (netStream == null)
			{
				throw new Error(MediaFrameworkStrings.NULL_NETSTREAM);					
			}
			this.netStream = netStream;
			this.urlResource = urlResource;	
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
		}
		
		/**
		 * @private
		 * Communicates a <code>playing</code> change to the media through the NetStream. 
		 * <p>For streaming media, parses the URL to extract the stream name.</p>
		 * @param newPlaying New <code>playing</code> value.
		 */								
		override protected function processPlayingChange(newPlaying:Boolean):void
		{
			if (newPlaying)
			{
				if (streamStarted)
				{				
					netStream.resume();						
				}
				else if (urlResource.url && (urlResource.url.protocol.search(/^rtmp$|rtmp[tse]$|rtmpte$/i) != -1)) //Streaming
				{	
					var parsedURL:URL = urlResource.url;
					var fms:FMSURL = parsedURL as FMSURL;
					if (fms == null)
					{
						fms = new FMSURL(parsedURL.toString());
					}
					
					var tempStreamName:String = fms.streamName;
					if(parsedURL.query != null && parsedURL.query != "")
					{
						 tempStreamName += "?" + parsedURL.query;
					} 										
					//Add optional query parameters to the stream name.
					netStream.play(tempStreamName);									
				}
				else // Progressive
				{
					netStream.play(urlResource.url.toString());					
				}	
				streamStarted = true;
			}
		}
		
		// Needed to detect when the stream didn't play:  i.e. complete or error cases
		private function onNetStatus(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_FAILED:
				case NetStreamCodes.NETSTREAM_PLAY_FILESTRUCTUREINVALID:
				case NetStreamCodes.NETSTREAM_PLAY_STREAMNOTFOUND:
				case NetStreamCodes.NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:				
				case NetStreamCodes.NETSTREAM_FAILED:
					streamStarted = false;
					resetPlaying();
					break;
				case NetStreamCodes.NETSTREAM_PLAY_STOP: //fired when streaming connections buffer, but also for when progressive connections finish.
					if(isProgressive) 
					{
						streamStarted = false;
						resetPlaying();
					}
					break;
			}
		}
		
		private function get isProgressive():Boolean
		{
			return netStream.bytesTotal != 0;
		}
						
		private var streamStarted:Boolean;
		private var netStream:NetStream;
		private var urlResource:IURLResource;
	}
}