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
	import flash.utils.ByteArray;
	
	import org.osmf.drm.DRMState;
	import org.osmf.events.DRMEvent;
	import org.osmf.events.MediaError;
	import org.osmf.utils.InterfaceTestCase;

	public class TestDRMTrait extends InterfaceTestCase
	{
		/**
		 * Subclasses can override to specify their own trait class.
		 **/
		override protected function createInterfaceObject(... args):Object
		{
			return new DRMTraitTest();
		}
		
		override public function setUp():void
		{
			super.setUp();
				
			_protectionTrait = createInterfaceObject() as DRMTraitTest;
			events = [];
		}
		
		public function testAuthMethod():void
		{
			assertEquals("",  _protectionTrait.authenticationMethod);
		}
		
		public function testNeedsAuthentication():void
		{
			protectionTrait.addEventListener(DRMEvent.DRM_STATE_CHANGE, eventCatcher);
			prodAuthNeeded()
			assertEquals(events.length, 1);						
		}
		
		public function testAuthenticationFailed():void
		{
			protectionTrait.addEventListener(DRMEvent.DRM_STATE_CHANGE, eventCatcher);
			prodAuthFailed();
			assertEquals(events.length, 1);						
		}
		
		public function testAuthenticationSuccess():void
		{
			protectionTrait.addEventListener(DRMEvent.DRM_STATE_CHANGE, eventCatcher);
			
			var start:Date = new Date(1000);
			var end:Date = new Date(2000);
			var period:Number = 50;
			
			prodAuthSuccess(start, end, period);
			assertEquals(events.length, 1);		
			assertTrue(events[0] is DRMEvent);
			var drmEvent:DRMEvent = events[0] as DRMEvent;
			assertEquals(start, drmEvent.startDate);
			assertEquals(end, drmEvent.endDate);
			assertEquals(period, drmEvent.period);
							
		}
		
		public function testAuthenticationSuccessToken():void
		{
			protectionTrait.addEventListener(DRMEvent.DRM_STATE_CHANGE, eventCatcher);
			var token:ByteArray = new ByteArray();
			prodAuthSuccessToken(token);
			assertEquals(events.length, 1);	
			assertTrue(events[0] is DRMEvent);
			var drmEvent:DRMEvent = events[0] as DRMEvent;
			assertEquals(token, drmEvent.token);					
		}
		
		public function testDates():void
		{			
			assertEquals(0, protectionTrait.period);
			assertNull(protectionTrait.startDate);
			assertNull(protectionTrait.endDate);
		}
		
		// Internals
		//
							
		protected function eventCatcher(event:Event):void
		{
			events.push(event);
		}
		
		protected function prodAuthNeeded():void
		{
			protectionTrait.updateState(DRMState.AUTHENTICATION_NEEDED);
		}
		
		protected function prodAuthFailed():void
		{
			protectionTrait.updateState(DRMState.AUTHENTICATE_FAILED, null, new MediaError(45, "Error"), null, null, 0);
		}
		
		protected function prodAuthSuccess(start:Date, end:Date, period:Number):void
		{
			protectionTrait.updateState(DRMState.AUTHENTICATED, null, null, start, end, period);
		}
		
		protected function prodAuthSuccessToken(token:ByteArray):void
		{
			protectionTrait.updateState(DRMState.AUTHENTICATED, token);
		}
		
		protected function get protectionTrait():DRMTraitTest
		{
			return _protectionTrait;
		}
		
		protected var events:Array;
		
		private var _protectionTrait:DRMTraitTest
	}
}
	
import org.osmf.traits.DRMTrait;
import flash.utils.ByteArray;
import org.osmf.events.MediaError;

class DRMTraitTest extends DRMTrait
{
	public function updateState(newState:String, token:ByteArray = null, error:MediaError = null, start:Date = null, end:Date = null, period:Number = 0):void
	{
		drmStateChange(newState, token, error, start, end, period);
	}
	
}