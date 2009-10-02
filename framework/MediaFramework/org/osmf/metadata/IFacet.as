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
	import flash.events.IEventDispatcher;
	
	import org.osmf.utils.URL;
	 
     /**
	 * Signals that all of the IFacets's values have changed.
	 * 
	 * @eventType org.osmf.events.FacetEvent.VALUE_ADD
	 */
     [Event(name='facetValueAdd', type='org.osmf.events.FacetValueEvent')]
	
     /**
	 * Signals that all of the IFacets's values have changed.
	 * 
	 * @eventType org.osmf.events.FacetEvent.VALUE_REMOVE
	 */
     [Event(name='facetValueRemove', type='org.osmf.events.FacetEvent')]
	
     /**
	 * Signals that all of the IFacets's values have changed.
	 * 
	 * @eventType org.osmf.events.FacetChangeEvent.VALUE_CHANGE
	 */
     [Event(name='facetValueChange', type='org.osmf.events.FacetChangeEvent')]
	
	/**
	 * The interface for all concrete classes that hold metadata relating to Open Source Media Framework media. 
	 * Metadata is descriptive information relative to a piece of media.  
	 * Examples of metadata classes include DictionaryMetadata and XMPMetadata.  
	 * These classes are stored on all IMediaResources as initial information relating to the media.  
	 * They are also stored on the MediaElement for per element, possibly dynamic metadata.
	 * Example of metadata content include: title, size, language, and subject.  
	 */  
	public interface IFacet extends IEventDispatcher
	{		
		/**
		 * The namespace that corresponds to the schema for this metadata.
		 */ 
		function get namespaceURL():URL;	
		
		/**
		 * Method returning the value that belongs to the passed identifier.
		 * 
		 * Returns 'undefined' if the facet fails to resolve the identifier.
		 */

		function getValue(identifier:IIdentifier):*;
		
		/**
		 * Merge takes a number of child facets, and merge them into a single facet that includes this facet.  This should return a new facet.  This is used to bubble up
		 * metadata in compositions. 
		 */ 
		function merge(childFacet:IFacet):IFacet;
		
	}
}