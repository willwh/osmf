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
	
	import org.openvideoplayer.events.BufferTimeChangeEvent;
	import org.openvideoplayer.utils.InterfaceTestCase;
	
	import flash.events.Event;

	public class TestIBufferable extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			bufferable = createInterfaceObject() as IBufferable;
			events = new Vector.<Event>;
		}
		
		public function testBufferTime():void
		{
			bufferable.addEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE,eventCatcher);
			
			var oldTime:Number = bufferable.bufferTime;
			
			bufferable.bufferTime = 5;
			assertTrue(bufferable.bufferTime == 5);
			
			bufferable.bufferTime = 10;
			assertTrue(bufferable.bufferTime == 10);
			
			bufferable.bufferTime = -100;
			assertTrue(bufferable.bufferTime == 0);
			
			// Should not trigger an event.
			bufferable.bufferTime = 0;
			
			var bsce:BufferTimeChangeEvent;
			
			assertTrue(events.length == 3);
			
			bsce = events[0] as BufferTimeChangeEvent;
			assertNotNull(bsce);
			assertTrue(bsce.oldTime == oldTime);
			assertTrue(bsce.newTime == 5);
			
			bsce = events[1] as BufferTimeChangeEvent;
			assertNotNull(bsce);
			assertTrue(bsce.oldTime == 5);
			assertTrue(bsce.newTime == 10);
			
			bsce = events[2] as BufferTimeChangeEvent;
			assertNotNull(bsce);
			assertTrue(bsce.oldTime == 10);
			assertTrue(bsce.newTime == 0);
		}
		
		// Utils
		//
		
		protected var bufferable:IBufferable;
		protected var events:Vector.<Event>;
		
		protected function eventCatcher(event:Event):void
		{
			events.push(event);
		}
	}
}