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
	
	import org.openvideoplayer.utils.URL;
	
	/**
	 * The metadata collection represents the container that holds the various metadata classes associated with a MediaElement.
	 */ 
	public interface IMetadata
	{	
		
		/** 
		 * Returns the type of facet supported by this resource.  We could
		 * support multiple if need be, but it would complicate usage.
		 * 
		 * @param nameSpace The Namespace to search for facet types.
		 */ 
		function getFacetTypes(nameSpace:URL):Vector.<FacetType>;
		 
		/** 
		 * Returns the facet of the given type, for data of the given namespace,
		 * null if none exists.  The result can be cast to the class represented
		 * by FacetType (similar to how we cast traits after calling getTrait).
		 */ 
		function getFacet(nameSpace:URL, facetType:FacetType):IFacet;
				
		/** 
		 * Returns adds a facet of the given type for data of the given namespace.
		 * Will overwrite an existing Facet (acts as update), with the same type and same namespace.
		 * 
		 * @param value the facet to add
		 * 
		 * @throws IllegalOperation if the data or namespace is null.
		 */ 
		function addFacet(value:IFacet):void;
		
		/**
		 * Removes the given facet from the specified namespace.  
		 * 
		 * @param The facet to remove.
		 * 
		 * @returns The removed facet.  Null if value is not in this IMetadata.
		 * 
		 * @throws IllegalOperation if the data or namespace is null.
		 */ 
		function removeFacet(value:IFacet):IFacet;	
	}
}