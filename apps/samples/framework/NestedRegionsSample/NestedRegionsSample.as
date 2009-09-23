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
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.openvideoplayer.composition.ParallelElement;
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.image.ImageElement;
	import org.openvideoplayer.image.ImageLoader;
	import org.openvideoplayer.layout.LayoutUtils;
	import org.openvideoplayer.layout.RegistrationPoint;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaPlayer;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.proxies.TemporalProxyElement;
	import org.openvideoplayer.gateways.RegionSprite;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.video.VideoElement;

	[SWF(backgroundColor='#333333', frameRate='30')]
	public class NestedRegionsSample extends Sprite
	{
		public function NestedRegionsSample()
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
			
			LayoutUtils.setRelativeLayout(banners.metadata, 100, 100);
			LayoutUtils.setLayoutAttributes(banners.metadata, ScaleMode.LETTERBOX, RegistrationPoint.TOP_MIDDLE);
			
			LayoutUtils.setRelativeLayout(skyScraper.metadata, 100, 100);
			LayoutUtils.setLayoutAttributes(skyScraper.metadata, ScaleMode.LETTERBOX, RegistrationPoint.MIDDLE_RIGHT);
			
			LayoutUtils.setRelativeLayout(mainContent.metadata, 100, 100);
			LayoutUtils.setLayoutAttributes(mainContent.metadata, ScaleMode.STRETCH, RegistrationPoint.TOP_MIDDLE);
			
			// Consruct a tree of regions:

			var mainRegion:RegionSprite = new RegionSprite();
			LayoutUtils.setAbsoluteLayout(mainRegion.metadata, 800, 450);
			mainRegion.backgroundColor = 0xFFFFFF;
			mainRegion.backgroundAlpha = .2;
			addChild(mainRegion);
			
				var bannerRegion:RegionSprite = new RegionSprite();
				bannerRegion.backgroundColor = 0xFF;
				bannerRegion.backgroundAlpha = .2;
				LayoutUtils.setAnchorLayout(bannerRegion.metadata, 5, 5, 5, NaN);
				LayoutUtils.setAbsoluteLayout(bannerRegion.metadata, NaN, 60);
				mainRegion.addChildRegion(bannerRegion);
				
				var skyScraperRegion:RegionSprite = new RegionSprite();
				skyScraperRegion.backgroundColor = 0xFF00;
				skyScraperRegion.backgroundAlpha = .2;
				LayoutUtils.setAnchorLayout(skyScraperRegion.metadata, NaN, 5, 5, 5);
				LayoutUtils.setAbsoluteLayout(skyScraperRegion.metadata, 120, NaN);
				mainRegion.addChildRegion(skyScraperRegion);
				
			// Bind media elements to their target regions:
			
			mainContent.gateway = mainRegion;
			banners.gateway = bannerRegion;
			skyScraper.gateway = skyScraperRegion;
			
			// To operate playback of the content tree, construct a
			// media player. Assignment of the root element to its source will
			// automatically start its loading and playback:
			
			var player:MediaPlayer = new MediaPlayer();
			player.source = rootElement;
		}
		
		// Utilities
		//
		
		private function constructBanner(url:String):MediaElement
		{
			return new TemporalProxyElement
					( BANNER_INTERVAL
					, constructImage(url)
					);
		}
		
		private function constructImage(url:String):MediaElement
		{
			return new ImageElement
					( new ImageLoader()
					, new URLResource(new URL(url))
					) 
				
		}
		
		private function constructVideo(url:String):VideoElement
		{
			return new VideoElement
					( new NetLoader
					, new URLResource(new URL(url))
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
