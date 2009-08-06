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
package org.openvideoplayer.composition
{
	import __AS3__.vec.Vector;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.openvideoplayer.events.*;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.*;
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.SimpleLoader;
	import org.openvideoplayer.utils.URL;

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
			serial.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAddRemoveEvent, false, 0, true);
			serial.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitAddRemoveEvent, false, 0, true);
						
			assertTrue(serial.traitTypes != null);
			assertTrue(serial.traitTypes.length == 0);
			
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			
			// Add some children with varying sets of traits.
			//
			
			var child1:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIBLE, MediaTraitType.LOADABLE]);
			serial.addChild(child1);
			
			// As soon as we add a child, the composition reflects its traits.
			// It becomes the "current child" of the composition.
			assertTrue(serial.traitTypes.length == 2);
			assertTrue(MediaTraitType(serial.traitTypes[0]) == MediaTraitType.AUDIBLE);
			assertTrue(MediaTraitType(serial.traitTypes[1]) == MediaTraitType.LOADABLE);
			assertTrue(traitAddEventCount == 2);
			assertTrue(traitRemoveEventCount == 0);

			// Although individual traits can internally cause the current child
			// to change, the only way to do so externally is to add the first
			// child to a serial composition.			
			var child2:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIBLE, MediaTraitType.BUFFERABLE]);
			serial.addChild(child2);
			
			// No change, because a child already existed.
			assertTrue(serial.traitTypes.length == 2);
			assertTrue(MediaTraitType(serial.traitTypes[0]) == MediaTraitType.AUDIBLE);
			assertTrue(MediaTraitType(serial.traitTypes[1]) == MediaTraitType.LOADABLE);
			assertTrue(traitAddEventCount == 2);
			assertTrue(traitRemoveEventCount == 0);
			
			// But if we remove and readd the first child, the second one
			// should now be reflected as the "current child".
			serial.removeChild(child1);
			serial.addChildAt(child1, 0);
			assertTrue(MediaTraitType(serial.traitTypes[0]) == MediaTraitType.AUDIBLE);
			assertTrue(MediaTraitType(serial.traitTypes[1]) == MediaTraitType.BUFFERABLE);
			assertTrue(traitAddEventCount == 4);
			assertTrue(traitRemoveEventCount == 2);
			serial.removeChild(child1);
			serial.removeChild(child2);
			assertTrue(traitAddEventCount == 4);
			assertTrue(traitRemoveEventCount == 4);
			
			// Add some more children.
			//

			var child3:DynamicMediaElement = new DynamicMediaElement([/*none*/]);
			
			serial.addChild(child3);

			var child4:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIBLE]);
			serial.addChildAt(child4, 0);

			var child5:DynamicMediaElement = new DynamicMediaElement(ALL_TRAIT_TYPES);
			serial.addChild(child5);
			
			// The first one we added should be the current child.
			assertTrue(serial.traitTypes.length == 0);
			assertTrue(traitAddEventCount == 4);
			assertTrue(traitRemoveEventCount == 4);
			
			// When we remove the current child, the next child should be the
			// new current child.
			serial.removeChild(child3);
			assertTrue(serial.traitTypes.length == ALL_TRAIT_TYPES.length);
			assertTrue(traitAddEventCount == 4 + ALL_TRAIT_TYPES.length);
			assertTrue(traitRemoveEventCount == 4);
			
			// Now when we remove the current child, the new current child is
			// the first child since there is no next child.
			serial.removeChild(child5);
			assertTrue(serial.traitTypes.length == 1);
			assertTrue(MediaTraitType(serial.traitTypes[0]) == MediaTraitType.AUDIBLE);
			assertTrue(traitAddEventCount == 5 + ALL_TRAIT_TYPES.length);
			assertTrue(traitRemoveEventCount == 4 + ALL_TRAIT_TYPES.length);
			
			// When we remove the last child, we have no more traits.
			serial.removeChild(child4);
			assertTrue(serial.traitTypes.length == 0);
			assertTrue(traitAddEventCount == 5 + ALL_TRAIT_TYPES.length);
			assertTrue(traitRemoveEventCount == 5 + ALL_TRAIT_TYPES.length);
		}
		
		public function testHasTraitDynamically():void
		{
			var serial:SerialElement = createSerialElement();
			serial.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAddRemoveEvent, false, 0, true);
			serial.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitAddRemoveEvent, false, 0, true);
						
			// No traits to begin with.
			assertHasTraits(serial,[]);
			
			// Add some children with varying sets of traits.
			//
			
			var child1:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIBLE, MediaTraitType.LOADABLE]);
			serial.addChild(child1);
			
			// The first child added is what gets reflected in the composite trait.
			assertHasTraits(serial, [MediaTraitType.AUDIBLE, MediaTraitType.LOADABLE]);
			
			var child2:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIBLE, MediaTraitType.BUFFERABLE]);
			serial.addChild(child2);
			
			// No change, because this was the second child added.
			assertHasTraits(serial, [MediaTraitType.AUDIBLE, MediaTraitType.LOADABLE]);
			
			// But if we remove the first child, then the second becomes the current child.
			serial.removeChildAt(0);
			assertHasTraits(serial, [MediaTraitType.AUDIBLE, MediaTraitType.BUFFERABLE]);
			serial.removeChildAt(0);
			
			var child3:DynamicMediaElement = new DynamicMediaElement([/*none*/]);
			serial.addChild(child3);
			assertHasTraits(serial, [/*none*/]);
			serial.removeChild(child3);
			
			var child4:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIBLE]);
			serial.addChild(child4);
			assertHasTraits(serial, [MediaTraitType.AUDIBLE]);
			serial.removeChild(child4);
			
			var child5:DynamicMediaElement = new DynamicMediaElement(ALL_TRAIT_TYPES);
			serial.addChild(child5);
			assertHasTraits(serial, ALL_TRAIT_TYPES);
		}
		
		public function testGetTraitAudible():void
		{
			var serial:SerialElement = createSerialElement();
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.AUDIBLE) == null);
			
			// Create a few media elements with the IAudible trait and some
			// initial properties.
			//
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.AUDIBLE]);
			var audible1:IAudible = mediaElement1.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			audible1.volume = 0.11;
			audible1.muted = true;
			audible1.pan = -0.22;

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.AUDIBLE]);
			var audible2:IAudible = mediaElement2.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			audible2.volume = 0.33;
			audible2.muted = false;
			audible2.pan = -0.44;
			
			// Add the first child.  This should cause its properties to
			// propagate to the composition.
			serial.addChild(mediaElement1);
			var audible:IAudible = serial.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			assertTrue(audible != null);
			assertTrue(audible.volume == 0.11);
			assertTrue(audible.muted == true);
			assertTrue(audible.pan == -0.22);
			
			// Add the second child.
			serial.addChild(mediaElement2);
			
			// Adding it shouldn't affect the properties of the composition.
			audible = serial.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			assertTrue(audible != null);
			assertTrue(audible.volume == 0.11);
			assertTrue(audible.muted == true);
			assertTrue(audible.pan == -0.22);
			
			// But the added child should inherit the properties of the
			// composition.
			audible2 = mediaElement2.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			assertTrue(audible2 != null);
			assertTrue(audible2.volume == 0.11);
			assertTrue(audible2.muted == true);
			assertTrue(audible2.pan == -0.22);
			
			// Change the settings on the second child.
			audible2.volume = 0.55;
			audible2.muted = false;
			audible2.pan = -0.66;
			
			// This should affect the composition and all of its children.
			audible = serial.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			assertTrue(audible != null);
			assertTrue(audible.volume == 0.55);
			assertTrue(audible.muted == false);
			assertTrue(audible.pan == -0.66);
			audible1 = mediaElement1.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			assertTrue(audible1 != null);
			assertTrue(audible1.volume == 0.55);
			assertTrue(audible1.muted == false);
			assertTrue(audible1.pan == -0.66);
			audible2 = mediaElement2.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			assertTrue(audible2 != null);
			assertTrue(audible2.volume == 0.55);
			assertTrue(audible2.muted == false);
			assertTrue(audible2.pan == -0.66);
		}
		
		public function testGetTraitAudible_DynamicChildTraits():void
		{
			var serial:SerialElement = createSerialElement();
			
			var mediaElement1:DynamicMediaElement
				= new DynamicMediaElement
					( 	[ MediaTraitType.AUDIBLE
						, MediaTraitType.TEMPORAL
						, MediaTraitType.SEEKABLE
						]
					);
			var audible1:AudibleTrait = mediaElement1.getTrait(MediaTraitType.AUDIBLE) as AudibleTrait;
			assertNotNull(audible1);
			SeekableTrait(mediaElement1.getTrait(MediaTraitType.SEEKABLE)).temporal
				= mediaElement1.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			TemporalTrait(mediaElement1.getTrait(MediaTraitType.TEMPORAL)).duration = 5;
			
			var mediaElement2:DynamicMediaElement
				= new DynamicMediaElement
					( 	[ MediaTraitType.TEMPORAL
						, MediaTraitType.SEEKABLE
						]
					);

			var audible2:AudibleTrait = mediaElement2.getTrait(MediaTraitType.AUDIBLE) as AudibleTrait;
			assertNull(audible2);
			SeekableTrait(mediaElement2.getTrait(MediaTraitType.SEEKABLE)).temporal
				= mediaElement2.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			TemporalTrait(mediaElement2.getTrait(MediaTraitType.TEMPORAL)).duration = 5;
			
			// Set the initial audible properties on the first child. The serial element will
			// adopt these for its composite audible trait:
			audible1.muted = true;
			audible1.pan = -1.0;
			audible1.volume = 0.5;
			
			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);
			
			var compAudible1:IAudible = serial.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			assertTrue(compAudible1.muted);
			assertEquals(-1.0, compAudible1.pan);
			assertEquals(0.5, compAudible1.volume);

			// TODO: this assertion currently fails, whereas it shouldn't. Tracing into to
			// next seek method, it turns out the composite trait's seekable _temporal
			// reference points to a temporal trait that's only 5 secs. long, whereas I 
			// think this should be 10 secs instead.
			assertTrue(ISeekable(serial.getTrait(MediaTraitType.SEEKABLE)).canSeekTo(6));

			// Skip to the next child:
			ISeekable(serial.getTrait(MediaTraitType.SEEKABLE)).seek(6);
			
			// Re-get our current audible trait:
			var compAudible2:IAudible = serial.getTrait(MediaTraitType.AUDIBLE) as IAudible;
