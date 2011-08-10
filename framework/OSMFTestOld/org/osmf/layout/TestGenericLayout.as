/*****************************************************
*  
*  Copyright 2011 Adobe Systems Incorporated.  All Rights Reserved.
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
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.ParallelElement;
	import org.osmf.layout.ScaleMode;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.DynamicMediaElement;

	public class TestGenericLayout extends TestCase
	{
		public function testBugFM1232_ScalingWithWidthOnly():void
		{
			var mediaWidth:int = 852;
			var mediaHeight:int = 480;
		
			// Create media element
			var mediaElement:DynamicMediaElement = new DynamicMediaElement();
					
			var viewSprite:Sprite = new TesterSprite();
			viewSprite.width = mediaWidth;
			viewSprite.height = mediaHeight;
			var displayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(viewSprite, mediaWidth, mediaHeight);
			mediaElement.doAddTrait(MediaTraitType.DISPLAY_OBJECT, displayObjectTrait);
			
			var layoutMetadata:LayoutMetadata = new LayoutMetadata();
			layoutMetadata.scaleMode = ScaleMode.LETTERBOX;
			layoutMetadata.percentWidth = 80;
			mediaElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, layoutMetadata);
			
			// Create container
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			container.width = 400;
			container.height = 300;
			
			// Create layout renderer
			var layoutRenderer:LayoutRenderer = new LayoutRenderer();
			layoutRenderer.container = container;
			
			var melt:ILayoutTarget = layoutRenderer.addTarget(MediaElementLayoutTarget.getInstance(mediaElement));
			layoutRenderer.invalidate();
			layoutRenderer.validateNow();
			
			assertEquals(0,   melt.displayObject.x);
			assertEquals(0,   melt.displayObject.y);
			assertEquals(320, melt.displayObject.width); 
			assertEquals(180, melt.displayObject.height);  	
		}
		
		public function testBugFM1232_ScalingWithHeightOnly():void
		{
			var mediaWidth:int = 852;
			var mediaHeight:int = 480;
			
			// Create media element
			var mediaElement:DynamicMediaElement = new DynamicMediaElement();
			
			var viewSprite:Sprite = new TesterSprite();
			viewSprite.width = mediaWidth;
			viewSprite.height = mediaHeight;
			var displayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(viewSprite, mediaWidth, mediaHeight);
			mediaElement.doAddTrait(MediaTraitType.DISPLAY_OBJECT, displayObjectTrait);
			
			var layoutMetadata:LayoutMetadata = new LayoutMetadata();
			layoutMetadata.scaleMode = ScaleMode.LETTERBOX;
			layoutMetadata.percentHeight = 80;
			mediaElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, layoutMetadata);
			
			// Create container
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			container.width = 640;
			container.height = 360;
			
			// Create layout renderer
			var layoutRenderer:LayoutRenderer = new LayoutRenderer();
			layoutRenderer.container = container;
			
			var melt:ILayoutTarget = layoutRenderer.addTarget(MediaElementLayoutTarget.getInstance(mediaElement));
			layoutRenderer.invalidate();
			layoutRenderer.validateNow();
			
			assertEquals(0,   melt.displayObject.x);
			assertEquals(0,   melt.displayObject.y);
			assertEquals(288, melt.displayObject.height);  	
			assertEquals(511, melt.displayObject.width); 
		}
		
		public function testBugFM1232_ParallelScalingWithWidthOnly():void
		{
			// Create image element
			var imageWidth:int = 50;
			var imageHeight:int = 50;
			var imageElement:DynamicMediaElement = new DynamicMediaElement();
			
			var imageSprite:Sprite = new TesterSprite();
			var imageDisplayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(imageSprite, imageWidth, imageHeight);
			imageElement.doAddTrait(MediaTraitType.DISPLAY_OBJECT, imageDisplayObjectTrait);
			
			var imageLayoutMetadata:LayoutMetadata = new LayoutMetadata();
			imageLayoutMetadata.scaleMode = ScaleMode.NONE;
			imageLayoutMetadata.x = 5;
			imageElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, imageLayoutMetadata);
			
			// Create media element
			var mediaWidth:int = 852;
			var mediaHeight:int = 480;
			var mediaElement:DynamicMediaElement = new DynamicMediaElement();
			
			var viewSprite:Sprite = new TesterSprite();
			viewSprite.width = mediaWidth;
			viewSprite.height = mediaHeight;
			var displayObjectTrait:DisplayObjectTrait = new DisplayObjectTrait(viewSprite, mediaWidth, mediaHeight);
			mediaElement.doAddTrait(MediaTraitType.DISPLAY_OBJECT, displayObjectTrait);
			
			var layoutMetadata:LayoutMetadata = new LayoutMetadata();
			layoutMetadata.scaleMode = ScaleMode.LETTERBOX;
			layoutMetadata.percentWidth = 80;
			mediaElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, layoutMetadata);
			
			// Create parallel element
			var parallelElement:ParallelElement = new ParallelElement();
			parallelElement.addChild(imageElement);
			parallelElement.addChild(mediaElement);
			
			var parallelLayout:LayoutMetadata = new LayoutMetadata();
			parallelLayout.width = 400;
			parallelLayout.height = 300;
			parallelElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, parallelLayout);
			
			// Create container
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			
			// Create layout renderer
			var layoutRenderer:LayoutRenderer = new LayoutRenderer();
			layoutRenderer.container = container;
			
			var melt:ILayoutTarget = layoutRenderer.addTarget(MediaElementLayoutTarget.getInstance(parallelElement));
			layoutRenderer.invalidate();
			layoutRenderer.validateNow();
			
			assertEquals(5,   imageSprite.x);
			assertEquals(0,   imageSprite.y);
			assertEquals(50,  imageSprite.width); 
			assertEquals(50,  imageSprite.height);  	

			assertEquals(0,   viewSprite.x);
			assertEquals(0,   viewSprite.y);
			assertEquals(320, viewSprite.width); 
			assertEquals(180, viewSprite.height);  	
		}
		
		public function testBug1231_IndexRevalidation():void
		{
			var enhancedLayout:EnhancedLayoutRenderer = new EnhancedLayoutRenderer();
			assertTrue(enhancedLayout.watchesMetadata(MetadataNamespaces.OVERLAY_LAYOUT_PARAMETERS));			
		}
	}
}
import org.osmf.layout.LayoutRenderer;

/**
 * @private
 */ 
internal class EnhancedLayoutRenderer extends LayoutRenderer
{
	public function EnhancedLayoutRenderer()
	{
		super();
	}
	
	public function watchesMetadata(type:String):Boolean
	{
		return (usedMetadatas.indexOf(type) != -1)
	}
}