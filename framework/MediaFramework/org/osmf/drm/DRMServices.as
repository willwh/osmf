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
	
	}
	import org.osmf.events.AuthenticationFailedEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.utils.MediaFrameworkStrings;

	/**
	 * Dispatched when username password  or token authentication is needed to playback.
	 */ 
	[Event(name='authenticationNeeded', type='org.osmf.events.TraitEvent')]
	
	/**
	 * Dispatched when the user is authenticated successfully
	 */ 
	[Event(name='authenticationComplete', type='org.osmf.events.TraitEvent')] 	
	 
	/**	 	
	 * Dispatches when the authentication fails, with the reason being stored on the event.
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
		public function set metadata(value:ByteArray):void
		{			
			try
			{
				drmContentData = new DRMContentData(value);
				onDRMConentData();
			}
			catch (error:Error)
			{
				var e:Error = error;
				function onComplete(event:Event):void
				{
					metadata = value;
				}
				var updater:SystemUpdater = new SystemUpdater();
				updater.addEventListener(IOErrorEvent.IO_ERROR, authError);
				updater.addEventListener(Event.COMPLETE, onComplete);
				updater.update(SystemUpdaterType.DRM);				
			}
		}
		
		/**
		 * The metadata property is specific to the DRM for the Flashplayer.  Once set, authentication
		 * and voucher retrieval is started.  This method may trigger an update to the DRM subsystem.  
		 */ 
		public function set contentData(value:DRMContentData):void
		{		
			drmContentData = value;
			onDRMConentData();
		}
		
		public function get contentData():DRMContentData
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
		 * The length of the playback window in seconds.  Returns null if authentication 
		 * hasn't taken place.
		 */		
		public function get period():int
		{
			if (voucher != null)
			{
				return voucher.playbackTimeWindow ? voucher.playbackTimeWindow.period : (voucher.voucherEndDate.time - voucher.voucherStartDate.time)/1000;	
			}
			else
			{
				return -1;
			}		
		}
		
		/**
		 * Downloads the voucher for the metadata specified.
		 */ 
		private function retrieveVoucher():void
		{		
			drmManager.addEventListener("loadVoucherComplete", onVoucherLoaded);
			drmManager.addEventListener("loadVoucherError", onDRMError);
			drmManager.addEventListener("drmStatus", onVoucherLoaded); //Same as "loadVoucherComplete"
						
			drmManager.loadVoucher(drmContentData, LoadVoucherSetting.ALLOW_SERVER);
					
		}
		
		private function onVoucherLoaded(event:DRMStatusEvent):void
		{							
			if (event.isLocal)
			{
				verifyLocalVoucher(event.voucher);
			}
			else
			{					
				onValidVoucher(event.voucher);					
			}
		}
									
		private function verifyLocalVoucher(voucher:DRMVoucher):void
		{
			var now:Date = new Date();
			if (voucher == null)
			{
				forceRefreshVoucher();
			}
			else
			{
				if ((voucher.voucherEndDate != null && voucher.voucherEndDate.valueOf() >= now.valueOf()) &&
					(voucher.voucherStartDate != null && voucher.voucherStartDate.valueOf() <= now.valueOf()))
				{
					onValidVoucher(voucher);
						
				}
				else
				{
					forceRefreshVoucher();
				}
			}
		}
			
		private function forceRefreshVoucher():void
		{
			drmManager.loadVoucher(drmContentData, LoadVoucherSetting.FORCE_REFRESH);
		}
			
		private function onDRMError(event:DRMErrorEvent):void
		{
			if (event.errorID == 3331)
			{
				forceRefreshVoucher();
			}
			else
			{
				removeEventListeners();				
				dispatchEvent(new AuthenticationFailedEvent(event.errorID, event.text));
			}
		}
		
		private function onValidVoucher(voucher:DRMVoucher):void
		{
			removeEventListeners();
			if(voucher == null)
			{
				throw new Error('null voucher');
			}
			this.voucher = voucher;
			dispatchEvent(new TraitEvent(TraitEvent.AUTHENTICATION_COMPLETE));
		}
			
		private function removeEventListeners():void
		{
			drmManager.removeEventListener("loadVoucherComplete", onVoucherLoaded);
			drmManager.removeEventListener("loadVoucherError", onDRMError);
			drmManager.removeEventListener("drmStatus", onVoucherLoaded); //Same as "loadVoucherComplete"
		}
	
		
		private function onDRMConentData():void
		{
			if (drmContentData != null)
			{
				if (drmContentData.authenticationMethod == AuthenticationMethod.ANONYMOUS)
				{
					retrieveVoucher();	
				}
				else
				{
					dispatchEvent(new TraitEvent(TraitEvent.AUTHENTICATION_NEEDED));				
				}				
			}
		}
		
		private function authComplete(event:DRMAuthenticationCompleteEvent):void
		{
			drmManager.removeEventListener(DRMAuthenticationErrorEvent.AUTHENTICATION_ERROR, authError);
			drmManager.removeEventListener(DRMAuthenticationCompleteEvent.AUTHENTICATION_COMPLETE, authComplete);
	
			retrieveVoucher();
		}			
				
		private function authError(event:DRMAuthenticationErrorEvent):void
		{
			drmManager.removeEventListener(DRMAuthenticationErrorEvent.AUTHENTICATION_ERROR, authError);
			drmManager.removeEventListener(DRMAuthenticationCompleteEvent.AUTHENTICATION_COMPLETE, authComplete);
				
			dispatchEvent(new AuthenticationFailedEvent(event.errorID, MediaErrorCodes.getDescriptionForErrorCode(event.errorID) ));
		}
		
		private var drmContentData:DRMContentData;
		private var voucher:DRMVoucher;
		private var drmManager:DRMManager;

		}
	}
}