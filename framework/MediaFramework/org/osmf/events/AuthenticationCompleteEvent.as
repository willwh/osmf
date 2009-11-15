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
package org.osmf.events
{
	import flash.events.Event;
	
	/**
	 * @private
	 * TODO: Remove private label when DRM content / 10.1 content is exposed
	 * Dispatched by the IContentProtectableTrait to signal successful authentication
	 * with for playing back this media.  contains a token which can be used later to speed up the 
	 * authentication process by passing to authenticateWithToken.
	 */ 
	public class AuthenticationCompleteEvent extends Event
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