/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The mediaContainers of this file are subject to the Mozilla Public License
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
package org.osmf.display
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.flexunit.TestCaseEx;
	
	public class TestMediaContainerGroup extends TestCaseEx
	{
		public function testNestedContainerMetrics():void
		{
			var root:MediaContainerGroup = new MediaContainerGroup();
			var childA:MediaContainerGroup = new MediaContainerGroup();
			var childA1:MediaContainerGroup = new MediaContainerGroup();
			var childA1A:MediaContainerGroup = new MediaContainerGroup();
			
			root.addChildGroup(childA);
			childA.addChildGroup(childA1);
			childA1.addChildGroup(childA1A);
			
			root.validateNow();
			
			assertEquals(0, root.width);
			assertEquals(0, root.height);
			assertEquals(0, root.measuredWidth);
			assertEquals(0, root.measuredHeight);
			
			childA1A.width = 400;
			childA1A.height = 50;
			root.validateNow();
			
			assertEquals(400, childA1A.width);
			assertEquals(50, childA1A.height);
			assertEquals(400, childA1A.measuredWidth);
			assertEquals(50, childA1A.measuredHeight);
			
			assertEquals(400, childA1.measuredWidth);
			assertEquals(50, childA1.measuredHeight);
			
			assertEquals(400, root.width);
			assertEquals(50, root.height);
			assertEquals(400, root.measuredWidth);
			assertEquals(50, root.measuredHeight);
		}
		
		public function testContainerSubContainers():void
		{
			var parent:MediaContainerGroup = new MediaContainerGroup();
			assertNotNull(parent.mediaContainer);
			parent.mediaContainer.backgroundColor = 0xff0000;
			parent.mediaContainer.backgroundAlpha = 1;
			parent.clipChildren = true;
			
			var sub1:MediaContainerGroup = new MediaContainerGroup();
			var sub2:MediaContainerGroup = new MediaContainerGroup();
			
			assertNotNull(parent);
			assertFalse(parent.containsChildGroup(sub1));
			assertFalse(parent.containsChildGroup(sub2));
			
			parent.addChildGroup(sub1);
			assertTrue(parent.containsChildGroup(sub1));
			
			parent.addChildGroup(sub2);
			assertTrue(parent.containsChildGroup(sub2));
			
			parent.removeChildGroup(sub1);
			assertFalse(parent.containsChildGroup(sub1));
			
			var error:Error;
			try
			{
				parent.removeChildGroup(sub1);
			}
			catch(e:Error)
			{
				error = e;
			}
			
			assertNotNull(error);
			assertTrue(error is IllegalOperationError);
		}
	}
}