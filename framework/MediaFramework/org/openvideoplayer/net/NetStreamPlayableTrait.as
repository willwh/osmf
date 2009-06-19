/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.net
{
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.traits.PlayableTrait;
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
				else if (urlResource.url && urlResource.url.protocol == "rtmp") //Streaming
				{	
					var parsedURL:URL = urlResource.url;
					
					//var id3Qualifier:String = parsedURL.streamName.indexOf("mp3") == parsedURL.streamName.length-3 ? "id3:" : "";
					//netStream.play(id3Qualifier + parsedURL.streamName);
					netStream.play(parsedURL.host);
					netStream.play("id3:" + parsedURL.host);
					
					streamStarted = true;
				}
				else // Progressive
				{
					netStream.play(urlResource.url);
					streamStarted = true;
				}	
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
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
				case NetStreamCodes.NETSTREAM_FAILED:
					streamStarted = false;
					resetPlaying();
					break;
			}
		}
						
		private var streamStarted:Boolean;
		private var netStream:NetStream;
		private var urlResource:IURLResource;
	}
}