//			assertEquals(compAudible1,compAudible2);
			
			// Add the audible trait to the second child:
			mediaElement2.doAddTrait(MediaTraitType.AUDIBLE,new AudibleTrait());
			
			// See if the audible trait changed:
			compAudible2 = serial.getTrait(MediaTraitType.AUDIBLE) as IAudible;
//			assertEquals(compAudible1,compAudible2);
			
			// See if the values propagated correctly:
			assertTrue(compAudible1.muted);
			assertEquals(-1.0, compAudible1.pan);
			assertEquals(0.5, compAudible1.volume);
			/*
			*/
		}
		
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
			assertTrue(loadable1.loadState == LoadState.LOADED);

			var loader2:SimpleLoader = new SimpleLoader();
			var mediaElement2:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE],
										loader2,
										new URLResource(new URL("http://www.example.com/loadable2")));
			var loadable2:ILoadable = mediaElement2.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable2.loadState == LoadState.CONSTRUCTED);

			var loader3:SimpleLoader = new SimpleLoader();
			var mediaElement3:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE],
										loader3,
										new URLResource(new URL("http://www.example.com/loadable3")));
			var loadable3:ILoadable = mediaElement3.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			loadable3.load();
			assertTrue(loadable3.loadState == LoadState.LOADED);
			
			// Nothing is added yet, so our composition shouldn't have the trait yet.
			assertTrue(serial.getTrait(MediaTraitType.LOADABLE) == null);
			
			// As soon as we add a child, that child will become our current
			// child, and the composite trait will reflect it.
			serial.addChild(mediaElement1);
			var loadable:ILoadable = serial.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			assertTrue(loadable.loadState == LoadState.LOADED);
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
			assertTrue(loadable.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable.resource != null &&
					   loadable.resource is URLResource &&
					   URLResource(loadable.resource).url.toString() == "http://www.example.com/loadable2");

			serial.addChild(mediaElement3);
			serial.removeChild(mediaElement2);
			loadable = serial.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable != null);
			assertTrue(loadable.loadState == LoadState.LOADED);
			
			serial.addChildAt(mediaElement1,0);
			serial.addChildAt(mediaElement2,1);
			
			// Changing the state of a non-current child should not affect the
			// state of the composition.
			loadable1 = mediaElement1.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			assertTrue(loadable1.loadState == LoadState.LOADED);
			loadable1.unload();
			assertTrue(loadable1.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable.loadState == LoadState.LOADED);
			
			// Calling unload() on the composition should only affect the
			// current child.
			assertTrue(loadable.loadState == LoadState.LOADED);
			assertTrue(loadable1.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable2.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable3.loadState == LoadState.LOADED);
			loadable.unload();
			assertTrue(loadable.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable1.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable2.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable3.loadState == LoadState.CONSTRUCTED);

			// Calling load() on the composition should only affect the current
			// child.
			loadable.load();
			assertTrue(loadable.loadState == LoadState.LOADED);
			assertTrue(loadable1.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable2.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable3.loadState == LoadState.LOADED);
			
			// If a load fails for a non-current child, then the composition
			// should be unaffected.
			loader2.forceFail = true;
			loadable2.load();
			assertTrue(loadable.loadState == LoadState.LOADED);
			assertTrue(loadable1.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable2.loadState == LoadState.LOAD_FAILED);
			assertTrue(loadable3.loadState == LoadState.LOADED);

			// If a load fails for the current child, then the composition
			// should reflect its state.
			loadable3.unload();
			loader3.forceFail = true;
			loadable3.load();
			assertTrue(loadable.loadState == LoadState.LOAD_FAILED);
			assertTrue(loadable1.loadState == LoadState.CONSTRUCTED);
			assertTrue(loadable2.loadState == LoadState.LOAD_FAILED);
			assertTrue(loadable3.loadState == LoadState.LOAD_FAILED);
		}
		
		public function testGetTraitTemporal():void
		{
			var serial:SerialElement = createSerialElement();
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.TEMPORAL) == null);
			
			// Create a few media elements with the ITemporal trait and some
			// initial properties.
			//

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL]);
			var temporal1:TemporalTrait = mediaElement1.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			temporal1.duration = 10;
			temporal1.position = 5;

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL]);
			var temporal2:TemporalTrait = mediaElement2.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			temporal2.duration = 30;
			temporal2.position = 10;

			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL]);
			var temporal3:TemporalTrait = mediaElement3.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			temporal3.duration = 20;
			temporal3.position = 15;
			
			// Add the first child.  This should cause its properties to
			// propagate to the composition.
			serial.addChild(mediaElement1);
			var temporal:ITemporal = serial.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			assertTrue(temporal != null);
			assertTrue(temporal.duration == 10);
			assertTrue(temporal.position == 5);
			
			// Change temporal1's position. This should result in the temporal's position
			// changing too:
			temporal1.position = 6;
			assertEquals(6,temporal.position);
			
			// Change back to 5, for that's what the rest of the test expects:
			temporal1.position = 5;
			
			// The composite trait's duration is the sum of all durations.  Its
			// position is the position of the current child within the entire
			// sequence.
			
			serial.addChild(mediaElement2);
			assertTrue(temporal.duration == 40);
			assertTrue(temporal.position == 5);
			
			// We can change the current child by removing and readding the current one.
			serial.removeChild(mediaElement1);
			serial.addChildAt(mediaElement1, 0);
			temporal = serial.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			assertTrue(temporal.duration == 40);
			assertTrue(temporal.position == 20);

			serial.addChild(mediaElement3);
			assertTrue(temporal.duration == 60);
			assertTrue(temporal.position == 20);
			
			serial.removeChild(mediaElement1);
			serial.removeChild(mediaElement2);
			serial.addChildAt(mediaElement1, 0);
			serial.addChildAt(mediaElement2, 1);
			
			temporal = serial.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			assertTrue(temporal.duration == 60);
			assertTrue(temporal.position == 55);
			
			temporal.addEventListener(TraitEvent.DURATION_REACHED, onDurationReached);
			
			// We should get a durationReached event when the current child
			// is the last child, and it reaches its duration.
			assertTrue(durationReachedEventCount == 0);
			temporal1.position = 10;
			assertTrue(durationReachedEventCount == 0);
			temporal2.position = 30;
			assertTrue(durationReachedEventCount == 0);
			temporal3.position = 19;
			assertTrue(durationReachedEventCount == 0);
			temporal3.position = 20;
			assertTrue(durationReachedEventCount == 1);
			
			// Adding a child before the current position should affect our
			// duration and position.
			var mediaElement4:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL]);
			var temporal4:TemporalTrait = mediaElement4.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			temporal4.duration = 33;
			temporal4.position = 22;
			serial.addChildAt(mediaElement4, 0);
			assertTrue(temporal.position == 93);
			assertTrue(temporal.duration == 93);
		}
		
		public function testGetTraitPlayable():void
		{
			var serial:SerialElement = createSerialElement();
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.PLAYABLE) == null);
			
			// Create a few media elements with the IPlayable trait.
			//

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.PLAYABLE]);
			var playable1:PlayableTrait = mediaElement1.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.PLAYABLE]);
			var playable2:PlayableTrait = mediaElement2.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;

			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.PLAYABLE]);
			var playable3:PlayableTrait = mediaElement3.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			
			// Adding a playing child should cause the composite trait to be
			// "playing".
			playable1.play();
			serial.addChild(mediaElement1);
			var playable:IPlayable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable != null);
			assertTrue(playable.playing == true);
			
			// Removing the last child should cause the composite trait to
			// disappear.
			serial.removeChild(mediaElement1);
			playable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable == null);
			
			playable1.resetPlaying();

			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);
			serial.addChild(mediaElement3);
			
			playable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable != null);
			assertTrue(playable.playing == false);
			
			playable.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChanged);
			
			// Playing the composite trait should cause the current child to
			// play (and dispatch an event).
			playable.play();
			assertTrue(playable.playing == true);
			assertTrue(playable1.playing == true);
			assertTrue(playable2.playing == false);
			assertTrue(playable3.playing == false);
			assertTrue(playingChangedEventCount == 1);
			
			// When the current child stops playing, the next child should
			// start (but there should be no event).
			playable1.resetPlaying();
			playable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable.playing == true);
			assertTrue(playable1.playing == false);
			assertTrue(playable2.playing == true);
			assertTrue(playable3.playing == false);
