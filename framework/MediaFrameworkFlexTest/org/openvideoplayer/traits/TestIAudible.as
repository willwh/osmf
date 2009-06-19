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
	import __AS3__.vec.Vector;
	
	import org.openvideoplayer.events.MutedChangeEvent;
	import org.openvideoplayer.events.PanChangeEvent;
	import org.openvideoplayer.events.VolumeChangeEvent;
	import org.openvideoplayer.utils.InterfaceTestCase;
	
	import flash.events.Event;

	public class TestIAudible extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			audible = createInterfaceObject() as IAudible;
			events = new Vector.<Event>;
		}
		
		public function testVolume():void
		{
			audible.addEventListener(VolumeChangeEvent.VOLUME_CHANGE,eventCatcher);
			
			assertTrue(audible.volume == 1);
			
			audible.volume = 0;
			assertTrue(audible.volume == 0);
			
			audible.volume = 0.5;
			assertTrue(audible.volume == 0.5);
			
			audible.volume = 100;
			assertTrue(audible.volume == 1);
			
			// Should not trigger change:
			audible.volume = 8054562546;
			
			var vce:VolumeChangeEvent;
			
			assertTrue(events.length == 3);
			vce = events[0] as VolumeChangeEvent;
			assertNotNull(vce);
			assertTrue(vce.oldVolume == 1);
			assertTrue(vce.newVolume == 0);
			
			vce = events[1] as VolumeChangeEvent;
			assertNotNull(vce);
			assertTrue(vce.oldVolume == 0);
			assertTrue(vce.newVolume == 0.5);
			
			vce = events[2] as VolumeChangeEvent;
			assertNotNull(vce);
			assertTrue(vce.oldVolume == 0.5);
			assertTrue(vce.newVolume == 1);
		}
		
		public function testMuted():void
		{
			audible.addEventListener(MutedChangeEvent.MUTED_CHANGE,eventCatcher);
			
			assertFalse(audible.muted);
			assertTrue(audible.volume == 1);
			
			audible.muted = true;
			assertTrue(audible.muted);
			assertTrue(audible.volume == 1);
			
			audible.muted = false; 
			assertFalse(audible.muted);
			assertTrue(audible.volume == 1);
			
			// Should not trigger change:
			audible.muted = false; 
			assertFalse(audible.muted);
			assertTrue(audible.volume == 1);
			
			var mce:MutedChangeEvent;
			
			assertTrue(events.length == 2);
			mce = events[0] as MutedChangeEvent;
			assertNotNull(mce);
			assertTrue(mce.muted);
			
			mce = events[1] as MutedChangeEvent;
			assertNotNull(mce);
			assertFalse(mce.muted);
		}
		
		public function testPan():void
		{
			audible.addEventListener(PanChangeEvent.PAN_CHANGE,eventCatcher);
			
			assertTrue(audible.pan == 0);
			
			audible.pan = -1;
			assertTrue(audible.pan == -1);
			
			audible.pan = 1;
			assertTrue(audible.pan == 1);
			
			audible.pan = -10;
			assertTrue(audible.pan == -1);
			
			audible.pan = 10
			assertTrue(audible.pan == 1);
			
			audible.pan = 0.152
			assertTrue(audible.pan == 0.152);
			
			// Should not trigger changed:
			audible.pan = 0.152;
			
			var pce:PanChangeEvent;
			
			assertTrue(events.length == 5);
			pce = events[0] as PanChangeEvent;
			assertTrue(pce.oldPan == 0);
			assertTrue(pce.newPan == -1);
			
			pce = events[1] as PanChangeEvent;
			assertTrue(pce.oldPan == -1);
			assertTrue(pce.newPan == 1);
			
			pce = events[2] as PanChangeEvent;
			assertTrue(pce.oldPan == 1);
			assertTrue(pce.newPan == -1);
			
			pce = events[3] as PanChangeEvent;
			assertTrue(pce.oldPan == -1);
			assertTrue(pce.newPan == 1);
			
			pce = events[4] as PanChangeEvent;
			assertTrue(pce.oldPan == 1);
			assertTrue(pce.newPan == 0.152);
		}
		
		// Utils
		//
		
		protected var audible:IAudible;
		protected var events:Vector.<Event>;
		
		protected function eventCatcher(event:Event):void
		{
			events.push(event);
		}
	}
}