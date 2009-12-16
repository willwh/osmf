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
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.events.ViewEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.DynamicMediaElement;
	
	public class TestParallelElement extends TestCompositeElement
	{
		// Overrides
		//
		
		override public function setUp():void
		{
			super.setUp();
			
			durationReachedEventCount = 0;
			durationChangedEventCount = 0;
			dimensionsChangeEventCount = 0;
			viewChangedEventCount = 0;
		}

		override protected function createMediaElement():MediaElement
		{
			var composite:CompositeElement = new ParallelElement();
			postCreateCompositeElement(composite);
			return composite;
		}

		// Tests
		//
		
		public function testGetTraitTypesDynamically():void
		{
			var parallel:ParallelElement = createParallelElement();
			parallel.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAddRemoveEvent, false, 0, true);
			parallel.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitAddRemoveEvent, false, 0, true);
			
			assertTrue(parallel.traitTypes != null);
			assertTrue(parallel.traitTypes.length == 0);
			
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			
			// Adding a media element with a new trait should cause that trait
			// to be reflected on the composition.
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.AUDIO]);
			parallel.addChild(mediaElement1);
			assertTrue(parallel.traitTypes.length == 1);
			assertTrue(parallel.traitTypes[0] == MediaTraitType.AUDIO);

			assertTrue(traitAddEventCount == 1);
			assertTrue(traitRemoveEventCount == 0);
			
			// Adding another media element with the same trait won't affect
			// the existing trait.
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.AUDIO, MediaTraitType.BUFFER]);
			parallel.addChild(mediaElement2);
			assertTrue(parallel.traitTypes.length == 2);
			assertTrue(parallel.traitTypes[0] == MediaTraitType.AUDIO);
			assertTrue(parallel.traitTypes[1] == MediaTraitType.BUFFER);

			assertTrue(traitAddEventCount == 2);
			assertTrue(traitRemoveEventCount == 0);

			// Adding a media element with all traits should cause all traits
			// to be reflected on the composition.
			var allTraitTypes:Array = vectorToArray(MediaTraitType.ALL_TYPES);
			var mediaElement3:MediaElement = new DynamicMediaElement(allTraitTypes);
			parallel.addChild(mediaElement3);
			assertTrue(parallel.traitTypes.length == allTraitTypes.length);
			for (var i:int = 0; i < allTraitTypes.length; i++)
			{
				assertTrue(parallel.traitTypes[i] == allTraitTypes[i]);
			}
			
			assertTrue(traitAddEventCount == allTraitTypes.length);
			assertTrue(traitRemoveEventCount == 0);

			// Removing a media element whose traits overlap with those of
			// other elements in the composition won't affect the reflected
			// traits.
			parallel.removeChild(mediaElement2);
			assertTrue(parallel.traitTypes.length == allTraitTypes.length);
			for (i = 0; i < allTraitTypes.length; i++)
			{
				assertTrue(MediaTraitType(parallel.traitTypes[i]) == allTraitTypes[i]);
			}
			
			assertTrue(traitAddEventCount == allTraitTypes.length);
			assertTrue(traitRemoveEventCount == 0);

			// But as soon as we remove a media element which is the only one
			// in the composition with a particular set of traits, then those
			// traits should no longer be reflected on the composition.
			parallel.removeChild(mediaElement3);
			assertTrue(parallel.traitTypes.length == 1);
			assertTrue(parallel.traitTypes[0] == MediaTraitType.AUDIO);
			
			assertTrue(traitAddEventCount == allTraitTypes.length);
			assertTrue(traitRemoveEventCount == allTraitTypes.length - 1);

			// Removing the last child should remove all traits.
			parallel.removeChild(mediaElement1);
			assertTrue(parallel.traitTypes.length == 0);

			assertTrue(traitAddEventCount == allTraitTypes.length);
			assertTrue(traitRemoveEventCount == allTraitTypes.length);
		}
		
		public function testHasTraitDynamically():void
		{
			var parallel:ParallelElement = createParallelElement();
			
			var allTraitTypes:Array = vectorToArray(MediaTraitType.ALL_TYPES);
			
			// No traits to begin with.
			assertHasTraits(parallel,[]);
				
			// Adding a media element with a new trait should cause that trait
			// to be reflected on the composition.
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.AUDIO]);
			parallel.addChild(mediaElement1);
			assertHasTraits(parallel,[MediaTraitType.AUDIO]);
			
			// Adding another media element with the same trait won't affect
			// the existing trait.
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.AUDIO, MediaTraitType.BUFFER]);
			parallel.addChild(mediaElement2);
			assertHasTraits(parallel,[MediaTraitType.AUDIO, MediaTraitType.BUFFER]);

			// Adding a media element with all traits should cause all traits
			// to be reflected on the composition.
			var mediaElement3:MediaElement = new DynamicMediaElement(allTraitTypes);
			parallel.addChild(mediaElement3);
			assertHasTraits(parallel,allTraitTypes);
			
			// Removing a media element whose traits overlap with those of
			// other elements in the composition won't affect the reflected
			// traits.
			parallel.removeChild(mediaElement2);
			assertHasTraits(parallel,allTraitTypes);
			
			// But as soon as we remove a media element which is the only one
			// in the composition with a particular set of traits, then those
			// traits should no longer be reflected on the composition.
			parallel.removeChild(mediaElement3);
			assertHasTraits(parallel,[MediaTraitType.AUDIO]);
			
			// Removing the last child should remove all traits.
			parallel.removeChild(mediaElement1);
			assertHasTraits(parallel,[]);
		}
