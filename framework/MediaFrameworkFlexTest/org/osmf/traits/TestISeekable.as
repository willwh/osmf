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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.osmf.events.SeekingChangeEvent;
	import org.osmf.utils.InterfaceTestCase;

	public class TestISeekable extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			eventDispatcher = new EventDispatcher();
			events = new Vector.<Event>;
			_seekable = createInterfaceObject() as ISeekable;
		}
		
		protected function get maxSeekValue():Number
		{
			return 0;
		}
		
		protected function get processesSeekCompletion():Boolean
		{
			// Some implementations of ISeekable will signal completion 
			// of a seek, although the default implementation doesn't.
			// Subclasses can override this to indicate that they process
			// completion.
			return false;
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
				eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, 5000));

				var eventCount:int = 0;

				seekable.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, onTestSeek);
				assertTrue(seekable.canSeekTo(maxSeekValue));
				seekable.seek(maxSeekValue);
				
				function onTestSeek(event:SeekingChangeEvent):void
				{
					eventCount++;
					
					if (eventCount == 1)
					{
						assertTrue(event.seeking);
						assertTrue(event.time == maxSeekValue);
						if (processesSeekCompletion == false)
						{
							eventDispatcher.dispatchEvent(new Event("testComplete"));
						}
					}
					else if (eventCount == 2)
					{
						assertTrue(event.seeking == false);
						assertTrue(event.time == maxSeekValue);
						assertTrue(processesSeekCompletion == true);
						
						eventDispatcher.dispatchEvent(new Event("testComplete"));
					}
					else fail();
				}
			}
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
		
		// Protected
		//
		
		protected function get seekable():ISeekable
		{
			return _seekable;
		}
		
		// Internals
		//

		private function eventCatcher(event:Event):void
		{
			events.push(event);
		}

		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder
		}

		private var _seekable:ISeekable;
		private var events:Vector.<Event>;
		private var eventDispatcher:EventDispatcher;
	}
}