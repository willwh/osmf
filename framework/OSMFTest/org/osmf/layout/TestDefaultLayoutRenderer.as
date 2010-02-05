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
package org.osmf.layout
{
	import flash.display.Sprite;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.display.ScaleMode;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.DynamicMediaElement;

	public class TestDefaultLayoutRenderer extends TestCase
	{
		public function testSingleChild():void
		{
			// Child
			
			var mediaElement:DynamicMediaElement = new DynamicMediaElement();
				
			MetadataUtils.setElementId(mediaElement.metadata,"mediaElement");
			
			var viewSprite:Sprite = new TesterSprite();
			var displayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(viewSprite);
			mediaElement.doAddTrait(MediaTraitType.DISPLAY_OBJECT, displayObjectTrait);

			var mediaElementRelative:RelativeLayoutFacet = new RelativeLayoutFacet();
			mediaElementRelative.x = 10;
			mediaElementRelative.y = 10;
			mediaElementRelative.width = 80;
			mediaElementRelative.height = 80;
			
			mediaElement.metadata.addFacet(mediaElementRelative);
			
			// Container
			
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			MetadataUtils.setElementId(container.metadata,"container");
			
			var layoutRenderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			layoutRenderer.container = container;
			layoutRenderer.addTarget(MediaElementLayoutTarget.getInstance(mediaElement));
			layoutRenderer.invalidate();
			
			layoutRenderer.validateNow();
			
			assertEquals(0, viewSprite.x);
			assertEquals(0, viewSprite.y);
			assertEquals(0, viewSprite.width);
			assertEquals(0, viewSprite.height);
			
			container.width = 300;
			container.height = 200;
			layoutRenderer.validateNow();
			
			assertEquals(30, viewSprite.x);
			assertEquals(20, viewSprite.y);
			assertEquals(240, viewSprite.width);
			assertEquals(160, viewSprite.height);
			
			mediaElementRelative.x = 5;
			
			layoutRenderer.validateNow();
			
			assertEquals(15, viewSprite.x);
			
			var mediaElementAbsolute:AbsoluteLayoutFacet = new AbsoluteLayoutFacet();
			mediaElement.metadata.addFacet(mediaElementAbsolute);
			
			mediaElementAbsolute.x = 50;
			layoutRenderer.validateNow();
			
			assertEquals(50, viewSprite.x);
			assertEquals(20, viewSprite.y);
			assertEquals(240, viewSprite.width);
			assertEquals(160, viewSprite.height);
			
			mediaElementAbsolute.y = 1;
			layoutRenderer.validateNow();
			
			assertEquals(50, viewSprite.x);
			assertEquals(1, viewSprite.y);
			assertEquals(240, viewSprite.width);
			assertEquals(160, viewSprite.height);
			
			mediaElementAbsolute.width = 100;
			layoutRenderer.validateNow();
			
			assertEquals(50, viewSprite.x);
			assertEquals(1, viewSprite.y);
			assertEquals(100, viewSprite.width);
			assertEquals(160, viewSprite.height);
			
			mediaElementAbsolute.height = 51;
			layoutRenderer.validateNow();
			
			assertEquals(50, viewSprite.x);
			assertEquals(1, viewSprite.y);
			assertEquals(100, viewSprite.width);
			assertEquals(51, viewSprite.height);
			
			mediaElement.metadata.removeFacet(mediaElementAbsolute);
			layoutRenderer.validateNow();
			
			assertEquals(15, viewSprite.x);
			assertEquals(20, viewSprite.y);
			assertEquals(240, viewSprite.width);
			assertEquals(160, viewSprite.height);
			
			var mediaElementAnchor:AnchorLayoutFacet = new AnchorLayoutFacet();
			mediaElementAnchor.left = 60;
			mediaElementAnchor.top = 15;
			mediaElementRelative.x = NaN; // Set NaN, for relative takes precedence over anchoring.
			mediaElementRelative.y = NaN;
			
			mediaElement.metadata.addFacet(mediaElementAnchor);
			layoutRenderer.validateNow();
			
			assertEquals(60, viewSprite.x);
			assertEquals(15, viewSprite.y);
			assertEquals(240, viewSprite.width);
			assertEquals(160, viewSprite.height);
		
			mediaElementAnchor.right = 10;
			mediaElementAnchor.bottom = 10;
			mediaElementRelative.width = NaN; // Set NaN, for relative takes precedence over anchoring.
			mediaElementRelative.height = NaN;
			layoutRenderer.validateNow();
			
			assertEquals(230, viewSprite.width);
			assertEquals(175, viewSprite.height);
			
			var padding:PaddingLayoutFacet = new PaddingLayoutFacet();
			padding.left = 1;
			padding.top = 2;
			padding.right = 3;
			padding.bottom = 4;
			
			mediaElement.metadata.addFacet(padding);
			layoutRenderer.validateNow();
			
			assertEquals(61, viewSprite.x);
			assertEquals(17, viewSprite.y);
			assertEquals(226, viewSprite.width);
			assertEquals(169, viewSprite.height);
		}
		
		public function testSingleChildScaleAndAlignment():void
		{
			// Child
			
			var mediaElement:DynamicMediaElement = new DynamicMediaElement();
				
			MetadataUtils.setElementId(mediaElement.metadata,"mediaElement");
			
			var viewSprite:Sprite = new TesterSprite();
			var displayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(viewSprite, 50, 50);
			mediaElement.doAddTrait(MediaTraitType.DISPLAY_OBJECT, displayObjectTrait);
			var layout:LayoutProperties = new LayoutProperties(mediaElement);
			layout.percentWidth = layout.percentHeight = 80;
			layout.percentX = layout.percentY = 10;
			layout.scaleMode = ScaleMode.NONE; // this is the default, actually.
			layout.alignment = RegistrationPoint.MIDDLE_RIGHT;
			
			// Container
			
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			MetadataUtils.setElementId(container.metadata,"container");
			
			var layoutRenderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			layoutRenderer.container = container;
			
			var melt:ILayoutTarget = layoutRenderer.addTarget(MediaElementLayoutTarget.getInstance(mediaElement));
			layoutRenderer.invalidate();
			
			container.width = 800;
			container.height = 600;
			
			layoutRenderer.validateNow();
			
			// Without any scaling, we'd expect the element to be at 80x60 - 640x480.
			// However scaling is set to 'NONE' - meaning intrinsic width and height get bounced (50x50):
			
			assertEquals(50, melt.mediaWidth);
			assertEquals(50, melt.mediaHeight);
			
			assertEquals(80 + 640 - 50, melt.displayObject.x);
			assertEquals(60 + 480 / 2 - 50 / 2, melt.displayObject.y);
			
			layout.alignment = RegistrationPoint.CENTER;
			layoutRenderer.validateNow();
			
			assertEquals(80 + 640 / 2 - 50 / 2, melt.displayObject.x);
			assertEquals(60 + 480 / 2 - 50 / 2, melt.displayObject.y);
			
			layout.alignment = RegistrationPoint.MIDDLE_LEFT;
			layoutRenderer.validateNow();
			
			assertEquals(80, melt.displayObject.x);
			assertEquals(60 + 480 / 2 - 50 / 2, melt.displayObject.y);
			
			layout.alignment = RegistrationPoint.TOP_LEFT;
			layoutRenderer.validateNow();
			
			assertEquals(80, melt.displayObject.x);
			assertEquals(60, melt.displayObject.y);
			
			layout.alignment = RegistrationPoint.TOP_MIDDLE;
			layoutRenderer.validateNow();
			
			assertEquals(80 + 640 / 2 - 50 / 2, melt.displayObject.x);
			assertEquals(60, melt.displayObject.y);
			
			layout.alignment = RegistrationPoint.TOP_RIGHT;
			layoutRenderer.validateNow();
			
			assertEquals(80 + 640 - 50, melt.displayObject.x);
			assertEquals(60, melt.displayObject.y);	
			
			layout.alignment = RegistrationPoint.BOTTOM_LEFT;
			layoutRenderer.validateNow();
			
			assertEquals(80, melt.displayObject.x);
			assertEquals(480 + 60 - 50, melt.displayObject.y);
			
			layout.alignment = RegistrationPoint.BOTTOM_MIDDLE;
			layoutRenderer.validateNow();
			
			assertEquals(80 + 640 / 2 - 50 / 2, melt.displayObject.x);
			assertEquals(480 + 60 - 50, melt.displayObject.y);
			
			layout.alignment = RegistrationPoint.BOTTOM_RIGHT;
			layoutRenderer.validateNow();
			
			assertEquals(80 + 640 - 50, melt.displayObject.x);
			assertEquals(480 + 60 - 50, melt.displayObject.y);	
		}
		
		public function testBottomUp():void
		{
			// Element with given dimenions: 400x800
			var mediaElement:DynamicMediaElement = new DynamicMediaElement();
				
			MetadataUtils.setElementId(mediaElement.metadata,"mediaElement");
			
			var viewSprite:Sprite = new TesterSprite();
			var displayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(viewSprite);
			mediaElement.doAddTrait(MediaTraitType.DISPLAY_OBJECT, displayObjectTrait);
			var layout:LayoutProperties = new LayoutProperties(mediaElement);
			layout.width = 400;
			layout.height = 800;
			
			// Container without any dimenion settings: should bubble up from child element:
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			MetadataUtils.setElementId(container.metadata,"container");
			
			var layoutRenderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			layoutRenderer.container = container;
			
			assertEquals(NaN, container.mediaWidth);
			assertEquals(NaN, container.mediaHeight);
			
			layoutRenderer.addTarget(MediaElementLayoutTarget.getInstance(mediaElement));
			layoutRenderer.validateNow();
			
			assertEquals(400, container.mediaWidth);
			assertEquals(800, container.mediaHeight);
		}
	
		public function testBottomUpTwoLevels():void
		{
			// Element with given dimenions: 400x800
			var mediaElement:DynamicMediaElement = new DynamicMediaElement();
				
			MetadataUtils.setElementId(mediaElement.metadata,"mediaElement");
			
			var viewSprite:Sprite = new TesterSprite();
			var displayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(viewSprite);
			mediaElement.doAddTrait(MediaTraitType.DISPLAY_OBJECT, displayObjectTrait);
			
			var layout:LayoutProperties = new LayoutProperties(mediaElement);
			layout.width = 400;
			layout.height = 800;
			
			// Container without any dimenion settings: should bubble up from child element:
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			MetadataUtils.setElementId(container.metadata,"container");
			
			var layoutRenderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			layoutRenderer.container = container;
			
			assertEquals(NaN, container.mediaWidth);
			assertEquals(NaN, container.mediaHeight);
			
			layoutRenderer.addTarget(MediaElementLayoutTarget.getInstance(mediaElement));
			layoutRenderer.validateNow();
			
			assertEquals(400, container.mediaWidth);
			assertEquals(800, container.mediaHeight);
			
			// Containter that holds the previous container: dimensions should 
			// bubble up another level:
			var container2:LayoutTargetSprite = new LayoutTargetSprite();
			MetadataUtils.setElementId(container2.metadata,"container2");
			
			var layoutRenderer2:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			layoutRenderer2.container = container2;
			
			assertEquals(NaN, container2.mediaWidth);
			assertEquals(NaN, container2.mediaHeight);
			
			layoutRenderer2.addTarget(container);
			layoutRenderer2.validateNow();
			
			assertEquals(400, container2.mediaWidth);
			assertEquals(800, container2.mediaHeight);
		}
		
		public function testOrdering():void
		{
			var renderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			renderer.container = container;
			
			var layout:LayoutProperties;
			
			var t1:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			layout = new LayoutProperties(t1);
			layout.order = 8;
			
			var t2:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			layout = new LayoutProperties(t2);
			layout.order = 2;
			
			var t3:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			layout = new LayoutProperties(t3);
			layout.order = 2;
			
			var t4:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			
			renderer.addTarget(t1);
			renderer.addTarget(t2);
			renderer.addTarget(t3);
			renderer.addTarget(t4);
			
			renderer.validateNow();
			
			assertEquals(t4, container.getChildAt(0));
			assertEquals(t3, container.getChildAt(1));
			assertEquals(t2, container.getChildAt(2));
			assertEquals(t1, container.getChildAt(3));
			
			layout = new LayoutProperties(t4);
			layout.order = 4;
			
			renderer.validateNow();
			
			assertEquals(t3, container.getChildAt(0));
			assertEquals(t2, container.getChildAt(1));
			assertEquals(t4, container.getChildAt(2));
			assertEquals(t1, container.getChildAt(3));
		}
		
		public function testPaddingAndRounding():void
		{
			var renderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			renderer.container = container;
			
			var t1:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			var layout:LayoutProperties = new LayoutProperties(t1);
			layout.width = layout.height = 100;
			layout.paddingLeft = 9.6;
			layout.paddingTop = 8.4;
			layout.paddingRight = 5.6;
			layout.paddingBottom = 3.8;
			layout.snapToPixel = true;
			t1.setIntrinsicDimensions(100,100);
			
			renderer.addTarget(t1);
			renderer.validateNow();
			
			assertEquals(10, t1.x);
			assertEquals(8, t1.y);
			assertEquals(85, t1.width);
			assertEquals(88, t1.height);
			
			layout.paddingLeft = NaN;
			layout.paddingTop = NaN;
			layout.paddingRight = NaN;
			layout.paddingBottom = NaN;
			
			renderer.validateNow();
			
			assertEquals(0, t1.x);
			assertEquals(0, t1.y);
			assertEquals(100, t1.width);
			assertEquals(100, t1.height);
		}
		
		public function testRegistrationPoint():void
		{
			var renderer:DefaultLayoutRenderer = new DefaultLayoutRenderer();
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			renderer.container = container;
			
			var t1:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			t1.setIntrinsicDimensions(100,100);
			
			renderer.addTarget(t1);
			var layout:LayoutProperties = new LayoutProperties(t1);
			layout.snapToPixel = true;
				
			layout.registrationPoint = RegistrationPoint.TOP_LEFT;
			renderer.validateNow();
			assertEquals(0, t1.x);
			assertEquals(0, t1.y);
			
			layout.registrationPoint = RegistrationPoint.TOP_MIDDLE;
			renderer.validateNow();
			assertEquals(-50, t1.x);
			assertEquals(0, t1.y);
			
			layout.registrationPoint = RegistrationPoint.TOP_RIGHT;
			renderer.validateNow();
			assertEquals(-100, t1.x);
			assertEquals(0, t1.y);
			
			layout.registrationPoint = RegistrationPoint.BOTTOM_LEFT;
			renderer.validateNow();
			assertEquals(0, t1.x);
			assertEquals(-100, t1.y);
			
			layout.registrationPoint = RegistrationPoint.BOTTOM_MIDDLE;
			renderer.validateNow();
			assertEquals(-50, t1.x);
			assertEquals(-100, t1.y);
			
			layout.registrationPoint = RegistrationPoint.BOTTOM_RIGHT;
			renderer.validateNow();
			assertEquals(-100, t1.x);
			assertEquals(-100, t1.y);
			
			layout.registrationPoint = RegistrationPoint.MIDDLE_LEFT;
			renderer.validateNow();
			assertEquals(0, t1.x);
			assertEquals(-50, t1.y);
			
			layout.registrationPoint = RegistrationPoint.CENTER;
			renderer.validateNow();
			assertEquals(-50, t1.x);
			assertEquals(-50, t1.y);
			
			layout.registrationPoint = RegistrationPoint.MIDDLE_RIGHT;
			renderer.validateNow();
			assertEquals(-100, t1.x);
			assertEquals(-50, t1.y);
		}
	}
}