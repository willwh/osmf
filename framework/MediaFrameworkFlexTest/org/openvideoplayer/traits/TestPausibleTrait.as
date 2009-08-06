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
package org.openvideoplayer.traits
{
	import org.openvideoplayer.events.PausedChangeEvent;
	
	public class TestPausibleTrait extends TestIPausible
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new PausibleTrait();
		}
		
		// Unpause is not on IPausible, hence we need to test it 'manually'
		// here:
		
		public function testUnpause():void
		{
			assertFalse(pausible.paused);
			
			pausible.addEventListener(PausedChangeEvent.PAUSED_CHANGE,eventCatcher);
			
			pausible.pause();
			assertTrue(pausible.paused);
			
			assertTrue(events.length == 1);
			var pce:PausedChangeEvent = events[0] as PausedChangeEvent;
			assertNotNull(pce);
			assertTrue(pce.paused);
			
			pausibleTraitBase.resetPaused();
			assertFalse(pausible.paused);
			
			assertTrue(events.length == 2);
			pce = events[1] as PausedChangeEvent;
			assertNotNull(pce);
			assertFalse(pce.paused);
		}
		
		// Utils
		//
		
		protected function get pausibleTraitBase():PausibleTrait
		{
			return pausible as PausibleTrait; 
		}
		
	}
}