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
	
	import org.osmf.display.ScaleMode;
	import org.osmf.gateways.RegionGateway;
	import org.osmf.layout.LayoutUtils;
	import org.osmf.layout.RegistrationPoint;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.utils.URL;
	import org.osmf.video.VideoElement;

	/**
	 * A simple OSMF application, building on HelloWorld.as.
	 * 
	 * Rather than specify explicit dimensions for the SWF, we now
	 * maximize the SWF and center the content.
	 **/
	[SWF(backgroundColor="0x333333")]
	public class HelloWorld extends Sprite
	{
		public function HelloWorld()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Create a gateway
			var gateway:RegionGateway = new RegionGateway();
			gateway.clipChildren = true;
			
			// Set the gateway's dimensions, in pixels:
			LayoutUtils.setAbsoluteLayout(gateway.metadata, 200, 200);
			addChild(gateway);
  
  			// Create a media player:
 			var player:MediaPlayer = new MediaPlayer();

			// Create a video element:
			var video:VideoElement = new VideoElement
				( new NetLoader
				, new URLResource(new URL(REMOTE_PROGRESSIVE))
				);
			// Have the element occupy 100% of its gateway's width and height:	
			LayoutUtils.setRelativeLayout(video.metadata, 100, 100);
			// Have the element scale 'ZOOM' mode (and distribute surplus space such that the
			// element stays center - which has no impact on this mode, but would on LETTERBOX,
			// for example).
			LayoutUtils.setLayoutAttributes(video.metadata, ScaleMode.ZOOM, RegistrationPoint.CENTER);
			video.gateway = gateway;
				
			// Set the MediaElement on the MediaPlayer.  Because
			// autoPlay defaults to true, playback begins immediately.
			player.element = video;
		}
		
		private static const REMOTE_PROGRESSIVE:String
			= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
	}
}
