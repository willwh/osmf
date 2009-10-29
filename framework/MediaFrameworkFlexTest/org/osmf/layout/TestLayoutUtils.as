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
	import org.osmf.metadata.Metadata;

	public class TestLayoutUtils extends TestCase
	{
		public function testLayoutUtils():void
		{
			var metadata:Metadata = new Metadata();
			
			var absolute:AbsoluteLayoutFacet
				= LayoutUtils.setAbsoluteLayout(metadata,1,2,3,4);
				
			assertEquals(1,absolute.width);
			assertEquals(2,absolute.height);
			assertEquals(3,absolute.x);
			assertEquals(4,absolute.y);
			
			var relative:RelativeLayoutFacet
				= LayoutUtils.setRelativeLayout(metadata,1,2,3,4);
				
			assertEquals(1,relative.width);
			assertEquals(2,relative.height);
			assertEquals(3,relative.x);
			assertEquals(4,relative.y);
			
			var anchor:AnchorLayoutFacet
				= LayoutUtils.setAnchorLayout(metadata,1,2,3,4);
				
			assertEquals(1,anchor.left);
			assertEquals(2,anchor.top);
			assertEquals(3,anchor.right);
			assertEquals(4,anchor.bottom);
			
			var attributes:LayoutAttributesFacet
				= LayoutUtils.setLayoutAttributes(metadata, ScaleMode.ZOOM, RegistrationPoint.BOTTOM_LEFT);
				
			assertEquals(ScaleMode.ZOOM, attributes.scaleMode);
			assertEquals(RegistrationPoint.BOTTOM_LEFT, attributes.alignment);
			
			var rendererFacet:LayoutRendererFacet
				= LayoutUtils.setLayoutRenderer(metadata, DefaultLayoutRenderer);
				
			assertEquals(DefaultLayoutRenderer, rendererFacet.rendererType);
		}
		
	}
}