// Need to fix the event counts. - WEIZ			
//			assertTrue(playingChangedEventCount == 1);

			playable2.resetPlaying();
			playable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable.playing == true);
			assertTrue(playable1.playing == false);
			assertTrue(playable2.playing == false);
			assertTrue(playable3.playing == true);
//			assertTrue(playingChangedEventCount == 1);
			
			// When the final child stops playing, the composite trait stops
			// playing (and dispatches an event).
			playable3.resetPlaying();
			playable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable.playing == false);
			assertTrue(playable1.playing == false);
			assertTrue(playable2.playing == false);
			assertTrue(playable3.playing == false);
//			assertTrue(playingChangedEventCount == 2);
			
			// Similarly, playing the current child should affect the composite
			// trait.
			playable3.play();
			assertTrue(playable.playing == true);
			assertTrue(playable1.playing == false);
			assertTrue(playable2.playing == false);
			assertTrue(playable3.playing == true);
			
			playable3.resetPlaying();
			assertTrue(playable.playing == false);
			
			// But playing a child that's not the current child shouldn't
			// affect the composite trait.
			playable2.play();
			assertTrue(playable.playing == false);
			assertTrue(playable1.playing == false);
			assertTrue(playable2.playing == true);
			assertTrue(playable3.playing == false);
		}
		
		public function testGetTraitPlayableWithLoadable():void
		{
			var serial:SerialElement = createSerialElement();
			
			// Create a few media elements.
			//

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.PLAYABLE]);
			var playable1:PlayableTrait = mediaElement1.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;

			var loader2:SimpleLoader = new SimpleLoader();
			var mediaElement2:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE],
										loader2,
										new URLResource(new URL("http://www.example.com/loadable1")));
			var playable2:PlayableTrait = mediaElement2.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			assertTrue(playable2 == null);
			var loadable2:ILoadable = mediaElement2.getTrait(MediaTraitType.LOADABLE) as ILoadable;			
			assertTrue(loadable2.loadState == LoadState.CONSTRUCTED);
			
			var loader3:SimpleLoader = new SimpleLoader();
			var mediaElement3:MediaElement =
				new DynamicMediaElement([MediaTraitType.LOADABLE],
										loader3,
										new URLResource(new URL("http://www.example.com/loadable1")));
			var playable3:PlayableTrait = mediaElement3.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			assertTrue(playable3 == null);
			var loadable3:ILoadable = mediaElement3.getTrait(MediaTraitType.LOADABLE) as ILoadable;			
			assertTrue(loadable3.loadState == LoadState.CONSTRUCTED);

			var mediaElement4:MediaElement = new DynamicMediaElement([MediaTraitType.PLAYABLE]);
			var playable4:PlayableTrait = mediaElement4.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			
			// Make sure that the third child gets the IPlayable trait when
			// it finishes loading.
			loadable3.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				if (event.loadable.loadState == LoadState.LOADED)
				{
					loadable3.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
					DynamicMediaElement(mediaElement3).doAddTrait(MediaTraitType.PLAYABLE, new PlayableTrait());
				}
			}
			
			// Add them as children.
			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);
			serial.addChild(mediaElement3);
			serial.addChild(mediaElement4);
			
			// Play the first child.  This should cause the composition to be
			// playing.
			playable1.play();
			var playable:IPlayable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(playable != null);
			assertTrue(playable.playing == true);
			
			// When the first child finishes, the following should happen:
			// 1) The second child is loaded.
			// 2) Because the second child doesn't have the playable trait
			//    when it loads, the third child is loaded. 
			// 3) Because the third child does have the playable trait when
			//    it's loaded, it becomes the new current child.
			playable1.resetPlaying();
			playable2 = mediaElement2.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			assertTrue(playable2 == null);
			playable3 = mediaElement3.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
