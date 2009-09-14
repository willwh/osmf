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
	
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.metadata.MetadataUtils;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SpatialTrait;
	import org.openvideoplayer.traits.ViewableTrait;
	import org.openvideoplayer.utils.DynamicMediaElement;

	public class TestDefaultLayoutRenderer extends TestCase
	{
		public function testSingleChild():void
		{
			// Child
			
			var mediaElement:DynamicMediaElement
				= new DynamicMediaElement([MediaTraitType.VIEWABLE, MediaTraitType.SPATIAL]);
				
			MetadataUtils.setElementId(mediaElement.metadata,"mediaElement");
			
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
			
			var container:LayoutContextSprite = new LayoutContextSprite();
			MetadataUtils.setElementId(container.metadata,"container");
			
			var layoutRenderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			container.layoutRenderer = layoutRenderer;
			layoutRenderer.context = container;
			layoutRenderer.addTarget(new MediaElementLayoutTarget(mediaElement));
			layoutRenderer.invalidate();
			
			layoutRenderer.validateNow();
			
			assertEquals(0, viewableSprite.x);
			assertEquals(0, viewableSprite.y);
			assertEquals(NaN, viewableSprite.width);
			assertEquals(NaN, viewableSprite.height);
			
			container.projectedWidth = 300;
			container.projectedHeight = 200;
			layoutRenderer.validateNow();
			
			assertEquals(300, container.projectedWidth);
			assertEquals(200, container.projectedHeight);
			
			// The container cannot have a calculated width: its sole
			// child has relative dimenions:
			assertEquals(NaN, container.calculatedWidth);
			assertEquals(NaN, container.calculatedHeight);
			
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
		
		public function testSingleChild_ScaleAndAlignment():void
		{
			// Child
			
			var mediaElement:DynamicMediaElement
				= new DynamicMediaElement([MediaTraitType.VIEWABLE, MediaTraitType.SPATIAL]);
				
			MetadataUtils.setElementId(mediaElement.metadata,"mediaElement");
			
			var spatial:SpatialTrait = SpatialTrait(mediaElement.getTrait(MediaTraitType.SPATIAL));
			spatial.setDimensions(50,50);
			var viewable:ViewableTrait = ViewableTrait(mediaElement.getTrait(MediaTraitType.VIEWABLE));
			var viewableSprite:Sprite = new TesterSprite();
			viewable.view = viewableSprite;

			LayoutUtils.setRelativeLayout(mediaElement.metadata, 80, 80 /* width, height */, 10, 10 /* x,y */);
			var meAttr:LayoutAttributesFacet
				= LayoutUtils.setScaleMode
					( mediaElement.metadata
					, ScaleMode.NONE, RegistrationPoint.MIDDLE_RIGHT
					);
			
			// Container
			
			var container:LayoutContextSprite = new LayoutContextSprite();
			MetadataUtils.setElementId(container.metadata,"container");
			
			var layoutRenderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			container.layoutRenderer = layoutRenderer;
			layoutRenderer.context = container;
			var melt:ILayoutContext = layoutRenderer.addTarget(new MediaElementLayoutTarget(mediaElement)) as ILayoutContext;
			layoutRenderer.invalidate();
			
			container.projectedWidth = 800;
			container.projectedHeight = 600;
			
			layoutRenderer.validateNow();
			
			// Without any scaling, we'd expect the element to be at 80x60 - 640x480.
			// However scaling is set to 'NONE' - meaning intrinsic width and height get bounced (50x50):
			
			assertEquals(50, melt.projectedWidth);
			assertEquals(50, melt.projectedHeight);
			
			assertEquals(80 + 640 - 50, melt.view.x);
			assertEquals(60 + 480 / 2 - 50 / 2, melt.view.y);
			
			meAttr.alignment = RegistrationPoint.CENTER;
			layoutRenderer.validateNow();
			
			assertEquals(80 + 640 / 2 - 50 / 2, melt.view.x);
			assertEquals(60 + 480 / 2 - 50 / 2, melt.view.y);
			
			meAttr.alignment = RegistrationPoint.MIDDLE_LEFT;
			layoutRenderer.validateNow();
			
			assertEquals(80, melt.view.x);
			assertEquals(60 + 480 / 2 - 50 / 2, melt.view.y);
			
			meAttr.alignment = RegistrationPoint.TOP_LEFT;
			layoutRenderer.validateNow();
			
			assertEquals(80, melt.view.x);
			assertEquals(60, melt.view.y);
			
			meAttr.alignment = RegistrationPoint.TOP_MIDDLE;
			layoutRenderer.validateNow();
			
			assertEquals(80 + 640 / 2 - 50 / 2, melt.view.x);
			assertEquals(60, melt.view.y);
			
			meAttr.alignment = RegistrationPoint.TOP_RIGHT;
			layoutRenderer.validateNow();
			
			assertEquals(80 + 640 - 50, melt.view.x);
			assertEquals(60, melt.view.y);	
			
			meAttr.alignment = RegistrationPoint.BOTTOM_LEFT;
			layoutRenderer.validateNow();
			
			assertEquals(80, melt.view.x);
			assertEquals(480 + 60 - 50, melt.view.y);
			
			meAttr.alignment = RegistrationPoint.BOTTOM_MIDDLE;
			layoutRenderer.validateNow();
			
			assertEquals(80 + 640 / 2 - 50 / 2, melt.view.x);
			assertEquals(480 + 60 - 50, melt.view.y);
			
			meAttr.alignment = RegistrationPoint.BOTTOM_RIGHT;
			layoutRenderer.validateNow();
			
			assertEquals(80 + 640 - 50, melt.view.x);
			assertEquals(480 + 60 - 50, melt.view.y);	
		}
		
		public function testBottomUp():void
		{
			// Element with given dimenions: 400x800
			var mediaElement:DynamicMediaElement
				= new DynamicMediaElement([MediaTraitType.VIEWABLE, MediaTraitType.SPATIAL]);
				
			MetadataUtils.setElementId(mediaElement.metadata,"mediaElement");
			
			var spatial:SpatialTrait = SpatialTrait(mediaElement.getTrait(MediaTraitType.SPATIAL));
			var viewable:ViewableTrait = ViewableTrait(mediaElement.getTrait(MediaTraitType.VIEWABLE));
			var viewableSprite:Sprite = new TesterSprite();
			viewable.view = viewableSprite;
			
			LayoutUtils.setAbsoluteLayout(mediaElement.metadata, 400, 800);
			
			// Container without any dimenion settings: should bubble up from child element:
			var container:LayoutContextSprite = new LayoutContextSprite();
			MetadataUtils.setElementId(container.metadata,"container");
			
			var layoutRenderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			container.layoutRenderer = layoutRenderer;
			layoutRenderer.context = container;
			
			assertEquals(NaN, container.projectedWidth);
			assertEquals(NaN, container.projectedHeight);
			assertEquals(NaN, container.calculatedWidth);
			assertEquals(NaN, container.calculatedHeight);
			
			layoutRenderer.addTarget(new MediaElementLayoutTarget(mediaElement));
			layoutRenderer.validateNow();
			
			assertEquals(400, container.calculatedWidth);
			assertEquals(800, container.calculatedHeight);
			
			assertEquals(NaN, container.projectedWidth);
			assertEquals(NaN, container.projectedHeight);
			
			// We have no real content:
			assertEquals(0, container.intrinsicWidth);
			assertEquals(0, container.intrinsicHeight);
		}
	
		public function testBottomUp_2_levels():void
		{
			// Element with given dimenions: 400x800
			var mediaElement:DynamicMediaElement
				= new DynamicMediaElement([MediaTraitType.VIEWABLE, MediaTraitType.SPATIAL]);
				
			MetadataUtils.setElementId(mediaElement.metadata,"mediaElement");
			
			var spatial:SpatialTrait = SpatialTrait(mediaElement.getTrait(MediaTraitType.SPATIAL));
			var viewable:ViewableTrait = ViewableTrait(mediaElement.getTrait(MediaTraitType.VIEWABLE));
			var viewableSprite:Sprite = new TesterSprite();
			viewable.view = viewableSprite;
			
			LayoutUtils.setAbsoluteLayout(mediaElement.metadata, 400, 800);
			
			// Container without any dimenion settings: should bubble up from child element:
			var container:LayoutContextSprite = new LayoutContextSprite();
			MetadataUtils.setElementId(container.metadata,"container");
			
			var layoutRenderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			container.layoutRenderer = layoutRenderer;
			layoutRenderer.context = container;
			
			assertEquals(NaN, container.projectedWidth);
			assertEquals(NaN, container.projectedHeight);
			assertEquals(NaN, container.calculatedWidth);
			assertEquals(NaN, container.calculatedHeight);
			
			layoutRenderer.addTarget(new MediaElementLayoutTarget(mediaElement));
			layoutRenderer.validateNow();
			
			assertEquals(400, container.calculatedWidth);
			assertEquals(800, container.calculatedHeight);
			
			assertEquals(NaN, container.projectedWidth);
			assertEquals(NaN, container.projectedHeight);
			
			// We have no real content:
			assertEquals(0, container.intrinsicWidth);
			assertEquals(0, container.intrinsicHeight);
			
			// Containter that holds the previous container: dimensions should 
			// bubble up another level:
			var container2:LayoutContextSprite = new LayoutContextSprite();
			MetadataUtils.setElementId(container2.metadata,"container2");
			
			var layoutRenderer2:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			container2.layoutRenderer = layoutRenderer2;
			layoutRenderer2.context = container2;
			
			assertEquals(NaN, container2.projectedWidth);
			assertEquals(NaN, container2.projectedHeight);
			assertEquals(NaN, container2.calculatedWidth);
			assertEquals(NaN, container2.calculatedHeight);
			
			layoutRenderer2.addTarget(container);
			layoutRenderer2.validateNow();
			
			assertEquals(400, container2.calculatedWidth);
			assertEquals(800, container2.calculatedHeight);
			
			assertEquals(NaN, container2.projectedWidth);
			assertEquals(NaN, container2.projectedHeight);
			
			// We have no real content:
			assertEquals(0, container2.intrinsicWidth);
			assertEquals(0, container2.intrinsicHeight);
		}
	}
}