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
	
	import org.osmf.events.SeekingChangeEvent;
	import org.osmf.utils.InterfaceTestCase;

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