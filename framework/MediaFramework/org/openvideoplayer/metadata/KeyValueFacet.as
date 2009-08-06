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
package org.openvideoplayer.metadata
{
	import __AS3__.vec.Vector;
	
	import flash.utils.Dictionary;
	
	import org.openvideoplayer.utils.URL;
	
	/**
	 * The KeyValue Facet class represents a concrete class of key value pairs for 
	 * storing metadata in a facet.  The keys are all Object, and the values are all Objects.
	 * Keys and values may not available for garbage collection until they are removed from the collection. 
	 */
	public class KeyValueFacet implements IKeyValueFacet
	{
		/**
		 * Constructs a KeyValueMetadata that holds metadata, seeded with the data param. It is assumed that all metadata is in the 
		 * dictionary at construction time, hence there is no setData method.  If metadata is added later to a piece of media, it
		 * is assumed a new IMetadata object is added to the Media, or the original dictionary is kept around and modified.
		 */ 
		public function KeyValueFacet(ns:URL = null, data:Dictionary = null)		
		{
			if (data == null)
			{
				data = new Dictionary();
			}
			this.data = data;
			if (ns == null)
			{
				ns = MetadataNamespaces.DEFAULT_METADATA;
			}
			_namespace = ns;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get nameSpace():URL
		{
			return _namespace;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get facetType():FacetType
		{
			return FacetType.KEY_VALUE_FACET;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addValue(key:Object, value:Object):void
		{
			data[key] = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeValue(key:Object):Object
		{
			var item:Object = data[key];
			delete data[key];
			return item;			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get keys():Vector.<Object>
		{
			var k:Vector.<Object> = new Vector.<Object>;
			for (var key:Object in data)
			{
				k.push(key);
			}
			return k;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getValue(key:Object):Object
		{
			return data[key];
		}
		
		private var data:Dictionary;
		private var _namespace:URL;

	}
}