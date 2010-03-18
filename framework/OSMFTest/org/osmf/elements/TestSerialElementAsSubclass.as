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
package org.osmf.elements
{
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.*;
	import org.osmf.traits.*;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.DynamicSerialElement;

	public class TestSerialElementAsSubclass extends TestCase
	{
		public function testCurrentChild():void
		{
			var currentChildChangeCount:int = 0;
			
			var serial:DynamicSerialElement = new DynamicSerialElement();
			serial.addEventListener("currentChildChange", onCurrentChildChange);
			
			assertTrue(serial.getCurrentChild() == null);
			assertTrue(currentChildChangeCount == 0);
			
			// Add some children.
			//
			
			var child1:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIO, MediaTraitType.LOAD]);
			serial.addChild(child1);
			
			// As soon as we add a child, it becomes the "current child" of the composition.
			assertTrue(serial.getCurrentChild() == child1);
			assertTrue(currentChildChangeCount == 1);

			var child2:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIO, MediaTraitType.BUFFER]);
			serial.addChild(child2);
			
			// No change to the current child.
			assertTrue(serial.getCurrentChild() == child1);
			assertTrue(currentChildChangeCount == 1);
						
			// But if we remove and readd the first child, the second one
			// should now be reflected as the "current child".
			serial.removeChild(child1);
			assertTrue(serial.getCurrentChild() == child2);
			assertTrue(currentChildChangeCount == 2);
			
			serial.addChildAt(child1, 0);
			assertTrue(serial.getCurrentChild() == child2);
			assertTrue(currentChildChangeCount == 2);
			
			// Add some more children.
			//

			var child3:DynamicMediaElement = new DynamicMediaElement([]);
			
			serial.addChild(child3);
			assertTrue(serial.getCurrentChild() == child2);
			assertTrue(currentChildChangeCount == 2);
			
			var child4:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIO]);
			serial.addChildAt(child4, 0);
			assertTrue(serial.getCurrentChild() == child2);
			assertTrue(currentChildChangeCount == 2);

			var child5:DynamicMediaElement = new DynamicMediaElement([MediaTraitType.AUDIO]);
			serial.addChild(child5);
			assertTrue(serial.getCurrentChild() == child2);
			assertTrue(currentChildChangeCount == 2);
			
			// When we remove the current child, the next child should be the
			// new current child.
			serial.removeChild(child2);
			assertTrue(serial.getCurrentChild() == child3);
			assertTrue(currentChildChangeCount == 3);

			serial.removeChild(child3);
			assertTrue(serial.getCurrentChild() == child5);
			assertTrue(currentChildChangeCount == 4);
			
			// Now when we remove the current child, the new current child is
			// the first child since there is no next child.
			serial.removeChild(child5);
			assertTrue(serial.getCurrentChild() == child4);
			assertTrue(currentChildChangeCount == 5);
			
			// When we remove the last child, we have no more current child.
			serial.removeChild(child4);
			assertTrue(serial.getCurrentChild() == child1);
			assertTrue(currentChildChangeCount == 6);
			serial.removeChild(child1);
			assertTrue(serial.getCurrentChild() == null);
			assertTrue(currentChildChangeCount == 7);
			
			function onCurrentChildChange(event:Event):void
			{
				currentChildChangeCount++;
			}
		}
	}
}