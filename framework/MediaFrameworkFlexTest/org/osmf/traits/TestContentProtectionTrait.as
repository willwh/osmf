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
	
	import org.osmf.events.ContentProtectionEvent;
	import org.osmf.events.MediaError;
	import org.osmf.utils.InterfaceTestCase;

	public class TestContentProtectionTrait extends InterfaceTestCase
	{
		/**
		 * Subclasses can override to specify their own trait class.
		 **/
		override protected function createInterfaceObject(... args):Object
		{
			return new ContentProtectionTrait();
		}
		
		override public function setUp():void
		{
			super.setUp();
				
			_protectionTrait = createInterfaceObject() as ContentProtectionTrait;
			events = [];
		}
		
		public function testNeedsAuthentication():void
		{
			protectionTrait.addEventListener(ContentProtectionEvent.AUTHENTICATION_NEEDED, eventCatcher);
			prodAuthNeeded()
			assertEquals(events.length, 1);						
		}
		
		public function testAuthenticationFailed():void
		{
			protectionTrait.addEventListener(ContentProtectionEvent.AUTHENTICATION_FAILED, eventCatcher);
			prodAuthFailed();
			assertEquals(events.length, 1);						
		}
		
		public function testAuthenticationSuccess():void
		{
			protectionTrait.addEventListener(ContentProtectionEvent.AUTHENTICATION_COMPLETE, eventCatcher);
			prodAuthSuccess();
			assertEquals(events.length, 1);						
		}
		
		public function testAuthenticationSuccessToken():void
		{
			protectionTrait.addEventListener(ContentProtectionEvent.AUTHENTICATION_COMPLETE, eventCatcher);
			prodAuthSuccessToken();
			assertEquals(events.length, 1);						
		}
		
		public function testDates():void
		{			
			assertTrue(isNaN(protectionTrait.period));
			assertTrue(protectionTrait.startDate == null);
			assertTrue(protectionTrait.endDate == null);
		}
		
		// Internals
		//
							
		protected function eventCatcher(event:Event):void
		{
			events.push(event);
		}
		
		protected function prodAuthNeeded():void
		{
			protectionTrait.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_NEEDED));
		}
		
		protected function prodAuthFailed():void
		{
			protectionTrait.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_FAILED, false, false, null, new MediaError(45, "Error")));
		}
		
		protected function prodAuthSuccess():void
		{
			protectionTrait.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_COMPLETE));
		}
		
		protected function prodAuthSuccessToken():void
		{
			protectionTrait.dispatchEvent(new ContentProtectionEvent(ContentProtectionEvent.AUTHENTICATION_COMPLETE));
		}
		
		protected function get protectionTrait():ContentProtectionTrait
		{
			return _protectionTrait;
		}
		
		protected var events:Array;
		
		private var _protectionTrait:ContentProtectionTrait
	}
}