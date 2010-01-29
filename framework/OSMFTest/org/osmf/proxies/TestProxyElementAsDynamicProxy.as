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
package org.osmf.proxies
{
	import org.osmf.events.MediaElementEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.BufferTrait;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.DynamicProxyElement;
	import org.osmf.utils.SimpleLoader;

	public class TestProxyElementAsDynamicProxy extends TestProxyElement
	{
		public function testBlockedTraits():void
		{
			var wrappedElement:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.TIME, MediaTraitType.LOAD]
										 , new SimpleLoader()
										 );

			var proxyElement:DynamicProxyElement = new DynamicProxyElement(wrappedElement);
			proxyElement.doBlockTrait(MediaTraitType.PLAY);
			proxyElement.doBlockTrait(MediaTraitType.LOAD);
			
			// The proxy blocks LOAD.
			//
			
			assertFalse(proxyElement.hasTrait(MediaTraitType.PLAY));
			assertFalse(proxyElement.hasTrait(MediaTraitType.LOAD));
			assertTrue(proxyElement.hasTrait(MediaTraitType.TIME));

			assertTrue(wrappedElement.hasTrait(MediaTraitType.LOAD));
			assertTrue(wrappedElement.getTrait(MediaTraitType.LOAD) != null);

			// TIME, LOAD
			assertTrue(wrappedElement.traitTypes.length == 2);
			
			// TIME
			assertTrue(proxyElement.traitTypes.length == 1);
						
			// If we now replace the wrapped element, then the traits of the
			// wrapped element should be reflected in the proxy's traits,
			// though the blocked traits should remain the same.
			//
			
			var proxiedElement2:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.PLAY, MediaTraitType.SEEK, MediaTraitType.LOAD]
										 , new SimpleLoader()
										 );

			proxyElement.proxiedElement = proxiedElement2;

			assertFalse(proxyElement.hasTrait(MediaTraitType.PLAY));
			assertTrue(proxyElement.hasTrait(MediaTraitType.SEEK));
			assertFalse(proxyElement.hasTrait(MediaTraitType.LOAD));
			assertFalse(proxyElement.hasTrait(MediaTraitType.TIME));
		}
		
		public function testOverriddenTraits():void
		{
			var wrappedElement:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.TIME, MediaTraitType.LOAD]
										 , new SimpleLoader()
										 );

			var overriddenTimeTrait:TimeTrait = new TimeTrait();
			var proxyElement:DynamicProxyElement = new DynamicProxyElement(wrappedElement);
			
			// Override PLAY and TIME.
			proxyElement.doAddTrait(MediaTraitType.PLAY, new PlayTrait());
			proxyElement.doAddTrait(MediaTraitType.TIME, overriddenTimeTrait);
			
			assertTrue(proxyElement.hasTrait(MediaTraitType.PLAY));
			assertTrue(proxyElement.hasTrait(MediaTraitType.LOAD));
			assertTrue(proxyElement.hasTrait(MediaTraitType.TIME));
			
			assertTrue(proxyElement.getTrait(MediaTraitType.TIME) == overriddenTimeTrait);

			// If we now replace the wrapped element, then the proxy should no
			// longer have the same overridden traits.  (Why?  Changing the
			// wrapped element first causes all overridden traits to be
			// removed, so that we can readd the overridden traits once our new
			// wrapped element is present, just in case the logic of readding
			// them needs to take the wrapped element into account.  Typically
			// overriding traits is the province of a ProxyElement subclass,
			// but in this test case we add them externally through the
			// doAddTrait helper function.  As a result, the overridden traits
			// won't be readded since we don't call doAddTrait again.)
			//
			
			var proxiedElement2:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.PLAY, MediaTraitType.TIME, MediaTraitType.LOAD]
										 , new SimpleLoader()
										 );

			proxyElement.proxiedElement = proxiedElement2;

			assertTrue(proxyElement.hasTrait(MediaTraitType.PLAY));
			assertTrue(proxyElement.hasTrait(MediaTraitType.LOAD));
			assertTrue(proxyElement.hasTrait(MediaTraitType.TIME));
			
			// The TimeTrait should now come from the wrapped element,
			// not the proxy.
			assertTrue(proxyElement.getTrait(MediaTraitType.TIME) != overriddenTimeTrait);
			assertTrue(proxyElement.getTrait(MediaTraitType.TIME) == proxiedElement2.getTrait(MediaTraitType.TIME));
		}
		
		public function testDispatchEvent():void
		{
			// Wrap up a temporal element, but override the TimeTrait
			// and block the PlayTrait.
			//
			
			var wrappedElement:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.TIME, MediaTraitType.LOAD]
										 , new SimpleLoader()
										 );

			var proxyElement:DynamicProxyElement = new DynamicProxyElement(wrappedElement);
			proxyElement.doBlockTrait(MediaTraitType.PLAY);

			var timeTrait:TimeTrait = new TimeTrait(30);
			proxyElement.doAddTrait(MediaTraitType.TIME, timeTrait);

			proxyElement.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
			proxyElement.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);

			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			
			// If the TimeTrait is added or removed on the wrapped
			// element, we shouldn't get any events.
			wrappedElement.doRemoveTrait(MediaTraitType.TIME);
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			wrappedElement.doAddTrait(MediaTraitType.TIME, new TimeTrait());
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			
			// Similarly, if we add or remove a trait to the wrapped element
			// which the proxy blocks, then we shouldn't get any events.
			wrappedElement.doAddTrait(MediaTraitType.PLAY, new PlayTrait());
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			wrappedElement.doRemoveTrait(MediaTraitType.PLAY);
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);

			// But if our proxy doesn't have an override for a trait or
			// block a trait, then we should get events.
			wrappedElement.doAddTrait(MediaTraitType.SEEK, new SeekTrait(timeTrait));
			assertTrue(traitAddEventCount == 1);
			assertTrue(traitRemoveEventCount == 0);
			wrappedElement.doRemoveTrait(MediaTraitType.SEEK);
			assertTrue(traitAddEventCount == 1);
			assertTrue(traitRemoveEventCount == 1);
			
			// If we add or remove a trait to the proxy which the wrapped
			// element already has, we should get no events.
			proxyElement.doAddTrait(MediaTraitType.LOAD, new LoadTrait(null,null));
			assertTrue(traitAddEventCount == 1);
			assertTrue(traitRemoveEventCount == 1);
			proxyElement.doRemoveTrait(MediaTraitType.LOAD);
			assertTrue(traitAddEventCount == 1);
			assertTrue(traitRemoveEventCount == 1);

			// But if we add or remove a trait to the proxy which the wrapped
			// element doesn't have, then we should get events.
			proxyElement.doAddTrait(MediaTraitType.BUFFER, new BufferTrait());
			assertTrue(traitAddEventCount == 2);
			assertTrue(traitRemoveEventCount == 1);
			proxyElement.doRemoveTrait(MediaTraitType.BUFFER);
			assertTrue(traitAddEventCount == 2);
			assertTrue(traitRemoveEventCount == 2);
			
			// Last, if we add or remove a trait to the proxy which the proxy
			// also blocks, then we should get events. 
			proxyElement.doAddTrait(MediaTraitType.PLAY, new PlayTrait());
			assertTrue(traitAddEventCount == 3);
			assertTrue(traitRemoveEventCount == 2);
			proxyElement.doRemoveTrait(MediaTraitType.PLAY);
			assertTrue(traitAddEventCount == 3);
			assertTrue(traitRemoveEventCount == 3);
		}
		
		// Overrides
		//

		override protected function createProxyElement():ProxyElement
		{
			return new DynamicProxyElement();
		}
		
		override protected function createMediaElement():MediaElement
		{
			return new DynamicProxyElement(new DynamicMediaElement(WRAPPED_TRAITS, new SimpleLoader()));
		}
		
		override public function setUp():void
		{
			super.setUp();
			
			traitAddEventCount = traitRemoveEventCount = 0;
		}

		override protected function get hasLoadTrait():Boolean
		{
			return true;
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return WRAPPED_TRAITS;
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return REFLECTED_TRAITS;
		}
		
		// Internals
		//
		
		private function onTraitAdd(event:MediaElementEvent):void
		{
			traitAddEventCount++;
		}

		private function onTraitRemove(event:MediaElementEvent):void
		{
			traitRemoveEventCount++;
		}
		
		private var traitAddEventCount:int;
		private var traitRemoveEventCount:int;
		
		private static const WRAPPED_TRAITS:Array =
					[ MediaTraitType.AUDIO
					, MediaTraitType.BUFFER
					, MediaTraitType.LOAD
					, MediaTraitType.PLAY
				    , MediaTraitType.DISPLAY_OBJECT
				    ];

		private static const REFLECTED_TRAITS:Array =
					[ MediaTraitType.AUDIO
					, MediaTraitType.BUFFER
					, MediaTraitType.LOAD
					, MediaTraitType.PLAY
				    , MediaTraitType.DISPLAY_OBJECT
				    ];
	}
}