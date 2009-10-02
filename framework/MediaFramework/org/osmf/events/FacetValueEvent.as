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
	import flash.events.Event;
	
	import org.osmf.metadata.IIdentifier;

	/**
	 * The FacetValue change event is used to listen for changes to values within the
	 * Facets.  The identifier, value, and namespace are all dispatched with this event.
	 */ 
	public class FacetValueEvent extends Event
	{
		
		/**
		 * Dispatched when a value is added to a IFacet.
		 */ 
		public static const VALUE_ADD:String = "facetValueAdd";
		
		/**
		 * Dispatched when a value is removed from a IFacet.
		 */ 
		public static const VALUE_REMOVE:String = "facetValueRemove";
				
		/**
		 * Constructs a new FacetValueEvent, which signals changes to a Facets values.
		 */ 
		public function FacetValueEvent(identifier:IIdentifier, value:*, type:String)
		{		
			super(type);
			_identifier = identifier;			
			_value = value;
		}	
		
		/**
		 * The unique identifier for this key in the facet's
		 * collection.
		 */ 
		public function get identifier():IIdentifier
		{
			return _identifier;
		}
				
		/**
		 * For add events, the new value that has been added to the facet.
		 * For remove event, the value removed from the facet.
		 * For change events, the new value replacing the old value.
		 */ 
		public function get value():*
		{
			return _value;
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function clone():Event
		{
			return new FacetValueEvent(_identifier, _value, type);
		}
				
		private var _identifier:IIdentifier;			
		private var _value:*;
		
	}
}