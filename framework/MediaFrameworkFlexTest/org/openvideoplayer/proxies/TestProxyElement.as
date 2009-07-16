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
	import flash.errors.IllegalOperationError;
	
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.TestMediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.PausibleTrait;
	import org.openvideoplayer.traits.PlayableTrait;
	import org.openvideoplayer.traits.SeekableTrait;
	import org.openvideoplayer.traits.TemporalTrait;
	import org.openvideoplayer.utils.DynamicMediaElement;
	import org.openvideoplayer.utils.DynamicProxyElement;
	import org.openvideoplayer.utils.SimpleLoader;

	public class TestProxyElement extends TestMediaElement
	{
		public function testConstructorExceptions():void
		{
			// No exception here.
			new ProxyElement(new MediaElement());
			
			// Can't have a null wrapper.
			try
			{
				new ProxyElement(null);
				
				fail();
			}
			catch (error:IllegalOperationError)
			{
			}
		}
		
		public function testBlockedTraits():void
		{
			var wrappedElement:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.TEMPORAL, MediaTraitType.LOADABLE]
										 , new SimpleLoader()
										 );

			var proxyElement:DynamicProxyElement = new DynamicProxyElement(wrappedElement);
			proxyElement.doBlockTrait(MediaTraitType.PAUSIBLE);
			proxyElement.doBlockTrait(MediaTraitType.LOADABLE);
			
			// The proxy blocks LOADABLE.
			//
			
			assertTrue(wrappedElement.hasTrait(MediaTraitType.LOADABLE));
			assertFalse(proxyElement.hasTrait(MediaTraitType.LOADABLE));

			assertTrue(wrappedElement.getTrait(MediaTraitType.LOADABLE) != null);
			assertTrue(proxyElement.getTrait(MediaTraitType.LOADABLE) == null);

			// TEMPORAL, LOADABLE
			assertTrue(wrappedElement.traitTypes.length == 2);
			
			// TEMPORAL
			assertTrue(proxyElement.traitTypes.length == 1);
		}
		
		public function testDispatchEvent():void
		{
			// Wrap up a temporal element, but override the temporal trait
			// and block the pausible trait.
			//
			
			var wrappedElement:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.TEMPORAL, MediaTraitType.LOADABLE]
										 , new SimpleLoader()
										 );

			var proxyElement:DynamicProxyElement = new DynamicProxyElement(wrappedElement);
			proxyElement.doBlockTrait(MediaTraitType.PAUSIBLE);

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
			wrappedElement.doAddTrait(MediaTraitType.PAUSIBLE, new PausibleTrait());
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);
			wrappedElement.doRemoveTrait(MediaTraitType.PAUSIBLE);
			assertTrue(traitAddEventCount == 0);
			assertTrue(traitRemoveEventCount == 0);

			// But if our proxy doesn't have an override for a trait or
			// block a trait, then we should get events.
			wrappedElement.doAddTrait(MediaTraitType.PLAYABLE, new PlayableTrait());
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
			proxyElement.doAddTrait(MediaTraitType.PAUSIBLE, new PausibleTrait());
			assertTrue(traitAddEventCount == 3);
			assertTrue(traitRemoveEventCount == 2);
			proxyElement.doRemoveTrait(MediaTraitType.PAUSIBLE);
			assertTrue(traitAddEventCount == 3);
			assertTrue(traitRemoveEventCount == 3);
		}
		
		// Overrides
		//
		
		override public function setUp():void
		{
			super.setUp();
			
			traitAddEventCount = traitRemoveEventCount = 0;
		}
		
		override protected function createMediaElement():MediaElement
		{
			return new ProxyElement(new DynamicMediaElement(WRAPPED_TRAITS, new SimpleLoader()));
		}
		
		override protected function get loadable():Boolean
		{
			return true;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return new URLResource("http://example.com");
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
					, MediaTraitType.PAUSIBLE
					, MediaTraitType.SPATIAL
				    , MediaTraitType.VIEWABLE
				    ];

		private static const REFLECTED_TRAITS:Array =
					[ MediaTraitType.AUDIBLE
					, MediaTraitType.BUFFERABLE
					, MediaTraitType.LOADABLE
					, MediaTraitType.PAUSIBLE
					, MediaTraitType.SPATIAL
				    , MediaTraitType.VIEWABLE
				    ];
	}
}