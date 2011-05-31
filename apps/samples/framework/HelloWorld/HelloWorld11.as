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
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.events.DynamicStreamEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.URLResource;
	
	/**
	 * Another simple OSMF application, building on HelloWorld2.as.
	 * 
	 * Plays a video, then shows a SWF, then plays another video.
	 **/
	[SWF(backgroundColor="0xdedede", width=640, height=480)]
	public class HelloWorld11 extends Sprite
	{
		public function HelloWorld11()
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
/*			var layoutMetadata:LayoutMetadata = new LayoutMetadata();
			layoutMetadata.layoutMode = LayoutMode.NONE;
			layoutMetadata.scaleMode = ScaleMode.LETTERBOX;
			layoutMetadata.percentHeight = 100;
			layoutMetadata.percentWidth = 100;
			layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
			layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;*/

			// create media element
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_V2_VOD));
			//mediaElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, layoutMetadata);
			container.addMediaElement(mediaElement);
			

			player = new MediaPlayer();
			player.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onPlayerStateChange);
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
			
			player.addEventListener(DynamicStreamEvent.AUTO_SWITCH_CHANGE, onAutoSwitchChange);
			player.addEventListener(DynamicStreamEvent.NUM_DYNAMIC_STREAMS_CHANGE, onNumDynamicStreamChange);
			player.addEventListener(DynamicStreamEvent.SWITCHING_CHANGE, onSwitchingChange);
			
			

			player.muted = false;
			player.loop = false;
			player.autoPlay = false;
			player.media = mediaElement;
			player.bufferTime = 4 ;
			player.autoDynamicStreamSwitch=true;
		}
		
		
		
		private function onPlayerStateChange(event:MediaPlayerStateChangeEvent):void
		{
			switch (event.state)
			{
				case MediaPlayerState.READY:
					{	
						trace("started");
						player.play();
					}
					break;
				case MediaPlayerState.PLAYING:
					break;
			}
		}
		
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			trace("[Error]", event.toString());	
		}
		
		
		private function onAutoSwitchChange(event:DynamicStreamEvent):void
		{
			trace(" [MBR]", event.toString());	
		}
		private function onNumDynamicStreamChange(event:DynamicStreamEvent):void
		{
			trace(" [MBR]", event.toString());	
		}
		private function onSwitchingChange(event:DynamicStreamEvent):void
		{
			trace(" [MBR]", event.toString());	
		}
		
		
		
		private var player:MediaPlayer;
		private var container:MediaContainer;
		private var start:Boolean = true;
		
		//private static const F4M_V2_VOD:String = "http://catherine.corp.adobe.com/osmf/mlm_tests/demo/mlm_root1.f4m";
		private static const F4M_V2_VOD:String = "http://catherine.corp.adobe.com/osmf/mlm_tests/mlm_ext.f4m";
	}
}
