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
	import org.osmf.media.IMediaTrait;
	
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
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	[Event(name='authenticationComplete', type='org.osmf.events.ContentProtectionEvent')] 	
	 
	/**	 	
	 * Dispatches when an authentication attempt fails.
	 * 
	 * @eventType org.osmf.events.ContentProtectionEvent.AUTHENTICATION_FAILED
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name='authenticationFailed', type='org.osmf.events.ContentProtectionEvent')] 	 	
	
	/**
	 * IContentProtectable defines the trait interface for media which can be protected by
	 * digital rights management (DRM) technology.  Both anonymous and credential-based
	 * authentication are supported.
	 * 
	 * The workflow for media which is IContentProtectable is that the media undergoes
	 * some type of authentication, after which it is valid (i.e. able to be played)
	 * for a specific time window. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 	
	public interface IContentProtectable extends IMediaTrait
	{
		/**
		 * The required method of authentication.  Possible values are "anonymous"
		 * and "usernameAndPassword".
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		function get authenticationMethod():String;
		
		/**
		 * Authenticates the media.  Can be used for both anonymous and credential-based
		 * authentication.  If the media has already been authenticated, this is a no-op.
		 * 
		 * @param username The username.  Should be null for anonymous authentication.
		 * @param password The password.  Should be null for anonymous authentication.
		 * 
		 * @throws IllegalOperationError If the media is not initialized yet.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		function authenticate(username:String, password:String):void;
		
		/**
		 * Authenticates the media using an object which serves as a token.  Can be used
		 * for both anonymous and credential-based authentication.  If the media has
		 * already been authenticated, this is a no-op.
		 * 
		 * @param token The token to use for authentication.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		function authenticateWithToken(token:Object):void;
						
		/**
		 * Returns the start date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		function get startDate():Date;
		
		/**
		 * Returns the end date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		function get endDate():Date;
		
		/**
		 * Returns the length of the playback window, in seconds.  Returns NaN if
		 * authentication hasn't taken place.
		 * 
		 * Note that this property will generally be the difference between startDate
		 * and endDate, but is included as a property because there may be times where
		 * the duration is known up front, but the start or end dates are not (e.g. a
		 * one week rental).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		function get period():Number;
	}
}