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
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.TestMediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class TestCompositeElement extends TestMediaElement
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
			return new CompositeElement(); 
		}
		
		override protected function get loadable():Boolean
		{
			return false;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return new URLResource("http://www.example.com");
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [];
		}

		// Overridden because setting the resource on a composite is a no-op.
		override public function testSetResource():void
		{
			var mediaElement:MediaElement = createMediaElement();
			
			mediaElement.resource = resourceForMediaElement
			assertTrue(mediaElement.resource == null);
		}
		
		// Tests
		//

		public function testGetNumChildren():void
		{
			var composite:CompositeElement = createCompositeElement();
			
			assertTrue(composite.numChildren == 0);
			
			var mediaElement:MediaElement = new MediaElement();
			composite.addChild(mediaElement);
			
			assertTrue(composite.numChildren == 1);
		}

		public function testGetChildAt():void
		{
			var composite:CompositeElement = createCompositeElement();
			
			assertTrue(composite.getChildAt(-1) == null);
			assertTrue(composite.getChildAt(0) == null);
			assertTrue(composite.getChildAt(1) == null);
			
			var mediaElement1:MediaElement = new MediaElement();
			var mediaElement2:MediaElement = new MediaElement();
			composite.addChild(mediaElement1);
			composite.addChild(mediaElement2);
			
			assertTrue(composite.getChildAt(-1) == null);
			assertTrue(composite.getChildAt(0) == mediaElement1);
			assertTrue(composite.getChildAt(1) == mediaElement2);
		}
		
		public function testGetChildIndex():void
		{
			var composite:CompositeElement = createCompositeElement();

			var mediaElement1:MediaElement = new MediaElement();
			var mediaElement2:MediaElement = new MediaElement();
			
			assertTrue(composite.getChildIndex(null) == -1);
			assertTrue(composite.getChildIndex(mediaElement1) == -1);
			assertTrue(composite.getChildIndex(mediaElement2) == -1);
			
			composite.addChild(mediaElement1);
			composite.addChild(mediaElement2);
			
			assertTrue(composite.getChildIndex(null) == -1);
			assertTrue(composite.getChildIndex(mediaElement1) == 0);
			assertTrue(composite.getChildIndex(mediaElement2) == 1);
		}

		public function testAddChild():void
		{
			var composite:CompositeElement = createCompositeElement();

			var mediaElement1:MediaElement = new MediaElement();
			var mediaElement2:MediaElement = new MediaElement();

			assertTrue(composite.numChildren == 0);
			
			composite.addChild(mediaElement1);
			assertTrue(composite.numChildren == 1);
			
			// It's possible to add the same child twice.
			composite.addChild(mediaElement1);
			assertTrue(composite.numChildren == 2);
			
			// Adding a new child should place it at the end of the list.
			composite.addChild(mediaElement2);
			assertTrue(composite.numChildren == 3);
			assertTrue(composite.getChildAt(0) == mediaElement1);
			assertTrue(composite.getChildAt(1) == mediaElement1);
			assertTrue(composite.getChildAt(2) == mediaElement2);
			
			// Adding a null child should throw an error.
			try
			{
				composite.addChild(null);
				fail();
			}
			catch (e:ArgumentError)
			{
			}
		}
		
		public function testAddChildAt():void
		{
			var composite:CompositeElement = createCompositeElement();

			var mediaElement1:MediaElement = new MediaElement();
			var mediaElement2:MediaElement = new MediaElement();

			assertTrue(composite.numChildren == 0);
			
			composite.addChildAt(mediaElement1, 0);
			assertTrue(composite.numChildren == 1);
			
			// It's possible to add the same child twice.
			composite.addChildAt(mediaElement1, 1);
			assertTrue(composite.numChildren == 2);
			assertTrue(composite.getChildAt(0) == mediaElement1);
			assertTrue(composite.getChildAt(1) == mediaElement1);
			
			// We can add at any index.
			composite.addChildAt(mediaElement2, 1);
			assertTrue(composite.numChildren == 3);
			assertTrue(composite.getChildAt(0) == mediaElement1);
			assertTrue(composite.getChildAt(1) == mediaElement2);
			assertTrue(composite.getChildAt(2) == mediaElement1);
			
			// Adding a null child should throw an error.
			try
			{
				composite.addChildAt(null,0);
				fail();
			}
			catch (e:ArgumentError)
			{
			}

			// Adding a child at a negative index should throw an error.
			try
			{
				composite.addChildAt(mediaElement1,-1);
				fail();
			}
			catch (e:RangeError)
			{
			}
			
			// Adding a child at an index greater than the length should
			// throw an error.
			try
			{
				composite.addChildAt(mediaElement1,composite.numChildren+1);
				fail();
			}
			catch (e:RangeError)
			{
			}
		}

		public function testRemoveChild():void
		{
			var composite:CompositeElement = createCompositeElement();

			var mediaElement1:MediaElement = new MediaElement();
			var mediaElement2:MediaElement = new MediaElement();
			
			composite.addChild(mediaElement1);
			composite.addChild(mediaElement1);
			composite.addChild(mediaElement2);
			
			var result:MediaElement = composite.removeChild(mediaElement1);
			assertTrue(result == mediaElement1);
			assertTrue(composite.numChildren == 2);
			assertTrue(composite.getChildAt(0) == mediaElement1);
			assertTrue(composite.getChildAt(1) == mediaElement2);

			result = composite.removeChild(mediaElement2);
			assertTrue(result == mediaElement2);
			assertTrue(composite.numChildren == 1);
			assertTrue(composite.getChildAt(0) == mediaElement1);
			
			// Removing a child that's not in the composition should throw
			// an error.
			try
			{
				composite.removeChild(mediaElement2);
				fail();
			}
			catch (e:ArgumentError)
			{
			}

			// Removing a null child should throw an error.
			try
			{
				composite.removeChild(null);
				fail();
			}
			catch (e:ArgumentError)
			{
			}
		}
		
		public function testRemoveChildAt():void
		{
			var composite:CompositeElement = createCompositeElement();

			var mediaElement1:MediaElement = new MediaElement();
			var mediaElement2:MediaElement = new MediaElement();
			
			composite.addChild(mediaElement1);
			composite.addChild(mediaElement1);
			composite.addChild(mediaElement2);
			
			var result:MediaElement = composite.removeChildAt(1);
			assertTrue(result == mediaElement1);
			assertTrue(composite.numChildren == 2);
			assertTrue(composite.getChildAt(0) == mediaElement1);
			assertTrue(composite.getChildAt(1) == mediaElement2);

			result = composite.removeChildAt(1);
			assertTrue(result == mediaElement2);
			assertTrue(composite.numChildren == 1);
			assertTrue(composite.getChildAt(0) == mediaElement1);
			
			// Removing a child with a negative index should throw an error.
			try
			{
				composite.removeChildAt(-1);
				fail();
			}
			catch (e:RangeError)
			{
			}
			assertTrue(composite.numChildren == 1);

			// Removing a child with too large an index should throw an error.
			try
			{
				composite.removeChildAt(1);
				fail();
			}
			catch (e:RangeError)
			{
			}
		}
		
		// Protected
		//
		
		final protected function createCompositeElement():CompositeElement
		{
			return createMediaElement() as CompositeElement;
		}
		
		
		final protected function assertHasTraits(mediaElement:MediaElement,traitTypes:Array):void
		{
			// Create a separate list with the traits that should *not* exist
			// on the media element.
			var missingTraitTypes:Array = ALL_TRAIT_TYPES.concat();
			for each (var traitType:MediaTraitType in traitTypes)
			{
				missingTraitTypes.splice(missingTraitTypes.indexOf(traitType),1);
			}
			assertTrue(traitTypes.length + missingTraitTypes.length == ALL_TRAIT_TYPES.length);
			
			// Verify the ones that should exist do exist.
			for (var i:int = 0; i < traitTypes.length; i++)
			{
				assertTrue(mediaElement.hasTrait(traitTypes[i]) == true);
			}
			
			// Verify the ones that shouldn't exist don't exist.
			for (i = 0; i < missingTraitTypes.length; i++)
			{
				assertTrue(mediaElement.hasTrait(missingTraitTypes[i]) == false);
			}
		}
				
		final protected function onTraitAddRemoveEvent(event:TraitsChangeEvent):void
		{
			if (event.type == TraitsChangeEvent.TRAIT_ADD)
			{
				traitAddEventCount++;
			}
			else if (event.type == TraitsChangeEvent.TRAIT_REMOVE)
			{
				traitRemoveEventCount++;
			}
			else fail();
		}
		
		protected static const ALL_TRAIT_TYPES:Array = 
			[     MediaTraitType.AUDIBLE
				, MediaTraitType.BUFFERABLE
				, MediaTraitType.LOADABLE
				, MediaTraitType.PAUSIBLE
				, MediaTraitType.PLAYABLE
				, MediaTraitType.SEEKABLE
				, MediaTraitType.SPATIAL
				, MediaTraitType.TEMPORAL
				, MediaTraitType.VIEWABLE
			];

		protected var traitAddEventCount:int;
		protected var traitRemoveEventCount:int;
	}
}