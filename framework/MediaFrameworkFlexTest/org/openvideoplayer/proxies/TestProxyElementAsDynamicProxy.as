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
package org.openvideoplayer.proxies
{
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.PausableTrait;
	import org.openvideoplayer.traits.PlayableTrait;
	import org.openvideoplayer.traits.SeekableTrait;
	import org.openvideoplayer.traits.TemporalTrait;
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.DynamicProxyElement;
	import org.openvideoplayer.utils.SimpleLoader;

	public class TestProxyElementAsDynamicProxy extends TestProxyElement
	{
		public function testBlockedTraits():void
		{
			var wrappedElement:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.TEMPORAL, MediaTraitType.LOADABLE]
										 , new SimpleLoader()
										 );

			var proxyElement:DynamicProxyElement = new DynamicProxyElement(wrappedElement);
			proxyElement.doBlockTrait(MediaTraitType.PAUSABLE);
			proxyElement.doBlockTrait(MediaTraitType.LOADABLE);
			
			// The proxy blocks LOADABLE.
			//
			
			assertFalse(proxyElement.hasTrait(MediaTraitType.PLAYABLE));
			assertFalse(proxyElement.hasTrait(MediaTraitType.PAUSABLE));
			assertFalse(proxyElement.hasTrait(MediaTraitType.LOADABLE));
			assertTrue(proxyElement.hasTrait(MediaTraitType.TEMPORAL));

			assertTrue(wrappedElement.hasTrait(MediaTraitType.LOADABLE));
			assertTrue(wrappedElement.getTrait(MediaTraitType.LOADABLE) != null);

			// TEMPORAL, LOADABLE
			assertTrue(wrappedElement.traitTypes.length == 2);
			
			// TEMPORAL
			assertTrue(proxyElement.traitTypes.length == 1);
						
			// If we now replace the wrapped element, then the traits of the
			// wrapped element should be reflected in the proxy's traits,
			// though the blocked traits should remain the same.
			//
			
			var wrappedElement2:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.PLAYABLE, MediaTraitType.PAUSABLE, MediaTraitType.LOADABLE]
										 , new SimpleLoader()
										 );

			proxyElement.wrappedElement = wrappedElement2;

			assertTrue(proxyElement.hasTrait(MediaTraitType.PLAYABLE));
			assertFalse(proxyElement.hasTrait(MediaTraitType.PAUSABLE));
			assertFalse(proxyElement.hasTrait(MediaTraitType.LOADABLE));
			assertFalse(proxyElement.hasTrait(MediaTraitType.TEMPORAL));
		}
		
		public function testOverriddenTraits():void
		{
			var wrappedElement:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.TEMPORAL, MediaTraitType.LOADABLE]
										 , new SimpleLoader()
										 );

			var overriddenTemporal:TemporalTrait = new TemporalTrait();
			var proxyElement:DynamicProxyElement = new DynamicProxyElement(wrappedElement);
			
			// Override PAUSABLE and TEMPORAL.
			proxyElement.doAddTrait(MediaTraitType.PAUSABLE, new PausableTrait(proxyElement));
			proxyElement.doAddTrait(MediaTraitType.TEMPORAL, overriddenTemporal);
			
			assertFalse(proxyElement.hasTrait(MediaTraitType.PLAYABLE));
			assertTrue(proxyElement.hasTrait(MediaTraitType.PAUSABLE));
			assertTrue(proxyElement.hasTrait(MediaTraitType.LOADABLE));
			assertTrue(proxyElement.hasTrait(MediaTraitType.TEMPORAL));
			
			assertTrue(proxyElement.getTrait(MediaTraitType.TEMPORAL) == overriddenTemporal);

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
			
			var wrappedElement2:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.PLAYABLE, MediaTraitType.TEMPORAL, MediaTraitType.LOADABLE]
										 , new SimpleLoader()
										 );

			proxyElement.wrappedElement = wrappedElement2;

			assertTrue(proxyElement.hasTrait(MediaTraitType.PLAYABLE));
			assertFalse(proxyElement.hasTrait(MediaTraitType.PAUSABLE));
			assertTrue(proxyElement.hasTrait(MediaTraitType.LOADABLE));
			assertTrue(proxyElement.hasTrait(MediaTraitType.TEMPORAL));
			
			// The temporal trait should now come from the wrapped element,
			// not the proxy.
			assertTrue(proxyElement.getTrait(MediaTraitType.TEMPORAL) != overriddenTemporal);
			assertTrue(proxyElement.getTrait(MediaTraitType.TEMPORAL) == wrappedElement2.getTrait(MediaTraitType.TEMPORAL));
		}
		
		public function testDispatchEvent():void
		{
			// Wrap up a temporal element, but override the temporal trait
			// and block the pausable trait.
			//
			
			var wrappedElement:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.TEMPORAL, MediaTraitType.LOADABLE]
										 , new SimpleLoader()
										 );

			var proxyElement:DynamicProxyElement = new DynamicProxyElement(wrappedElement);
			proxyElement.doBlockTrait(MediaTraitType.PAUSABLE);

			var temporalTrait:TemporalTrait = new TemporalTrait();
			temporalTrait.duration = 30;
			proxyElement.doAddTrait(MediaTraitType.TEMPORAL, temporalTrait);

			proxyElement.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
			proxyElement.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);

			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			
			// If the temporal trait is added or removed on the wrapped
			// element, we shouldn't get any events.
			wrappedElement.doRemoveTrait(MediaTraitType.TEMPORAL);
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			wrappedElement.doAddTrait(MediaTraitType.TEMPORAL, new TemporalTrait());
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			
			// Similarly, if we add or remove a trait to the wrapped element
			// which the proxy blocks, then we shouldn't get any events.
			wrappedElement.doAddTrait(MediaTraitType.PAUSABLE, new PausableTrait(wrappedElement));
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			wrappedElement.doRemoveTrait(MediaTraitType.PAUSABLE);
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);

			// But if our proxy doesn't have an override for a trait or
			// block a trait, then we should get events.
			wrappedElement.doAddTrait(MediaTraitType.PLAYABLE, new PlayableTrait(wrappedElement));
			assertTrue(traitAddEventCount == 1);
			assertTrue(traitRemoveEventCount == 0);
			wrappedElement.doRemoveTrait(MediaTraitType.PLAYABLE);
			assertTrue(traitAddEventCount == 1);
			assertTrue(traitRemoveEventCount == 1);
			
			// If we add or remove a trait to the proxy which the wrapped
			// element already has, we should get no events.
			proxyElement.doAddTrait(MediaTraitType.LOADABLE, new LoadableTrait(null,null));
			assertTrue(traitAddEventCount == 1);
			assertTrue(traitRemoveEventCount == 1);
			proxyElement.doRemoveTrait(MediaTraitType.LOADABLE);
			assertTrue(traitAddEventCount == 1);
			assertTrue(traitRemoveEventCount == 1);

			// But if we add or remove a trait to the proxy which the wrapped
			// element doesn't have, then we should get events.
			proxyElement.doAddTrait(MediaTraitType.SEEKABLE, new SeekableTrait());
			assertTrue(traitAddEventCount == 2);
			assertTrue(traitRemoveEventCount == 1);
			proxyElement.doRemoveTrait(MediaTraitType.SEEKABLE);
			assertTrue(traitAddEventCount == 2);
			assertTrue(traitRemoveEventCount == 2);
			
			// Last, if we add or remove a trait to the proxy which the proxy
			// also blocks, then we should get events. 
			proxyElement.doAddTrait(MediaTraitType.PAUSABLE, new PausableTrait(proxyElement));
			assertTrue(traitAddEventCount == 3);
			assertTrue(traitRemoveEventCount == 2);
			proxyElement.doRemoveTrait(MediaTraitType.PAUSABLE);
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

		override protected function get loadable():Boolean
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
		
		private function onTraitAdd(event:TraitsChangeEvent):void
		{
			traitAddEventCount++;
		}

		private function onTraitRemove(event:TraitsChangeEvent):void
		{
			traitRemoveEventCount++;
		}
		
		private var traitAddEventCount:int;
		private var traitRemoveEventCount:int;
		
		private static const WRAPPED_TRAITS:Array =
					[ MediaTraitType.AUDIBLE
					, MediaTraitType.BUFFERABLE
					, MediaTraitType.LOADABLE
					, MediaTraitType.PAUSABLE
					, MediaTraitType.SPATIAL
				    , MediaTraitType.VIEWABLE
				    ];

		private static const REFLECTED_TRAITS:Array =
					[ MediaTraitType.AUDIBLE
					, MediaTraitType.BUFFERABLE
					, MediaTraitType.LOADABLE
					, MediaTraitType.PAUSABLE
					, MediaTraitType.SPATIAL
				    , MediaTraitType.VIEWABLE
				    ];
	}
}