package adobeTV.flash.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class BufferEvent extends Event
	{
				
		////////////////////////
		///Public vars
		////////////////////////
		public static const BUFFER_CHANGE:String = "BUFFER_CHANGE_EVENT"
		
		public function BufferEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);	
			//trace("WBChildEvent fired  "+type);
		}
		
		
		
		public var available:Number;
		
		
		
		
	}
	
}