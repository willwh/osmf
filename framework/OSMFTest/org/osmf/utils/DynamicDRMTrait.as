package org.osmf.utils
{
	import flash.utils.ByteArray;
	
	import org.osmf.drm.DRMState;
	import org.osmf.events.MediaError;
	import org.osmf.traits.DRMTrait;

	public class DynamicDRMTrait extends DRMTrait
	{
		public function DynamicDRMTrait()
		{
			super();
		}
		
		override public function get authenticationMethod():String
		{
			return _authenticationMethod;
		}
		
		override public function authenticate(username:String=null, password:String=null):void
		{
			drmStateChange(DRMState.AUTHENTICATING, null, null);
			if (username == null)
			{				
				drmStateChange(DRMState.AUTHENTICATE_FAILED, null, null);
			}
			else
			{				
				drmStateChange(DRMState.AUTHENTICATED, null, null);
			}
		}

		override public function authenticateWithToken(token:Object):void
		{
			drmStateChange(DRMState.AUTHENTICATING, token, null);
			if (token == null)
			{				
				drmStateChange(DRMState.AUTHENTICATE_FAILED, null, null);
			}
			else
			{				
				drmStateChange(DRMState.AUTHENTICATED, token, null);
			}
		}
		
		public function invokeDrmStateChange(state:String,  token:ByteArray, error:MediaError, start:Date, end:Date, period:Number, serverURL:String, authenticationMethod:String):void
		{
			_authenticationMethod = authenticationMethod
			this.drmStateChange(state, token, error, start, end, period, serverURL);
		}
		
		private var _authenticationMethod:String = "";
		
	}
}