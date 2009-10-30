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
	 * Authentication Failed event is fired by the IContentProtectable trait in response to a failure 
	 * getting content decrypted.   The specific information about the failure is in the detail and error
	 * id fields.
	 */ 
	public class AuthenticationFailedEvent extends Event
	{
		/**
		 * Signaled when authentication fails on the IContentProtectable trait.
		 */ 
		public static const AUTHENTICATION_FAILED:String = "authenticationFailed";
		
		/**
		 * Constructs a new AuthenticationFailed event with the specified error id and detail information.
		 */ 
		public function AuthenticationFailedEvent(errorID:int, detail:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(AUTHENTICATION_FAILED, bubbles, cancelable);
			_detail = detail;
			_errorID = errorID;
		}
		
		/**
		 * The specific code the corresponds to the Error.
		 */ 
		public function get errorID():int
		{
			return _errorID;
		}
		
		/**
		 * The human readable description of the Error.
		 */ 
		public function get detail():String
		{
			return _detail;
		}
		
		override public function clone():Event
		{
			return new AuthenticationFailedEvent(_errorID, _detail, bubbles, cancelable);
		}
		
		
		private var _errorID:int;
		private var _detail:String;
		
	}
}