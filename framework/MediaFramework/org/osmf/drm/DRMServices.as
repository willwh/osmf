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
package org.osmf.drm
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	CONFIG::FLASH_10_1
	{
		import flash.events.DRMAuthenticationCompleteEvent;
		import flash.events.DRMAuthenticationErrorEvent;
		import flash.events.DRMErrorEvent;
		import flash.events.DRMStatusEvent;
		import flash.net.drm.AuthenticationMethod;
		import flash.net.drm.DRMContentData;
		import flash.net.drm.DRMManager;
		import flash.net.drm.DRMVoucher;
		import flash.net.drm.LoadVoucherSetting;
		import flash.system.SystemUpdater;
		import flash.system.SystemUpdaterType;
		import flash.utils.ByteArray;
		import org.osmf.events.MediaErrorCodes;	
		import flash.net.drm.DRMContentData;
		import flash.net.drm.DRMContentData;
		import flash.events.DRMStatusEvent;
		import flash.events.DRMErrorEvent;
	
	}
	import org.osmf.events.AuthenticationFailedEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.utils.MediaFrameworkStrings;
	import org.osmf.events.MediaErrorCodes;
	
	import flash.utils.ByteArray;
	import flash.events.SecurityErrorEvent;
	import org.osmf.events.AuthenticationCompleteEvent;


	/**
	 * Dispatched when username password  or token authentication is needed to playback.
	 */ 
	[Event(name='authenticationNeeded', type='org.osmf.events.TraitEvent')]
	
	/**
	 * Dispatched when the user is authenticated successfully
	 * 
	 * @eventType AuthenticationCompleteEvent.AUTHENTICATION_COMPLETE
	 */ 
	[Event(name='authenticationComplete', type='org.osmf.events.AuthenticationCompleteEvent')] 	
	 
	/**	 	
	 * Dispatches when the authentication fails, with the reason being stored on the event.
	 * 
	 * @eventType AuthenticationFailedEvent.AUTHENTICATION_FAILED
	 */
	[Event(name='authenticationFailed', type='org.osmf.events.AuthenticationFailedEvent')] 	 
	
	/**
	 * The DRMServices class is a utility class to adapt the Flash Players DRM to the OSMF style IContentProtectable
	 * trait API.  DRMServices handles triggering Updates to the DRMsubsystem, as well as triggering the appropriate events
	 * when authentication is needed, complete, or failed. 
	 */ 
	public class DRMServices extends EventDispatcher
	{
	CONFIG::FLASH_10_1
	{
			
		/**
		 * Constructs a new DRMServices adpater.
		 */ 
		public function DRMServices()
		{
			drmManager = DRMManager.getDRMManager();
		}
		
		/**
		 * The metadata property is specific to the DRM for the Flashplayer.  Once set, authentication
		 * and voucher retrieval is started.  This method may trigger an update to the DRM subsystem.  metadta
		 * forms the basis for content data.
		 */ 
		public function set drmMetadata(value:Object):void
		{		
			lastToken = null;
			if(value is DRMContentData)
			{
				drmContentData = value as DRMContentData;
				retrieveVoucher();	
			}
			else
			{	
				try
				{
					drmContentData = new DRMContentData(value as ByteArray);
					retrieveVoucher();	
				}
				catch (error:Error)
				{
					var e:Error = error;
					function onComplete(event:Event):void
					{
						updater.removeEventListener(IOErrorEvent.IO_ERROR, onComplete);
						updater.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onComplete);
						updater.removeEventListener(Event.COMPLETE, onComplete);
						if (event.type == Event.COMPLETE)
						{
							drmMetadata = value;
						}	
					}					
					var updater:SystemUpdater = new SystemUpdater();
					updater.addEventListener(IOErrorEvent.IO_ERROR, onComplete);
					updater.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onComplete);
					updater.addEventListener(Event.COMPLETE, onComplete);
					updater.update(SystemUpdaterType.DRM);				
				}
			}
		}
			
		public function get drmMetadata():Object
		{		
			return drmContentData;
		}

					
		/**
		 * The type of authentication required to obtain a voucher for the associated content.
		 * The supported types of authentication are:			
		 * AuthenticationMethod.ANONYMOUS — anyone can obtain a voucher.
		 * AuthenticationMethod.USERNAME_AND_PASSWORD — the user must supply a valid username and password of an account that is authorized to view the associated content.
		 * The AuthenticationMethod class provides string constants to use with the authenticationMethod property.
		 * 
		 * returns null if metadata hasn't been set.
		 */ 
		public function get authenticationMethod():String
		{			
			return drmContentData ? drmContentData.authenticationMethod : null;
		}
		
		/**
		 * Authenticates a user using a username and password.
		 * 
		 * @throws IllegalOperationError if metadata not set.
		 */ 
		public function authenticate(username:String, password:String):void
		{			
			if (drmContentData == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.DRM_METADATA_NOT_SET);
			}
		
			drmManager.addEventListener(DRMAuthenticationErrorEvent.AUTHENTICATION_ERROR, authError);			
			drmManager.addEventListener(DRMAuthenticationCompleteEvent.AUTHENTICATION_COMPLETE, authComplete);			
			drmManager.authenticate(drmContentData.serverURL, drmContentData.domain, username, password);
		}
		
		/**
		 * Authenticates a user using a byte array, which serves as a token.
		 * 
		 * @throws IllegalOperationError if metadata not set.
		 */ 
		public function authenticateWithToken(token:ByteArray):void
		{
			if (drmContentData == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.DRM_METADATA_NOT_SET);
			}
			
			drmManager.setAuthenticationToken(drmContentData.serverURL, drmContentData.domain, token);
			retrieveVoucher();
		}
					
		/**
		 * Returns the start date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */	
		public function get startDate():Date
		{
			if (voucher != null)
			{
				return voucher.playbackTimeWindow ? voucher.playbackTimeWindow.startDate : voucher.voucherStartDate;	
			}
			else
			{
				return null;
			}			
		}
		
		/**
		 * Returns the end date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */	
		public function get endDate():Date
		{
			if (voucher != null)
			{
				return voucher.playbackTimeWindow ? voucher.playbackTimeWindow.endDate : voucher.voucherEndDate;	
			}
			else
			{
				return null;
			}			
		}
		
		/**
		 * The length of the playback window in seconds.  Returns NaN if authentication 
		 * hasn't taken place.
		 */		
		public function get period():Number
		{
			if (voucher != null)
			{
				return voucher.playbackTimeWindow ? voucher.playbackTimeWindow.period : (voucher.voucherEndDate.time - voucher.voucherStartDate.time)/1000;	
			}
			else
			{
				return NaN;
			}		
		}
		
		/**
		 * Downloads the voucher for the metadata specified.
		 */ 
		private function retrieveVoucher():void
		{				
			drmManager.addEventListener(DRMErrorEvent.DRM_ERROR, onDRMError);
			drmManager.addEventListener(DRMStatusEvent.DRM_STATUS, onVoucherLoaded); //Same as "loadVoucherComplete"
						
			drmManager.loadVoucher(drmContentData, LoadVoucherSetting.ALLOW_SERVER);					
		}
		
		private function onVoucherLoaded(event:DRMStatusEvent):void
		{	
			var now:Date = new Date();
			this.voucher = event.voucher;		
			if (voucher && (voucher.voucherEndDate != null && voucher.voucherEndDate.time >= now.time) &&
				(voucher.voucherStartDate != null && voucher.voucherStartDate.time <= now.time))
			{
				removeEventListeners();				
				dispatchEvent(new AuthenticationCompleteEvent(lastToken));			
			}
			else
			{
				forceRefreshVoucher();
			}		
		}
					
		private function forceRefreshVoucher():void
		{
			drmManager.loadVoucher(drmContentData, LoadVoucherSetting.FORCE_REFRESH);
		}
			
		private function onDRMError(event:DRMErrorEvent):void
		{
			switch(event.errorID)
			{
				case  MediaErrorCodes.DRM_CONTENT_NOT_YET_VALID:
					forceRefreshVoucher();
					break;
				case MediaErrorCodes.DRM_NEEDS_AUTHENTICATION:
					dispatchEvent(new TraitEvent(TraitEvent.AUTHENTICATION_NEEDED));
					break;
				default:
					removeEventListeners();				
					dispatchEvent(new AuthenticationFailedEvent(event.errorID, event.text));	
					break;
			}	
		}
					
		private function removeEventListeners():void
		{
			drmManager.removeEventListener(DRMErrorEvent.DRM_ERROR, onDRMError);
			drmManager.removeEventListener(DRMStatusEvent.DRM_STATUS, onVoucherLoaded); //Same as "loadVoucherComplete"
		}
		
		private function authComplete(event:DRMAuthenticationCompleteEvent):void
		{
			drmManager.removeEventListener(DRMAuthenticationErrorEvent.AUTHENTICATION_ERROR, authError);
			drmManager.removeEventListener(DRMAuthenticationCompleteEvent.AUTHENTICATION_COMPLETE, authComplete);
			lastToken = event.token;	
			retrieveVoucher();
		}			
				
		private function authError(event:DRMAuthenticationErrorEvent):void
		{
			drmManager.removeEventListener(DRMAuthenticationErrorEvent.AUTHENTICATION_ERROR, authError);
			drmManager.removeEventListener(DRMAuthenticationCompleteEvent.AUTHENTICATION_COMPLETE, authComplete);
			
			dispatchEvent(new AuthenticationFailedEvent(event.errorID, MediaErrorCodes.getDescriptionForErrorCode(event.errorID) ));
		}
		
		private var lastToken:ByteArray
		private var drmContentData:DRMContentData;
		private var voucher:DRMVoucher;
		private var drmManager:DRMManager;

	}
	}
}