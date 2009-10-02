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
package org.osmf.events
{
	import org.osmf.metadata.IFacet;
	import org.osmf.metadata.IIdentifier;

	/**
	 * FacetValueChangeEvent is the event dispatched when the data within a facet changes.
	 * Data is tracked within an IFacet using an IIdentifier.  The newly changed value is also present in this 
	 * event, as well as the old value.
	 */ 
	public class FacetValueChangeEvent extends FacetValueEvent
	{
		/**
		 * Dispatched when a value is updated on a IFacet.
		 */ 
		public static const VALUE_CHANGE:String = "facetValueChange";
		
		public function FacetValueChangeEvent(identifier:IIdentifier, value:*, oldValue:*)
		{
			super(identifier, value, VALUE_CHANGE);
			_oldValue = oldValue;
		}
		
		/**
		 * @returns the value of the 
		 */ 
		public function get oldValue():*
		{
			return _oldValue;
		}
		
		private var _oldValue:*;
		
	}
}