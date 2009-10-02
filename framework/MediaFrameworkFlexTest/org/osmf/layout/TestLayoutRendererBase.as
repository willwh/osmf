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
package org.osmf.layout
{
	import flexunit.framework.TestCase;

	public class TestLayoutRendererBase extends TestCase
	{
		public function testBaseLayoutRenderer():void
		{
			var renderer:LayoutRendererBase = new LayoutRendererBase();
			assertNotNull(renderer);
			
			var c:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			
			var l1:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			l1.setIntrinsicDimensions(50,200);
			
			var l2:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			l2.setIntrinsicDimensions(100,150);
			
			renderer.context = c;
			c.layoutRenderer = renderer;
			
			renderer.addTarget(l1);
			renderer.addTarget(l2);
			
			renderer.validateNow();
			
			assertEquals(50, l1.calculatedWidth);
			assertEquals(200, l1.calculatedHeight);
			
			assertEquals(100, l2.calculatedWidth);
			assertEquals(150, l2.calculatedHeight);
			
			assertEquals(50, l1.projectedWidth);
			assertEquals(200, l1.projectedHeight);
			
			assertEquals(100, l2.projectedWidth);
			assertEquals(150, l2.projectedHeight); 
			
			// Top level container does not have projected dimensions (for
			// there's no-one rendering it:)
			assertEquals(NaN, c.projectedWidth);
			assertEquals(NaN, c.projectedHeight);
			
			// Top level container should have aggregate calculated dimensions:
			assertEquals(100, c.calculatedWidth);
			assertEquals(200, c.calculatedHeight);
		}
		
	}
}