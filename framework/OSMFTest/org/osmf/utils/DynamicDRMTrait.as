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
package org.osmf.utils
{
	import flash.utils.ByteArray;
	
	import org.osmf.events.MediaError;
	import org.osmf.traits.DRMState;
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