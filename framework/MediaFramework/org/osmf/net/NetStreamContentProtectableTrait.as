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
	import flash.utils.ByteArray;
	
	CONFIG::FLASH_10_1
	{
	import org.osmf.drm.DRMServices;
	import flash.net.drm.DRMContentData;
	}
	
	import org.osmf.events.AuthenticationFailedEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.traits.ContentProtectableTrait;

    
    /**
     * NetStream specific protected content trait.
     */
	public class NetStreamContentProtectableTrait extends ContentProtectableTrait
	{
		CONFIG::FLASH_10_1
		{
		/**
   		 * Constructs a NetContentProtectableTrait
   		 */ 
		public function NetStreamContentProtectableTrait()
		{
			super();
			
			drmServices.addEventListener(TraitEvent.AUTHENTICATION_COMPLETE, redispatch);
			drmServices.addEventListener(AuthenticationFailedEvent.AUTHENTICATION_FAILED, redispatch);
			drmServices.addEventListener(TraitEvent.AUTHENTICATION_NEEDED, redispatch);						
		}
		
		/**
		 * 	metadata The FlashPlayer specific drm metadata.
		 */
		public function set metadata(value:ByteArray):void
		{
			drmServices.metadata = value;
		}
					
		/**
		 * 	DRMContentData that has been previously constructed
		 */
		public function set contentData(value:DRMContentData):void
		{
			drmServices.contentData = value;
		}
		
		/**
		 * 	DRMContentData that has been previously constructed
		 */
		public function get contentData():DRMContentData
		{
			return drmServices.contentData;
		}
				
				
		/**
		 * @inheritDoc
		 */ 		
		override public function get authenticationMethod():String
		{
			return drmServices.authenticationMethod;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Authenticates a user in order to retrieve a voucher for a protected piece of content.
		 * @throws IllegalOperation error if the drmMetadata isn't set.
		 */ 
		override protected function processAuthenticate(username:String, password:String):void
		{							
			drmServices.authenticate(username, password);
		}
		
		/**
		 * Authenticates a user using a byte array, which serves as a token.
		 * 
		 * @throws IllegalOperation error if the drmMetadata isn't set.
		 */ 
		override protected function processAuthenticateWithToken(token:ByteArray):void
		{							
			drmServices.authenticateWithToken(token);
		}
		
		/**
		 * Returns the start date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */	
		override public function get startDate():Date
		{
			return drmServices.startDate;
		}
		
		/**
		 * Returns the end date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */	
		override public function get endDate():Date
		{
			return drmServices.endDate;
		}
		
		/**
		 * Returns the length of the playback window.  Returns -1 if authentication 
		 * hasn't taken place.
		 */		
		override public function get period():int
		{
			return drmServices.period;
		}
						
		private function redispatch(event:Event):void
		{
			dispatchEvent(event.clone());
		}
															
		private var drmServices:DRMServices = new DRMServices();
    	}
	}
}