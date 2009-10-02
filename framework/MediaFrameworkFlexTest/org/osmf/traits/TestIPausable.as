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
	import __AS3__.vec.Vector;
	
	import org.osmf.events.PausedChangeEvent;
	import org.osmf.utils.InterfaceTestCase;
	
	import flash.events.Event;

	public class TestIPausable extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			pausable = createInterfaceObject() as IPausable;
			events = new Vector.<Event>;
		}
		
		public function testPause():void
		{
			assertFalse(pausable.paused);
			
			pausable.addEventListener(PausedChangeEvent.PAUSED_CHANGE,eventCatcher);
			
			pausable.pause();
			assertTrue(pausable.paused);
			
			// A change event should have been fired:
			assertTrue(events.length == 1);

			// Verify if the event holds the correct info:			
			var pce:PausedChangeEvent = events[0] as PausedChangeEvent;
			assertNotNull(pce);
			assertTrue(pce.paused);
			
			// Pause again. This is not a change, so no event should be triggered:
			pausable.pause();
			assertTrue(events.length == 1);
		}
		
		// Utils
		//
		
		protected var pausable:IPausable;
		protected var events:Vector.<Event>;
		
		protected function eventCatcher(event:Event):void
		{
			events.push(event);
		}
	}
}