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
package org.osmf.utils
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	[ExcludeClass]
		
	/**
	 * @private
	 * 
	 * Utility class that captures the boiler plate code that is required
	 * for a class to implement a read-only property who's value is controlled
	 * by an outside entity that emits change events on the property bearing
	 * class.
	 */	
	public class ExternalProperty
	{
		public function ExternalProperty(dispatcher:IEventDispatcher, event:String)
		{
			this.dispatcher = dispatcher;
			
			dispatcher.addEventListener
				( event
				, onPropertyChange
				, false
				, Number.MAX_VALUE
				);
		}
		
		public function get value():Object
		{
			return _value;
		}

		// Internals
		//
		
		private var dispatcher:IEventDispatcher;
		private var _value:Object;
		
		private function onPropertyChange(event:Event):void
		{
			if	(	_value == event["oldValue"]
				&&	_value != event["newValue"]
				)
			{
				_value = event["newValue"];
			}
		}
	}
}