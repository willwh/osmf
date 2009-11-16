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
	import org.osmf.events.ContentProtectionEvent;
	import org.osmf.events.MediaError;
	
	/**
	 * Dispatched when either anonymous or credential-based authentication is needed in order
	 * to playback the media.
	 *
	 * @eventType org.osmf.events.ContentProtectionEvent.AUTHENTICATION_NEEDED
 	 */ 
	[Event(name='authenticationNeeded', type='org.osmf.events.ContentProtectionEvent')]
	
	/**
	 * Dispatched when an authentication attempt succeeds.
	 * 
	 * @eventType org.osmf.events.ContentProtectionEvent.AUTHENTICATION_COMPLETE
	 */ 
	[Event(name='authenticationComplete', type='org.osmf.events.ContentProtectionEvent')] 	
	 
	/**	 	
	 * Dispatches when an authentication attempt fails.
	 * 
	 * @eventType org.osmf.events.ContentProtectionEvent.AUTHENTICATION_FAILED
	 */
	[Event(name='authenticationFailed', type='org.osmf.events.ContentProtectionEvent')] 	 	
	
	/**
	 * The ContentProtectableTrait class provides a base IContentProtectable
	 * implementation.  It can be used as the base class for a more specific
	 * ContentProtectableTrait subclass or as is by a media element that listens
	 * for and handles its change events.
	 */	
	public class ContentProtectableTrait extends MediaTraitBase implements IContentProtectable 
	{
		/**
		 * Constructor.
		 */ 
		public function ContentProtectableTrait()
		{
			super();
		}
		
		/**
		 * Must be called by the implementing media on completing authentication.  Dispatches
		 * the change event.
		 */		
		final public function processAuthenticateCompletion(success:Boolean, token:Object, error:MediaError):void
		{
			dispatchEvent
				( new ContentProtectionEvent
					( success ? ContentProtectionEvent.AUTHENTICATION_COMPLETE : ContentProtectionEvent.AUTHENTICATION_FAILED
					, false
					, false
					, token
					, error
					)
				);
		}
		
		/**
		 * @inheritDoc
		 */ 		
		public function get authenticationMethod():String
		{
			return _authenticationMethod;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function authenticate(username:String, password:String):void
		{
			if (canProcessAuthenticate())
			{
				processAuthenticate(username, password);
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function authenticateWithToken(token:Object):void
		{							
			if (canProcessAuthenticateWithToken())
			{
				processAuthenticateWithToken(token);
			}
		}

		/**
		 * @inheritDoc
		 */	
		public function get startDate():Date
		{
			return _startDate;
		}
		
		/**
		 * @inheritDoc
		 */	
		public function get endDate():Date
		{
			return _endDate;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get period():Number
		{
			return _period;
		}
		
		/**
		 * Called before the <code>processAuthenticate</code> method is called.
		 *  
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 */		
		protected function canProcessAuthenticate():Boolean
		{							
			return true;
		}
		
		/**
		 * Called before the <code>processAuthenticateWithToken</code> method is called.
		 * 
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 */		
		protected function canProcessAuthenticateWithToken():Boolean
		{							
			return true;
		}
		
		/**
		 * Called immediately before the <code>authenticationState</code> property is changed
		 * in response to a call to authenticate.
		 * 
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *
		 * @param username The username for the authentication request.
		 * @param password The password for the authentication request.
		 */		
		protected function processAuthenticate(username:String, password:String):void
		{							
		}
		
		/**
		 * Called immediately before the <code>authenticationState</code> property is changed
		 * in response to a call to authenticateWithToken.
		 * 
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *
		 * @param username The username for the authentication request.
		 * @param password The password for the authentication request.
		 */		
		protected function processAuthenticateWithToken(token:Object):void
		{							
		}
		
		private var _authenticationMethod:String;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _period:Number;
	}
}