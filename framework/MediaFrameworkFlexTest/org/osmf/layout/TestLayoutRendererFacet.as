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
	
	import org.osmf.metadata.NullFacetSynthesizer;
	import org.osmf.metadata.StringIdentifier;

	public class TestLayoutRendererFacet extends TestCase
	{
		public function testLayoutRendererFacet():void
		{
			var facet:LayoutRendererFacet = new LayoutRendererFacet(DefaultLayoutRenderer);
			
			assertNotNull(facet);
			assertEquals(facet.rendererType, DefaultLayoutRenderer);
			assertEquals(facet.getValue(null), DefaultLayoutRenderer);
			assertEquals(facet.getValue(new StringIdentifier("wa!")), DefaultLayoutRenderer);
			
			assertEquals(DefaultLayoutRenderer, facet.getValue(null));
			assertEquals(DefaultLayoutRenderer, facet.getValue(new StringIdentifier("@*#$^98367423874")));
			
			assertTrue(facet.synthesizer is NullFacetSynthesizer);
		}
		
	}
}