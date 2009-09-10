/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.openvideoplayer.traits
{
	import flash.events.*;
	import flash.errors.*;
	
	import org.openvideoplayer.events.SwitchingChangeEvent;
	import org.openvideoplayer.utils.InterfaceTestCase;
	
	public class TestISwitchable extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			_eventDispatcher = new EventDispatcher();
			switchable = super.interfaceObj as ISwitchable;
			
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			switchable = null;
			_eventDispatcher = null;
			
		}
		
		public function testSwitchUp():void
		{
			assertFalse(switchable.switchUnderway);
			assertTrue(switchable.autoSwitch);
			
			switchable.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onSwitchingChange);
			
			switchable.autoSwitch = false;
			
			_eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TIMEOUT));
			
			switchable.switchTo(switchable.currentIndex + 1);
		}
		
		public function testSwitchDown():void
		{
			assertFalse(switchable.switchUnderway);
			assertTrue(switchable.autoSwitch);
			
			switchable.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onSwitchingChange);
			switchable.autoSwitch = false;
			switchable.switchTo(switchable.maxIndex);
			_eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TIMEOUT));
			switchable.switchTo(0);
		}
		
		public function testSwitchUpMax():void
		{
			assertFalse(switchable.switchUnderway);
			assertTrue(switchable.autoSwitch);
			
			switchable.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onSwitchingChange);
			switchable.autoSwitch = false;
			_eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, TIMEOUT));
			switchable.switchTo(switchable.maxIndex);			
		}
		
		public function testBadMaxIndex():void
		{
			try
			{
				this.switchable.maxIndex = 99;
			}
			catch(e:RangeError)
			{
				return;
			}
			
			fail("Expected a RangeError in testBadMaxIndex.");
		}
		
		public function testBadSwitch1():void
		{
			assertTrue(switchable.autoSwitch);
			try
			{
				switchable.switchTo(1);
			}
			catch(e:IllegalOperationError)
			{
				return;
			}
			
			fail("Expected an IllegalOperationError in testBadSwitch1.");
		}
				
		public function testBadSwitch2():void
		{
			assertTrue(switchable.autoSwitch);
			switchable.autoSwitch = false;

			try
			{
				switchable.switchTo(-1);
			}
			catch(e:RangeError)
			{
				return;
			}
			
			fail("Expected a RangeError in testBadSwitch2.");
		}

		public function testBadSwitch3():void
		{
			assertTrue(switchable.autoSwitch);
			switchable.autoSwitch = false;

			try
			{
				switchable.switchTo(99);
			}
			catch(e:RangeError)
			{
				return;
			}
			
			fail("Expected a RangeError in testBadSwitch3.");
		}

		protected function onSwitchingChange(event:SwitchingChangeEvent):void
		{
			switch (event.newState)
			{
				case SwitchingChangeEvent.SWITCHSTATE_COMPLETE:
					assertFalse(switchable.switchUnderway);
					assertEquals(SwitchingChangeEvent.SWITCHSTATE_REQUESTED, event.oldState);
					_eventDispatcher.dispatchEvent(new Event("testComplete"));									
					break;
				case SwitchingChangeEvent.SWITCHSTATE_REQUESTED:
					assertTrue(switchable.switchUnderway);
					assertTrue(event.detail.detailCode > 0);
					assertTrue(event.detail.description.length > 0);
					break;
				case SwitchingChangeEvent.SWITCHSTATE_FAILED:
					fail("Error switching streams");
					_eventDispatcher.dispatchEvent(new Event("testComplete"));									
					break;
			}
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
				
		private static const TIMEOUT:int = 4000;
		protected var switchable:ISwitchable;
		private var _eventDispatcher:EventDispatcher;
	}
}
