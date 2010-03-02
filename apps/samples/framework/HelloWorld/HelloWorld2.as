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
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.layout.ScaleMode;
	import org.osmf.elements.VideoElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;

	/**
	 * A simple OSMF application, building on HelloWorld.as.
	 * 
	 * Rather than specify explicit dimensions for the SWF, we now
	 * maximize the SWF and center the content.
	 **/
	[SWF(backgroundColor="0x333333")]
	public class HelloWorld2 extends Sprite
	{
		public function HelloWorld2()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
 
 			// Create the container class that displays the media.
 			var container:MediaContainer = new MediaContainer();
			addChild(container);

			// Set the container's size to match that of the stage, and
			// prevent the content from being scaled.
			container.width = stage.stageWidth;
			container.height = stage.stageHeight;
			container.layoutMetadata.scaleMode = ScaleMode.NONE;

			// Create the resource to play.
			var resource:URLResource = new URLResource("http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv");
			
			// Create the MediaElement and add it to our container class.
			var videoElement:VideoElement =  new VideoElement(resource);
			container.addMediaElement(videoElement);
			
			// Set the MediaElement on a MediaPlayer.  Because autoPlay
			// defaults to true, playback begins immediately.
			var mediaPlayer:MediaPlayer = new MediaPlayer();
			mediaPlayer.media = videoElement;
		}
	}
}
