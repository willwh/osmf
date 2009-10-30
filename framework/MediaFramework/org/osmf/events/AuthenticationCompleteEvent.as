package org.osmf.events
{
	import flash.events.Event;
	
	/**
	 * Dispatched by the IContentProtectableTrait to signal successful authentication
	 * with for playing back this media.  contains a token which can be used later to speed up the 
	 * authentication process by passing to authenticateWithToken.
	 */ 
	public class AuthenticationCompleteEvent extends TraitEvent
	{
		/**
		 * Authentication Complete is dispatched when a user can successfully playback encrypted
		 * content.  This event is dispatched for anonymous authentication as well as credential based.
		 *  
		 * @eventType AUTHENTICATION_COMPLETE 
		 */ 
		public static const AUTHENTICATION_COMPLETE:String = "authenticationComplete";
		
		
		public function AuthenticationCompleteEvent(token:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(AUTHENTICATION_COMPLETE, bubbles, cancelable);
			_token = token;
		}
		
		public function get token():Object
		{
			return _token;
		}
		
		override public function clone():Event
		{
			return new AuthenticationCompleteEvent(_token);
		}
		
		
		private var _token:Object
	}
}