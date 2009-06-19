/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.media
{
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.traits.AudibleTrait;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.NullResource;

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