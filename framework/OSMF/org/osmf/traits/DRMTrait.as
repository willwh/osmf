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

	import org.osmf.drm.DRMState;
	import org.osmf.events.DRMEvent;
	import org.osmf.events.MediaError;
	
	/**
	 * Dispatched when either anonymous or credential-based authentication is needed in order
	 * to playback the media.
	 *
	 * @eventType org.osmf.events.DRMEvent.DRM_STATE_CHANGE
 	 *  
 	 *  @langversion 3.0
 	 *  @playerversion Flash 10.1
 	 *  @playerversion AIR 1.5
 	 *  @productversion OSMF 1.0
 	 */ 
	[Event(name='drmStateChange', type='org.osmf.events.DRMEvent')]
				
	/**
	 * DRMTrait defines the trait interface for media which can be
	 * protected by digital rights management (DRM) technology.  It can also be
	 * used as the base class for a more specific DRMTrait subclass.
	 * 
	 * Both anonymous and credential-based authentication are supported.
	 * 
	 * The workflow for media which has a DRMTrait is that the media undergoes
	 * some type of authentication, after which it is valid (i.e. able to be played)
	 * for a specific time window.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 	
	public class DRMTrait extends MediaTraitBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function DRMTrait()
		{
			super(MediaTraitType.DRM);
		}
		
		/**
		 * The required method of authentication.  Possible values are "anonymous"
		 * and "usernameAndPassword".  The default is "".  This method should be override by
		 * subclasses.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function get authenticationMethod():String
		{
			return "";
		}
		
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
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function authenticate(username:String = null, password:String = null):void
		{
		}
		
		/**
		 * Authenticates the media using an object which serves as a token.  Can be used
		 * for both anonymous and credential-based authentication.  If the media has
		 * already been authenticated, this is a no-op.
		 * 
		 * @param token The token to use for authentication.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function authenticateWithToken(token:Object):void
		{							
		}
		
		/**
		 * The current state of the DRM for this media.  The states are explained
		 * in the DRMState enumeration in the org.osmf.drm package.
		 * @see DRMState
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get drmState():String
		{
			return _drmState;
		}  

		/**
		 * Returns the start date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get startDate():Date
		{
			return _startDate;
		}
		
		/**
		 * Returns the end date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get endDate():Date
		{
			return _endDate;
		}
		
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
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get period():Number
		{
			return _period;
		}
		
		/**
		 * Returns the URL of the server used to manage this content's DRM.  Returns "" if
		 * the server is unknown.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */				
		public function get serverURL():String
		{
			return _serverURL;
		}
				
		// Internals
		//
		
		/**
		 * Must be called by the implementing drm subsystem classes.  
		 * Dispatches the change event, as well as updates the start,
		 * end, period values.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected final function drmStateChange(newState:String, token:Object, error:MediaError, start:Date=null, end:Date=null, period:Number=0, serverURL:String = null):void
		{
			_drmState = newState;
			_serverURL = serverURL;
			_period = period;	
			_endDate = end;	
			_startDate = start;
			dispatchEvent
				( new DRMEvent
					( DRMEvent.DRM_STATE_CHANGE,
					newState,
					false,
					false,
					_startDate,
					_endDate,
					_period,
					_serverURL,
					token,
					error					
					)
				);
		}
		
		private var _serverURL:String;
		private var _drmState:String = DRMState.INITIALIZING;	
		private var _period:Number = 0;	
		private var _endDate:Date;	
		private var _startDate:Date;	
		
			
	}
}