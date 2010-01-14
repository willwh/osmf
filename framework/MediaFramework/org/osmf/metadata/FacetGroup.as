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
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.osmf.events.FacetValueChangeEvent;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.URL;
	
	/**
	 * Dispatched when the facet group changes as a result of either
	 * a value being added, removed, or changed on a facet, or when
	 * a facet is begin added to, or removed from the group.
	 */	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * Defines a group of facets that share one and the same name
	 * space.
	 */	
	public class FacetGroup extends EventDispatcher
	{
		// Public interface
		//
		
		/**
		 * Constructor.
		 *  
		 * @param nameSpace The namespace of the facets that all children of
		 * this group have in common.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function FacetGroup(nameSpace:URL)
		{
			_namespaceURL = nameSpace;
			
			facets = new Vector.<Object>();
		}
		
		/**
		 * Defines the namespace of the facets that all children of this group
		 * have in common.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get namespaceURL():URL
		{
			return _namespaceURL;
		}

		/**
		 * Adds a facet to the group.
		 * 
		 * @param metadata The metadata instance that the facet is to be tracked
		 * in relation to. This relation is tracked because one facet may be the
		 * child of multiple metadata instances.
		 * @param facet The facet to add.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function addFacet(metadata:Metadata, facet:Facet):void
		{
			if (metadata == null || facet == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			if (facet.namespaceURL.rawUrl != _namespaceURL.rawUrl)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NAMESPACE_MUST_EQUAL_GROUP_NS));
			}
			
			facets.push({metadata:metadata, facet:facet});
			facet.addEventListener(FacetValueChangeEvent.VALUE_CHANGE, changeDispatchingEventHandler);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Removes a facet from the group.
		 *  
		 * @param metadata The metadata instance that the facet is to be tracked
		 * in relation to. This relation is tracked because one facet may be the
		 * child of multiple metadata instances.
		 * @param facet The facet to remove.
		 * @returns The remove facet, or null if the specified item wasn't listed.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function removeFacet(metadata:Metadata, facet:Facet):Facet
		{
			var result:Facet;
			var index:int = indexOf(metadata, facet);
			
			if (index != -1)
			{
				result = facets.splice(index,1)[0].facet;
				facet.removeEventListener(FacetValueChangeEvent.VALUE_CHANGE, changeDispatchingEventHandler);
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			return result;
		}
	
		/**
		 * Defines the number of facets that are in the group.
		 */		
		public function get length():int
		{
			return facets.length;
		}
		
		/**
		 * Gets a metadata reference.
		 * 
		 * @param index The index of the metadata reference to return.
		 * @return The metadata reference at the specified index.
		 * @throws RangeError if the specified index is out of bounds. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function getMetadataAt(index:uint):Metadata
		{
			if (index >= facets.length)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));	
			}
			
			return facets[index].metadata;
		}
		
		/**
		 * Gets a facet reference.
		 * 
		 * @param index The index of the facet to return.
		 * @return The facet at the specified index.
		 * @throws RangeError if the specified index is out of bounds. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function getFacetAt(index:int):Facet
		{
			if (index >= facets.length)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));	
			}
			
			return facets[index].facet;
		}
		
		/**
		 * Gets the index of a given metadata/facet pair.
		 * 
		 * @param metadata The metadata reference to localize.
		 * @param facet The facet to localize.
		 * @return -1 if the pair was not found, or the requested index.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */			
		public function indexOf(metadata:Metadata, facet:Facet):int
		{
			var result:int = -1;
			var record:Object;
			
			for (var i:int = 0; i<facets.length; i++)
			{
				record = facets[i];
				
				if 	(	record.metadata == metadata
					&&	record.facet == facet
					)
				{
					result = i;
					break;
				}
			}
			
			return result;
		}

		// Internals
		//
		
		private function changeDispatchingEventHandler(event:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private var _namespaceURL:URL;
		private var facets:Vector.<Object>;
	}
}