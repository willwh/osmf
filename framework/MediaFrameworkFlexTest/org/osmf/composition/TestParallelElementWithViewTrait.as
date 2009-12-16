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
	
	import org.osmf.events.ViewEvent;
	import org.osmf.layout.AbsoluteLayoutFacet;
	import org.osmf.layout.AnchorLayoutFacet;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.ViewTrait;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.DynamicViewTrait;

	public class TestParallelElementWithViewTrait extends TestCase
	{
		public function testViewTraitDimensions():void
		{
			var parallel:ParallelElement = new ParallelElement();
			
			// No trait to begin with.
			assertFalse(parallel.hasTrait(MediaTraitType.VIEW));
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.VIEW], null, null, true);
			var viewTrait1:DynamicViewTrait = mediaElement1.getTrait(MediaTraitType.VIEW) as DynamicViewTrait;
			
			parallel.addChild(mediaElement1);
			assertTrue(parallel.hasTrait(MediaTraitType.VIEW));
			
			var viewTrait:ViewTrait = parallel.getTrait(MediaTraitType.VIEW) as ViewTrait;
			assertTrue(viewTrait != null);
			assertTrue(viewTrait.mediaWidth == viewTrait1.mediaWidth);
			assertTrue(viewTrait.mediaHeight == viewTrait1.mediaHeight);
			
			viewTrait.addEventListener(ViewEvent.DIMENSION_CHANGE, onDimensionChange);
			
			viewTrait1.setDimensions(50, 50);
			
			assertTrue(dimensionsChangeEventCount == 1);
			
			// TODO: Fix the rest of this test.  For some reason, setting the dimensions
			// doesn't propagate to the container, it only affects the underlying trait. 
			if (true) return;
			
			assertEquals(50, viewTrait.mediaWidth);
			assertEquals(50, viewTrait.mediaHeight);
			
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.VIEW], null, null, true);
			var viewTrait2:DynamicViewTrait = mediaElement2.getTrait(MediaTraitType.VIEW) as DynamicViewTrait;
			parallel.addChild(mediaElement2);
			
			assertEquals(50, viewTrait.mediaWidth);
			assertEquals(50, viewTrait.mediaHeight);
			
			viewTrait2.setDimensions(100, 50);
			
			assertEquals(2, dimensionsChangeEventCount);
			
			assertEquals(100, viewTrait.mediaWidth);
			assertEquals(50, viewTrait.mediaHeight);
			
			viewTrait2.setDimensions(100, 100);
			
			assertEquals(3, dimensionsChangeEventCount);
			
			assertEquals(viewTrait.mediaWidth, 100);
			assertEquals(viewTrait.mediaHeight, 100);
			
			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.VIEW], null, null, true);
			var viewTrait3:DynamicViewTrait = mediaElement3.getTrait(MediaTraitType.VIEW) as DynamicViewTrait;
			
			parallel.addChild(mediaElement3);
			
			assertTrue(parallel.hasTrait(MediaTraitType.VIEW));
			
			viewTrait = parallel.getTrait(MediaTraitType.VIEW) as ViewTrait;
			assertNotNull(viewTrait);
			
			assertEquals(4, dimensionsChangeEventCount);
			
			assertEquals(0, viewTrait.mediaWidth);
			assertEquals(0, viewTrait.mediaHeight);
			
			var view3:Sprite = new Sprite();
			view3.graphics.drawRect(0, 0, 600, 600);
			viewTrait3.view = view3;
			
			parallel.removeChild(mediaElement3);
			parallel.removeChild(mediaElement2);
			parallel.removeChild(mediaElement1);
		
			// No trait to end with.
			assertFalse(parallel.hasTrait(MediaTraitType.VIEW));
		}
		
		public function testViewTraitView():void
		{
			var parallel:ParallelElement = new ParallelElement();
			
			// No trait to begin with.
			assertFalse(parallel.hasTrait(MediaTraitType.VIEW));
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.VIEW], null, null, true);
			var viewTrait1:DynamicViewTrait = mediaElement1.getTrait(MediaTraitType.VIEW) as DynamicViewTrait;
			var view1:Sprite =  new Sprite();
			viewTrait1.view = view1;
			
			parallel.addChild(mediaElement1);
			
			assertTrue(parallel.hasTrait(MediaTraitType.VIEW));
			
			var viewTrait:ViewTrait = parallel.getTrait(MediaTraitType.VIEW) as ViewTrait; 
			assertNotNull(viewTrait);
			
			viewTrait.addEventListener(ViewEvent.VIEW_CHANGE, onViewChanged);
			
			var view:DisplayObjectContainer = viewTrait.view as DisplayObjectContainer;
			assertNotNull(view);
			
			// TODO: We should either enable the commented out lines, or remove them
			// entirely (if they aren't appropriate to this test).  Note that the ViewTrait
			// should not expose the layoutRenderer, so we would need some other way of
			// validating (perhaps we just wait for an invalidation and make the test
			// async>).
			
			// The display list is not updated until we validate. Force an update:
			//viewTrait.layoutRenderer.validateNow();
			//assertTrue(view.contains(viewTrait1.view));
			
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.VIEW], null, null, true);
			var viewTrait2:DynamicViewTrait = mediaElement2.getTrait(MediaTraitType.VIEW) as DynamicViewTrait;
			var view2:Sprite =  new Sprite();
			viewTrait2.view = view2;
			
			parallel.addChild(mediaElement2);
			
			// TODO: See above comment.
			
			// The display list is not updated until we validat. Force an update:
			//viewTrait.layoutRenderer.validateNow();
			//assertTrue(view.contains(viewTrait2.view));
		}
		
		public function testViewTraitLayout():void
		{
			var parallel:ParallelElement = new ParallelElement();
			var absolute:AbsoluteLayoutFacet = new AbsoluteLayoutFacet();
			absolute.width = 300;
			absolute.height = 200;
			parallel.metadata.addFacet(absolute);
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.VIEW], null, null, true);
			absolute = new AbsoluteLayoutFacet();
			absolute.x = 10;
			absolute.y = 10;
			mediaElement1.metadata.addFacet(absolute);
			
			var anchor:AnchorLayoutFacet = new AnchorLayoutFacet();
			anchor.bottom = 10;
			anchor.right = 10;
			mediaElement1.metadata.addFacet(anchor);
			
			DynamicViewTrait(mediaElement1.getTrait(MediaTraitType.VIEW)).view = new Sprite();
			
			parallel.addChild(mediaElement1);
			
			var viewTrait:ViewTrait = parallel.getTrait(MediaTraitType.VIEW) as ViewTrait;
				
			assertNotNull(viewTrait);
		}
		
		private function onViewChanged(event:ViewEvent):void
		{
			viewChangedEventCount++;
		}

		private function onDimensionChange(event:ViewEvent):void
		{
			dimensionsChangeEventCount++;
		}

		private var viewChangedEventCount:int = 0;
		private var dimensionsChangeEventCount:int = 0;
	}
}