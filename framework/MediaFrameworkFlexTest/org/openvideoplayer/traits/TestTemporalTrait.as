/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.traits
{
	import org.openvideoplayer.events.DurationChangeEvent;
	import org.openvideoplayer.events.TraitEvent;
	
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
		
		public function testPosition():void 
		{
			assertTrue(isNaN(temporal.position));
			
			if (canChangePosition)
			{
				// Position must never exceed duration.
				temporalTraitBase.position = 10;
				assertTrue(temporal.position == 0);
	
				temporalTraitBase.duration = 25;
				temporalTraitBase.position = 10;
				assertTrue(temporal.position == 10);
				temporalTraitBase.position = 50;
				assertTrue(temporal.position == 25);
				temporalTraitBase.duration = 5;
				assertTrue(temporal.position == 5);
				
				// Setting the position to the duration should cause the
				// durationReached event to fire.
				
				temporal.addEventListener(TraitEvent.DURATION_REACHED,eventCatcher);
				
				temporalTraitBase.duration = 20;
				temporalTraitBase.position = 20;
				
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
		
		protected function get canChangePosition():Boolean
		{
			// Subclasses can override if explicit position changes are
			// disallowed.
			return true;
		}
	}
}
