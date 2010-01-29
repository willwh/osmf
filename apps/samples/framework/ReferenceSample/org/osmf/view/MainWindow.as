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
package org.osmf.view
{
	import flash.events.MouseEvent;
	import flash.system.Security;
	
	import org.osmf.events.PlayEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.URLResource;
	import org.osmf.model.ReferenceSWFElement;
	import org.osmf.net.NetLoader;
	import org.osmf.swf.SWFLoader;
	import org.osmf.utils.FMSURL;
	import org.osmf.utils.URL;
	import org.osmf.video.VideoElement;

	public class MainWindow extends MainWindowLayout
	{
		// Overrides
		//
				
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			Security.allowDomain(REMOTE_SWF);
			
			description.text =  "This sample app demonstrates the use of the IMediaReferrer interface to enable communication " +
								"between one MediaElement and another MediaElement when the two pieces of media don't have any " +
								"up front knowledge of each other, which is typically the case when a player application loads " +
								"a plugin.  The orange box in the lower left corner is an external SWF.  If you click on the SWF " +
								"when the video is playing, the SWF will cause the video to pause.";
			
			buttonPlayPause.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
			mediaPlayerWrapper.mediaPlayer.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
			updateButtonText();
			
			mediaPlayerWrapper.mediaPlayer.autoPlay = false;
			
			mediaFactory = new MediaFactory();
			
			registerMedia(mediaFactory);
			
			loadMedia();
		}
		
		// Internals
		//
		
		private function registerMedia(mediaFactory:MediaFactory):void
		{
			var netLoader:NetLoader = new NetLoader();
			
			// The default VideoElement.
			mediaFactory.addMediaInfo
				( new MediaInfo
					( "org.osmf.video"
					, netLoader
					, createVideoElement
					)
				);
			
			var swfLoader:SWFLoader = new SWFLoader();
			
			// A referencing SWFElement.  Typically this would be loaded from
			// a plugin, but we add it manually to keep this case simple.
			mediaFactory.addMediaInfo
				( new MediaInfo
					( "com.example.custom.referencing.swf"
					, swfLoader
					, createReferenceSWFElement
					)
				);
		}
		
		private function createVideoElement():MediaElement
		{
			return new VideoElement();
		}
		
		private function createReferenceSWFElement():MediaElement
		{
			return new ReferenceSWFElement();
		}
		
		private function loadMedia():void
		{
			// Note that references are automatically set by the MediaFactory.
			// So here, we create the video and SWF elements through the factory,
			// so that the reference gets set up.
			//
			
			// Create the media and set it on our media player.
			mediaPlayerWrapper.element = mediaFactory.createMediaElement(new URLResource(new FMSURL(REMOTE_STREAM)));
			
			// Create the overlay SWF as well.
			overlayMediaPlayer.element = mediaFactory.createMediaElement(new URLResource(new URL(REMOTE_SWF)));
		}
		
		// Event Handlers
		//
		
		private function onPlayPauseClick(event:MouseEvent):void
		{
			if (mediaPlayerWrapper.mediaPlayer.canPlay)
			{
				if (mediaPlayerWrapper.mediaPlayer.playing)
				{
					mediaPlayerWrapper.mediaPlayer.pause();
				}
				else
				{
					mediaPlayerWrapper.mediaPlayer.play();
				}
			}
		}
		
		private function onPlayStateChange(event:PlayEvent):void
		{
			updateButtonText();
		}
		
		private function updateButtonText():void
		{
			if (mediaPlayerWrapper.mediaPlayer.canPlay &&
				mediaPlayerWrapper.mediaPlayer.playing)
			{
				buttonPlayPause.label = "Pause";
			}
			else
			{
				buttonPlayPause.label = "Play";
			}
		}
		
		private var mediaFactory:MediaFactory;

		private static const REMOTE_STREAM:String 			= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
		private static const REMOTE_SWF:String				= "http://mediapm.edgesuite.net/osmf/swf/ReferenceSampleSWF.swf";
	}
}
