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
	
	import flash.events.Event;
	
	import org.openvideoplayer.events.SeekingChangeEvent;
	import org.openvideoplayer.utils.InterfaceTestCase;

	public class TestISeekable extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			events = new Vector.<Event>;
			seekable = createInterfaceObject() as ISeekable;
		}
		
		protected function get maxSeekValue():Number
		{
			return 0;
		}
		
		public function testSeeking():void
		{
			assertFalse(seekable.seeking);
		}
		
		public function testCanSeekTo():void
		{
			assertFalse(seekable.canSeekTo(-1));
			if (maxSeekValue > 0)
			{
				assertTrue(seekable.canSeekTo(maxSeekValue));
			}
			assertFalse(seekable.canSeekTo(maxSeekValue+1));
		}
		
		public function testSeek():void
		{
			if (maxSeekValue > 0)
			{
				seekable.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, addAsync(onTestSeek, 1000));
				
				assertTrue(seekable.canSeekTo(maxSeekValue));
				
				seekable.seek(maxSeekValue);
			}
		}
		
		private function onTestSeek(event:SeekingChangeEvent):void
		{
			assertTrue(event.seeking);
		}

		public function testSeekInvalid():void
		{
			if (maxSeekValue > 0)
			{
				seekable.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, eventCatcher);
			
				assertFalse(seekable.canSeekTo(maxSeekValue + 1));
				
				seekable.seek(maxSeekValue + 1);
					
				// This should not cause any change events:
				assertTrue(events.length == 0);
			}
		}
		
		// Utils
		//
		
		protected var seekable:ISeekable;
		protected var events:Vector.<Event>;
		
		protected function eventCatcher(event:Event):void
		{
			events.push(event);
		}
	}
}