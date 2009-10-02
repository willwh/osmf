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
package org.osmf.media
{
	import org.osmf.events.TraitsChangeEvent;
	import org.osmf.traits.AudibleTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.NullResource;

	public class TestMediaElementAsSubclass extends TestMediaElement
	{
		// Overrides
		//
		
		override public function setUp():void
		{
			super.setUp();
			
			traitAddEventCount = 0;
			traitRemoveEventCount = 0;
		}
		
		override protected function createMediaElement():MediaElement
		{
			return new DynamicMediaElement(); 
		}
		
		override protected function get loadable():Boolean
		{
			return false;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return new NullResource();
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [];
		}
		
		// Tests
		//
		
		public function testAddTrait():void
		{
			var mediaElement:DynamicMediaElement = createMediaElement() as DynamicMediaElement;
			mediaElement.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
			mediaElement.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
			
			assertTrue(traitAddEventCount == 0);
			
			assertTrue(mediaElement.hasTrait(MediaTraitType.AUDIBLE) == false);
			mediaElement.doAddTrait(MediaTraitType.AUDIBLE, new AudibleTrait());
			assertTrue(mediaElement.hasTrait(MediaTraitType.AUDIBLE) == true);
			
			assertTrue(traitAddEventCount == 1);
			
			// Now check a bunch of error cases.
			//
			
			// Duplicate trait.
			try
			{
				mediaElement.doAddTrait(MediaTraitType.AUDIBLE, new AudibleTrait());
				
				fail();
			}
			catch (error:ArgumentError)
			{
				assertTrue(traitAddEventCount == 1);
			}

			// Null trait type:
			try
			{
				mediaElement.doAddTrait(null, new AudibleTrait());
				
				fail();
			}
			catch (error:ArgumentError)
			{
				assertTrue(traitAddEventCount == 1);
			}
			
			// Null trait:
			try
			{
				mediaElement.doAddTrait(MediaTraitType.AUDIBLE, null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
				assertTrue(traitAddEventCount == 1);
			}

			// Mismatched trait and trait type:
			try
			{
				mediaElement.doAddTrait(MediaTraitType.LOADABLE, new AudibleTrait());
				
				fail();
			}
			catch (error:ArgumentError)
			{
				assertTrue(traitAddEventCount == 1);
			}
		}
		
		public function testRemoveTrait():void
		{
			var mediaElement:DynamicMediaElement = createMediaElement() as DynamicMediaElement;
			mediaElement.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
			mediaElement.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
			
			assertTrue(traitRemoveEventCount == 0);
			
			assertTrue(mediaElement.hasTrait(MediaTraitType.AUDIBLE) == false);
			mediaElement.doAddTrait(MediaTraitType.AUDIBLE, new AudibleTrait());
			assertTrue(mediaElement.hasTrait(MediaTraitType.AUDIBLE) == true);
			
			assertTrue(traitRemoveEventCount == 0);
			
			mediaElement.doRemoveTrait(MediaTraitType.AUDIBLE);
			assertTrue(mediaElement.hasTrait(MediaTraitType.AUDIBLE) == false);
			
			assertTrue(traitRemoveEventCount == 1);
			
			// Removing a non-existent trait is a no-op.
			mediaElement.doRemoveTrait(MediaTraitType.AUDIBLE);
			assertTrue(traitRemoveEventCount == 1);
			
			// A null trait type is an error case.
			try
			{
				mediaElement.doRemoveTrait(null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
				assertTrue(traitRemoveEventCount == 1);
			}
		}
		
		// Internals
		//
		
		private function onTraitAdd(event:TraitsChangeEvent):void
		{
			traitAddEventCount++;
		}

		private function onTraitRemove(event:TraitsChangeEvent):void
		{
			traitRemoveEventCount++;
		}
		
		private var traitAddEventCount:int = 0;
		private var traitRemoveEventCount:int = 0;
	}
}