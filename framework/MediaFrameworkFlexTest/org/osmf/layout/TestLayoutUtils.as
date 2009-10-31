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
	
	import org.osmf.display.ScaleMode;
	import org.osmf.metadata.IFacet;
	import org.osmf.metadata.Metadata;

	public class TestLayoutUtils extends TestCase
	{
		public function testLayoutUtils():void
		{
			// For the sake of coverage (but otherwise completely useles):
			var layoutUtils:LayoutUtils = new LayoutUtils();
			assertNotNull(layoutUtils);
			
			// Run all available methods with a null metadata arg, making sure they
			// throw an exception:
			assertTrue(throws(function():void{LayoutUtils.setAbsoluteLayout(null,0,0);}));
			assertTrue(throws(function():void{LayoutUtils.setAnchorLayout(null,0,0,0,0);}));
			assertTrue(throws(function():void{LayoutUtils.setLayoutAttributes(null,null,null);}));
			assertTrue(throws(function():void{LayoutUtils.setLayoutRenderer(null,null);}));
			assertTrue(throws(function():void{LayoutUtils.setRelativeLayout(null,0,0);}));
			
			var i:int;
			var metadata:Metadata = new Metadata();
			
			var c1:AbsoluteLayoutFacet;
			var c2:RelativeLayoutFacet;
			var c3:AnchorLayoutFacet;
			var c4:LayoutAttributesFacet;
			var c5:LayoutRendererFacet;
			
			// Run all these test twice: once without the facet present, and once
			// when it is:
			for (i=0; i<2; i++)
			{
				var absolute:AbsoluteLayoutFacet
					= c1
					= LayoutUtils.setAbsoluteLayout(metadata,1,2,3,4);
					
				if (i == 1) assertEquals(c1, absolute);
					
				assertEquals(1,absolute.width);
				assertEquals(2,absolute.height);
				assertEquals(3,absolute.x);
				assertEquals(4,absolute.y);
				
				assertNull(absolute.merge(null));
				
				var relative:RelativeLayoutFacet
					= c2
					= LayoutUtils.setRelativeLayout(metadata,1,2,3,4);
					
				if (i == 1) assertEquals(c2, relative);
					
				assertEquals(1,relative.width);
				assertEquals(2,relative.height);
				assertEquals(3,relative.x);
				assertEquals(4,relative.y);
				
				assertNull(relative.merge(null));
				
				var anchor:AnchorLayoutFacet
					= c3
					= LayoutUtils.setAnchorLayout(metadata,1,2,3,4);
					
				if (i == 1) assertEquals(c3, anchor);
					
				assertEquals(1,anchor.left);
				assertEquals(2,anchor.top);
				assertEquals(3,anchor.right);
				assertEquals(4,anchor.bottom);
				
				assertNull(anchor.merge(null));
				
				var attributes:LayoutAttributesFacet
					= c4
					= LayoutUtils.setLayoutAttributes
						( metadata
						, ScaleMode.ZOOM
						, RegistrationPoint.BOTTOM_LEFT
						, 10
						);
						
				if (i == 1) assertEquals(c4, attributes);
					
				assertEquals(ScaleMode.ZOOM, attributes.scaleMode);
				assertEquals(RegistrationPoint.BOTTOM_LEFT, attributes.alignment); 
				assertEquals(10, attributes.order);
				
				assertNull(attributes.merge(null));
				
				var rendererFacet:LayoutRendererFacet
					= c5
					= LayoutUtils.setLayoutRenderer(metadata, DefaultLayoutRenderer);
				
				if (i == 1) assertEquals(c5, rendererFacet);
					
				assertEquals(DefaultLayoutRenderer, rendererFacet.rendererType);
				
				assertNull(rendererFacet.merge(null));
			}
		}
		
		private function throws(f:Function):Boolean
		{
			var result:Boolean;
			
			try
			{
				f();
			}
			catch(e:Error)
			{
				result = true;
			}
			
			return result;
		}
		
	}
}