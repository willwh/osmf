package org.osmf.utils
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
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