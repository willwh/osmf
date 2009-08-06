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
	import flash.events.Event;
	
	import org.openvideoplayer.events.MediaErrorEvent;
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	
	/**
	 * A ProxyElement acts as a wrapper for another MediaElement.
	 * Its purpose is to control access to the wrapped element.
	 * <p>ProxyElement is not instantiated directly but rather used
	 * as the base class for creating wrappers for specific purposes. 
	 * ProxyElement can be subclassed for any trait type or set of trait types.
	 * The subclass controls access to the wrapped element either by overriding
	 * one or more of the wrapped element's traits or by blocking them.</p>
	 * <p>To override any of the wrapped element's traits, 
	 * the subclass creates its own trait instances,
	 * which it substitutes for the wrapped element's traits that it wishes to override.
	 * It uses the ProxyElement's <code>setupOverriddenTraits()</code> method to arrange for
	 * the wrapped element's traits to be overridden.</p>
	 * <p>To block traits, the subclass prevents the traits of
	 * the wrapped element from being exposed by calling the ProxyElement's
	 * <code>blocksTrait(type:MediaTraitType)</code> method for every trait
	 * type that it wants to block.
	 * This causes the wrapped element's <code>hasTrait()</code>
	 * method to return <code>false</code> and its
	 * <code>getTrait()</code> method to return <code>null</code>
	 * for the blocked trait types.</p>
	 * <p>A ProxyElement normally dispatches the wrapped element's
	 * TraitsChangeEvents, unless its <code>blocksTrait()</code> method returns 
	 * <code>false</code> for the trait that is the target of the
	 * TraitsChangeEvent.</p>
	 * <p>ProxyElement subclasses are useful for modifying the behavior of a
	 * MediaElement in a non-invasive way.  
	 * An example would be adding
	 * temporal capabilities to a set of ImageElements to present them in a slide show
	 * in which the images are displayed for a specified duration.
	 * The ProxyElement subclass would wrap the non-temporal ImageElements
	 * and override the wrapped element's ITemporal trait to return a custom
	 * instance of that trait.
	 * A similar approach can be applied to other traits, either to provide an 
	 * alternate implementation of some of the wrapped element's underlying traits,
	 * to provide an implementation when a needed underlying trait does not exist,
	 * or to prevent an underlying trait from being exposed at all.</p>
	 * @see TemporalProxyElement
	 * @see org.openvideoplayer.events.TraitsChangeEvent
	 * @see org.openvideoplayer.traits
	 **/
	public class ProxyElement extends MediaElement
	{
		/**
		 * Constructor.
		 * 
		 * @param wrappedElement MediaElement to wrap.  Changes to
		 * the wrapped element are reflected in the proxy element's properties
		 * and events, with the exception of those changes for which an override
		 * takes precedence.
		 * 
		 * @throws IllegalOperationError If the wrappedElement is <code>null</code>. 
		 **/
		public function ProxyElement(wrappedElement:MediaElement)
		{
			super();
			
			if (wrappedElement == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			_wrappedElement = wrappedElement;
			
			// Ensure all events from the wrapped MediaElement are also
			// dispatched by this proxy.
			wrappedElement.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
			wrappedElement.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
			wrappedElement.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);

			// Set up the traits for the proxy, now that we're prepared to
			// respond to change events.  (Note that this class's setupTraits
			// prevents a call to the base class.)
			setupOverriddenTraits();
		}
		
		/**
		 * @private
		 **/
		override public function get traitTypes():Array
		{
			var results:Array = new Array();
			
			// Only return the traits reflected by the proxy. 
			for each (var traitType:MediaTraitType in ALL_TRAIT_TYPES)
			{
				if (hasTrait(traitType))
				{
					results.push(traitType);
				}
			}
			
			return results;
		}

		/**
		 * @private
		 **/
		override public function hasTrait(type:MediaTraitType):Boolean
		{
			if (type == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			return getTrait(type) != null;
		}
		
		/**
		 * @private
		 **/
		override public function getTrait(type:MediaTraitType):IMediaTrait
		{
			if (type == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}

			var trait:IMediaTrait = null;
			
			// Don't return the trait if it's blocked.
			if (blocksTrait(type) == false)
			{
				// Give precedence to a trait on the proxy.
				trait = super.getTrait(type) ||	wrappedElement.getTrait(type);
			}
			
			return trait;
		}
		
		/**
         * @private
		 **/
		override public function initialize(value:Array):void
		{
			wrappedElement.initialize(value);
		}
		
		/**
		 * @private
		 **/
		override public function get resource():IMediaResource
		{
			return wrappedElement.resource;
		}
		/**
		 * @private
		 **/		
		override public function set resource(value:IMediaResource):void
		{
			wrappedElement.resource = value;
		}
		
		/**
		 * @private
		 **/
		override public function dispatchEvent(event:Event):Boolean
		{
			var doDispatchEvent:Boolean = true;

			// If the proxy is dispatching a TraitsChangeEvent for a trait
			// that isn't blocked but which already exists on the wrapped
			// element, then we swallow the event.
			var traitEvent:TraitsChangeEvent = event as TraitsChangeEvent;
			if  (  traitEvent != null
				&& blocksTrait(traitEvent.traitType) == false
				&& wrappedElement.hasTrait(traitEvent.traitType) == true
				)
			{
				doDispatchEvent = false;
			}
			
			if (doDispatchEvent)
			{
				super.dispatchEvent(event);
			}
			
			return doDispatchEvent;
		}
		
		/**
		 * Sets up overridden traits and and finalizes them to ensure a consistent initialization
		 * process.  Clients should subclass <code>setupOverriddenTraits()</code>
		 * instead of this method.
		 **/
		final override protected function setupTraits():void
		{
		}
		
		/**
		 * Sets up the traits for this proxy.  The proxy's traits will always
		 * override (i.e. take precedence over) the traits of the wrapped
		 * element.
		 * 
		 * Subclasses can override this method to set up their own traits.
		 **/
		protected function setupOverriddenTraits():void
		{
			super.setupTraits();
		}
		
		protected function get wrappedElement():MediaElement
		{
			return _wrappedElement;
		}
		
		/**
		 * Indicates whether the ProxyElement will prevent the trait of the specified
		 * type from being exposed when the wrapped element contains the trait
		 * and the proxy does not.  The default is <code>false</code> for all trait types.
		 * 
		 * Subclasses override this to selectively block access to the
		 * traits of the wrapped element on a per-type basis.
		 * @param type Trait type to block or not block
		 * @return Returns <code>true</code> to block the trait of the specified type, 
		 * <code>false</code> not to block
		 **/ 
		protected function blocksTrait(type:MediaTraitType):Boolean
		{
			return false;
		}
		
		// Internals
		//
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function onTraitAdd(event:TraitsChangeEvent):void
		{
			processTraitsChangeEvent(event);
		}

		private function onTraitRemove(event:TraitsChangeEvent):void
		{
			processTraitsChangeEvent(event);
		}
		
		private function processTraitsChangeEvent(event:TraitsChangeEvent):void
		{
			// We only redispatch the event if the change is for a non-blocked,
			// non-overridden trait.
			if (blocksTrait(event.traitType) == false &&
				super.hasTrait(event.traitType) == false)
			{
				super.dispatchEvent(event.clone());
			}
		}

		private static const ALL_TRAIT_TYPES:Array =
				[ MediaTraitType.AUDIBLE
				, MediaTraitType.BUFFERABLE
				, MediaTraitType.LOADABLE
				, MediaTraitType.PAUSIBLE
				, MediaTraitType.PLAYABLE
				, MediaTraitType.SEEKABLE
				, MediaTraitType.SPATIAL
				, MediaTraitType.TEMPORAL
			    , MediaTraitType.VIEWABLE
			    ];

		private var _wrappedElement:MediaElement;
	}
}