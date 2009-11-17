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
	import flash.utils.Dictionary;
	
	import org.osmf.events.FacetValueChangeEvent;
	import org.osmf.events.FacetValueEvent;
	import org.osmf.utils.URL;
	
	/**
	 * The KeyValue Facet class represents a concrete class of key value pairs for 
	 * storing metadata in a facet.  The keys are all Object, and the values are all Objects.
	 * Keys and values may not available for garbage collection until they are removed from the collection. 
	 */
	public class KeyValueFacet extends EventDispatcher implements IFacet
	{
		/**
		 * Constructs a KeyValueMetadata that holds metadata, seeded with the data param. It is assumed that all metadata is in the 
		 * dictionary at construction time, hence there is no setData method.  If metadata is added later to a piece of media, it
		 * is assumed a new IMetadata object is added to the Media, or the original dictionary is kept around and modified.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function KeyValueFacet(ns:URL = null)		
		{			
			data = new Dictionary();			
			if (ns == null)
			{
				ns = MetadataNamespaces.DEFAULT_METADATA;
			}			
			_namespaceURL = ns;
		}
		
		// IFacet
		//
				
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get namespaceURL():URL
		{
			return _namespaceURL;
		}
				
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function getValue(identifier:IIdentifier):*
		{
			var objectIdentifier:ObjectIdentifier = identifier as ObjectIdentifier; 
			if (objectIdentifier)
			{
				return data[objectIdentifier.key];
			}			
		}
		
		/**
		 * Merges child key value facets with this key value facet.  Merge is used in the
		 * compositing of Metadata.  Merge conflicts are resolved, by the parent
		 * (this) winning in all cases.  When there is a child conflict,
		 * the latter child key in the list is chosen.  Meaning, if two keys conflict in the 
		 * children Facets, the facet closer to the end of the childrenFacets Vector is chosen.
		 * Returns a new facet, with all merged values.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function merge(childFacet:IFacet):IFacet
		{
			var merged:KeyValueFacet = new KeyValueFacet(namespaceURL);
			var key:ObjectIdentifier;
			var currentKeys:Vector.<ObjectIdentifier> = KeyValueFacet(childFacet).keys;
			for each (key in currentKeys) //Child facets.
			{
				merged.addValue(key, childFacet.getValue(key));
			}				
			for (var keyStr:String in data) //Add data from our own dictionary
			{
				merged.addValue(new ObjectIdentifier(keyStr), data[keyStr]);
			}	
			
			return merged;
		} 
		
		/**
		 * Associates the key with the value object.  If the ObjectIdentifier's key property
		 * is equal to the key of another object already in the Facet 
		 * this will overwrite the association with the new value.
		 * 
		 * @param key the object to associate the value with
		 * @param value the value to add  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function addValue(key:ObjectIdentifier, value:Object):void
		{
			var oldValue:* = data[key.key];			
			data[key.key] = value;
			
			if (oldValue != value)
			{				
				var event:Event
					= oldValue === undefined
						? new FacetValueEvent
							( FacetValueEvent.VALUE_ADD
							, false
							, false
							, key
							, value
							)
						: new FacetValueChangeEvent
							( FacetValueChangeEvent.VALUE_CHANGE
							, false
							, false
							, key
							, value
							, oldValue
							)
						;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * Removes the data associated with the specified key from this facet. Returns
		 * undefined if the key is not present in this collection.
		 * 
		 * @param key the key associated with the value to be removed.
		 * @returns the removed item
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function removeValue(key:ObjectIdentifier):*
		{
			var value:* = data[key.key];
			if (value !== undefined)
			{
				delete data[key.key];
								
				dispatchEvent
					( new FacetValueEvent
						( FacetValueEvent.VALUE_REMOVE
						, false
						, false
						, key
						, value
						)
					);
			}
			return value;
		}
		
		/**
		 * @returns All of the keys used in this dictionary.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get keys():Vector.<ObjectIdentifier>
		{
			var allKeys:Vector.<ObjectIdentifier> = new Vector.<ObjectIdentifier>;
			for (var key:Object in data)
			{
				allKeys.push(new ObjectIdentifier(key));
			}
			return allKeys;
		}
				
		private var data:Dictionary;
		private var _namespaceURL:URL;

	}
}