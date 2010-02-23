/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.traits
{
	/**
	 * DRMState specifies the different DRM states a piece of media can be in.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	public final class DRMState
	{		
		/**
		 * The DRMTrait is preparing to use the DRM
		 * for media playback.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public static const UNINITIALIZED:String 			= "uninitialized"; 
		
		/**
		 * The DRMTrait needs credential-based authentication.  Call authenticate()
		 * on the DRMTrait to provide authentication.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public static const AUTHENTICATION_NEEDED:String	= "authenticationNeeded"; 
		
		/**
		 * The DRMTrait is authenticating when the authentication 
		 * information has been received and the DRM subsystem
		 * is in the process of validating the credentials.  If
		 * the media is anonymously authenticated, the DRM subsystem
		 * is validating that the content is still valid to play.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public static const AUTHENTICATING:String	 		= "authenticating";
		
		/**
		 * The authenticated state is entered when the right to
		 * play back the media has been received.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public static const AUTHENTICATION_COMPLETE:String			= "authenticationComplete"; 
		
		/**
		 *  The authentication attempt failed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public static const AUTHENTICATION_ERROR:String		= "authenticationError";
		
		/**
		 *  The DRM subsystem is updating itself.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public static const DRM_SYSTEM_UPDATING:String					= "drmSystemUpdating";

	}
}