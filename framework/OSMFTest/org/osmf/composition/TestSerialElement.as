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

		private function createSerialElement():SerialElement
		{
			return createMediaElement() as SerialElement;
		}
	}
}