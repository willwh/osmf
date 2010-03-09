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

package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import org.osmf.chrome.controlbar.ControlBar;
	import org.osmf.containers.MediaContainer;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutRenderer;
	import org.osmf.layout.VerticalAlign;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.net.StreamType;
	import org.osmf.net.StreamingURLResource;

	[SWF(backgroundColor="0x000000", frameRate="25", width="640", height="360")]
	public class DVRSample extends Sprite
	{
		public function DVRSample()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			layoutRenderer = new LayoutRenderer();
			
			mediaContainer = new MediaContainer(layoutRenderer);
			mediaContainer.width = stage.stageWidth;
			mediaContainer.height = stage.stageHeight;
			addChild(mediaContainer);
			
			mediaPlayer = new MediaPlayer();
			mediaPlayer.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError); 
			
			mediaFactory = new DefaultMediaFactory();
			
			// Below is a place holder media element: in order to see the DVR
			// feature at work, one will have to connect to a DVRCast equiped
			// server that is progress of recording a live stream, and comment
			// the statement below:
			mediaElement
				= mediaFactory.createMediaElement
					( new URLResource
						( "http://mediapm.edgesuite.net/osmf/content/test/logo_animated.flv"
						)
					);
					
			/*
			This clause illustrates how to connect to a DVRCast equiped server. The
			URL is not a publically accessible server: it has to be replaced by a
			custom address.
			mediaElement
				= mediaFactory.createMediaElement
					( new StreamingURLResource
						( "rtmp://192.0.0.150/dvrcast_origin/livestream"
						, StreamType.DVR
						)
					);
			*/
					
			mediaContainer.addMediaElement(mediaElement);
			mediaPlayer.media = mediaElement;
			
			controlBar = new ControlBar();
			controlBar.element = mediaElement;
			controlBar.layoutMetadata.index = 2;
			controlBar.layoutMetadata.bottom = 25;
			controlBar.layoutMetadata.verticalAlign = VerticalAlign.TOP;
			controlBar.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
			
			layoutRenderer.addTarget(controlBar);
		}
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			trace(event.error.message, "\n", event.error.detail);
		}
		
		private var layoutRenderer:LayoutRenderer;
		private var mediaContainer:MediaContainer;
		private var controlBar:ControlBar;
		private var mediaPlayer:MediaPlayer;
		private var mediaFactory:MediaFactory;
		private var mediaElement:MediaElement;
	}
}
