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
	import org.osmf.events.FacetValueChangeEvent;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.NullFacetSynthesizer;
	import org.osmf.metadata.FacetKey;

	public class TestLayoutAttributesFacet extends TestCase
	{
		public function testLayoutAttributesFacet():void
		{
			var lastEvent:FacetValueChangeEvent;
			var eventCounter:int = 0;

			function onFacetChange(event:FacetValueChangeEvent):void
			{
				lastEvent = event;
				eventCounter++;
			}
			
			var facet:LayoutAttributesFacet = new LayoutAttributesFacet();
			facet.addEventListener(FacetValueChangeEvent.VALUE_CHANGE, onFacetChange);
						
			assertEquals(facet.namespaceURL, MetadataNamespaces.LAYOUT_ATTRIBUTES);
			
			facet.verticalAlign = VerticalAlign.BOTTOM;
			
			assertEquals(1, eventCounter);
			assertEquals(LayoutAttributesFacet.VERTICAL_ALIGN, lastEvent.key);
			assertEquals(null, lastEvent.oldValue);
			assertEquals(VerticalAlign.BOTTOM, lastEvent.value);
			assertEquals(facet.verticalAlign, facet.getValue(LayoutAttributesFacet.VERTICAL_ALIGN), VerticalAlign.BOTTOM);
			
			facet.horizontalAlign = HorizontalAlign.RIGHT;
			
			assertEquals(2, eventCounter);
			assertEquals(LayoutAttributesFacet.HORIZONTAL_ALIGN, lastEvent.key);
			assertEquals(null, lastEvent.oldValue);
			assertEquals(HorizontalAlign.RIGHT, lastEvent.value);
			assertEquals(facet.horizontalAlign, facet.getValue(LayoutAttributesFacet.HORIZONTAL_ALIGN), HorizontalAlign.RIGHT);
			
			facet.index = 2;
			
			assertEquals(3, eventCounter);
			assertEquals(LayoutAttributesFacet.INDEX, lastEvent.key);
			assertEquals(NaN, lastEvent.oldValue);
			assertEquals(2, lastEvent.value);
			assertEquals(facet.index, facet.getValue(LayoutAttributesFacet.INDEX), 2);
			
			facet.snapToPixel = false;
			
			assertEquals(4, eventCounter);
			assertEquals(LayoutAttributesFacet.SNAP_TO_PIXEL, lastEvent.key);
			assertEquals(true, lastEvent.oldValue);
			assertEquals(false, lastEvent.value);
			assertEquals(facet.snapToPixel, facet.getValue(LayoutAttributesFacet.SNAP_TO_PIXEL), false);
			
			facet.scaleMode = ScaleMode.LETTERBOX;
			
			assertEquals(5, eventCounter);
			assertEquals(LayoutAttributesFacet.SCALE_MODE, lastEvent.key);
			assertEquals(null, lastEvent.oldValue);
			assertEquals(ScaleMode.LETTERBOX, lastEvent.value);
			assertEquals(facet.scaleMode, facet.getValue(LayoutAttributesFacet.SCALE_MODE), ScaleMode.LETTERBOX);
			
			assertEquals(undefined, facet.getValue(null));
			assertEquals(undefined, facet.getValue(new FacetKey("@*#$^98367423874")));
			
			assertTrue(facet.synthesizer is NullFacetSynthesizer);
		}
	}
}