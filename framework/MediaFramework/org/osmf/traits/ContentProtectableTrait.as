package org.osmf.traits
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import org.osmf.events.TraitEvent;
	
	/**
	 * Dispatched when username password  or token authentication is needed to playback.
	 *
	 * @eventType org.osmf.events.TraitEvent.AUTHENTICATION_NEEDED
 	 */ 
	[Event(name='authenticationNeeded', type='org.osmf.events.TraitEvent')]
	
	/**
	 * Dispatched when the user is authenticated successfully
	 * 
	 * @eventType org.osmf.events.TraitEvent.AUTHENTICATION_COMPLETE
	 */ 
	[Event(name='authenticationComplete', type='org.osmf.events.TraitEvent')] 	
	 
	/**	 	
	 * Dispatches when the authentication fails, with the reason being stored on the event.
	 * 
	 * @eventType org.osmf.events.AuthenticationFailedEvent.AUTHENTICATION_FAILED
	 */
	[Event(name='authenticationFailed', type='org.osmf.events.AuthenticationFailedEvent')] 	 	
	
	/**
	 * The default implementation of IContentProtectble.
	 */ 
	public class ContentProtectableTrait extends MediaTraitBase implements IContentProtectable 
	{
				
		/**
		 * Constructs a ContentProtectableTrait without The raw metadata describes the location of the voucher server, along 
		 * with other information about the license.
		 */ 
		public function ContentProtectableTrait()
		{
			
		}
		
		/**
		 * @inheritDoc
		 */ 		
		public function get authenticationMethod():String
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Authenticates a user in order to retrieve a voucher for a protected piece of content.
		 * @throws IllegalOperation error if the drmMetadata isn't set.
		 */ 
		public function authenticate(username:String, password:String):void
		{							
			if (canProcessAuthenticate(username,password))
			{
				processAuthenticate(username,password);
			}
		}
		
		/**
		 * Authenticates a user using a byte array, which serves as a token.
		 * 
		 * @throws IllegalOperation error if the drmMetadata isn't set.
		 */ 
		public function authenticateWithToken(token:ByteArray):void
		{							
			if (canProcessAuthenticateWithToken(token))
			{
				processAuthenticateWithToken(token);
			}
		}
		
		/**
		 * Returns the start date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */	
		public function get startDate():Date
		{
			return null;
		}
		
		/**
		 * Returns the end date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */	
		public function get endDate():Date
		{
			return null;
		}
		
		/**
		 * Returns the length of the playback window.  Returns -1 if authentication 
		 * hasn't taken place.
		 */		
		public function get period():int
		{
			return -1;
		}
		
		/**
		 * Overrride to allow conditional processing of authentication logic.
		 */ 
		protected function canProcessAuthenticate(username:String, password:String):Boolean
		{							
			return true;
		}
		
		/**
		 * Overrride to allow conditional processing of authentication logic.
		 */ 
		protected function canProcessAuthenticateWithToken(token:ByteArray):Boolean
		{							
			return true;
		}
		
		/**
		 * Overrride to provide authentication logic.
		 */ 
		protected function processAuthenticate(username:String, password:String):void
		{							
			//Overrride with DRM specific code
		}
		
		/**
		 * Overrride to provide authentication logic.
		 */ 
		protected function processAuthenticateWithToken(token:ByteArray):void
		{							
			//Overrride with DRM specific code
		}

		
	}
}