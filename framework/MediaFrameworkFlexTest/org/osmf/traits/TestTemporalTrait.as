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
	import org.osmf.events.DurationChangeEvent;
	import org.osmf.events.TraitEvent;
	
	public class TestTemporalTrait extends TestITemporal
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new TemporalTrait();
		}
		
		public function testDuration():void
		{
			temporal.addEventListener(DurationChangeEvent.DURATION_CHANGE,eventCatcher);
			
			assertTrue(isNaN(temporal.duration));
			
			temporalTraitBase.duration = 10;
			assertTrue(temporal.duration == 10);
			
			temporalTraitBase.duration = 20;
			assertTrue(temporal.duration == 20);
			
			assertTrue(events.length == 2);
			
			var dce:DurationChangeEvent;
			
			dce = events[0] as DurationChangeEvent;
			assertNotNull(dce);
			assertTrue(isNaN(dce.oldDuration));
			assertTrue(dce.newDuration == 10);
			
			dce = events[1] as DurationChangeEvent;
			assertNotNull(dce);
			assertTrue(dce.oldDuration == 10);
			assertTrue(dce.newDuration == 20); 
		}
		
		public function testCurrentTime():void 
		{
			assertTrue(isNaN(temporal.currentTime));
			
			if (canChangeCurrentTime)
			{
				// Current time must never exceed duration.
				temporalTraitBase.currentTime = 10;
				assertTrue(temporal.currentTime == 0);
	
				temporalTraitBase.duration = 25;
				temporalTraitBase.currentTime = 10;
				assertTrue(temporal.currentTime == 10);
				temporalTraitBase.currentTime = 50;
				assertTrue(temporal.currentTime == 25);
				temporalTraitBase.duration = 5;
				assertTrue(temporal.currentTime == 5);
				
				// Setting the currentTime to the duration should cause the
				// durationReached event to fire.
				
				temporal.addEventListener(TraitEvent.DURATION_REACHED, eventCatcher);
				
				temporalTraitBase.duration = 20;
				temporalTraitBase.currentTime = 20;
				
				var dre:TraitEvent;
				dre = events[0] as TraitEvent;
				assertNotNull(dre && dre.type == TraitEvent.DURATION_REACHED);
			}
		}
		
		// Utils
		//
		
		protected function get temporalTraitBase():TemporalTrait
		{
			return temporal as TemporalTrait;
		}
		
		protected function get canChangeCurrentTime():Boolean
		{
			// Subclasses can override if explicit currentTime changes are
			// disallowed.
			return true;
		}
	}
}
