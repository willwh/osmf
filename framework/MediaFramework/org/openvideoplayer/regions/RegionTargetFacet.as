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
package org.openvideoplayer.regions
{
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.metadata.IFacet;
	import org.openvideoplayer.metadata.IIdentifier;
	import org.openvideoplayer.metadata.MetadataNamespaces;
	import org.openvideoplayer.utils.URL;

	/**
	 * The RegionTargetFacet is a facet that holds a single value of type
	 * IFacet.
	 */	
	public class RegionTargetFacet extends EventDispatcher implements IFacet
	{
		/**
		 * Constructor
		 * 
		 * @param region The IFacet value that this facet holds.
		 * 
		 */		
		public function RegionTargetFacet(region:IRegion)
		{
			_region = region;
		}
	
		// IFacet
		//
	
		/**
		 * @inheritDoc
		 */		
		public function get namespaceURL():URL
		{
			return MetadataNamespaces.REGION_TARGET;
		}
		
		/**
		 * Always returns the region value that this facet holds.
		 *
		 * @inheritDoc
		 */
		public function getValue(identifyer:IIdentifier):*
		{
			return _region;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function merge(childFacet:IFacet):IFacet
		{
			return null;
		}
		
		// Public API
		//
		
		public function get region():IRegion
		{
			return _region;
		}
		
		// Internals
		//
		
		private var _region:IRegion;
		
	}
}