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
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectFacet;

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
			bannersLayout.verticalAlign = VerticalAlign.TOP;
			bannersLayout.horizontalAlign = HorizontalAlign.CENTER;
			
			var skyScraperLayout:LayoutRendererProperties = new LayoutRendererProperties(skyScraper);
			skyScraperLayout.percentWidth = 100;
			skyScraperLayout.percentHeight = 100;
			skyScraperLayout.scaleMode = ScaleMode.LETTERBOX;
			skyScraperLayout.verticalAlign = VerticalAlign.MIDDLE;
			skyScraperLayout.horizontalAlign = HorizontalAlign.RIGHT;
			
			var mainLayout:LayoutRendererProperties = new LayoutRendererProperties(mainContent);
			mainLayout.percentWidth = 100;
			mainLayout.percentHeight = 100;
			mainLayout.scaleMode = ScaleMode.STRETCH;
			mainLayout.verticalAlign = VerticalAlign.TOP;
			mainLayout.horizontalAlign = HorizontalAlign.CENTER;
			
			// Consruct a tree of containers:

			var mainGroup:MediaContainer = new MediaContainer();
			mainGroup.width = 640;
			mainGroup.height = 352;
			mainGroup.backgroundColor = 0xFFFFFF;
			mainGroup.backgroundAlpha = .2;
			setElementId(mainGroup.metadata, "mainGroup");
			addChild(mainGroup);
			
				var bannerGroup:MediaContainer = new MediaContainer();
				bannerGroup.backgroundColor = 0xFF;
				bannerGroup.backgroundAlpha = .2;
				bannerGroup.height = 60;
				
				var bannerGroupLayout:LayoutRendererProperties = new LayoutRendererProperties(bannerGroup);
				bannerGroupLayout.left = bannerGroupLayout.right = bannerGroupLayout.top = 5;
				setElementId(bannerGroup.metadata, "bannerGroup");
				
				var skyScraperGroup:MediaContainer = new MediaContainer();
				skyScraperGroup.backgroundColor = 0xFF00;
				skyScraperGroup.backgroundAlpha = .2;
				skyScraperGroup.width = 120;
				
				var skyScraperGroupLayout:LayoutRendererProperties = new LayoutRendererProperties(skyScraperGroup);
				skyScraperGroupLayout.right = skyScraperGroupLayout.top = skyScraperGroupLayout.bottom = 5;
				setElementId(skyScraperGroup.metadata, "skyScraperGroup");
				
			// Bind media elements to their target containers:
			mainGroup.addMediaElement(mainContent);
			bannerGroup.addMediaElement(banners);
			skyScraperGroup.addMediaElement(skyScraper);
			
			// Add the sub containers to the main container's layout renderer. We
			// can do this because MediaContainer implements ILayoutTarget:
			mainGroup.layoutRenderer.addTarget(bannerGroup);
			mainGroup.layoutRenderer.addTarget(skyScraperGroup);
			
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
					( new URLResource(url)
					) 
				
		}
		
		private function constructVideo(url:String):VideoElement
		{
			return new VideoElement
					( new URLResource(url)
					);
		}
		
		/**
		 * Adds an element string identifier to a metadata instance.
		 *  
		 * @param target The metadata instance to set the id on.
		 * @param id The id to set.
		 */		
		private static function setElementId(target:Metadata, id:String):void
		{
			target.addFacet(new ObjectFacet(MetadataNamespaces.ELEMENT_ID, id));
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
