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
	
	import org.openvideoplayer.composition.ParallelElement;
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.display.MediaPlayerSprite;
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.image.ImageElement;
	import org.openvideoplayer.image.ImageLoader;
	import org.openvideoplayer.layout.LayoutAttributesFacet;
	import org.openvideoplayer.layout.LayoutUtils;
	import org.openvideoplayer.layout.RegistrationPoint;
	import org.openvideoplayer.layout.RelativeLayoutFacet;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.proxies.TemporalProxyElement;
	import org.openvideoplayer.regions.RegionSprite;
	import org.openvideoplayer.regions.RegionTargetFacet;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.video.VideoElement;

	[SWF(backgroundColor='#333333', frameRate='30')]
	public class RegionsSample extends Sprite
	{
		public function RegionsSample()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

			// Setup a banner region:
			bannerRegion = new RegionSprite();
			LayoutUtils.setAbsoluteLayout(bannerRegion.metadata, 468, 60);
			
			bannerTarget = new RegionTargetFacet(bannerRegion);
			addChild(bannerRegion);
			
			var rootElement:ParallelElement = new ParallelElement();
			
			var banners:SerialElement = new SerialElement();
			banners.metadata.addFacet(bannerTarget);
			banners.addChild(constructBanner1());
			banners.addChild(constructBanner2());
			banners.addChild(constructBanner3());
			
			var bannersRelative:RelativeLayoutFacet = new RelativeLayoutFacet();
			bannersRelative.width = 100;
			bannersRelative.height = 100;
			banners.metadata.addFacet(bannersRelative);
			
			var bannersAttributes:LayoutAttributesFacet = new LayoutAttributesFacet();
			bannersAttributes.scaleMode = ScaleMode.NONE;
			bannersAttributes.alignment = RegistrationPoint.CENTER;
			banners.metadata.addFacet(bannersAttributes);
			
			var mainContent:VideoElement = constructVideo();
			
			rootElement.addChild(mainContent);
			rootElement.addChild(banners);
			
			var player:MediaPlayerSprite = new MediaPlayerSprite();
			player.setAvailableSize(468,468 * 3 / 4);
			player.y = 50;
			addChild(player);
			
			player.element = rootElement;
		}
		
		private function constructBanner1():MediaElement
		{
			var result:MediaElement 
				= new TemporalProxyElement
					( BANNER_INTERVAL
					, new ImageElement
						( new ImageLoader()
						, new URLResource(new URL(BANNER_1))
						) 
					);
			
			return result;
		}
		
		private function constructBanner2():MediaElement
		{
			var result:MediaElement 
				= new TemporalProxyElement
					( BANNER_INTERVAL
					, new ImageElement
						( new ImageLoader()
						, new URLResource(new URL(BANNER_2))
						) 
					);
			
			return result;
		}
		
		private function constructBanner3():MediaElement
		{
			var result:MediaElement 
				= new TemporalProxyElement
					( BANNER_INTERVAL
					, new ImageElement
						( new ImageLoader()
						, new URLResource(new URL(BANNER_3))
						) 
					);
			
			return result;
		}
		
		private function constructVideo():VideoElement
		{
			var result:VideoElement 
				= new VideoElement
					( new NetLoader
					, new URLResource(new URL(REMOTE_PROGRESSIVE))
					);
			
			return result;
		}
		
		private var bannerRegion:RegionSprite;
		private var bannerTarget:RegionTargetFacet;
		
		private static const BANNER_INTERVAL:int = 5;
		
		private static const REMOTE_PROGRESSIVE:String
			= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
			
		// IAB standard banners from:
		// http://www.iab.net/iab_products_and_industry_services/1421/1443/1452
		
		private static const BANNER_1:String
			= "http://www.iab.net/media/image/468x60.gif";
			
		private static const BANNER_2:String
			= "http://www.iab.net/media/image/234x60.gif";
			
		private static const BANNER_3:String
			= "http://www.iab.net/media/image/120x60.gif";
		
	}
}
