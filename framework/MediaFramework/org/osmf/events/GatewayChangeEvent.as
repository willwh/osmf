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
	
	import org.osmf.media.IMediaGateway;

	/**
	 * GatewayChangeEvent signals that a reference to an IGateway has changed.
	 */	
	public class GatewayChangeEvent extends Event
	{
		public static const GATEWAY_CHANGE:String = "gatewayChange";
		
		/**
		 * Constructor
		 *  
		 * @param oldValue Old IGateway reference.
		 * @param newValue New IGateway reference.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */		
		public function GatewayChangeEvent(oldValue:IMediaGateway, newValue:IMediaGateway, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(GATEWAY_CHANGE, bubbles, cancelable);
			
			_oldValue = oldValue;
			_newValue = newValue;
		}
		
		/**
		 * Defines the old gateway reference.
		 */		
		public function get oldValue():IMediaGateway
		{
			return _oldValue;
		}
		
		/**
		 * Defines the new gateway reference.
		 */		
		public function get newValue():IMediaGateway
		{
			return _newValue;
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new GatewayChangeEvent(_oldValue, _newValue, bubbles, cancelable);
		}
		
		// Internals
		//
		
		private var _oldValue:IMediaGateway;
		private var _newValue:IMediaGateway;
	}
}