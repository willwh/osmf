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
	 * FacetValueChangeEvent is the event dispatched when the data within a facet changes.
	 * Data is tracked within an IFacet using an IIdentifier.  The newly changed value is also present in this 
	 * event, as well as the old value.
	 */ 
	public class FacetValueChangeEvent extends FacetValueEvent
	{
		/**
		 * The FacetValueChangeEvent.VALUE_CHANGE constant defines the value
		 * of the type property of the event object for a facetValueChange
		 * event.
		 * 
		 * @eventType VALUE_CHANGE
		 **/
		public static const VALUE_CHANGE:String = "facetValueChange";
		
		/**
		 * Constructor.
		 * 
		 * @param type Event type.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 * @param identifier The unique identifier for this key in the facet's collection.
		 * @param value The affected value.
		 * @param oldValue The previous value.
		 **/
		public function FacetValueChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, identifier:IIdentifier=null, value:*=null, oldValue:*=null)
		{
			super(type, bubbles, cancelable, identifier, value);
			
			_oldValue = oldValue;
		}
		
		/**
		 * The previous value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get oldValue():*
		{
			return _oldValue;
		}
		
		/**
		 * @private
		 */ 
		override public function clone():Event
		{
			return new FacetValueChangeEvent(type, bubbles, cancelable, identifier, value, _oldValue);
		}

		private var _oldValue:*;
	}
}