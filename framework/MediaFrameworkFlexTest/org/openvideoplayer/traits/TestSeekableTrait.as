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
	import flash.events.Event;
	
	import org.openvideoplayer.events.SeekingChangeEvent;
	
	public class TestSeekableTrait extends TestISeekable
	{
		override protected function createInterfaceObject(... args):Object
		{
			var seekable:SeekableTrait = new SeekableTrait();
			var temporal:TemporalTrait = createTemporalTrait();
			temporal.duration = 5;
			seekable.temporal = temporal;
			return seekable;
		}
		
		override protected function get maxSeekValue():Number
		{
			return 5;
		}
		
		protected function createTemporalTrait():TemporalTrait
		{
			return new TemporalTrait();
		}
		
		public function testSeekWithTemporal():void
		{
			seekable.addEventListener(SeekingChangeEvent.SEEKING_CHANGE,eventCatcher);
			
			seekable.seek(4);
			
			var sce:SeekingChangeEvent;
				
			assertTrue(events.length == 2);
			
			sce = events[0] as SeekingChangeEvent;
			assertNotNull(sce);
			assertTrue(sce.seeking);
			assertTrue(sce.time == 4);
			
			sce = events[1] as SeekingChangeEvent;
			assertNotNull(sce);
			assertFalse(sce.seeking);
			assertTrue(isNaN(sce.time));
		}
		
		// Utils
		//
		
		protected function get seekableTraitBase():SeekableTrait
		{
			return seekable as SeekableTrait;
		}
		
		override protected function eventCatcher(event:Event):void
		{
			super.eventCatcher(event);
			trace('event catcher');
			var sce:SeekingChangeEvent = event as SeekingChangeEvent;
			if (sce && sce.seeking == true)
			{
				// Seeking being toggled to true, needs to be answered
				// to by starting the seek, and then signalling its 
				// completion like so:
				seekableTraitBase.processSeekCompletion(NaN);	
			}
		}
	}
}