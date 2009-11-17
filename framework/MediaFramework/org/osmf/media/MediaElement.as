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
	import __AS3__.vec.Vector;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.osmf.events.GatewayChangeEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.metadata.Metadata;
	import org.osmf.traits.IDisposable;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.MediaFrameworkStrings;

	/**
	 * Dispatched when an IMediaTrait is added to the media element.
	 *
	 * @eventType org.osmf.events.MediaElementEvent.TRAIT_ADD
	 **/
	[Event(name="traitAdd",type="org.osmf.events.MediaElementEvent")]
	
	/**
	 * Dispatched when an IMediaTrait is removed from the media element.
	 *
	 * @eventType org.osmf.events.MediaElementEvent.TRAIT_REMOVE
	 **/
	[Event(name="traitRemove",type="org.osmf.events.MediaElementEvent")]

	/**
	 * Dispatched when an error which impacts the operation of the media
	 * element occurs.
	 *
	 * @eventType org.osmf.events.MediaErrorEvent.MEDIA_ERROR
	 **/
	[Event(name="mediaError",type="org.osmf.events.MediaErrorEvent")]
	
	/**
	 * Dispatched when the element's gateway property changed.
	 * 
	 * @eventType org.osmf.events.GatewayChangeEvent.GATEWAY_CHANGE
	 */	
	[Event(name="gatewayChange",type="org.osmf.events.GatewayChangeEvent")]
		
	/**
     * A MediaElement represents a unified media experience.
     * It may consist of a simple media item, such as a video or a sound.
     * Different instances (or subclasses) can represent different types of media.
     * A MediaElement may also represent a complex media experience composed of 
     * multiple items, such as videos, ad banners, SWF overlays, background page branding, etc.
	 * 
     * <p>Programmatically, a media element encapsulates a set of media traits and
     * a state space.
	 * The media traits
	 * represent the capabilities of the media element and are dynamic in
	 * nature.  At one moment in time a media element might be
	 * seekable, at another moment it might not be. For example, this could occur 
     * if the media element is a video sequence containing unskippable ads.</p>
	 * <p>A media element operates on a media resource.  For example, if the
	 * media element represents a video player, the media resource might
	 * encapsulate a URL to a video stream.
     * If the media element represents a complex media composition, 
     * the media resource URL might be a document that references
     * the multiple resources used in the media composition.</p>
     * @see IMediaTrait
     * @see IMediaResource
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class MediaElement extends EventDispatcher
	{
		// Public interface
		//
		
		/**
		 * Constructor.
		 **/
		public function MediaElement()
		{			
			setupTraits();
		}
	
		/**
		 * A Vector of MediaTraitTypes representing the trait types on this
		 * media element.
		 **/
		public function get traitTypes():Vector.<MediaTraitType>
		{
			// Return a copy of our types vector.
			return _traitTypes.concat();
		}
		
		/**
		 * Determines whether this media element has a media trait of the
		 * specified type.
		 * 
         * @param type The Class of the media trait to check for.
		 * 
		 * @throws ArgumentError If the parameter is <code>null</code>.
		 * @return <code>true</code> if this media element has a media
		 * trait of the specified class, <code>false</code> otherwise.
		 **/
		public function hasTrait(type:MediaTraitType):Boolean
		{
			if (type == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			return _traits[type] != null;
		}
		
		/**
		 * Returns the media trait of the specified type.
		 * 
         * @param type The Class of the media trait to return.
		 * 
         * @throws ArgumentError If the parameter is <code>null</code>.
         * @return The retrieved trait or <code>null</code> if no such trait exists on this
		 * media element.
		 **/
		public function getTrait(type:MediaTraitType):IMediaTrait
		{
			if (type == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}

			return _traits[type];
		}
		
		/**
		 * The media resource that this media element operates on.
		 **/
		public function get resource():IMediaResource
		{
			return _resource;
		}
		
		public function set resource(value:IMediaResource):void
		{
			_resource = value;		
		}
		
		/**
		 * The gateway that this element uses.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get gateway():IMediaGateway
		{
			return _gateway;
		}
		
		public function set gateway(value:IMediaGateway):void
		{
			if (_gateway != value)
			{
				var containerGateway:IContainerGateway = _gateway as IContainerGateway;
				if (containerGateway && containerGateway.containsElement(this))
				{
					containerGateway.removeElement(this);	
				}
				
				var event:GatewayChangeEvent = new GatewayChangeEvent
					( GatewayChangeEvent.GATEWAY_CHANGE
					, false
					, false
					, _gateway
					, value
					);
					
				_gateway = value;
				containerGateway = _gateway as IContainerGateway;
				
				if (containerGateway && containerGateway.containsElement(this) == false)
				{
					containerGateway.addElement(this);
				}
				
				dispatchEvent(event);
			}
		}
		
		/**
		 * @returns The metadata container associated with this MediaElement
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get metadata():Metadata
		{
			if(_metadata == null)
			{
				_metadata = createMetadata();
			}
			return _metadata;
		}
				
		// Protected
		//
		
		/**
		 * Creates metadata		
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		 protected function createMetadata():Metadata
		 {
		 	return new Metadata();
		 }
		 
		
		/**
		 * Adds a new media trait to this media element.  If successful,
		 * dispatches a MediaElementEvent.
		 * 
         * @param type The type of media trait to add.
		 * @param trait The media trait to add.
		 * 
         * @throws ArgumentError If either parameter is <code>null</code>, or
		 * if the specified type and the type of the media trait don't match,
		 * or if a different instance of the specific trait class has already
		 * been added.
		 **/
		protected function addTrait(type:MediaTraitType, instance:IMediaTrait):void
		{
			if (type == null || instance == null || !(instance is type.traitInterface))
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			var result:IMediaTrait = _traits[type];
			
			if (result == null)
			{
				_traits[type] = result = instance;
				_traitTypes.push(type);
				
				// Listen for errors:
				result.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
				
				// Signal addition:
				dispatchEvent(new MediaElementEvent(MediaElementEvent.TRAIT_ADD, false, false, type));
			}
			else if (result != instance)
			{
				throw new ArgumentError(MediaFrameworkStrings.TRAIT_INSTANCE_ALREADY_ADDED);
			}
		}
		
		/**
		 * Removes a media trait from this media element.  If successful,
		 * dispatches a MediaElementEvent.
		 * 
         * @param type The Class of the media trait to remove.
		 * 
         * @throws ArgumentError If the parameter is <code>null</code>.
         * @return The removed trait or <code>null</code> if no trait was
         * removed.
		 **/
		protected function removeTrait(type:MediaTraitType):IMediaTrait
		{
			if (type == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}

			var result:IMediaTrait = _traits[type];
			
			if (result != null)
			{
				// Stop listening for errors:
				result.removeEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
				if (result is IDisposable)
				{
					(result as IDisposable).dispose();
				}

				// Signal removal is about to occur:
				dispatchEvent(new MediaElementEvent(MediaElementEvent.TRAIT_REMOVE, false, false, type));
				
				_traitTypes.splice(_traitTypes.indexOf(type),1);
				delete _traits[type];
			}
			
			return result;
		}
		
		/**
		 * Sets up the traits for this media element.  Occurs during
		 * construction.  Subclasses should override this method and call
		 * addTrait for each trait of their own.
		 **/
		protected function setupTraits():void
		{
		}		

		// Internals
		//
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			dispatchEvent(event.clone());
		}

		private var _traitTypes:Vector.<MediaTraitType> = new Vector.<MediaTraitType>();
		private var _traits:Dictionary = new Dictionary();
		private var _resource:IMediaResource;
		private var _gateway:IMediaGateway;
		private var _metadata:Metadata;
		
	}
}