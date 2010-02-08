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
	import org.osmf.display.ScaleMode;
	import org.osmf.flexunit.TestCaseEx;
	import org.osmf.media.MediaElement;

	public class TestLayoutRendererProperties extends TestCaseEx
	{
		public function testLayoutUtils():void
		{
			assertThrows(function():void{ new LayoutRendererProperties(null); });
			
			var lp:LayoutRendererProperties = new LayoutRendererProperties(new MediaElement());
			assertNotNull(lp);
			
			assertEquals(NaN, lp.order);
			assertEquals(null, lp.scaleMode);
			assertEquals(null, lp.verticalAlignment);
			assertEquals(null, lp.horizontalAlignment);
			assertEquals(false, lp.snapToPixel);
			assertEquals(null, lp.mode);
			
			assertEquals(NaN, lp.x);
			assertEquals(NaN, lp.y);			
			assertEquals(NaN, lp.width);
			assertEquals(NaN, lp.height);
			
			assertEquals(NaN, lp.percentX);
			assertEquals(NaN, lp.percentY);
			assertEquals(NaN, lp.percentWidth);
			assertEquals(NaN, lp.percentHeight);
						
			assertEquals(NaN, lp.left);
			assertEquals(NaN, lp.right);
			assertEquals(NaN, lp.top);
			assertEquals(NaN, lp.bottom);
			
			assertEquals(NaN, lp.paddingLeft);
			assertEquals(NaN, lp.paddingRight);
			assertEquals(NaN, lp.paddingTop);
			assertEquals(NaN, lp.paddingBottom);
			
			// Check all routines twice; first time around, a facet
			// could be created.
			for (var i:int = 0; i<2; i++)
			{
				lp.order = 1;
				assertEquals(1, lp.order);
				
				lp.verticalAlignment = VerticalAlign.BOTTOM;
				assertEquals(VerticalAlign.BOTTOM, lp.verticalAlignment);
				
				lp.horizontalAlignment = HorizontalAlign.CENTER;
				assertEquals(HorizontalAlign.CENTER, lp.horizontalAlignment);
				
				lp.scaleMode = ScaleMode.LETTERBOX;
				assertEquals(ScaleMode.LETTERBOX, lp.scaleMode);
				
				lp.snapToPixel = true;
				assertTrue(lp.snapToPixel);
				
				lp.mode 
				
				lp.x = 1;
				assertEquals(1, lp.x);
				
				lp.y = 2;
				assertEquals(2, lp.y);
				
				lp.width = 3;
				assertEquals(3, lp.width);
				
				lp.height = 4;
				assertEquals(4, lp.height);
				
				lp.percentX = 5;
				assertEquals(5, lp.percentX);
				
				lp.percentY = 6;
				assertEquals(6, lp.percentY);
				
				lp.percentWidth = 7;
				assertEquals(7, lp.percentWidth);
				
				lp.percentWidth = 8;
				assertEquals(8, lp.percentWidth);
				
				lp.left = 9;
				assertEquals(9, lp.left);
				
				lp.right = 10;
				assertEquals(10, lp.right);
				
				lp.top = 11;
				assertEquals(11, lp.top);
				
				lp.bottom = 12;
				assertEquals(12, lp.bottom);
				
				lp.paddingLeft = 13;
				assertEquals(13, lp.paddingLeft);
				
				lp.paddingRight = 14;
				assertEquals(14, lp.paddingRight);
				
				lp.paddingTop = 15;
				assertEquals(15, lp.paddingTop);
				
				lp.paddingBottom = 16;
				assertEquals(16, lp.paddingBottom);
			} 
		}
	}
}