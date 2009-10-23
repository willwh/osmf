package adobeTV.flash.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class PlayerEvent extends Event
	{
				
		////////////////////////
		///Public vars
		////////////////////////
		public static const PLAYHEAD_UPDATE:String = "PLAYHEAD_UPDATE_EVENT";//updated,created,deleted
		public static const PLAYHEAD_SEEK:String = "PLAYHEAD_SEEK_EVENT";//updated,created,deleted
		public static const PLAYER_LOGO:String = "PLAYER_LOGO_EVENT";//updated,created,deleted
		public static const PLAYER_LOAD_NOADS:String = "PLAYER_LOAD_NOADS_EVENT";//updated,created,deleted
		
		public function PlayerEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);	
			//trace("WBChildEvent fired  "+type);
		}
		
		
		
		public var total:Number;	
		public var current:Number;
		public var available:Number;
		public var enabled:Boolean;
		public var isProgressive:Boolean;
		
		
		
		
	}
	
}