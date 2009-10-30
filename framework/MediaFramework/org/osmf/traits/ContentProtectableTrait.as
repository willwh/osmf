/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.traits
{
	import flash.utils.ByteArray;
	
	/**
	 * Dispatched when username password  or token authentication is needed to playback.
	 *
	 * @eventType org.osmf.events.TraitEvent.AUTHENTICATION_NEEDED
 	 */ 
	[Event(name='authenticationNeeded', type='org.osmf.events.TraitEvent')]
	
	/**
	 * Dispatched when the user is authenticated successfully
	 * 
	 * @eventType org.osmf.events.AuthenticationCompleteEvent.AUTHENTICATION_COMPLETE
	 */ 
	[Event(name='authenticationComplete', type='org.osmf.events.AuthenticationCompleteEvent')] 	
	 
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
		public function authenticateWithToken(token:Object):void
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
		 * Returns the length of the playback window.  Returns NaN if authentication 
		 * hasn't taken place.
		 */		
		public function get period():Number
		{
			return NaN;
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
		protected function canProcessAuthenticateWithToken(token:Object):Boolean
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
		protected function processAuthenticateWithToken(token:Object):void
		{							
			//Overrride with DRM specific code
		}

		
	}
}