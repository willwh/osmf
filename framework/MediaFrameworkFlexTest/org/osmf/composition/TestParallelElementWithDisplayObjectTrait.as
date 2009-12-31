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
package org.osmf.composition
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.layout.AbsoluteLayoutFacet;
	import org.osmf.layout.AnchorLayoutFacet;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.DynamicDisplayObjectTrait;

	public class TestParallelElementWithDisplayObjectTrait extends TestCase
	{
		public function testDisplayObjectTraitDimensions():void
		{
			var parallel:ParallelElement = new ParallelElement();
			
			// No trait to begin with.
			assertFalse(parallel.hasTrait(MediaTraitType.DISPLAY_OBJECT));
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.DISPLAY_OBJECT], null, null, true);
			var displayObjectTrait1:DynamicDisplayObjectTrait = mediaElement1.getTrait(MediaTraitType.DISPLAY_OBJECT) as DynamicDisplayObjectTrait;
			
			parallel.addChild(mediaElement1);
			assertTrue(parallel.hasTrait(MediaTraitType.DISPLAY_OBJECT));
			
			var displayObjectTrait:DisplayObjectTrait = parallel.getTrait(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait;
			assertTrue(displayObjectTrait != null);
			assertTrue(displayObjectTrait.mediaWidth == displayObjectTrait1.mediaWidth);
			assertTrue(displayObjectTrait.mediaHeight == displayObjectTrait1.mediaHeight);
			
			displayObjectTrait.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSizeChange);
			
			displayObjectTrait1.setSize(50, 50);
			
			assertTrue(sizeChangeEventCount == 1);
			
			// TODO: Fix the rest of this test.  For some reason, setting the dimensions
			// doesn't propagate to the container, it only affects the underlying trait. 
			if (true) return;
			
			assertEquals(50, displayObjectTrait.mediaWidth);
			assertEquals(50, displayObjectTrait.mediaHeight);
			
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.DISPLAY_OBJECT], null, null, true);
			var displayObjectTrait2:DynamicDisplayObjectTrait = mediaElement2.getTrait(MediaTraitType.DISPLAY_OBJECT) as DynamicDisplayObjectTrait;
			parallel.addChild(mediaElement2);
			
			assertEquals(50, displayObjectTrait.mediaWidth);
			assertEquals(50, displayObjectTrait.mediaHeight);
			
			displayObjectTrait2.setDimensions(100, 50);
			
			assertEquals(2, dimensionsChangeEventCount);
			
			assertEquals(100, displayObjectTrait.mediaWidth);
			assertEquals(50, displayObjectTrait.mediaHeight);
			
			displayObjectTrait2.setDimensions(100, 100);
			
			assertEquals(3, dimensionsChangeEventCount);
			
			assertEquals(displayObjectTrait.mediaWidth, 100);
			assertEquals(displayObjectTrait.mediaHeight, 100);
			
			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.DISPLAY_OBJECT], null, null, true);
			var displayObjectTrait3:DynamicDisplayObjectTrait = mediaElement3.getTrait(MediaTraitType.DISPLAY_OBJECT) as DynamicDisplayObjectTrait;
			
			parallel.addChild(mediaElement3);
			
			assertTrue(parallel.hasTrait(MediaTraitType.DISPLAY_OBJECT));
			
			displayObjectTrait = parallel.getTrait(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait;
			assertNotNull(displayObjectTrait);
			
			assertEquals(4, sizeChangeEventCount);
			
			assertEquals(0, displayObjectTrait.mediaWidth);
			assertEquals(0, displayObjectTrait.mediaHeight);
			
			var view3:Sprite = new Sprite();
			view3.graphics.drawRect(0, 0, 600, 600);
			displayObjectTrait3.view = view3;
			
			parallel.removeChild(mediaElement3);
			parallel.removeChild(mediaElement2);
			parallel.removeChild(mediaElement1);
		
			// No trait to end with.
			assertFalse(parallel.hasTrait(MediaTraitType.DISPLAY_OBJECT));
		}
		
		public function testDisplayObjectTraitDisplayObject():void
		{
			var parallel:ParallelElement = new ParallelElement();
			
			// No trait to begin with.
			assertFalse(parallel.hasTrait(MediaTraitType.DISPLAY_OBJECT));
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.DISPLAY_OBJECT], null, null, true);
			var displayObjectTrait1:DynamicDisplayObjectTrait = mediaElement1.getTrait(MediaTraitType.DISPLAY_OBJECT) as DynamicDisplayObjectTrait;
			var view1:Sprite =  new Sprite();
			displayObjectTrait1.displayObject = view1;
			
			parallel.addChild(mediaElement1);
			
			assertTrue(parallel.hasTrait(MediaTraitType.DISPLAY_OBJECT));
			
			var displayObjectTrait:DisplayObjectTrait = parallel.getTrait(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait; 
			assertNotNull(displayObjectTrait);
			
			displayObjectTrait.addEventListener(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, onDisplayObjectChanged);
			
			var view:DisplayObjectContainer = displayObjectTrait.displayObject as DisplayObjectContainer;
			assertNotNull(view);
			
			// TODO: We should either enable the commented out lines, or remove them
			// entirely (if they aren't appropriate to this test).  Note that the DisplayObjectTrait
			// should not expose the layoutRenderer, so we would need some other way of
			// validating (perhaps we just wait for an invalidation and make the test
			// async>).
			
			// The display list is not updated until we validate. Force an update:
			//displayObjectTrait.layoutRenderer.validateNow();
			//assertTrue(view.contains(displayObjectTrait1.view));
			
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.DISPLAY_OBJECT], null, null, true);
			var displayObjectTrait2:DynamicDisplayObjectTrait = mediaElement2.getTrait(MediaTraitType.DISPLAY_OBJECT) as DynamicDisplayObjectTrait;
			var view2:Sprite =  new Sprite();
			displayObjectTrait2.displayObject = view2;
			
			parallel.addChild(mediaElement2);
			
			// TODO: See above comment.
			
			// The display list is not updated until we validat. Force an update:
			//displayObjectTrait.layoutRenderer.validateNow();
			//assertTrue(view.contains(displayObjectTrait2.view));
		}
		
		public function testDisplayObjectTraitLayout():void
		{
			var parallel:ParallelElement = new ParallelElement();
			var absolute:AbsoluteLayoutFacet = new AbsoluteLayoutFacet();
			absolute.width = 300;
			absolute.height = 200;
			parallel.metadata.addFacet(absolute);
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.DISPLAY_OBJECT], null, null, true);
			absolute = new AbsoluteLayoutFacet();
			absolute.x = 10;
			absolute.y = 10;
			mediaElement1.metadata.addFacet(absolute);
			
			var anchor:AnchorLayoutFacet = new AnchorLayoutFacet();
			anchor.bottom = 10;
			anchor.right = 10;
			mediaElement1.metadata.addFacet(anchor);
			
			DynamicDisplayObjectTrait(mediaElement1.getTrait(MediaTraitType.DISPLAY_OBJECT)).displayObject = new Sprite();
			
			parallel.addChild(mediaElement1);
			
			var displayObjectTrait:DisplayObjectTrait = parallel.getTrait(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait;
				
			assertNotNull(displayObjectTrait);
		}
		
		private function onDisplayObjectChanged(event:DisplayObjectEvent):void
		{
			viewChangedEventCount++;
		}

		private function onMediaSizeChange(event:DisplayObjectEvent):void
		{
			sizeChangeEventCount++;
		}

		private var viewChangedEventCount:int = 0;
		private var sizeChangeEventCount:int = 0;
	}
}