package org.osmf.drm
{
	import flash.errors.IllegalOperationError;
	import flash.events.DRMAuthenticationCompleteEvent;
	import flash.events.DRMAuthenticationErrorEvent;
	import flash.events.DRMErrorEvent;
	import flash.events.DRMStatusEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.drm.AuthenticationMethod;
	import flash.net.drm.DRMContentData;
	import flash.net.drm.DRMManager;
	import flash.net.drm.DRMVoucher;
	import flash.net.drm.LoadVoucherSetting;
	import flash.system.SystemUpdaterType;
	import flash.utils.ByteArray;
	
	import org.osmf.events.AuthenticationFailedEvent;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.TraitEvent;
	
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
		/**
		 * Constructs a new DRMServices adpater.
		 */ 
		public function DRMServices()
		{
			var drmManager:DRMManager = DRMManager.getDRMManager();
			drmManager.addEventListener(DRMAuthenticationErrorEvent.AUTHENTICATION_ERROR, authError);
			drmManager.addEventListener('loadVoucherComplete', authComplete);
			drmManager.addEventListener('loadVoucherError', authError);
			
		}
		
		/**
		 * The metadata property is specific to the DRM for the Flashplayer.  Once set, authentication
		 * and voucher retrieval is started.  This method may trigger an update to the DRM subsystem.  
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
				var updater:DRMUpdater = DRMUpdater.getInstance();
				updater.addEventListener(IOErrorEvent.IO_ERROR, authError);
				updater.addEventListener(Event.COMPLETE, onComplete);
				updater.update(SystemUpdaterType.DRM);				
			}
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
			if(drmContentData == null)
			{
				throw new IllegalOperationError('Metadata not set');
			}
			function authComplete(event:DRMAuthenticationCompleteEvent):void
			{
				retrieveVoucher();
				drmManager.removeEventListener(DRMAuthenticationCompleteEvent.AUTHENTICATION_COMPLETE, authComplete);
			}
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
			if(drmContentData == null)
			{
				throw new IllegalOperationError('Metadata not set');
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
			return voucher ? voucher.playbackTimeWindow.startDate : null;
		}
		
		/**
		 * Returns the end date for the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */	
		public function get endDate():Date
		{
			return voucher ? voucher.playbackTimeWindow.endDate : null;
		}
		
		/**
		 * Returns the length of the playback window.  Returns null if authentication 
		 * hasn't taken place.
		 */		
		public function get period():int
		{
			return voucher ? voucher.playbackTimeWindow.period : -1;
		}
		
		/**
		 * Downloads the voucher for the metadata specified.
		 */ 
		private function retrieveVoucher():void
		{		
			drmManager.addEventListener("loadVoucherComplete", onVoucherLoaded);
			drmManager.addEventListener("loadVoucherError", onVoucherError);
			drmManager.addEventListener("drmStatus", onVoucherLoaded); //Same as "loadVoucherComplete"
						
			drmManager.loadVoucher(drmContentData, LoadVoucherSetting.ALLOW_SERVER);
							
			function onVoucherLoaded(event:DRMStatusEvent):void
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
			
			function onVoucherError(event:DRMStatusEvent):void
			{							
				dispatchEvent(new AuthenticationFailedEvent(-1, event.detail));
			}
						
			function verifyLocalVoucher(voucher:DRMVoucher):void
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
			
			function forceRefreshVoucher():void
			{
				drmManager.loadVoucher(drmContentData, LoadVoucherSetting.FORCE_REFRESH);
			}
			
			function onDRMError(event:DRMErrorEvent):void
			{
				if (event.errorID == 3331)
				{
					forceRefreshVoucher();
				}
				else
				{
					dispatchEvent(new AuthenticationFailedEvent(event.errorID, event.text));
				}
			}
			
			function onValidVoucher(voucher:DRMVoucher):void
			{
				this.voucher = voucher;
				dispatchEvent(new TraitEvent(TraitEvent.AUTHENTICATION_COMPLETE));
			}
			
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
		
		
		private function authComplete(event:Event):void
		{
			dispatchEvent(new Event("authenticationComplete"));
		}
		
		private function authError(event:DRMAuthenticationErrorEvent):void
		{			
			dispatchEvent(new AuthenticationFailedEvent(event.errorID, MediaErrorCodes.getDescriptionForErrorCode(event.errorID) ));
		}
		
		private var drmContentData:DRMContentData;
		private var voucher:DRMVoucher;
		private var drmManager:DRMManager = DRMManager.getDRMManager();

	}
}