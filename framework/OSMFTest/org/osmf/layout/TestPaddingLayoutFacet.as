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
	
	import org.osmf.events.FacetValueChangeEvent;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.NullFacetSynthesizer;
	import org.osmf.metadata.StringIdentifier;

	public class TestPaddingLayoutFacet extends TestCase
	{
		public function testPaddingLayoutFacet():void
		{
			var lastEvent:FacetValueChangeEvent;
			var eventCounter:int = 0;

			function onFacetChange(event:FacetValueChangeEvent):void
			{
				lastEvent = event;
				eventCounter++;
			}
			
			var facet:PaddingLayoutFacet = new PaddingLayoutFacet();
			facet.addEventListener(FacetValueChangeEvent.VALUE_CHANGE, onFacetChange);
						
			assertEquals(facet.namespaceURL, MetadataNamespaces.PADDING_LAYOUT_PARAMETERS);
			
			facet.left = 1;
			
			assertEquals(1, eventCounter);
			assertEquals(PaddingLayoutFacet.LEFT, lastEvent.identifier);
			assertEquals(NaN, lastEvent.oldValue);
			assertEquals(1, lastEvent.value);
			assertEquals(facet.left, facet.getValue(PaddingLayoutFacet.LEFT), 1);
			
			facet.top = 2;
			
			assertEquals(2, eventCounter);
			assertEquals(PaddingLayoutFacet.TOP, lastEvent.identifier);
			assertEquals(NaN, lastEvent.oldValue);
			assertEquals(2, lastEvent.value);
			assertEquals(facet.top, facet.getValue(PaddingLayoutFacet.TOP), 2);
			
			facet.right = 3;
			
			assertEquals(3, eventCounter);
			assertEquals(PaddingLayoutFacet.RIGHT, lastEvent.identifier);
			assertEquals(NaN, lastEvent.oldValue);
			assertEquals(3, lastEvent.value);
			assertEquals(facet.right, facet.getValue(PaddingLayoutFacet.RIGHT), 3);
			
			facet.bottom = 4;
			
			assertEquals(4, eventCounter);
			assertEquals(PaddingLayoutFacet.BOTTOM, lastEvent.identifier);
			assertEquals(NaN, lastEvent.oldValue);
			assertEquals(4, lastEvent.value);
			assertEquals(facet.bottom, facet.getValue(PaddingLayoutFacet.BOTTOM), 4);
			
			assertEquals(undefined, facet.getValue(null));
			assertEquals(undefined, facet.getValue(new StringIdentifier("@*#$^98367423874")));
			
			assertTrue(facet.synthesizer is NullFacetSynthesizer);
		}
	}
}