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
package org.openvideoplayer.layout
{
	import flash.display.Sprite;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SpatialTrait;
	import org.openvideoplayer.traits.ViewableTrait;
	import org.openvideoplayer.utils.DynamicMediaElement;

	public class TestDefaultLayoutRenderer extends TestCase
	{
		public function TestDefaultLayoutRenderer(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testSingleChild():void
		{
			// Child
			
			var mediaElement:DynamicMediaElement
				= new DynamicMediaElement([MediaTraitType.VIEWABLE, MediaTraitType.SPATIAL]);
			
			var spatial:SpatialTrait = SpatialTrait(mediaElement.getTrait(MediaTraitType.SPATIAL));
			var viewable:ViewableTrait = ViewableTrait(mediaElement.getTrait(MediaTraitType.VIEWABLE));
			var viewableSprite:Sprite = new TesterSprite();
			viewable.view = viewableSprite;

			var mediaElementRelative:RelativeLayoutFacet = new RelativeLayoutFacet();
			mediaElementRelative.x = 10;
			mediaElementRelative.y = 10;
			mediaElementRelative.width = 80;
			mediaElementRelative.height = 80;
			
			mediaElement.metadata.addFacet(mediaElementRelative);
			
			// Container
			
			var containerAbsolute:AbsoluteLayoutFacet = new AbsoluteLayoutFacet();
			var container:LayoutContextSprite = new LayoutContextSprite();
			container.metadata.addFacet(containerAbsolute);
			
			var layoutRenderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			layoutRenderer.context = container;
			layoutRenderer.addTarget(new MediaElementLayoutTarget(mediaElement));
			layoutRenderer.invalidate();
			
			layoutRenderer.validateNow();
			
			assertEquals(0, viewableSprite.x);
			assertEquals(0, viewableSprite.y);
			assertEquals(NaN, viewableSprite.width);
			assertEquals(NaN, viewableSprite.height);
			
			containerAbsolute.width = 300;
			containerAbsolute.height = 200;
			layoutRenderer.validateNow();
			
			assertEquals(30, viewableSprite.x);
			assertEquals(20, viewableSprite.y);
			assertEquals(240, viewableSprite.width);
			assertEquals(160, viewableSprite.height);
			
			mediaElementRelative.x = 5;
			
			layoutRenderer.validateNow();
			
			assertEquals(15, viewableSprite.x);
			
			var mediaElementAbsolute:AbsoluteLayoutFacet = new AbsoluteLayoutFacet();
			mediaElement.metadata.addFacet(mediaElementAbsolute);
			
			mediaElementAbsolute.x = 50;
			layoutRenderer.validateNow();
			
			assertEquals(50, viewableSprite.x);
			assertEquals(20, viewableSprite.y);
			assertEquals(240, viewableSprite.width);
			assertEquals(160, viewableSprite.height);
			
			mediaElementAbsolute.y = 1;
			layoutRenderer.validateNow();
			
			assertEquals(50, viewableSprite.x);
			assertEquals(1, viewableSprite.y);
			assertEquals(240, viewableSprite.width);
			assertEquals(160, viewableSprite.height);
			
			mediaElementAbsolute.width = 100;
			layoutRenderer.validateNow();
			
			assertEquals(50, viewableSprite.x);
			assertEquals(1, viewableSprite.y);
			assertEquals(100, viewableSprite.width);
			assertEquals(160, viewableSprite.height);
			
			mediaElementAbsolute.height = 51;
			layoutRenderer.validateNow();
			
			assertEquals(50, viewableSprite.x);
			assertEquals(1, viewableSprite.y);
			assertEquals(100, viewableSprite.width);
			assertEquals(51, viewableSprite.height);
			
			mediaElement.metadata.removeFacet(mediaElementAbsolute);
			layoutRenderer.validateNow();
			
			assertEquals(15, viewableSprite.x);
			assertEquals(20, viewableSprite.y);
			assertEquals(240, viewableSprite.width);
			assertEquals(160, viewableSprite.height);
			
			var mediaElementAnchor:AnchorLayoutFacet = new AnchorLayoutFacet();
			mediaElementAnchor.left = 60;
			mediaElementAnchor.top = 15;
			mediaElementRelative.x = NaN; // Set NaN, for relative takes precedence over anchoring.
			mediaElementRelative.y = NaN;
			
			mediaElement.metadata.addFacet(mediaElementAnchor);
			layoutRenderer.validateNow();
			
			assertEquals(60, viewableSprite.x);
			assertEquals(15, viewableSprite.y);
			assertEquals(240, viewableSprite.width);
			assertEquals(160, viewableSprite.height);
		
			mediaElementAnchor.right = 10;
			mediaElementAnchor.bottom = 10;
			mediaElementRelative.width = NaN; // Set NaN, for relative takes precedence over anchoring.
			mediaElementRelative.height = NaN;
			layoutRenderer.validateNow();
			
			assertEquals(230, viewableSprite.width);
			assertEquals(175, viewableSprite.height);
			
			var padding:PaddingLayoutFacet = new PaddingLayoutFacet();
			padding.left = 1;
			padding.top = 2;
			padding.right = 3;
			padding.bottom = 4;
			
			mediaElement.metadata.addFacet(padding);
			layoutRenderer.validateNow();
			
			assertEquals(61, viewableSprite.x);
			assertEquals(17, viewableSprite.y);
			assertEquals(226, viewableSprite.width);
			assertEquals(169, viewableSprite.height);
		}
	}
}