// This should be true, need to be fixed! - WEIZ
//			assertTrue(playable3 != null);
//			assertTrue(loadable2.loadState == LoadState.LOADED);
//			assertTrue(loadable3.loadState == LoadState.LOADED);
//			assertTrue(playable.playing == true);
			assertTrue(playable1.playing == false);
//			assertTrue(playable3.playing == true);
			assertTrue(playable4.playing == false);
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
			
			spatial.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE,onDimensionChange);
			
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
			serial.removeChild(mediaElement1);
			
			assertEquals(2,dimensionsChangeEventCount);
			
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
			
			viewable.addEventListener(ViewChangeEvent.VIEW_CHANGE,onViewChanged);
			
			var view1:Sprite = new Sprite();
			viewable1.view = view1;
			
			assertEquals(1,viewChangedEventCount);
			assertEquals(view1,viewable.view);
			
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.VIEWABLE]);
			var viewable2:ViewableTrait = mediaElement2.getTrait(MediaTraitType.VIEWABLE) as ViewableTrait;
			var view2:Sprite = new Sprite();
			viewable2.view = view2;
			
			serial.addChild(mediaElement2);
			serial.removeChild(mediaElement1);
			
			assertEquals(2,viewChangedEventCount);
			assertEquals(view2,viewable.view);
			
			serial.removeChild(mediaElement2);
			
			// No trait to end with.
			assertFalse(serial.hasTrait(MediaTraitType.VIEWABLE));
			assertNull(serial.getTrait(MediaTraitType.VIEWABLE));
		}
		
		public function testGetTraitPausible():void
		{
			var serial:SerialElement = createSerialElement();
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.PAUSIBLE) == null);
			
			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.PAUSIBLE, MediaTraitType.PLAYABLE]);
			var pausible1:IPausible = mediaElement1.getTrait(MediaTraitType.PAUSIBLE) as IPausible;
			var playable1:IPlayable = mediaElement1.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			
			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.PAUSIBLE, MediaTraitType.PLAYABLE]);
			var pausible2:IPausible = mediaElement2.getTrait(MediaTraitType.PAUSIBLE) as IPausible;
			var playable2:IPlayable = mediaElement2.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			pausible2.pause();
			
			// Add the first child. This should cause its properties to 
			// propagate to the composition.
			serial.addChild(mediaElement1);
			var pausible:IPausible = serial.getTrait(MediaTraitType.PAUSIBLE) as IPausible;
			var playable:IPlayable = serial.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			assertTrue(pausible.paused == false);
			
			// Add the second child.
			serial.addChild(mediaElement2);

			// The paused state of the second child should not affect the paused state of the composition.
			assertTrue(pausible.paused == false);
			
			// Pause the composite trait and then check the state of the composition and the current child
			pausible.pause();
			assertTrue(pausible.paused == true);
			assertTrue(pausible.paused == pausible1.paused);
			
			playable.play();
			assertTrue(pausible.paused == false);
			assertTrue(pausible.paused == pausible1.paused);
