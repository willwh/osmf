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
package org.osmf.gg
{
	import org.osmf.events.*;
	import org.osmf.media.*;
	import org.osmf.metadata.*;
	import org.osmf.proxies.*;
	import org.osmf.traits.*;
	
	/**
	 * A ProxyElement which tracks media playback and publishes events to
	 * GlanceGuide via the GlanceGuide SWF.  Works with any MediaElement, not
	 * just VideoElement.
	 **/
	public class GGVideoProxyElement extends ListenerProxyElement
	{
		/**
		 * Constructor.
		 **/
		public function GGVideoProxyElement(wrappedElement:MediaElement=null)
		{
			super(wrappedElement);
		}
		
		// Tracking Methods
		//
		
	
		override protected function processVolumeChange(newVolume:Number):void
		{
			// Volume parameters must be between 1 and 100, inclusive.
			sendEvent(SET_VOLUME, Math.max(1, newVolume * 100));
		}

		override protected function processMutedChange(muted:Boolean):void
		{
			sendEvent(MUTE, muted);
		}

		override protected function processBufferingChange(buffering:Boolean):void
		{
			trace("Buffering Change: " + buffering);
		}

		override protected function processBufferTimeChange(newBufferTime:Number):void
		{
			trace("Buffer Time Change: " + newBufferTime);
		}

		override protected function processLoadStateChange(loadState:String):void
		{
			var videoType:String;
			
			switch (loadState)
			{
				case LoadState.UNINITIALIZED:
					if (lastLoadState == LoadState.UNLOADING)
					{
						// The call to UNLOAD_VIDEO has two optional params.
						//
						
						videoType = getContentTypeFromMetadata(wrappedElement.resource.metadata);
						
						sendEvent(UNLOAD_VIDEO, currentTime, videoType);
					}
					break;
				case LoadState.READY:
					// The call to LOAD_VIDEO has three required params.
					//
					
					// URL of the video:
					var urlResource:URLResource = wrappedElement.resource as URLResource; 
					var url:String = urlResource != null ? urlResource.url.rawUrl : null;
					
					// Type of the video:
					videoType = getContentTypeFromMetadata(wrappedElement.resource.metadata);
					
					// Metadata about the video:
					var videoInfo:String = getVideoInfoFromMetadata(wrappedElement.resource.metadata);
					
					sendEvent(LOAD_VIDEO, url, videoType, videoInfo);
					break;
			}
			
			lastLoadState = loadState;
		}
		
		override protected function processPlayStateChange(playState:String):void
		{
			if (playState == PlayState.PLAYING)
			{
				sendEvent(PLAY_VIDEO, currentTime);
				trace("play: " + currentTime);
			}
			else if (playState == PlayState.PAUSED)
			{
				sendEvent(PAUSE_VIDEO, currentTime);
				trace("pause: " + currentTime);
			}
		}

		override protected function processSeekingChange(seeking:Boolean, time:Number):void
		{
			if (seeking)
			{
				sendEvent(SEEK, currentTime, time);
			}
		}
		
		override protected function processDurationReached():void
		{
			sendEvent(STOP, currentTime);
		}

		// Utility Methods
		//
		
		private function get currentTime():Number
		{
			var timeTrait:TimeTrait = getTrait(MediaTraitType.TIME) as TimeTrait;
			return timeTrait != null ? timeTrait.currentTime : 0;
		}

		private function get duration():Number
		{
			var timeTrait:TimeTrait = getTrait(MediaTraitType.TIME) as TimeTrait;
			return timeTrait != null ? timeTrait.duration : 0;
		}
		
		private function getContentTypeFromMetadata(metadata:Metadata):String
		{
			// Typically, we'll work with a specific metadata schema (facet)
			// here in order to get the content type field.  But for this
			// simple sample app, I'll just hardcode it.
			return "content";
		}

		private function getVideoInfoFromMetadata(metadata:Metadata):String
		{
			// Typically, we'll work with a specific metadata schema (facet)
			// here in order to get the video info.  Some of the metadata can
			// be retrieved from the traits.  For the rest, I'll hardcode it.
			
			var xml:XML = 
				<videoInfo>
					<length>{duration}</length>
					<title>Sample Title</title>
				</videoInfo>
				
			return xml.toXMLString();
		}
		
		private function sendEvent(eventType:int, ...params):void
		{
			// Uncomment the following line to integrate with the GlanceGuide
			// library.  Note that to do so, you'll need to link in the
			// GlanceGuide source or SWC, or else this class will fail to
			// compile.
			//ggCom.getInstance().PM(eventType, params);
		}
		
		// PM Constants
		//
		
		private var lastLoadState:String;
		
		private static const LOAD_VIDEO:int 	= 3;
		private static const UNLOAD_VIDEO:int 	= 4;
		private static const PLAY_VIDEO:int 	= 5;
		private static const PAUSE_VIDEO:int 	= 6;
		private static const STOP:int 			= 7;
		private static const SEEK:int		 	= 8;
		private static const MUTE:int 			= 9;
		private static const SET_VOLUME:int 	= 11;
	}
}