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
	 * TODO: Remove private tag when DRM content / 10.1 content is public.
	 * 
	 * A ContentProtectionEvent is dispatched when a ContentProtectionTrait's properties change.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0	 
	 */ 
	public class ContentProtectionEvent extends Event
	{
		/**
		 * The ContentProtectionEvent.AUTHENTICATION_NEEDED constant defines the value
		 * of the type property of the event object for an authenticationNeeded
		 * event.
		 * 
		 * @eventType AUTHENTICATION_NEEDED
		 **/
		public static const AUTHENTICATION_NEEDED:String = "authenticationNeeded";

		/**
		 * The ContentProtectionEvent.AUTHENTICATION_COMPLETE constant defines the value
		 * of the type property of the event object for an authenticationComplete
		 * event.
		 * 
		 * @eventType AUTHENTICATION_COMPLETE
		 **/
		public static const AUTHENTICATION_COMPLETE:String = "authenticationComplete";
		
		/**
		 * The ContentProtectionEvent.AUTHENTICATION_FAILED constant defines the value
		 * of the type property of the event object for an authenticationFailed
		 * event.
		 * 
		 * @eventType AUTHENTICATION_FAILED
		 **/
		public static const AUTHENTICATION_FAILED:String = "authenticationFailed";

		/**
		 * Constructor.
		 * 
		 * @param type The type of the event.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented.
		 * @param token The token returned as a result of a successful authentication.
		 * @param error The error that describes an authentication failure.
		 **/
		public function ContentProtectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, token:Object=null, error:MediaError=null)
		{
			super(type, bubbles, cancelable);
			
			_token = token;
			_error = error;
		}
		
		/**
		 * The token returned as a result of a successful authentication.
		 **/
		public function get token():Object
		{
			return _token;
		}

		/**
		 * The error that describes an authentication failure.
		 **/
		public function get error():MediaError
		{
			return _error;
		}
		
		/**
		 * @private
		 **/
		override public function clone():Event
		{
			return new ContentProtectionEvent(type, bubbles, cancelable, _token, _error);
		}
		
		
		private var _token:Object;
		private var _error:MediaError;
	}
}