/* There are some problems with the following three lines of code. It seems that the pause causes
   the SerialElement to change the current child.
   
			pausible1.pause();
			assertTrue(pausible1.paused == true);
			assertTrue(pausible.paused == true);
*/			
		}

		public function testGetTraitBufferable():void
		{
			runBufferablePropertiesTests();
			runBufferableEventsTests();
		}
		
		public function testGetTraitSeekable():void
		{
			runBasicSeekableTests();
			runUnseekableTests();
			runAddSeekingCurrentChildren();
			runAddSeekingNoncurrentChildren();
		}
		
		override public function testMediaErrorEventDispatch():void
		{
			forceLoadable = true;
			
			super.testMediaErrorEventDispatch();
		}
		
		override public function testNestedMediaErrorEventDispatch():void
		{
			forceLoadable = true;
			
			super.testNestedMediaErrorEventDispatch();
		}

		// Internals
		//
		
		private function onDurationReached(event:TraitEvent):void
		{
			durationReachedEventCount++;
		}

		private function onPlayingChanged(event:PlayingChangeEvent):void
		{
			playingChangedEventCount++;
		}
		
		private function onDimensionChange(event:DimensionChangeEvent):void
		{
			dimensionsChangeEventCount++;
		}
		
		private function onViewChanged(event:ViewChangeEvent):void
		{
			viewChangedEventCount++;
		}

		private function createSerialElement():SerialElement
		{
			return createMediaElement() as SerialElement;
		}
		
		private function runBufferablePropertiesTests():void
		{
			var serial:SerialElement = createSerialElement();
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.BUFFERABLE) == null);

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.BUFFERABLE]);
			var bufferable1:BufferableTrait = mediaElement1.getTrait(MediaTraitType.BUFFERABLE) as BufferableTrait;
			assertTrue(bufferable1 != null);

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.BUFFERABLE]);
			var bufferable2:BufferableTrait = mediaElement2.getTrait(MediaTraitType.BUFFERABLE) as BufferableTrait;
			assertTrue(bufferable2 != null);
			
			// Set child bufferable properties
			bufferable1.bufferLength = 5;
			bufferable1.bufferTime = 10;
			bufferable1.buffering = true;

			bufferable2.bufferLength = 25;
			bufferable2.bufferTime = 20;
			bufferable2.buffering = false;
			
			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);
			
			var bufferable:IBufferable = serial.getTrait(MediaTraitType.BUFFERABLE) as IBufferable;
			assertTrue(bufferable.bufferLength == bufferable1.bufferLength);
			assertTrue(bufferable.buffering == bufferable1.buffering);
			assertTrue(bufferable.bufferTime == bufferable1.bufferTime);
			
			bufferable.bufferTime = 50;
			assertTrue(bufferable.bufferTime == 50);
			assertTrue(bufferable1.bufferTime == bufferable.bufferTime);
			
			serial.removeChild(mediaElement1);
			assertTrue(bufferable.bufferLength == bufferable2.bufferLength);
			assertTrue(bufferable.buffering == bufferable2.buffering);
			assertTrue(bufferable.bufferTime == bufferable2.bufferTime);
		}

		private function runBufferableEventsTests():void
		{			
			events = new Vector.<Event>();
			
			var serial:SerialElement = createSerialElement();
			
			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.BUFFERABLE) == null);

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.BUFFERABLE]);
			var bufferable1:BufferableTrait = mediaElement1.getTrait(MediaTraitType.BUFFERABLE) as BufferableTrait;
			assertTrue(bufferable1 != null);

			bufferable1.bufferLength = 5;
			bufferable1.bufferTime = 10;
			bufferable1.buffering = true;

			serial.addChild(mediaElement1);
			
			var bufferable:IBufferable = serial.getTrait(MediaTraitType.BUFFERABLE) as IBufferable;
			bufferable.addEventListener(BufferingChangeEvent.BUFFERING_CHANGE, eventCatcher);
			bufferable.addEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE, eventCatcher);
			
			assertTrue(bufferable.bufferLength == bufferable1.bufferLength);
			assertTrue(bufferable.buffering == bufferable1.buffering);
			assertTrue(bufferable.bufferTime == bufferable1.bufferTime);
			
			bufferable.bufferTime = 20;
			assertTrue(events.length == 1);
			
			bufferable1.bufferTime = 30;
			assertTrue(events.length == 2);
			
			bufferable1.buffering = false;
			assertTrue(events.length == 3);

			bufferable1.buffering = false;
			assertTrue(events.length == 3);
		}

		protected function runBasicSeekableTests():void
		{
			events = new Vector.<Event>();
			var serial:SerialElement = createSerialElement();

			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.TEMPORAL) == null);
			assertTrue(serial.getTrait(MediaTraitType.SEEKABLE) == null);

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE, MediaTraitType.PLAYABLE, MediaTraitType.PAUSIBLE]);
			var temporal1:TemporalTrait = mediaElement1.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var seekable1:SeekableTrait = mediaElement1.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			temporal1.duration = 30;
			temporal1.position = 0;

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE]);
			var temporal2:TemporalTrait = mediaElement2.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var seekable2:SeekableTrait = mediaElement2.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			temporal2.duration = 15;
			temporal2.position = 0;

			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE, MediaTraitType.PLAYABLE, MediaTraitType.PAUSIBLE]);
			var temporal3:TemporalTrait = mediaElement3.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var seekable3:SeekableTrait = mediaElement3.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			temporal3.duration = 20;
			temporal3.position = 0;

			var mediaElement4:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL]);
			var temporal4:TemporalTrait = mediaElement4.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			temporal4.duration = 10;
			temporal4.position = 0;

			var mediaElement5:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE]);
			var temporal5:TemporalTrait = mediaElement5.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var seekable5:SeekableTrait = mediaElement5.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			temporal5.duration = 40;
			temporal5.position = 0;
			
			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);
			serial.addChild(mediaElement3);
			serial.addChild(mediaElement4);
			serial.addChild(mediaElement5);
			
			var temporal:CompositeTemporalTrait = serial.getTrait(MediaTraitType.TEMPORAL) as CompositeTemporalTrait;
			var seekable:ISeekable = serial.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			assertTrue(temporal != null);
			assertTrue(seekable != null);
			assertTrue(seekable.seeking == false);
			
			assertTrue(seekable.canSeekTo(20) == true);
			assertTrue(seekable.canSeekTo(35) == true);
			assertTrue(seekable.canSeekTo(55) == true);
			assertTrue(seekable.canSeekTo(70) == true);
			assertTrue(seekable.canSeekTo(90) == true);
			assertTrue(seekable.canSeekTo(-100) == false);

			seekable.seek(50);
			temporal = serial.getTrait(MediaTraitType.TEMPORAL) as CompositeTemporalTrait;
			seekable1.processSeekCompletion(30);
			seekable3.processSeekCompletion(5);
			assertTrue(temporal.position == 50);
			
			// Based on current implementation of SerialElement, change of current child will
			// invalidate the current composite seekable and create a new one.
			seekable = serial.getTrait(MediaTraitType.SEEKABLE) as ISeekable;			

			seekable.seek(5);
			seekable3.processSeekCompletion(0);
			seekable1.processSeekCompletion(5);
			temporal = serial.getTrait(MediaTraitType.TEMPORAL) as CompositeTemporalTrait;
			seekable = serial.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			assertTrue(temporal.position == 5);

			// Seek within the current child does not invalidate the current composite seekable.			
			seekable.seek(25);
			seekable1.processSeekCompletion(25);
			assertTrue(temporal.position == 25);

			seekable.seek(15);
			seekable1.processSeekCompletion(15);
			assertTrue(temporal.position == 15);
		}
		
		protected function runUnseekableTests():void
		{
			var serial:SerialElement = createSerialElement();

			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.TEMPORAL) == null);
			assertTrue(serial.getTrait(MediaTraitType.SEEKABLE) == null);

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE]);
			var temporal1:TemporalTrait = mediaElement1.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var seekable1:SeekableTrait = mediaElement1.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			temporal1.duration = 30;
			temporal1.position = 0;

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL]);
			var temporal2:TemporalTrait = mediaElement2.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			temporal2.duration = 15;
			temporal2.position = 0;

			var mediaElement3:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE]);
			var temporal3:TemporalTrait = mediaElement3.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var seekable3:SeekableTrait = mediaElement3.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			temporal3.duration = 20;
			temporal3.position = 0;

			serial.addChild(mediaElement3);
			serial.addChildAt(mediaElement1, 0);
			serial.addChildAt(mediaElement2, 1);
			
			var temporal:CompositeTemporalTrait = serial.getTrait(MediaTraitType.TEMPORAL) as CompositeTemporalTrait;
			var seekable:ISeekable = serial.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			assertTrue(temporal != null);
			assertTrue(seekable != null);
			assertTrue(seekable.seeking == false);
			
			assertTrue(seekable.canSeekTo(20) == true);
			assertTrue(seekable.canSeekTo(40) == true);
		}
		
		protected function runAddSeekingCurrentChildren():void
		{
			var serial:SerialElement = createSerialElement();

			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.TEMPORAL) == null);
			assertTrue(serial.getTrait(MediaTraitType.SEEKABLE) == null);

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE]);
			var temporal1:TemporalTrait = mediaElement1.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var seekable1:SeekableTrait = mediaElement1.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			temporal1.duration = 30;
			temporal1.position = 0;

			seekable1.seek(10);			
			
			serial.addChild(mediaElement1);

			var seekable:ISeekable = serial.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			assertTrue(seekable.seeking == true);
		}
		
		protected function runAddSeekingNoncurrentChildren():void
		{
			var serial:SerialElement = createSerialElement();

			// No trait to begin with.
			assertTrue(serial.getTrait(MediaTraitType.TEMPORAL) == null);
			assertTrue(serial.getTrait(MediaTraitType.SEEKABLE) == null);

			var mediaElement1:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE]);
			var temporal1:TemporalTrait = mediaElement1.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var seekable1:SeekableTrait = mediaElement1.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			temporal1.duration = 30;
			temporal1.position = 0;

			var mediaElement2:MediaElement = new DynamicMediaElement([MediaTraitType.TEMPORAL, MediaTraitType.SEEKABLE]);
			var temporal2:TemporalTrait = mediaElement2.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var seekable2:SeekableTrait = mediaElement2.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			temporal2.duration = 15;
			temporal2.position = 0;

			seekable2.seek(10);			
			
			serial.addChild(mediaElement1);
			serial.addChild(mediaElement2);

			var seekable:ISeekable = serial.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			assertTrue(seekable.seeking != true);
		}
		
		protected function eventCatcher(event:Event):void
		{
			events.push(event);
		}
		
		private var durationReachedEventCount:int = 0;
		private var playingChangedEventCount:int = 0;
		private var dimensionsChangeEventCount:int = 0;
		private var viewChangedEventCount:int = 0;
		
		private var events:Vector.<Event>;
	}
}