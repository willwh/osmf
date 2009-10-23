package org.osmf.traits
{
	import flash.utils.ByteArray;
	import org.osmf.media.IMediaTrait;
	
	
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
	 * The IContentProtectable trait is placed upon media elements that have content protection
	 * in place. Anonymous and Credential based schemes are supported.  Infomation such as playbackTimeWindow is available
	 * once the authentication takes place. 
	 */ 	
	public interface IContentProtectable extends IMediaTrait
	{
		/**
		 * The type of authentication required to obtain a voucher for the associated content.
		 * The supported types of authentication are:			
		 * AuthenticationMethod.ANONYMOUS — anyone can obtain a voucher.
		 * AuthenticationMethod.USERNAME_AND_PASSWORD — the user must supply a valid username and password of an account that is authorized to view the associated content.
		 * The AuthenticationMethod class provides string constants to use with the authenticationMethod property.
		 */ 
		function get authenticationMethod():String;
		
		/**
		 * Authenticates a user using a username and password.
		 */ 
		function authenticate(username:String, password:String):void;
		
		/**
		 * Authenticates a user using a byte array, which serves as a token.
		 */ 
		function authenticateWithToken(token:ByteArray):void;
				
		/**
		 * Returns the start date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */	
		function get startDate():Date;
		
		/**
		 * Returns the end date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */	
		function get endDate():Date;
		
		/**
		 * Returns the length of the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */		
		function get period():int;
				
	}
}