/*
		
		public function testGetTraitSpatial():void
		{
			var parallel:ParallelElement = createParallelElement();
			
			// No trait to begin with.
			assertFalse(parallel.hasTrait(MediaTraitType.SPATIAL));
			assertTrue(parallel.getTrait(MediaTraitType.SPATIAL) == null);
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.SPATIAL]);
			var spatial1:SpatialTrait = mediaElement1.getTrait(MediaTraitType.SPATIAL) as SpatialTrait;
			
			parallel.addChild(mediaElement1);
			assertTrue(parallel.hasTrait(MediaTraitType.SPATIAL));
			
			var spatialP:ISpatial = parallel.getTrait(MediaTraitType.SPATIAL) as ISpatial;
			
			assertTrue(spatialP);
			assertTrue(spatialP.width == spatial1.width);
			assertTrue(spatialP.height == spatial1.height);
			
			spatialP.addEventListener(DimensionEvent.DIMENSION_CHANGE,onDimensionChange);
			
			spatial1.setDimensions(50,50);
			
			assertTrue(dimensionsChangeEventCount == 1);
			
			assertEquals(50, spatialP.width);
			assertEquals(50, spatialP.height);
			
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.SPATIAL]);
			var spatial2:SpatialTrait = mediaElement2.getTrait(MediaTraitType.SPATIAL) as SpatialTrait;
			parallel.addChild(mediaElement2);
			
			assertEquals(50, spatialP.width);
			assertEquals(50, spatialP.height);
			
			spatial2.setDimensions(100,50);
			
			assertEquals(2, dimensionsChangeEventCount);
			
			assertEquals(100, spatialP.width);
			assertEquals(50, spatialP.height);
			
			spatial2.setDimensions(100,100);
			
			assertEquals(3, dimensionsChangeEventCount);
			
			assertEquals(spatialP.width, 100);
			assertEquals(spatialP.height, 100);
			
			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.VIEWABLE,MediaTraitType.SPATIAL]);
			var viewable3:ViewableTrait = mediaElement3.getTrait(MediaTraitType.VIEWABLE) as ViewableTrait;
			
			parallel.addChild(mediaElement3);
			
			assertTrue(parallel.hasTrait(MediaTraitType.VIEWABLE));
			
			var viewableP:IViewable = parallel.getTrait(MediaTraitType.VIEWABLE) as IViewable;
			assertNotNull(viewableP);
			
			assertEquals(4, dimensionsChangeEventCount);
			
			assertEquals(0, spatialP.width);
			assertEquals(0, spatialP.height);
			
			var view3:Sprite = new Sprite();
			view3.graphics.drawRect(0,0,600,600);
			viewable3.view = view3;
			
			parallel.removeChild(mediaElement3);
			parallel.removeChild(mediaElement2);
			parallel.removeChild(mediaElement1);
		
			// No trait to end with.
			assertFalse(parallel.hasTrait(MediaTraitType.SPATIAL));
			assertNull(parallel.getTrait(MediaTraitType.SPATIAL))
		}
		
		public function testGetTraitViewable():void
		{
			var parallel:ParallelElement = createParallelElement();
			
			// No trait to begin with.
			assertFalse(parallel.hasTrait(MediaTraitType.VIEWABLE));
			assertNull(parallel.getTrait(MediaTraitType.VIEWABLE));
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.VIEWABLE,MediaTraitType.SPATIAL]);
			var viewable1:ViewableTrait = mediaElement1.getTrait(MediaTraitType.VIEWABLE) as ViewableTrait;
			var view1:Sprite =  new Sprite();
			viewable1.view = view1;
			
			parallel.addChild(mediaElement1);
			
			assertTrue(parallel.hasTrait(MediaTraitType.VIEWABLE));
			
			var viewableTrait:CompositeViewableTrait = parallel.getTrait(MediaTraitType.VIEWABLE) as CompositeViewableTrait; 
			assertNotNull(viewableTrait);
			
			viewableTrait.addEventListener(ViewEvent.VIEW_CHANGE,onViewChanged);
			
			var view:DisplayObjectContainer = viewableTrait.view as DisplayObjectContainer;
			assertNotNull(view);
			
			// The display list is not updated until we validat. Force an update:
			viewableTrait.layoutRenderer.validateNow();
			
			assertTrue(view.contains(viewable1.view));
			
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.VIEWABLE,MediaTraitType.SPATIAL]);
			var viewable2:ViewableTrait = mediaElement2.getTrait(MediaTraitType.VIEWABLE) as ViewableTrait;
			var view2:Sprite =  new Sprite();
			viewable2.view = view2;
			
			parallel.addChild(mediaElement2);
			
			// The display list is not updated until we validat. Force an update:
			viewableTrait.layoutRenderer.validateNow();
			
			assertTrue(view.contains(viewable2.view));
			*/
			/* -- changing because of layout work... 
			var spatial:ISpatial = parallel.getTrait(MediaTraitType.SPATIAL) as ISpatial;
			
			assertNotNull(spatial);
			assertEquals(0,spatial.width);
			assertEquals(0,spatial.height);
			
			parallel.removeChild(mediaElement1);
			view1.graphics.drawRect(0,0,10,20);
			parallel.addChild(mediaElement1);
			
			assertEquals(10,spatial.width);
			assertEquals(20,spatial.height);
			
			parallel.removeChild(mediaElement2);
			view2.graphics.drawRect(0,0,50,60);
			parallel.addChild(mediaElement2);
			
			assertEquals(50,spatial.width);
			assertEquals(60,spatial.height);
			
			parallel.removeChild(mediaElement2);
			
			assertEquals(10,spatial.width);
			assertEquals(20,spatial.height);
			
			parallel.removeChild(mediaElement1);
			
			// No trait to end with.
			assertFalse(parallel.hasTrait(MediaTraitType.VIEWABLE));
			assertNull(parallel.getTrait(MediaTraitType.VIEWABLE));
			
			assertEquals(0,viewChangedEventCount);
			*/
		/*}
		
		public function testViewableLayout():void
		{
			var parallel:ParallelElement = createParallelElement();
			var absolute:AbsoluteLayoutFacet = new AbsoluteLayoutFacet();
			absolute.width = 300;
			absolute.height = 200;
			parallel.metadata.addFacet(absolute);
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.VIEWABLE,MediaTraitType.SPATIAL]);
			absolute = new AbsoluteLayoutFacet();
			absolute.x = 10;
			absolute.y = 10;
			mediaElement1.metadata.addFacet(absolute);
			
			var anchor:AnchorLayoutFacet = new AnchorLayoutFacet();
			anchor.bottom = 10;
			anchor.right = 10;
			mediaElement1.metadata.addFacet(anchor);
			
			ViewableTrait(mediaElement1.getTrait(MediaTraitType.VIEWABLE)).view = new Sprite();
			
			parallel.addChild(mediaElement1);
			
			var compositeViewable:CompositeViewableTrait
				= parallel.getTrait(MediaTraitType.VIEWABLE)
				as CompositeViewableTrait;
				
			assertNotNull(compositeViewable);
		}
		*/
		
		override public function testMediaErrorEventDispatch():void
		{
			forceLoadTrait = true;
			
			super.testMediaErrorEventDispatch();
		}
		
		override public function testNestedMediaErrorEventDispatch():void
		{
			forceLoadTrait = true;
			
			super.testNestedMediaErrorEventDispatch();
		}
		
		// Internals
		//
		
		private function onDurationReached(event:TimeEvent):void
		{
			durationReachedEventCount++;
		}

		private function onDurationChanged(event:TimeEvent):void
		{
			durationChangedEventCount++;
		}
		
		private function onDimensionChange(event:ViewEvent):void
		{
			dimensionsChangeEventCount++;
		}
		
		private function onViewChanged(event:ViewEvent):void
		{
			viewChangedEventCount++;
		}

		private function createParallelElement():ParallelElement
		{
			return createMediaElement() as ParallelElement;
		}

		private function eventCatcher(event:Event):void
		{
			events.push(event);
		}
				
		private var durationReachedEventCount:int = 0;
		private var durationChangedEventCount:int = 0;
		private var dimensionsChangeEventCount:int = 0;
		private var viewChangedEventCount:int = 0;
		
		private var events:Vector.<Event>;
	}
}