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
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	
	import org.osmf.containers.IMediaContainer;
	import org.osmf.events.ContainerChangeEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.Metadata;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.OSMFStrings;
	
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
	 * MediaElementEvents, unless its <code>blocksTrait()</code> method returns 
	 * <code>false</code> for the trait that is the target of the
	 * MediaElementEvent.</p>
	 * <p>ProxyElement subclasses are useful for modifying the behavior of a
	 * MediaElement in a non-invasive way.  
	 * An example would be adding
	 * temporal capabilities to a set of ImageElements to present them in a slide show
	 * in which the images are displayed for a specified duration.
	 * The ProxyElement subclass would wrap the non-temporal ImageElements
	 * and override the wrapped element's TimeTrait to return a custom
	 * instance of that trait.
	 * A similar approach can be applied to other traits, either to provide an 
	 * alternate implementation of some of the wrapped element's underlying traits,
	 * to provide an implementation when a needed underlying trait does not exist,
	 * or to prevent an underlying trait from being exposed at all.</p>
	 * @see TemporalProxyElement
	 * @see org.osmf.events.MediaElementEvent
	 * @see org.osmf.traits
	 **/
	public class ProxyElement extends MediaElement
	{
		/**
		 * Constructor.
		 * 
		 * @param wrappedElement MediaElement to wrap.  Changes to the wrapped
		 * element are reflected in the proxy element's properties and events,
		 * with the exception of those changes for which an override takes
		 * precedence.  If the param is null, then it must be set (via the
		 * wrappedElement setter) immediately after this constructor call, and
		 * before any other methods on this ProxyElement are called, or an
		 * IllegalOperationError will be thrown.
		 **/
		public function ProxyElement(wrappedElement:MediaElement)
		{
			super();
			
			this.wrappedElement = wrappedElement;
		}
		
		/**
		 * The MediaElement for which this ProxyElement serves as a proxy,
		 * or wrapper.
		 **/
		public function set wrappedElement(value:MediaElement):void
		{
			var traitType:String;
			
			if (value != _wrappedElement)
			{
				if (_wrappedElement != null)
				{
					// Clear the listeners for the old wrapped element.
					toggleMediaElementListeners(_wrappedElement, false);

					// The wrapped element is changing, signal trait removal
					// for all traits.
					for each (traitType in _wrappedElement.traitTypes)
					{
						super.dispatchEvent(new MediaElementEvent(MediaElementEvent.TRAIT_REMOVE, false, false, traitType));
					}
					
					// All traits that were overridden on the proxy must be
					// removed.
					removeOverriddenTraits();
				}
				
				_wrappedElement = value;
				
				if (_wrappedElement != null)
				{
					// Add listeners for the new wrapped element, so that
					// events from the wrapped element are also dispatched by
					// the proxy.
					toggleMediaElementListeners(_wrappedElement, true);
					
					// Set up the traits for the proxy, now that we're prepared
					// to respond to change events.  (Note that this class's
					// setupTraits prevents a call to the base class.)
					setupOverriddenTraits();
					
					// The wrapped element has changed, signal trait addition
					// for all traits.
					for each (traitType in _wrappedElement.traitTypes)
					{
						super.dispatchEvent(new MediaElementEvent(MediaElementEvent.TRAIT_ADD, false, false, traitType));
					}

					// Forward our gateway (if any) to the wrapped element:
					if (outerGateway)
					{
						outerGateway.addMediaElement(_wrappedElement);
					}
				}
			}
		}
		
		public function get wrappedElement():MediaElement
		{
			return _wrappedElement;
		}
		
		/**
		 * @private
		 **/
		override public function get traitTypes():Vector.<String>
		{
			var results:Vector.<String> = new Vector.<String>();
			
			// Only return the traits reflected by the proxy. 
			for each (var traitType:String in MediaTraitType.ALL_TYPES)
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
		override public function hasTrait(type:String):Boolean
		{
			if (type == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			return getTrait(type) != null;
		}
		
		/**
		 * @private
		 **/
		override public function getTrait(type:String):MediaTraitBase
		{
			if (type == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}

			var trait:MediaTraitBase = null;
			
			// Don't return the trait if it's blocked.
			if (blocksTrait(type) == false)
			{				
				// Give precedence to a trait on the proxy.
				trait = super.getTrait(type) ||	(wrappedElement != null ? wrappedElement.getTrait(type) : null);
			}
			
			return trait;
		}
		
		/**
		 * @private
		 **/
		override public function get resource():MediaResourceBase
		{		
			return wrappedElement ? wrappedElement.resource : null;
		}
		
		/**
		 * @private
		 **/		
		override public function set resource(value:MediaResourceBase):void
		{	
			if (wrappedElement != null)
			{
				wrappedElement.resource = value;
			}
		}
		
		/**
		override public function get gateway():IMediaContainer
		{
			return wrappedElement ? wrappedElement.container : outerGateway;
		}
		
		override public function set gateway(value:IMediaContainer):void
		{	
			// Retain the value as the gateway that was set from the outside
			// of the wrapped element:
			outerGateway = value;
			
			if (wrappedElement != null)
			{		
				wrappedElement.container = value;
			}
		}*/
		
		/**
		 * @private
		 **/
		override public function dispatchEvent(event:Event):Boolean
		{			
			var doDispatchEvent:Boolean = true;

			// If the proxy is dispatching a MediaElementEvent for a trait
			// that isn't blocked but which already exists on the wrapped
			// element, then we swallow the event.
			var traitEvent:MediaElementEvent = event as MediaElementEvent;
			if  (  traitEvent != null
				&& blocksTrait(traitEvent.traitType) == false
				&& wrappedElement != null
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
		 * @private
		 **/
		override public function get metadata():Metadata
		{
			return wrappedElement.metadata;
		}
		
		/**
		 * @private
		 * 
		 * Don't create any metadata, since we will be using the wrapped element's data only.
		 **/
		override protected function createMetadata():Metadata
		{
			return null;
		}

		/**
		 * Sets up overridden traits and finalizes them to ensure a consistent initialization
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
		
		/**
		 * Indicates whether the ProxyElement will prevent the trait of the specified
		 * type from being exposed when the wrapped element contains the trait
		 * and the proxy does not.  The default is <code>false</code> for all trait types.
		 * 
		 * Subclasses override this to selectively block access to the
		 * traits of the wrapped element on a per-type basis.
		 * @param type MediaTraitType to block or not block
		 * @return Returns <code>true</code> to block the trait of the specified type, 
		 * <code>false</code> not to block
		 **/ 
		protected function blocksTrait(traitType:String):Boolean
		{
			return false;
		}
		
		// Internals
		//
		
		private function removeOverriddenTraits():void
		{				
			var overriddenTraitTypes:Vector.<String> = super.traitTypes;
			for each (var traitType:String in overriddenTraitTypes)
			{
				removeTrait(traitType);
			}
		}
		
		private function toggleMediaElementListeners(mediaElement:MediaElement, add:Boolean):void
		{
			if (add)
			{
				_wrappedElement.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
				_wrappedElement.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				_wrappedElement.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
				_wrappedElement.addEventListener(ContainerChangeEvent.CONTAINER_CHANGE, onContainerChange);
			}
			else
			{
				_wrappedElement.removeEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
				_wrappedElement.removeEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				_wrappedElement.removeEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
				_wrappedElement.removeEventListener(ContainerChangeEvent.CONTAINER_CHANGE, onContainerChange);
			}
		}
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function onTraitAdd(event:MediaElementEvent):void
		{
			processTraitsChangeEvent(event);
		}

		private function onTraitRemove(event:MediaElementEvent):void
		{
			processTraitsChangeEvent(event);
		}
		
		private function onContainerChange(event:ContainerChangeEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function processTraitsChangeEvent(event:MediaElementEvent):void
		{
			// We only redispatch the event if the change is for a non-blocked,
			// non-overridden trait.
			if	(	blocksTrait(event.traitType) == false
				&&	super.hasTrait(event.traitType) == false
				)
			{
				super.dispatchEvent(event.clone());
			}
		}
		
		private var _wrappedElement:MediaElement;
		private var outerGateway:IMediaContainer;
	}
}