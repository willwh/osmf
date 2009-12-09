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

package org.osmf.metadata
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.events.FacetValueChangeEvent;
	import org.osmf.events.FacetValueEvent;
	import org.osmf.events.MetadataEvent;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.URL;
	
	/**
	 * The MetadataWatcher class is a convenience class that helps monitoring Metadata
	 * instances for change.
	 */	
	public class MetadataWatcher
	{
		/**
		 * Constructor 
		 * @param metadata The Metadata to watch for change.
		 * @param nameSpace The namespace that identifies the IFacet instance to watch
		 * for change.
		 * @param identifier The identifier pointing to the value of interest to watch
		 * for change. Note that this parameter is optional: not specifying an
		 * identifier will result in the facet as a whole being watched for change.
		 * @param callback The method to invoke on either the facet or facet value (see
		 * identifier parameter description) changing. The callback function is expected
		 * to take one argument, which will be set to the new value.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function MetadataWatcher(metadata:Metadata, nameSpace:URL, identifier:IIdentifier, callback:Function)
		{
			if (metadata == null || nameSpace == null || callback == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}

			this.metadata = metadata;
			this.nameSpace = nameSpace;
			this.identifier = identifier;
			this.callback = callback;
		}
		
		/**
		 * Starts watching the target facet (value)
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function watch():void
		{
			if (watching == false)
			{
				watching = true;
				
				// Make sure we are watching for facets being added. process-
				// WatchedFacetChange that is invoked later, will remove the
				// listener should it already be present on our metadata:
				metadata.addEventListener
					( MetadataEvent.FACET_ADD, onFacetAdd
					, false, 0, true
					);
				
				processWatchedFacetChange(metadata.getFacet(nameSpace));
				
				// For convience, always trigger a first change callback when
				// start watching:
				if (identifier)
				{
					callback(currentFacet ? currentFacet.getValue(identifier) : undefined);
				}
				else
				{
					callback(currentFacet ? currentFacet : undefined);
				}
			}
		}
		
		/**
		 * Stops watching the target facet (value)
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function unwatch():void
		{
			if (watching == true)
			{
				processWatchedFacetChange(null, false);
				
				// If we weren't watching our facet yet, then processWatched-
				// FacetChange will not have remove our facet addition listener:
				metadata.removeEventListener(MetadataEvent.FACET_ADD, onFacetAdd);
				
				watching = false;
			}
		}	
		
		// Internals
		//
			
		private function processWatchedFacetChange(facet:IFacet, dispatchChange:Boolean = true):void
		{
			// Don't change anything if the new facet matches the old one:
			if (currentFacet != facet)
			{
				var oldFacet:IFacet = currentFacet;
				
				if (currentFacet)
				{
					// Remove the event listeners for the currently set facet:
					currentFacet.removeEventListener(FacetValueChangeEvent.VALUE_CHANGE,onFacetValueChange);
					currentFacet.removeEventListener(FacetValueEvent.VALUE_ADD,onFacetValueAdd);
					currentFacet.removeEventListener(FacetValueEvent.VALUE_REMOVE,onFacetValueRemove);
					
					metadata.removeEventListener(MetadataEvent.FACET_REMOVE, onFacetRemove);
				}
				else
				{
					// If there's currently no facet set, then remove the listener
					// that's out to capture the addition of the facet:
					metadata.removeEventListener(MetadataEvent.FACET_ADD, onFacetAdd);
				}
				
				// Now assign the new facet value:
				currentFacet = facet;
				
				if (facet)
				{
					// Listen to the facet informing us about value changes:
					facet.addEventListener
						( FacetValueChangeEvent.VALUE_CHANGE,onFacetValueChange
						, false, 0, true
						);
					facet.addEventListener
						( FacetValueEvent.VALUE_ADD,onFacetValueAdd
						, false, 0, true
						);
					facet.addEventListener
						( FacetValueEvent.VALUE_REMOVE,onFacetValueRemove
						, false, 0, true
						);
					
					// Listen to the metadata informing us about the facet being removed:
					metadata.addEventListener(MetadataEvent.FACET_REMOVE, onFacetRemove);
				}
				else
				{
					// If there's currently no facet set, then listen to the metadata
					// instance informing us about new facets being added:
					metadata.addEventListener(MetadataEvent.FACET_ADD, onFacetAdd);
				}
			}
		}
		
		// Metadata Handlers
		//
		
		private function onFacetAdd(event:MetadataEvent):void
		{
			// See if this is the facet that we're watching:
			if (event.facet.namespaceURL.rawUrl == nameSpace.rawUrl)
			{
				processWatchedFacetChange(event.facet);
				
				// In case we're watching at the facet level only, then
				// trigger the callback:
				if (identifier == null)
				{
					callback(event.facet);
				}
				else
				{
					callback(event.facet.getValue(identifier));
				}
			}
		}
		
		private function onFacetRemove(event:MetadataEvent):void
		{
			// See if this is the facet that we're watching:
			if (event.facet && event.facet.namespaceURL.rawUrl == nameSpace.rawUrl)
			{
				processWatchedFacetChange(null);
				
				callback(undefined);
			}
		}
		
		// Facet Handlers
		//
		
		private function onFacetValueChange(event:FacetValueChangeEvent):void
		{
			if (identifier)
			{
				// We're watching a specific value: only invoke the callback
				// if this is 'our' value that is changing:
				if (identifier.equals(event.identifier))
				{
					callback(event.value);
				}	
			}
			else
			{
				// We're watching the entire facet: invoke callback:
				callback(event.target as IFacet);
			}
		}
		
		private function onFacetValueAdd(event:FacetValueEvent):void
		{
			if (identifier)
			{
				// We're watching a specific value: only invoke the callback
				// if this is 'our' value that is being added:
				if (identifier.equals(event.identifier))
				{
					callback(event.value);
				}	
			}
			else
			{
				// We're watching the entire facet: invoke callback:
				callback(event.target as IFacet);
			}
		}
		
		private function onFacetValueRemove(event:FacetValueEvent):void
		{
			if (identifier)
			{
				// We're watching a specific value: only invoke the callback
				// if this is 'our' value that is being removed:
				if (identifier.equals(event.identifier))
				{
					callback(undefined);
				}	
			}
			else
			{
				// We're watching the entire facet: invoke callback:
				callback(event.target as IFacet);
			}
		}
		
		private var metadata:Metadata;
		private var nameSpace:URL;
		private var identifier:IIdentifier;
		private var callback:Function;
		
		private var currentFacet:IFacet;
		private var watching:Boolean;
		
	}
}