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
	
	import flash.events.Event;
	
	import org.osmf.events.AudioEvent;
	import org.osmf.utils.InterfaceTestCase;

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
			audible.addEventListener(AudioEvent.VOLUME_CHANGE,eventCatcher);
			
			assertTrue(audible.volume == 1);
			
			audible.volume = 0;
			assertTrue(audible.volume == 0);
			
			audible.volume = 0.5;
			assertTrue(audible.volume == 0.5);
			
			audible.volume = 100;
			assertTrue(audible.volume == 1);
			
			// Should not trigger change:
			audible.volume = 8054562546;
			
			var vce:AudioEvent;
			
			assertTrue(events.length == 3);
			vce = events[0] as AudioEvent;
			assertNotNull(vce);
			assertTrue(vce.type == AudioEvent.VOLUME_CHANGE);
			assertTrue(vce.volume == 0);
			
			vce = events[1] as AudioEvent;
			assertNotNull(vce);
			assertTrue(vce.type == AudioEvent.VOLUME_CHANGE);
			assertTrue(vce.volume == 0.5);
			
			vce = events[2] as AudioEvent;
			assertNotNull(vce);
			assertTrue(vce.type == AudioEvent.VOLUME_CHANGE);
			assertTrue(vce.volume == 1);
		}
		
		public function testMuted():void
		{
			audible.addEventListener(AudioEvent.MUTED_CHANGE,eventCatcher);
			
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
			
			var mce:AudioEvent;
			
			assertTrue(events.length == 2);
			mce = events[0] as AudioEvent;
			assertNotNull(mce);
			assertTrue(mce.type == AudioEvent.MUTED_CHANGE);
			assertTrue(mce.muted);
			
			mce = events[1] as AudioEvent;
			assertNotNull(mce);
			assertTrue(mce.type == AudioEvent.MUTED_CHANGE);
			assertFalse(mce.muted);
		}
		
		public function testPan():void
		{
			audible.addEventListener(AudioEvent.PAN_CHANGE,eventCatcher);
			
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
			
			var pce:AudioEvent;
			
			assertTrue(events.length == 5);
			pce = events[0] as AudioEvent;
			assertTrue(pce.type == AudioEvent.PAN_CHANGE);
			assertTrue(pce.pan == -1);
			
			pce = events[1] as AudioEvent;
			assertTrue(pce.type == AudioEvent.PAN_CHANGE);
			assertTrue(pce.pan == 1);
			
			pce = events[2] as AudioEvent;
			assertTrue(pce.type == AudioEvent.PAN_CHANGE);
			assertTrue(pce.pan == -1);
			
			pce = events[3] as AudioEvent;
			assertTrue(pce.type == AudioEvent.PAN_CHANGE);
			assertTrue(pce.pan == 1);
			
			pce = events[4] as AudioEvent;
			assertTrue(pce.type == AudioEvent.PAN_CHANGE);
			assertTrue(pce.pan == 0.152);
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