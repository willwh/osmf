package adobeTV.flash.events
{

	
		import flash.events.Event;	
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class ScreenDimensionEvent  extends Event
	{
		
		////////////////////////
		///Public vars
		////////////////////////
		public static const SCREEN_MODE_UPDATE:String = "SCREEN_MODE_UPDATE_EVENT";//updated,created,deleted
		
		
		public function ScreenDimensionEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);	
			//trace("WBChildEvent fired  "+type);
		}
		
		
		public var mode:int;
		public var scale:int;	
		public var enabled:Boolean;
		
		
	
	
	//END CLASS
	}
}