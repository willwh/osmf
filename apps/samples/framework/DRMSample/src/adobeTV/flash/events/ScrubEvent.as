package adobeTV.flash.events
{
	
	import flash.events.Event;
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class ScrubEvent extends Event
	{
		
		
				
		////////////////////////
		///Public vars
		////////////////////////
		public static const SEEK_START:String = "SEEK_START_EVENT";//updated,created,deleted
		public static const SEEK_CHANGING:String = "SEEK_CHANGING_EVENT";//updated,created,deleted
		public static const SEEK_COMMITED:String = "SEEK_COMMITED_EVENT";//updated,created,deleted
		
		public function ScrubEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);	
			//trace("WBChildEvent fired  "+type);
		}
		
		public var percent:Number=-1;		
		
		
	}
	
}