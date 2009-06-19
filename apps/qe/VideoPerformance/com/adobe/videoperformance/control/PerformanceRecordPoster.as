package com.adobe.videoperformance.control
{
	import com.adobe.videoperformance.model.Model;
	import com.adobe.videoperformance.model.PerformanceRecord;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * This class takes care of posting a performance record to the
	 * server.
	 * 
	 * The server's URL, and service path get fetched from the model
	 * (see Model.VIDEO_SERVER and Model.VIDEO_SERVICE).
	 * 
	 * To do a post, instantiate the class and invoke the 'post'
	 * method. To stay up to date on the posts outcome, you can
	 * register for the Event.COMPLETE event.
	 */	
	public class PerformanceRecordPoster extends EventDispatcher
	{
		// Public Interface
		//
		
		/**
		 * Posts a record to the server.
		 *  
		 * @param record The record to post.
		 * @return True if the post was successfully initiated.
		 * 
		 */
		public function post(record:PerformanceRecord):Boolean
		{
			var result:Boolean;
			
			if (_posting == false)
			{
				_succeeded = false;
				_posting = true;
				
				try
		 	 	 {
		 	 	 	var connection:NetConnection = new NetConnection();
					connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
					connection.objectEncoding = 0;
					
					connection.connect(Model.VIDEO_SERVER);
					connection.call(Model.VIDEO_SERVICE, new Responder(onPostResult,onPostStatus), record);
					
					result = true;
				}
				catch(e:Error)
				{
					_posting = false;
				}
			}
			
			return result;		
		}
		
		/**
		 * Determines if a post operation is currently in progress.
		 */		
		public function get posting():Boolean
		{
			return _posting;
		}
		
		/**
		 * Determines if the last attempted post operation completed
		 * successfully. Note that this value is initially toggled to
		 * 'false' upon a new post being initiated.
		 */		
		public function get succeeded():Boolean
		{
			return _succeeded;
		}
		
		// Internals
		//
		
		private var _posting:Boolean;
		private var _succeeded:Boolean;
		
		private function onPostResult(result:Object):void
		{
			_succeeded = true;
			_posting = false;
			
			dispatchEvent(new Event(Event.COMPLETE));
			
//			ExternalInterface.call("alert","Records posted!");
		}
		
		private function onPostStatus(status:Object):void
		{
			var msg:String = "PerformanceRecordPoster: onPostStatus:\n"
			for (var field:String in status)
			{
				msg += field + ' = ' + status[field];
			}
			ExternalInterface.call("alert",msg);
			
			_succeeded = false;
			_posting = false;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			ExternalInterface.call("alert","PerformanceRecordPoster: onSecurityError:\n"+event.text);
			
			_succeeded = false;
			_posting = false;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}