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
	
	import org.osmf.containers.IMediaContainer;

	/**
	 * GatewayChangeEvent signals that a reference to an IGateway has changed.
	 */	
	public class GatewayChangeEvent extends Event
	{
		/**
		 * The GatewayChangeEvent.GATEWAY_CHANGE constant defines the value
		 * of the type property of the event object for a gatewayChange
		 * event.
		 * 
		 * @eventType GATEWAY_CHANGE
		 **/
		public static const GATEWAY_CHANGE:String = "gatewayChange";
		
		/**
		 * Constructor
		 * 
		 * @param type Event type.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 * @param oldValue Old IGateway reference.
		 * @param newValue New IGateway reference.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function GatewayChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, oldValue:IMediaContainer=null, newValue:IMediaContainer=null)
		{
			super(type, bubbles, cancelable);
			
			_oldValue = oldValue;
			_newValue = newValue;
		}
		
		/**
		 * Defines the old gateway reference.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get oldValue():IMediaContainer
		{
			return _oldValue;
		}
		
		/**
		 * Defines the new gateway reference.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get newValue():IMediaContainer
		{
			return _newValue;
		}
		
		// Overrides
		//
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new GatewayChangeEvent(type, bubbles, cancelable, _oldValue, _newValue);
		}
		
		// Internals
		//
		
		private var _oldValue:IMediaContainer;
		private var _newValue:IMediaContainer;
	}
}