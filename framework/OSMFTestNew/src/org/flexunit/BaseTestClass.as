package org.flexunit
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.flexunit.asserts.fail;

	public class BaseTestClass
	{
		public function BaseTestClass()
		{
		}
		
		// Utils
		//
		
		/**
		 * Asserts that a function throws an exception on being invoked.
		 * 
		 * @param f The function that's expected to throw an exception.
		 * @param arguments The arguments to pass to the function on its invocation.
		 * @return The result of the function invocation. 
		 * 
		 */		
		protected function assertThrows(f:Function, ...arguments):*
		{
			var result:*;
			
			try
			{
				result = f.apply(null,arguments);
				fail();
			}
			catch(e:Error)
			{	
			}
			
			return result;
		}
		
		/**
		 * Asserts that one or more events get dispatched on a function being
		 * invoked.
		 *  
		 * @param dispatcher The expected dispatcher of the events.
		 * @param types The types of the events that the dispatcher is expected to dispatch.
		 * @param f The function that's expected to trigger the event dispatching.
		 * @param arguments The arguments to pass to the function on its invocation.
		 * @return The result of the function invocation.
		 * 
		 */		
		protected function assertDispatches(dispatcher:EventDispatcher, types:Array, f:Function, ...arguments):*
		{
			var result:*;
			var dispatched:Dictionary = new Dictionary();
			function handler(event:Event):void
			{
				dispatched[event.type] = true;
			}
			
			var type:String;
			for each (type in types)
			{
				dispatcher.addEventListener(type, handler);
			}
			
			result = f.apply(null, arguments);
			
			for each (type in types)
			{
				dispatcher.removeEventListener(type, handler);
			}
			
			for each (type in types)
			{
				if (dispatched[type] != true)
				{
					fail("Event of type " + type + " was not fired.");
				}
			}
			
			return result;
		}
	}
}