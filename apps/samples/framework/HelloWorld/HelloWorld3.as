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
	import flash.events.Event;
	
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.display.MediaPlayerSprite;
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.proxies.TemporalProxyElement;
	import org.openvideoplayer.swf.SWFElement;
	import org.openvideoplayer.swf.SWFLoader;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.video.VideoElement;

	/**
	 * Simple OSMF application.  Centers SWF and content.  Plays a video, then
	 * shows an orange (SWF) box, then plays another video.
	 **/
	[SWF(backgroundColor="0x333333")]
	public class HelloWorld3 extends Sprite
	{
		public function HelloWorld3()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.addEventListener(Event.RESIZE, onStageResize);
  
 			sprite = new MediaPlayerSprite();
			sprite.scaleMode = ScaleMode.NONE;
			fitSpriteToStage();
			addChild(sprite);
			
			sprite.element = createMediaElement();
		}
		
		private function createMediaElement():MediaElement
		{
			var serialElement:SerialElement = new SerialElement();
			
           	serialElement.addChild
           		( new VideoElement
					( new NetLoader
					, new URLResource(new URL(REMOTE_PROGRESSIVE))
					)
				);

           	serialElement.addChild
           		( new TemporalProxyElement
					( 3
					, new SWFElement
						( new SWFLoader()
						, new URLResource(new URL(REMOTE_SWF))
						)
					)
				);

           	serialElement.addChild
           		( new VideoElement
					( new NetLoader
					, new URLResource(new URL(REMOTE_STREAM))
					)
				);
				
			return serialElement;
		}
		
		private function onStageResize(event:Event):void
		{
			fitSpriteToStage();
		}
		
		private function fitSpriteToStage():void
		{
			sprite.width = stage.stageWidth;
			sprite.height = stage.stageHeight;
		}
		
		private var sprite:MediaPlayerSprite;
		
		private static const REMOTE_PROGRESSIVE:String
			= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
			
		private static const REMOTE_SWF:String
			= "http://mediapm.edgesuite.net/osmf/swf/ReferenceSampleSWF.swf";
			
		private static const REMOTE_STREAM:String
			= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
	}
}
