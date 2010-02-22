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
	/**
	 * The FacetKey represents a key that can be used to look up a corresponding
	 * value within a Facet.
	 * 
	 * The OSMF Metadata APIs are based upon the idea that all metadata associated
	 * with a piece of media can be broken down into a set of Facets, or views
	 * into a subset of that metadata, and that each such Facet consists of a set
	 * of key-value pairs.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	public class FacetKey
	{
		/**
		 * Constructor.
		 * 
		 * @param key The actual key encapsulated by this FacetKey.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function FacetKey(key:Object)
		{
			_key = key;
		}
		
		/**
		 * The actual key encapsulated by this FacetKey.  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function get key():Object
		{
			return _key;
		}
		
		/**
		 * Comparison function between FacetKeys.  All FacetKeys
		 * expose a comparison function so that the Facet knows how
		 * to distinguish between two FacetKeys.
		 * 
		 * Subclasses can override to provide custom comparison logic.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function equals(value:FacetKey):Boolean
		{
			return value != null ? key == value.key : false;  
		}
		
		private var _key:Object;
	}
}