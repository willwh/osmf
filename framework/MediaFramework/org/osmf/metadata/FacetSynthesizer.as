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
	import org.osmf.composition.CompositionMode;
	import org.osmf.utils.URL;
	
	/**
	 * Defines an algorithm that can synthesize a facet value
	 * from any number of facet values of a given namespace, in
	 * the context of a parent MetaData, FacetGroup, CompositionMode, 
	 * and active MetaData context.
	 */	
	public class FacetSynthesizer
	{
		/**
		 * Constructor
		 * 
		 * @param nameSpace Defines the namespace of the facet values
		 * that the synthesizer can interpret.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public function FacetSynthesizer(nameSpace:URL)
		{
			_namespaceURL = nameSpace;
		}
		
		
		/**
		 * Defines the namespace of the facet values that the synthesizer
		 * can interpret.
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
		 * Synthesizes a facet value from the passed arguments.
		 * 
		 * If the specified mode is SERIAL, then active metadata's facet of the synthesizer's
		 * type will be returned as the synthesized facet.
		 * 
		 * If the specified mode is PARALLEL, then the synthesized facet value will be null,
		 * unless the facet group contains a single child, in which case the single child is
		 * what is return as the synthesized facet.
		 * 
		 * @param targetMetadata The metadata instance that will have the synthesized value appended.
		 * @param facetGroup The collection of facets the synthesized value should be based on.
		 * @param mode The mode of synthesizes that should be applied.
		 * @param activeMetadata If the targetMetadata value belongs to a SerialElement this value
		 * references the metadata of its currently active child.
		 * @return The synthesized value.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function synthesize
							( targetMetadata:Metadata
							, facetGroup:FacetGroup
							, mode:CompositionMode
							, activeMetadata:Metadata
							):IFacet
		{	
			var result:IFacet;
			
			if (mode == CompositionMode.SERIAL && activeMetadata)
			{
				// Return the currently active facet:
				result = activeMetadata.getFacet(_namespaceURL);
			}
			else // mode is PARALLLEL
			{
				// If the facet group contains a single facet, then
				// return that as the synthesized facet. Otherwise
				// return null:
				result
					= (facetGroup && facetGroup.length == 1)
						? facetGroup.getFacetAt(0)
						: null;
			}
			
			return result;
		}

		// Internals
		//
		
		private var _namespaceURL:URL;
	}
}