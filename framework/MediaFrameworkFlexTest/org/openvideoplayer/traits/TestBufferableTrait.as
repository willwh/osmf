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
	import org.openvideoplayer.events.BufferingChangeEvent;
	
	public class TestBufferableTrait extends TestIBufferable
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new BufferableTrait();
		}
		
		protected function get canChangeBufferLength():Boolean
		{
			return true;
		}
		
		public function testBuffering():void
		{
			bufferable.addEventListener(BufferingChangeEvent.BUFFERING_CHANGE,eventCatcher);
			
			assertFalse(bufferable.buffering);
			
			bufferableTraitBase.buffering = true;
			assertTrue(bufferable.buffering);
			
			bufferableTraitBase.buffering = false;
			assertFalse(bufferable.buffering);
			
			// Should not trigger a change event:
			bufferableTraitBase.buffering = false;
			
			assertTrue(events.length == 2);
			
			var bce:BufferingChangeEvent;
			
			bce = events[0] as BufferingChangeEvent;
			assertNotNull(bce);
			assertTrue(bce.buffering);
			
			bce = events[1] as BufferingChangeEvent;
			assertNotNull(bce);
			assertFalse(bce.buffering);
		}
		
		public function testBufferLength():void
		{
			bufferableTraitBase.bufferLength = 10;
			if (canChangeBufferLength)
			{
				assertTrue(bufferable.bufferLength == 10);
			}
			else
			{
				assertTrue(bufferable.bufferLength == 0);
			}
		}
		
		// Utils
		//
		
		protected function get bufferableTraitBase():BufferableTrait
		{
			return bufferable as BufferableTrait;
		}
		
	}
}