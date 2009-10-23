package adobeTV.flash.events
{	
	import flash.events.Event;
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class CCEvent extends Event
	{
		
		
				
		////////////////////////
		///Public vars
		////////////////////////
		public static const URL_MISSING:String = "URL_MISSING_EVENT";//updated,created,deleted
		
		public function CCEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);	
			//trace("WBChildEvent fired  "+type);
		}
			
		
		
	}
	
}