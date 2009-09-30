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
package org.openvideoplayer.view
{
	import flash.events.MouseEvent;
	import flash.system.Security;
	
	import org.openvideoplayer.events.PlayingChangeEvent;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.MediaInfo;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.model.ReferenceSWFElement;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.swf.SWFLoader;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.video.VideoElement;

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
			mediaPlayerWrapper.mediaPlayer.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChange);
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
					( "org.openvideoplayer.video"
					, netLoader
					, VideoElement
					, [netLoader]
					)
				);
			
			var swfLoader:SWFLoader = new SWFLoader();
			
			// A referencing SWFElement.  Typically this would be loaded from
			// a plugin, but we add it manually to keep this case simple.
			mediaFactory.addMediaInfo
				( new MediaInfo
					( "com.example.custom.referencing.swf"
					, swfLoader
					, ReferenceSWFElement
					, [swfLoader]
					)
				);
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
			if (mediaPlayerWrapper.mediaPlayer.playable)
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
		
		private function onPlayingChange(event:PlayingChangeEvent):void
		{
			updateButtonText();
		}
		
		private function updateButtonText():void
		{
			if (mediaPlayerWrapper.mediaPlayer.playable &&
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
