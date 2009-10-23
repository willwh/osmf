package org.osmf.net
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import org.osmf.drm.DRMServices;
	import org.osmf.events.AuthenticationFailedEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.traits.ContentProtectableTrait;
    
    /**
     * NetStream specific protected content trait.
     */
	public class NetContentProtectableTrait extends ContentProtectableTrait
	{
		/**
   		 * Constructs a NetContentProtectableTrait
   		 */ 
		public function NetContentProtectableTrait()
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