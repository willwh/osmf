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
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.vast.loader.VASTLoadedContext;
	import org.openvideoplayer.vast.loader.VASTLoader;
	import org.openvideoplayer.vast.media.VASTMediaGenerator;
	import org.openvideoplayer.video.VideoElement;

	/**
	 * Demonstrates playback of a video preceded by a preroll from a VAST
	 * document.
	 **/
	[SWF(backgroundColor="0x333333")]
	public class VASTSample extends Sprite
	{
		public function VASTSample()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
            
  			// Create the Sprite class that holds our MediaPlayer.
 			sprite = new MediaPlayerSprite();
			addChild(sprite);
			
			// Set the Sprite's size to match that of the stage, and
			// prevent the content from being scaled.
			sprite.scaleMode = ScaleMode.NONE;
			sprite.width = stage.stageWidth;
			sprite.height = stage.stageHeight;
			
			// Make sure we resize the Sprite when the stage dimensions
			// change.
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			// Second param indicates whether to set it as a preroll or
			// as a postroll.
			loadVASTDocument(new URL(VAST_DOCUMENT_URL1), true);
		}
		
		private function loadVASTDocument(vastURL:URL, applyAsPreroll:Boolean):void
		{
			var loadableTrait:LoadableTrait
				= new LoadableTrait(new VASTLoader(), new URLResource(vastURL));
						
			loadableTrait.addEventListener
				( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
				, onLoadableStateChange
				);
			loadableTrait.load();
						
			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					loadableTrait.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
						
					// Create the appropriate inline MediaElements.
					var loadedContext:VASTLoadedContext = event.loadable.loadedContext as VASTLoadedContext;
					var generator:VASTMediaGenerator = new VASTMediaGenerator();
					var mediaElements:Vector.<MediaElement> = generator.createMediaElements(loadedContext.vastDocument);
					
					// We'll use the first one (if any) as our preroll.
					loadMediaWithAd(applyAsPreroll, mediaElements.length > 0 ? mediaElements[0] : null);
				}
			}
		}
		
		private function loadMediaWithAd(applyAsPreroll:Boolean, adElement:MediaElement):void
		{
			// Create our MediaElement.
			var serialElement:SerialElement = new SerialElement();
			
			// Set the ad as a preroll (if asked).
			if (applyAsPreroll && adElement != null)
			{
				serialElement.addChild(adElement);
			}

			// Add the main video.
			serialElement.addChild
				( new VideoElement
					( new NetLoader
					, new URLResource(new URL(REMOTE_STREAM))
					)
				);
			
			// Set the ad as a postroll (if asked).
			if (!applyAsPreroll && adElement != null)
			{
				serialElement.addChild(adElement);
			}

			// Set the MediaElement on the MediaPlayer.  Because
			// autoPlay defaults to true, playback begins immediately.
			sprite.element = serialElement;
		}
		
		private function onStageResize(event:Event):void
		{
			sprite.width = stage.stageWidth;
			sprite.height = stage.stageHeight;
		}
		
		private var sprite:MediaPlayerSprite;

		// Sample VAST documents.  The first has an inline ad, the second a wrapper.
		private static const VAST_DOCUMENT_URL1:String = "http://ad.doubleclick.net/pfadx/N270.135279.6816128834321/B3442378.2;dcadv=1379578;sz=0x0;ord=123;dcmt=text/html";
		private static const VAST_DOCUMENT_URL2:String = "http://ad.doubleclick.net/pfadx/AngelaSite;kw=vastdemo;sz=468x60;ord=667;dcmt=text/html";
		
		private static const REMOTE_STREAM:String
			= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
	}
}
