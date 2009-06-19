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
package com.adobe.strobe.plugins.smil.parsing
{
	import org.openvideoplayer.audio.AudioElement;
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.image.ImageElement;
	import org.openvideoplayer.image.ImageLoader;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.video.VideoElement;
	

	// Sample SMIL document this parse can parse:
	//
	//
	//  <smil xmlns="http://www.w3.org/2005/SMIL21/Language">
	//  	<body>
	//  			<seq id="PiratesVideoSequence">
	//  				<video src="rtmp://foo.com/video-1" />
	//  				<video src="rtmp://foo.com/video-2" />
	//  				<video src="rtmp://foo.com/video-3" />
	//  			</seq>
	//  	</body>
	//  </smil>

	
	
	public class SMILParser
	{
		public static const NS:Namespace = new Namespace("http://www.w3.org/2005/SMIL21/Language");
		
		public function SMILParser()
		{
		}

		public function parse(xml:XML):MediaElement
		{
			// error checking for non-existent namespace here
			
			var media:MediaElement;
			
			if (xml != null)
			{
				if(xml.NS::body.length() > 0)
				{
					try
					{
						media = parseBody(xml.NS::body[0]);
					}
					catch (e:Error)
					{
						// Add error handling here for parsing related errors
						throw new Error("Custom Error Message");
					}
				}
			}
			return media;
		}


		private function parseBody(bodyXml:XML):MediaElement
		{
			
			var media:MediaElement;
			if (bodyXml != null)
			{
				// Iterate over all the children of the 'body' element.
				// The 'body' element is expected to have only
				// one child, and custom error handling (such as logging
				// warning messages) could be done for the subsequent children 
				// if any are found.
				for each (var item:XML in bodyXml.children())
				{
					// Only the first one is parsed
					media = parseMediaElement(item) as MediaElement;
					
					// Add error handling for subsequent children
					// if necessary. For now, simply ignore the rest of them
					break;
					
				}
			}			
			return media;
		}
		
		private function parseMediaElement(mediaXml:XML):MediaElement
		{
			var media:MediaElement;
				
			if (mediaXml != null)
			{
				var tagName:String = mediaXml.localName();
				if (tagName == "seq")
				{
					media = new SerialElement();
					var serialElement:SerialElement = media as SerialElement;
					for each (var item:XML in mediaXml.children())
					{
						var childElement:MediaElement = parseMediaElement(item);
						serialElement.addChild(childElement);
					}
				}
				else if (tagName == "video")
				{
					media = new VideoElement(new NetLoader(),new URLResource(mediaXml.@src));						
				}
				else if(tagName == "audio")
				{
					media = new AudioElement(new NetLoader(), new URLResource(mediaXml.@src));
				}
				else if(tagName == "image")
				{
					media = new ImageElement(new ImageLoader(), new URLResource(mediaXml.@src));
				}
			}
			
			return media;
		}
		
		
	}
}