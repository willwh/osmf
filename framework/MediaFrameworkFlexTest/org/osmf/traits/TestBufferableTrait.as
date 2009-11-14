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
	import org.osmf.events.BufferEvent;
	
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
			bufferable.addEventListener(BufferEvent.BUFFERING_CHANGE,eventCatcher);
			
			assertFalse(bufferable.buffering);
			
			bufferableTraitBase.buffering = true;
			assertTrue(bufferable.buffering);
			
			bufferableTraitBase.buffering = false;
			assertFalse(bufferable.buffering);
			
			// Should not trigger a change event:
			bufferableTraitBase.buffering = false;
			
			assertTrue(events.length == 2);
			
			var bce:BufferEvent;
			
			bce = events[0] as BufferEvent;
			assertNotNull(bce);
			assertTrue(bce.buffering);
			
			bce = events[1] as BufferEvent;
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