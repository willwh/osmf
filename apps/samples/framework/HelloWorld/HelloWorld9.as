/*****************************************************
*  
*  Copyright 2011 Adobe Systems Incorporated.  All Rights Reserved.
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
package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.DurationElement;
	import org.osmf.elements.ParallelElement;
	import org.osmf.elements.SWFElement;
	import org.osmf.elements.SerialElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutMetadata;
	import org.osmf.layout.LayoutMode;
	import org.osmf.layout.ScaleMode;
	import org.osmf.layout.VerticalAlign;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.URLResource;
	import org.osmf.net.MediaItem;
	import org.osmf.traits.AlternativeAudioTrait;

	/**
	 * Another simple OSMF application, building on HelloWorld2.as.
	 * 
	 * Plays a video, then shows a SWF, then plays another video.
	 **/
	[SWF(backgroundColor="0xdedede", width=640, height=480)]
	public class HelloWorld9 extends Sprite
	{
		public function HelloWorld9()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
 			
 			// Create the container class that displays the media.
 			container = new MediaContainer();
			container.x = 0;
			container.y = 0;
			container.width = stage.stageWidth;
			container.height = stage.stageHeight;
			addChild(container);
			
			// Create some layout metadata from the MediaElement.  This will cause
			// it to be centered in the container, with no scaling of content.
			var layoutMetadata:LayoutMetadata = new LayoutMetadata();
			layoutMetadata.layoutMode = LayoutMode.NONE;
			layoutMetadata.scaleMode = ScaleMode.LETTERBOX;
			layoutMetadata.percentHeight = 100;
			layoutMetadata.percentWidth = 100;
			layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
			layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;

			// create media elelemt
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_VOD));
			mediaElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, layoutMetadata);
			container.addMediaElement(mediaElement);
			
			// Set the MediaElement on a MediaPlayer.  Because autoPlay
			// defaults to true, playback begins immediately.
			player = new MediaPlayer();
			player.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onPlayerStateChange);
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
			player.muted = false;
			player.loop = false;
			player.autoPlay = false;
			player.media = mediaElement;
			
			setTimeout(doPlay, 5000);
			function doPlay():void
			{
				player.play();
			}
		}
		
		private function onPlayerStateChange(event:MediaPlayerStateChangeEvent):void
		{
			switch (event.state)
			{
				case MediaPlayerState.READY:
					trace("Alternative languages", player.hasAlternativeAudio ? "available" : " not available" );
					if (player.hasAlternativeAudio)
					{
						for (var index:int = 0; index < player.numAlternativeAudio; index++)
						{
							var item:MediaItem = player.getMediaItemForAlternativeAudioIndex(index);
							trace("[", item.language, "]", item.description);
						}
					}
					break;
				case MediaPlayerState.PLAYING:
					if (player.hasAlternativeAudio)
					{
						if (!audioChanged && player.currentTime > 0.2)
						{
							player.changeAlternativeAudioIndexTo(1);
							audioChanged = true;
						}
					}
					break;
			}
		}
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			trace("[Error]", event.toString());	
		}
		
		private var audioChanged:Boolean = false;
		private var player:MediaPlayer;
		private var container:MediaContainer;
		
		private static const F4M_VOD:String = "http://10.131.237.104/vod/late_binding_audio/sync_test/sync_test_lba.f4m";
		//private static const F4M_LIVE:String = "http://10.131.237.104/live/events/latebind/events/_definst_/liveevent.f4m";
		private static const F4M_LIVE:String = "http://catherine.corp.adobe.com/osmf/late_bindings_audio_sp3/demo_live.f4m";	
		//private static const F4M_LIVE:String = "http://10.131.237.107/live/events/latebind/events/_definst_/liveevent.f4m";
	}
}
