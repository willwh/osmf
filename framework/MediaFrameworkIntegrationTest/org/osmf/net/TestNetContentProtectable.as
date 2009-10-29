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
	import org.osmf.events.AuthenticationFailedEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.traits.TestContentProtectable;

	public class TestNetContentProtectable extends TestContentProtectable
	{
		public function TestNetContentProtectable()
		{
			super();
		}
				
		override protected function createInterfaceObject(... args):Object
		{			
			return new NetStreamContentProtectableTrait();
		}
		
		override protected function prodAuthNeeded():void
		{
			protectable.dispatchEvent(new TraitEvent(TraitEvent.AUTHENTICATION_NEEDED));
		}
		
		override protected function prodAuthFailed():void
		{
			protectable.dispatchEvent(new AuthenticationFailedEvent(45, "Error"));
		}
		
		override protected function prodAuthSuccess():void
		{
			protectable.dispatchEvent(new TraitEvent(TraitEvent.AUTHENTICATION_COMPLETE));
		}
		
		override protected function prodAuthSuccessToken():void
		{
			protectable.dispatchEvent(new TraitEvent(TraitEvent.AUTHENTICATION_COMPLETE));
		}
		
		
	}
}