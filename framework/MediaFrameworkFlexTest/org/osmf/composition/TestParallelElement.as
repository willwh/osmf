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
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.DynamicMediaElement;
	
	public class TestParallelElement extends TestCompositeElement
	{
		// Overrides
		//
		
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

		private function createParallelElement():ParallelElement
		{
			return createMediaElement() as ParallelElement;
		}
	}
}