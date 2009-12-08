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
package org.osmf.net
{
	import flash.events.Event;
	
	CONFIG::FLASH_10_1
	{
	import org.osmf.drm.DRMServices;
	import flash.net.drm.DRMContentData;
	}
	
	import org.osmf.traits.ContentProtectableTrait;
	import org.osmf.events.ContentProtectionEvent;

    [ExcludeClass]
    
    /**
	 * @private
	 * 
     * NetStream-specific protected content trait.
     */
	public class NetStreamContentProtectableTrait extends ContentProtectableTrait
	{
	CONFIG::FLASH_10_1
	{
		/**
   		 * Constructs a NetContentProtectableTrait
   		 *  
   		 *  @langversion 3.0
   		 *  @playerversion Flash 10
   		 *  @playerversion AIR 1.5
   		 *  @productversion OSMF 1.0
   		 */ 
		public function NetStreamContentProtectableTrait()
		{
			super();
			
			drmServices.addEventListener(ContentProtectionEvent.AUTHENTICATION_COMPLETE, redispatchEvent);
			drmServices.addEventListener(ContentProtectionEvent.AUTHENTICATION_FAILED, redispatchEvent);
			drmServices.addEventListener(ContentProtectionEvent.AUTHENTICATION_NEEDED, redispatchEvent);						
		}
		
		/**
		 * Data used by the flash player to implement DRM specific content protection.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set drmMetadata(value:Object):void
		{
			if (value != drmServices.drmMetadata)
			{
				drmServices.drmMetadata = value;
			}
		}
		
		public function get drmMetadata():Object
		{
			return drmServices.drmMetadata;
		}
				
		override public function get authenticationMethod():String
		{
			return drmServices.authenticationMethod;
		}
		
		override protected function processAuthenticate(username:String, password:String):void
		{							
			drmServices.authenticate(username, password);
		}
		
		override protected function processAuthenticateWithToken(token:Object):void
		{							
			drmServices.authenticateWithToken(token);
		}
		
		override public function get startDate():Date
		{
			return drmServices.startDate;
		}
		
		override public function get endDate():Date
		{
			return drmServices.endDate;
		}
		
		override public function get period():Number
		{
			return drmServices.period;
		}
		
		// Internals
		//
						
		private function redispatchEvent(event:Event):void
		{
			dispatchEvent(event.clone());
		}
															
		private var drmServices:DRMServices = new DRMServices();
    }
	}
}