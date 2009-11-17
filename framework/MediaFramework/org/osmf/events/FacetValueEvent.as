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
		 * The FacetValueEvent.VALUE_ADD constant defines the value
		 * of the type property of the event object for a facetValueAdd
		 * event.
		 * 
		 * @eventType VALUE_ADD
		 **/
		public static const VALUE_ADD:String = "facetValueAdd";
		
		/**
		 * The FacetValueEvent.VALUE_REMOVE constant defines the value
		 * of the type property of the event object for a facetValueRemove
		 * event.
		 * 
		 * @eventType VALUE_REMOVE
		 **/
		public static const VALUE_REMOVE:String = "facetValueRemove";
				
		/**
		 * Constructor.
		 * 
		 * @param type Event type.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 * @param identifier The unique identifier for this key in the facet's collection.
		 * @param value The affected value.
		 **/
		public function FacetValueEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, identifier:IIdentifier=null, value:*=null)
		{		
			super(type, bubbles, cancelable);
			
			_identifier = identifier;			
			_value = value;
		}	
		
		/**
		 * The unique identifier for this key in the facet's
		 * collection.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get identifier():IIdentifier
		{
			return _identifier;
		}
				
		/**
		 * For add events, the new value that has been added to the facet.
		 * For remove event, the value removed from the facet.
		 * For change events, the new value replacing the old value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get value():*
		{
			return _value;
		}
		
		/**
		 * @private
		 */ 
		override public function clone():Event
		{
			return new FacetValueEvent(type, bubbles, cancelable, _identifier, _value);
		}
				
		private var _identifier:IIdentifier;			
		private var _value:*;
	}
}