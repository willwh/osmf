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
	import org.osmf.layout.LayoutUtils;
	
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
			
			root.layoutRenderer.validateNow();
			
			assertEquals(NaN, root.width);
			assertEquals(NaN, root.height);
			assertEquals(NaN, root.calculatedWidth);
			assertEquals(NaN, root.calculatedHeight);
			assertEquals(NaN, root.projectedWidth);
			assertEquals(NaN, root.projectedHeight);
			
			LayoutUtils.setAbsoluteLayout(childA1A.metadata,400,50);
			root.layoutRenderer.validateNow();
			
			assertEquals(NaN, root.width);
			assertEquals(NaN, root.height);
			assertEquals(400, root.calculatedWidth);
			assertEquals(50, root.calculatedHeight);
			assertEquals(NaN, root.projectedWidth);
			assertEquals(NaN, root.projectedHeight);
			
			assertEquals(400, childA1A.width);
			assertEquals(50, childA1A.height);
			assertEquals(400, childA1A.calculatedWidth);
			assertEquals(50, childA1A.calculatedHeight);
			assertEquals(400, childA1A.projectedWidth);
			assertEquals(50, childA1A.projectedHeight);
			
			assertEquals(400, childA1.calculatedWidth);
			assertEquals(50, childA1.calculatedHeight);
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
			assertFalse(parent.containsGroup(sub1));
			assertFalse(parent.containsGroup(sub2));
			
			parent.addChildGroup(sub1);
			assertTrue(parent.containsGroup(sub1));
			
			parent.addChildGroup(sub2);
			assertTrue(parent.containsGroup(sub2));
			
			parent.removeChildGroup(sub1);
			assertFalse(parent.containsGroup(sub1));
			
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