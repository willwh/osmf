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
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osmf.events.*;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.traits.*;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.SimpleLoader;
	import org.osmf.utils.URL;

	public class TestSerialElement extends TestCompositeElement
	{
		// Overrides
		//
		
		override public function setUp():void
		{
			super.setUp();
			
			durationReachedEventCount = 0;
			playingChangedEventCount = 0;
			dimensionsChangeEventCount = 0;
			viewChangedEventCount = 0;
		}
		
		override protected function createMediaElement():MediaElement
		{
			var composite:CompositeElement = new SerialElement();
			postCreateCompositeElement(composite);
			return composite;
		}
		
		// Tests
		//

		public function testGetTraitTypesDynamically():void
		{
			var serial:SerialElement = createSerialElement();
			serial.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAddRemoveEvent, false, 0, true);
			serial.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitAddRemoveEvent, false, 0, true);
						
			assertTrue(serial.traitTypes != null);
			assertTrue(serial.traitTypes.length == 0);
			
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			
			// Add some children with varying sets of traits.
			//
			
			var child1:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIO, MediaTraitType.LOAD]);
			serial.addChild(child1);
			
			// As soon as we add a child, the composition reflects its traits.
			// It becomes the "current child" of the composition.
			assertTrue(serial.traitTypes.length == 2);
			assertTrue(serial.traitTypes[0] == MediaTraitType.AUDIO);
			assertTrue(serial.traitTypes[1] == MediaTraitType.LOAD);
			assertTrue(traitAddEventCount == 2);
			assertTrue(traitRemoveEventCount == 0);

			// Although individual traits can internally cause the current child
			// to change, the only way to do so externally is to add the first
			// child to a serial composition.			
			var child2:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIO, MediaTraitType.BUFFER]);
			serial.addChild(child2);
			
			// No change, because a child already existed.
			assertTrue(serial.traitTypes.length == 2);
			assertTrue(serial.traitTypes[0] == MediaTraitType.AUDIO);
			assertTrue(serial.traitTypes[1] == MediaTraitType.LOAD);
			assertTrue(traitAddEventCount == 2);
			assertTrue(traitRemoveEventCount == 0);
			
			// But if we remove and readd the first child, the second one
			// should now be reflected as the "current child".
			serial.removeChild(child1);
			serial.addChildAt(child1, 0);
			assertTrue(serial.traitTypes[0] == MediaTraitType.AUDIO);
			assertTrue(serial.traitTypes[1] == MediaTraitType.BUFFER);
			assertTrue(traitAddEventCount == 4);
			assertTrue(traitRemoveEventCount == 2);
			serial.removeChild(child1);
			serial.removeChild(child2);
			assertTrue(traitAddEventCount == 4);
			assertTrue(traitRemoveEventCount == 4);
			
			// Add some more children.
			//

			var allTraitTypes:Array = vectorToArray(MediaTraitType.ALL_TYPES);
			
			var child3:DynamicMediaElement = new DynamicMediaElement([/*none*/]);
			
			serial.addChild(child3);

			var child4:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIO]);
			serial.addChildAt(child4, 0);

			var child5:DynamicMediaElement = new DynamicMediaElement(allTraitTypes);
			serial.addChild(child5);
			
			// The first one we added should be the current child.
			assertTrue(serial.traitTypes.length == 0);
			assertTrue(traitAddEventCount == 4);
			assertTrue(traitRemoveEventCount == 4);
			
			// When we remove the current child, the next child should be the
			// new current child.
			serial.removeChild(child3);
			assertTrue(serial.traitTypes.length == allTraitTypes.length);
			assertTrue(traitAddEventCount == 4 + allTraitTypes.length);
			assertTrue(traitRemoveEventCount == 4);
			
			// Now when we remove the current child, the new current child is
			// the first child since there is no next child.
			serial.removeChild(child5);
			assertTrue(serial.traitTypes.length == 1);
			assertTrue(serial.traitTypes[0] == MediaTraitType.AUDIO);
			assertTrue(traitAddEventCount == 5 + allTraitTypes.length);
			assertTrue(traitRemoveEventCount == 4 + allTraitTypes.length);
			
			// When we remove the last child, we have no more traits.
			serial.removeChild(child4);
			assertTrue(serial.traitTypes.length == 0);
			assertTrue(traitAddEventCount == 5 + allTraitTypes.length);
			assertTrue(traitRemoveEventCount == 5 + allTraitTypes.length);
		}
		
		public function testHasTraitDynamically():void
		{
			var serial:SerialElement = createSerialElement();
			serial.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAddRemoveEvent, false, 0, true);
			serial.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitAddRemoveEvent, false, 0, true);
					
			// No traits to begin with.
			assertHasTraits(serial,[]);
			
			var allTraitTypes:Array = vectorToArray(MediaTraitType.ALL_TYPES);
			
			// Add some children with varying sets of traits.
			//
			
			var child1:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIO, MediaTraitType.LOAD]);
			serial.addChild(child1);
			
			// The first child added is what gets reflected in the composite trait.
			assertHasTraits(serial, [MediaTraitType.AUDIO, MediaTraitType.LOAD]);
			
			var child2:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIO, MediaTraitType.BUFFER]);
			serial.addChild(child2);
			
			// No change, because this was the second child added.
			assertHasTraits(serial, [MediaTraitType.AUDIO, MediaTraitType.LOAD]);
			
			// But if we remove the first child, then the second becomes the current child.
			serial.removeChildAt(0);
			assertHasTraits(serial, [MediaTraitType.AUDIO, MediaTraitType.BUFFER]);
			serial.removeChildAt(0);
			
			var child3:DynamicMediaElement = new DynamicMediaElement([/*none*/]);
			serial.addChild(child3);
			assertHasTraits(serial, [/*none*/]);
			serial.removeChild(child3);
			
			var child4:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIO]);
			serial.addChild(child4);
			assertHasTraits(serial, [MediaTraitType.AUDIO]);
			serial.removeChild(child4);
			
			var child5:DynamicMediaElement = new DynamicMediaElement(allTraitTypes);
			serial.addChild(child5);
			assertHasTraits(serial, allTraitTypes);
		}
		/*
		
		public function testGetTraitLoadable():void
		{
			var serial:SerialElement = createSerialElement();
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.LOADABLE) == null);
			
			// Create a few media elements with the ILoadable trait and give
			// them various load states.
			//

			var loader1:SimpleLoader = new SimpleLoader();
			var mediaElement1:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE],
										loader1,
										new URLResource(new URL("http://www.example.com/loadable1")));
			var loadable1:ILoadable = mediaElement1.getTrait(MediaTraitType.LOADABLE) as ILoadable;			
			loadable1.load();
			assertTrue(loadable1.loadState == LoadState.READY);

			var loader2:SimpleLoader = new SimpleLoader();
			var mediaElement2:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE],
										loader2,
										new URLResource(new URL("http://www.example.com/loadable2")));
			var loadable2:ILoadable = mediaElement2.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable2.loadState == LoadState.UNINITIALIZED);

			var loader3:SimpleLoader = new SimpleLoader();
			var mediaElement3:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE],
										loader3,
										new URLResource(new URL("http://www.example.com/loadable3")));
			var loadable3:ILoadable = mediaElement3.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			loadable3.load();
			assertTrue(loadable3.loadState == LoadState.READY);
			
			// Nothing is added yet, so our composition shouldn't have the trait yet.
			assertTrue(serial.getTrait(MediaTraitType.LOADABLE) == null);
			
			// As soon as we add a child, that child will become our current
			// child, and the composite trait will reflect it.
			serial.addChild(mediaElement1);
			var loadable:ILoadable = serial.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			assertTrue(loadable.loadState == LoadState.READY);
			assertTrue(loadable.resource != null &&
					   loadable.resource is URLResource &&
					   URLResource(loadable.resource).url.toString() == "http://www.example.com/loadable1");
			
			// The composite loadable should always reflect the trait of the
			// current child.
			serial.removeChild(mediaElement1);
			assertTrue(serial.getTrait(MediaTraitType.LOADABLE) == null);
			serial.addChild(mediaElement2);
			loadable = serial.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			assertTrue(loadable.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable.resource != null &&
					   loadable.resource is URLResource &&
					   URLResource(loadable.resource).url.toString() == "http://www.example.com/loadable2");

			serial.addChild(mediaElement3);
			serial.removeChild(mediaElement2);
			loadable = serial.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			assertTrue(loadable.loadState == LoadState.READY);
			
			serial.addChildAt(mediaElement1,0);
			serial.addChildAt(mediaElement2,1);
			
			// Changing the state of a non-current child should not affect the
			// state of the composition.
			loadable1 = mediaElement1.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable1.loadState == LoadState.READY);
			loadable1.unload();
			assertTrue(loadable1.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable.loadState == LoadState.READY);
			
			// Calling unload() on the composition should only affect the
			// current child.
			assertTrue(loadable.loadState == LoadState.READY);
			assertTrue(loadable1.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable2.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable3.loadState == LoadState.READY);
			loadable.unload();
			assertTrue(loadable.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable1.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable2.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable3.loadState == LoadState.UNINITIALIZED);

			// Calling load() on the composition should only affect the current
			// child.
			loadable.load();
			assertTrue(loadable.loadState == LoadState.READY);
			assertTrue(loadable1.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable2.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable3.loadState == LoadState.READY);
			
			// If a load fails for a non-current child, then the composition
			// should be unaffected.
			loader2.forceFail = true;
			loadable2.load();
			assertTrue(loadable.loadState == LoadState.READY);
			assertTrue(loadable1.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable2.loadState == LoadState.LOAD_ERROR);
			assertTrue(loadable3.loadState == LoadState.READY);

			// If a load fails for the current child, then the composition
			// should reflect its state.
			loadable3.unload();
			loader3.forceFail = true;
			loadable3.load();
			assertTrue(loadable.loadState == LoadState.LOAD_ERROR);
			assertTrue(loadable1.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable2.loadState == LoadState.LOAD_ERROR);
			assertTrue(loadable3.loadState == LoadState.LOAD_ERROR);
		}
		
		public function testGetTraitPlayableWithLoadable():void
		{
			var serial:SerialElement = createSerialElement();
			
			// Create a few media elements.
			//

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.PLAYABLE, MediaTraitType.TEMPORAL]);
			var playable1:PlayableTrait = mediaElement1.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			var temporal1:TemporalTrait = mediaElement1.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			temporal1.duration = 1;

			var loader2:SimpleLoader = new SimpleLoader();
			var mediaElement2:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE],
										loader2,
										new URLResource(new URL("http://www.example.com/loadable1")));
			var playable2:PlayableTrait = mediaElement2.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			assertTrue(playable2 == null);
			var loadable2:ILoadable = mediaElement2.getTrait(MediaTraitType.LOADABLE) as ILoadable;			
			assertTrue(loadable2.loadState == LoadState.UNINITIALIZED);
			
			var loader3:SimpleLoader = new SimpleLoader();
			var mediaElement3:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE],
										loader3,
										new URLResource(new URL("http://www.example.com/loadable1")));
			var playable3:PlayableTrait = mediaElement3.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			assertTrue(playable3 == null);
			var loadable3:ILoadable = mediaElement3.getTrait(MediaTraitType.LOADABLE) as ILoadable;			
			assertTrue(loadable3.loadState == LoadState.UNINITIALIZED);
			var temporal3:TemporalTrait = null;
			
			var mediaElement4:MediaElement = new DynamicMediaElement([MediaTraitType.PLAYABLE, MediaTraitType.TEMPORAL]);
			var playable4:PlayableTrait = mediaElement4.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			var temporal4:TemporalTrait = mediaElement4.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			temporal4.duration = 1;
			
			// Make sure that the third child gets the IPlayable trait when
			// it finishes loading.
			loadable3.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
			function onLoadStateChange(event:LoadEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					loadable3.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
					DynamicMediaElement(mediaElement3).doAddTrait(MediaTraitType.PLAYABLE, new PlayableTrait(mediaElement3));
					temporal3 = new TemporalTrait();
					temporal3.duration = 1;
					DynamicMediaElement(mediaElement3).doAddTrait(MediaTraitType.TEMPORAL, temporal3);
				}
			}
			
			// Add them as children.
			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);
			serial.addChild(mediaElement3);
			serial.addChild(mediaElement4);

			var temporal:ITemporal = serial.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			temporal.addEventListener(TimeEvent.DURATION_REACHED, onDurationReached);
			
			// Play the first child.  This should cause the composition to be
			// playing.
			playable1.play();
			var playable:IPlayable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable != null);
			assertTrue(playable.playing == true);
			
			// If the first child's playing state changes, that's not sufficient
			// to trigger the playback of the next child.
			playable1.resetPlaying();
			assertTrue(playable1.playing == false);
			assertTrue(playable.playing == false);
			playable2 = mediaElement2.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			assertTrue(playable2 == null);
			playable3 = mediaElement3.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			assertTrue(playable3 == null);
			assertTrue(loadable2.loadState == LoadState.UNINITIALIZED);
			assertTrue(loadable3.loadState == LoadState.UNINITIALIZED);
			
			// However, when the first child reaches its duration, the following
			// should happen:
			// 1) The second child is loaded.
			// 2) Because the second child doesn't have the playable trait
			//    when it loads, the third child is loaded. 
			// 3) Because the third child does have the playable trait when
			//    it's loaded, it becomes the new current child.
			temporal1.currentTime = temporal1.duration;
			playable2 = mediaElement2.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			assertTrue(playable2 == null);
			playable3 = mediaElement3.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			assertTrue(playable3 != null);
			assertTrue(loadable2.loadState == LoadState.READY);
			assertTrue(loadable3.loadState == LoadState.READY);
			playable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable.playing == true);
			assertTrue(playable1.playing == false);
			assertTrue(playable3.playing == true);
			assertTrue(playable4.playing == false);
			
			assertTrue(durationReachedEventCount == 0);
			
			// When the third child reaches its duration, the next child
			// should be playing.
			playable3.resetPlaying();
			temporal3.currentTime = temporal3.duration;
			playable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable.playing == true);
			assertTrue(playable1.playing == false);
			assertTrue(playable3.playing == false);
			assertTrue(playable4.playing == true);
			
			assertTrue(durationReachedEventCount == 0);
			
			// When the fourth child reaches its duration, we should receive
			// the duration reached event.
			playable4.resetPlaying();
			temporal4.currentTime = temporal4.duration;
			playable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable.playing == false);
			assertTrue(playable1.playing == false);
			assertTrue(playable3.playing == false);
			assertTrue(playable4.playing == false);
			
			assertTrue(durationReachedEventCount == 1);
		}
		
		public function testGetTraitSpatial():void
		{
			var serial:SerialElement = createSerialElement();
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.SPATIAL]);
			var spatial1:SpatialTrait = mediaElement1.getTrait(MediaTraitType.SPATIAL) as SpatialTrait;
			
			// No trait to begin with.
			assertFalse(serial.hasTrait(MediaTraitType.SPATIAL));
			assertNull(serial.getTrait(MediaTraitType.SPATIAL));
			
			serial.addChild(mediaElement1);
			
			assertTrue(serial.hasTrait(MediaTraitType.SPATIAL));
			var spatial:ISpatial = serial.getTrait(MediaTraitType.SPATIAL) as ISpatial;
			assertNotNull(spatial);
			
			spatial.addEventListener(DimensionEvent.DIMENSION_CHANGE,onDimensionChange);
			
			assertEquals(0,spatial.width);
			assertEquals(0,spatial.height);
			
			spatial1.setDimensions(10,100);
			
			assertEquals(1,dimensionsChangeEventCount);
			
			assertEquals(10,spatial.width);
			assertEquals(100,spatial.height);
			
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.SPATIAL]);
			var spatial2:SpatialTrait = mediaElement2.getTrait(MediaTraitType.SPATIAL) as SpatialTrait;
			spatial2.setDimensions(51,52);
			
			serial.addChild(mediaElement2);
			assertEquals(spatial,serial.getTrait(MediaTraitType.SPATIAL));
			assertNull(serial.getTrait(MediaTraitType.VIEWABLE));
			
			serial.removeChild(mediaElement1);
			
			assertNotNull(serial.getTrait(MediaTraitType.SPATIAL));
			assertEquals(2,dimensionsChangeEventCount);
			
			// Child removal got us a new spatial trait:
			spatial = serial.getTrait(MediaTraitType.SPATIAL) as ISpatial;
			spatial.addEventListener(DimensionEvent.DIMENSION_CHANGE,onDimensionChange);
			
			assertEquals(51,spatial.width);
			assertEquals(52,spatial.height);
			
			serial.removeChild(mediaElement2);
			
			// No trait to end with.
			assertFalse(serial.hasTrait(MediaTraitType.SPATIAL));
			assertNull(serial.getTrait(MediaTraitType.SPATIAL));
		}
		
		public function testGetTraitViewable():void
		{
			var serial:SerialElement = createSerialElement();
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.VIEWABLE]);
			var viewable1:ViewableTrait = mediaElement1.getTrait(MediaTraitType.VIEWABLE) as ViewableTrait;
			
			// No trait to begin with.
			assertFalse(serial.hasTrait(MediaTraitType.VIEWABLE));
			assertNull(serial.getTrait(MediaTraitType.VIEWABLE));
			
			serial.addChild(mediaElement1);
			
			assertTrue(serial.hasTrait(MediaTraitType.VIEWABLE));
			var viewable:IViewable = serial.getTrait(MediaTraitType.VIEWABLE) as IViewable;
			assertNotNull(viewable);
			
			viewable.addEventListener(ViewEvent.VIEW_CHANGE,onViewChanged);
			
			var view1:Sprite = new Sprite();
			viewable1.view = view1;
			
			// The view no longer changes: there's a fixed container sprite in between now:
			assertEquals(0,viewChangedEventCount);
			
			// The container should contain 'view1' though (once the layout has been updated!)
			CompositeViewableTrait(viewable).layoutRenderer.validateNow();
			assertTrue(DisplayObjectContainer(viewable.view).contains(view1));
			
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.VIEWABLE]);
			var viewable2:ViewableTrait = mediaElement2.getTrait(MediaTraitType.VIEWABLE) as ViewableTrait;
			var view2:Sprite = new Sprite();
			viewable2.view = view2;
			
			serial.addChild(mediaElement2);
			serial.removeChild(mediaElement1);
			
			assertEquals(0,viewChangedEventCount);
			
			// The container should contain 'view2' now (once the layout has been updated!)
			CompositeViewableTrait(viewable).layoutRenderer.validateNow();
			assertTrue(DisplayObjectContainer(viewable.view).contains(view2));
			assertFalse(DisplayObjectContainer(viewable.view).contains(view1));
				
			serial.removeChild(mediaElement2);
			
			// No trait to end with.
			assertFalse(serial.hasTrait(MediaTraitType.VIEWABLE));
			assertNull(serial.getTrait(MediaTraitType.VIEWABLE));
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

		private function onDimensionChange(event:ViewEvent):void
		{
			dimensionsChangeEventCount++;
		}
		
		private function onViewChanged(event:ViewEvent):void
		{
			viewChangedEventCount++;
		}

		private function createSerialElement():SerialElement
		{
			return createMediaElement() as SerialElement;
		}

		protected function eventCatcher(event:Event):void
		{
			events.push(event);
		}
		
		private var durationReachedEventCount:int = 0;
		private var dimensionsChangeEventCount:int = 0;
		private var viewChangedEventCount:int = 0;
		
		private var events:Vector.<Event>;
	}
}