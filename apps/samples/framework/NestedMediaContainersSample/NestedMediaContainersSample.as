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
	
	import org.osmf.display.MediaContainerGroup;
	import org.osmf.display.ScaleMode;
	import org.osmf.elements.DurationElement;
	import org.osmf.elements.ImageElement;
	import org.osmf.elements.ParallelElement;
	import org.osmf.elements.SerialElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutRendererProperties;
	import org.osmf.layout.VerticalAlign;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.utils.URL;

	[SWF(backgroundColor='#333333', frameRate='30')]
	public class NestedMediaContainersSample extends Sprite
	{
		public function NestedMediaContainersSample()
		{
			// Setup the Flash stage:
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            runSample();
  		} 
        
        private function runSample():void
        {   
			// Construct a small tree of media elements:
			
			var rootElement:ParallelElement = new ParallelElement();
			
				var mainContent:VideoElement = constructVideo(REMOTE_PROGRESSIVE);
				rootElement.addChild(mainContent);
				
				var banners:SerialElement = new SerialElement();
					banners.addChild(constructBanner(BANNER_1));
					banners.addChild(constructBanner(BANNER_2));
					banners.addChild(constructBanner(BANNER_3));
				rootElement.addChild(banners);
					
				var skyScraper:MediaElement = constructImage(SKY_SCRAPER_1);
				rootElement.addChild(skyScraper);
			
			// Next, decorate the content tree with attributes:
			
			var bannersLayout:LayoutRendererProperties = new LayoutRendererProperties(banners);
			bannersLayout.percentWidth = 100;
			bannersLayout.percentHeight = 100;
			bannersLayout.scaleMode = ScaleMode.LETTERBOX;
			bannersLayout.verticalAlignment = VerticalAlign.TOP;
			bannersLayout.horizontalAlignment = HorizontalAlign.CENTER;
			
			var skyScraperLayout:LayoutRendererProperties = new LayoutRendererProperties(skyScraper);
			skyScraperLayout.percentWidth = 100;
			skyScraperLayout.percentHeight = 100;
			skyScraperLayout.scaleMode = ScaleMode.LETTERBOX;
			skyScraperLayout.verticalAlignment = VerticalAlign.MIDDLE;
			skyScraperLayout.horizontalAlignment = HorizontalAlign.RIGHT;
			
			var mainLayout:LayoutRendererProperties = new LayoutRendererProperties(mainContent);
			mainLayout.percentWidth = 100;
			mainLayout.percentHeight = 100;
			mainLayout.scaleMode = ScaleMode.STRETCH;
			mainLayout.verticalAlignment = VerticalAlign.TOP;
			mainLayout.horizontalAlignment = HorizontalAlign.CENTER;
			
			// Consruct a tree of containers:

			var mainGroup:MediaContainerGroup = new MediaContainerGroup();
			mainGroup.width = 640;
			mainGroup.height = 352;
			mainGroup.mediaContainer.backgroundColor = 0xFFFFFF;
			mainGroup.mediaContainer.backgroundAlpha = .2;
			MetadataUtils.setElementId(mainGroup.metadata, "mainGroup");
			addChild(mainGroup);
			
				var bannerGroup:MediaContainerGroup = new MediaContainerGroup();
				bannerGroup.mediaContainer.backgroundColor = 0xFF;
				bannerGroup.mediaContainer.backgroundAlpha = .2;
				bannerGroup.height = 60;
				
				var bannerGroupLayout:LayoutRendererProperties = new LayoutRendererProperties(bannerGroup);
				bannerGroupLayout.left = bannerGroupLayout.right = bannerGroupLayout.top = 5;
				MetadataUtils.setElementId(bannerGroup.metadata, "bannerGroup");
				mainGroup.addChildGroup(bannerGroup);
				
				var skyScraperGroup:MediaContainerGroup = new MediaContainerGroup();
				skyScraperGroup.mediaContainer.backgroundColor = 0xFF00;
				skyScraperGroup.mediaContainer.backgroundAlpha = .2;
				skyScraperGroup.width = 120;
				
				var skyScraperGroupLayout:LayoutRendererProperties = new LayoutRendererProperties(skyScraperGroup);
				skyScraperGroupLayout.right = skyScraperGroupLayout.top = skyScraperGroupLayout.bottom = 5;
				MetadataUtils.setElementId(skyScraperGroup.metadata, "skyScraperGroup");
				mainGroup.addChildGroup(skyScraperGroup);
				
			// Bind media elements to their target containers:
			
			mainGroup.mediaContainer.addMediaElement(mainContent);
			bannerGroup.mediaContainer.addMediaElement(banners);
			skyScraperGroup.mediaContainer.addMediaElement(skyScraper);
			
			// To operate playback of the content tree, construct a
			// media player. Assignment of the root element to its source will
			// automatically start its loading and playback:
			
			var player:MediaPlayer = new MediaPlayer();
			player.media = rootElement;
		}
		
		// Utilities
		//
		
		private function constructBanner(url:String):MediaElement
		{
			return new DurationElement
					( BANNER_INTERVAL
					, constructImage(url)
					);
		}
		
		private function constructImage(url:String):MediaElement
		{
			return new ImageElement
					( new URLResource(new URL(url))
					) 
				
		}
		
		private function constructVideo(url:String):VideoElement
		{
			return new VideoElement
					( new URLResource(new URL(url))
					);
		}
		
		private static const BANNER_INTERVAL:int = 5;
		
		private static const REMOTE_PROGRESSIVE:String
			= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
			
		// IAB standard banners from:
		private static const IAB_URL:String
			= "http://www.iab.net/iab_products_and_industry_services/1421/1443/1452";
		
		private static const BANNER_1:String
			= "http://www.iab.net/media/image/468x60.gif";
			
		private static const BANNER_2:String
			= "http://www.iab.net/media/image/234x60.gif";
			
		private static const BANNER_3:String
			= "http://www.iab.net/media/image/120x60.gif";
			
		private static const SKY_SCRAPER_1:String
			= "http://www.iab.net/media/image/120x600.gif"
		
	}
}
