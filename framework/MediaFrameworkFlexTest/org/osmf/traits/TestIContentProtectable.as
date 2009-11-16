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
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
	import org.osmf.events.ContentProtectionEvent;
	import org.osmf.events.MediaError;
	import org.osmf.utils.InterfaceTestCase;

	public class TestIContentProtectable extends InterfaceTestCase
	{
		public function TestIContentProtectable()
		{
			super();
		}
		
		override public function setUp():void
		{
			super.setUp();			
			events = [];
			protectable = super.interfaceObj as IContentProtectable;		
		}
		
		public function testNeedsAuthentication():void
		{
			protectable.addEventListener(ContentProtectionEvent.AUTHENTICATION_NEEDED, eventCatcher);
			prodAuthNeeded()
			assertEquals(events.length, 1);						
		}
		
		public function testAuthenticationFailed():void
		{
			protectable.addEventListener(ContentProtectionEvent.AUTHENTICATION_FAILED, eventCatcher);
			prodAuthFailed();
			assertEquals(events.length, 1);						
		}
		
		public function testAuthenticationSuccess():void
		{
			protectable.addEventListener(ContentProtectionEvent.AUTHENTICATION_COMPLETE, eventCatcher);
			prodAuthSuccess();
			assertEquals(events.length, 1);						
		}
		
		public function testAuthenticationSuccessToken():void
		{
			protectable.addEventListener(ContentProtectionEvent.AUTHENTICATION_COMPLETE, eventCatcher);
			prodAuthSuccessToken();
			assertEquals(events.length, 1);						
		}
		
		public function testDates():void
		{			
			Assert.assertEquals(NaN, protectable.period);
			Assert.assertNull(protectable.startDate);
			Assert.assertNull(protectable.endDate);
		}
							
		protected function eventCatcher(event:Event):void
		{
			events.push(event);
		}
		
		protected function prodAuthNeeded():void
		{
			protectable.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_NEEDED));
		}
		
		protected function prodAuthFailed():void
		{
			protectable.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_FAILED, false, false, null, new MediaError(45, "Error")));
		}
		
		protected function prodAuthSuccess():void
		{
			protectable.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_COMPLETE));
		}
		
		protected function prodAuthSuccessToken():void
		{
			protectable.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_COMPLETE));
		}
		
		protected var events:Array;
		protected var protectable:IContentProtectable;
	}
}