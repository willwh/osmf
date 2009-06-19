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