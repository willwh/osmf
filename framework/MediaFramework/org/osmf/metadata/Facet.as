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
	import flash.events.EventDispatcher;
	
	import org.osmf.utils.URL;
	 
     /**
	 * Signals that all of the Facets's values have changed.
	 * 
	 * @eventType org.osmf.events.FacetEvent.VALUE_ADD
	 */
     [Event(name='facetValueAdd', type='org.osmf.events.FacetValueEvent')]
	
     /**
	 * Signals that all of the Facets's values have changed.
	 * 
	 * @eventType org.osmf.events.FacetEvent.VALUE_REMOVE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
     [Event(name='facetValueRemove', type='org.osmf.events.FacetEvent')]
	
     /**
	 * Signals that all of the Facets's values have changed.
	 * 
	 * @eventType org.osmf.events.FacetValueChangeEvent.VALUE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
     [Event(name='facetValueChange', type='org.osmf.events.FacetValueChangeEvent')]
	
	/**
	 * The base class for all classes that hold metadata relating to Open Source Media Framework media. 
	 * Metadata is descriptive information relative to a piece of media.  
	 * Examples of metadata classes include DictionaryMetadata and XMPMetadata.  
	 * These classes are stored on all IMediaResources as initial information relating to the media.  
	 * They are also stored on the MediaElement for per element, possibly dynamic metadata.
	 * Example of metadata content include: title, size, language, and subject.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */  
	public class Facet extends EventDispatcher
	{		
		/**
		 * Constructs a new facet with the specified namespace url.
		 */ 
		public function Facet(namespaceURL:URL)
		{
			_namespaceURL = namespaceURL;
		}
		
		/**
		 * The namespace that corresponds to the schema for this metadata.
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
		 * Method returning the value that belongs to the passed identifier.
		 * 
		 * Returns 'undefined' if the facet fails to resolve the identifier.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */

		public function getValue(identifier:IIdentifier):*
		{
			return null;
		}
		
		/**
		 * Defines the facet synthesizer that will be used by default to
		 * synthesize a new value based on a group of facets that share
		 * the namespace that this facet is registered under.
		 * 
		 * Note that facet synthesizers that get set on the facet's parent
		 * take precedence over the one that is defined here.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get synthesizer():FacetSynthesizer
		{
			return null;
		}
		
		private var _namespaceURL:URL;
	}
}