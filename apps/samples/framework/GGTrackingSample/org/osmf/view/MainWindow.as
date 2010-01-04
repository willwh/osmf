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
	
	import org.osmf.display.ScaleMode;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.PluginLoadEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.plugin.PluginManager;
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
			
			buttonPlayPause.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
			mediaPlayerWrapper.mediaPlayer.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
			updateButtonText();
			
			mediaPlayerWrapper.mediaPlayer.autoPlay = false;
			mediaPlayerWrapper.scaleMode = ScaleMode.NONE;
			
			mediaFactory = new MediaFactory();
			registerDefaultMedia(mediaFactory);
			
			// CONFIGURATION VALUES
			// 
			
			// Change this value to toggle between loading the GG plugin
			// and not loading it.
			var usePlugin:Boolean = true;
			
			// Set this value to point to the remotely hosted GG plugin. 
			const GG_PLUGIN_URL:String = "http://swf.glanceguide.com/swf/osmf/GGTrackingPlugin.swf";
			
			if (usePlugin)
			{
				pluginManager = new PluginManager(mediaFactory);
				pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, onPluginLoaded);
				pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOAD_FAILED, onPluginLoadFailed);
			
				var pluginResource:IMediaResource = new URLResource(new URL(GG_PLUGIN_URL));
				pluginManager.loadPlugin(pluginResource);
			}
			else
			{
				loadMedia();
			}
		}
		
		// Internals
		//
		
		private function registerDefaultMedia(mediaFactory:MediaFactory):void
		{
			var netLoader:NetLoader = new NetLoader();
			
			mediaFactory.addMediaInfo
				( new MediaInfo
					( "org.osmf.video"
					, netLoader
					, createVideoElement
					)
				);
		}
		
		private function createVideoElement():MediaElement
		{
			return new VideoElement(new NetLoader());
		}
		
		private function onPluginLoaded(event:PluginLoadEvent):void
		{
			loadMedia();
		}

		private function onPluginLoadFailed(event:PluginLoadEvent):void
		{
			trace("Plugin load failed");
		}
		
		private function loadMedia():void
		{
			// Create the media and set it on our media player.
			mediaPlayerWrapper.element = mediaFactory.createMediaElement(new URLResource(new FMSURL(REMOTE_STREAM)));
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

		private var pluginManager:PluginManager;
		private var mediaFactory:MediaFactory;
		private var media:MediaElement;

		private static const REMOTE_PROGRESSIVE:String 		= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		private static const REMOTE_STREAM:String 			= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
	}
}
