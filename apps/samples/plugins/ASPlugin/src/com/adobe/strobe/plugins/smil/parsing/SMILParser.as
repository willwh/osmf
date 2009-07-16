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