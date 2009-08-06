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
	/**
	 * Clients can define new FacetTypes for their own view into the data.  Each facet type is marked by the IFacet 
	 * marker interface.  This is an enumeration.
	 */
	public class FacetType
	{
		/**
		 * Constructs a new FacetType.  Sould be done once per facet type, given this is an enumeration class.
		 */
		public function FacetType(type:String)
		{
			_type = type;
		}
		
		/**
		 * KeyValue facet is simliar to a dictionary, which uses key value pair matching to store data.
		 */
    	public static const KEY_VALUE_FACET:FacetType = new FacetType('keyValueFacet');
    	
    	private var _type:String;
	}
}