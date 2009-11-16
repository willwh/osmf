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
	import org.osmf.events.ContentProtectionEvent;
	import org.osmf.events.MediaError;
	
	public class TestContentProtectable extends TestIContentProtectable
	{
		public function TestContentProtectable()
		{
			super();
		}
		
		override protected function createInterfaceObject(... args):Object
		{			
			return new ContentProtectableTrait();
		}
		
		public function testAuthMethod():void
		{
			assertNull(protectable.authenticationMethod);
		}
		
		override protected function prodAuthFailed():void
		{
			protectable.authenticate("test","test");
			protectable.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_FAILED, false, false, null, new MediaError(45, "Error")));
		}
		
		override protected function prodAuthSuccess():void
		{
			protectable.authenticate("test","test");
			protectable.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_COMPLETE));
		}
		
		override protected function prodAuthSuccessToken():void
		{
			protectable.authenticateWithToken("testtest");
			protectable.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_COMPLETE));
		}
	}
}