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
	import org.openvideoplayer.metadata.MetadataNamespaces;
	import org.openvideoplayer.metadata.ObjectFacet;

	/**
	 * The RegionTargetFacet is a facet that holds a single value of type
	 * IFacet.
	 */	
	public class RegionTargetFacet extends ObjectFacet
	{
		/**
		 * Constructor
		 * 
		 * @param region The IFacet value that this facet holds.
		 * 
		 */		
		public function RegionTargetFacet(region:IRegion)
		{
			super(MetadataNamespaces.REGION_TARGET, region);
		}
		
		// Public API
		//
		
		public function get region():IRegion
		{
			return _object as IRegion;
		}
	}
}