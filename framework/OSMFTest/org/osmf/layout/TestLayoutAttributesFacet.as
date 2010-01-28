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
	import org.osmf.metadata.StringIdentifier;

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
			
			facet.alignment = RegistrationPoint.BOTTOM_RIGHT;
			
			assertEquals(1, eventCounter);
			assertEquals(LayoutAttributesFacet.ALIGNMENT, lastEvent.identifier);
			assertEquals(null, lastEvent.oldValue);
			assertEquals(RegistrationPoint.BOTTOM_RIGHT, lastEvent.value);
			assertEquals(facet.alignment, facet.getValue(LayoutAttributesFacet.ALIGNMENT), RegistrationPoint.BOTTOM_RIGHT);
			
			facet.order = 2;
			
			assertEquals(2, eventCounter);
			assertEquals(LayoutAttributesFacet.ORDER, lastEvent.identifier);
			assertEquals(NaN, lastEvent.oldValue);
			assertEquals(2, lastEvent.value);
			assertEquals(facet.order, facet.getValue(LayoutAttributesFacet.ORDER), 2);
			
			facet.registrationPoint = RegistrationPoint.TOP_MIDDLE;
			
			assertEquals(3, eventCounter);
			assertEquals(LayoutAttributesFacet.REGISTRATION_POINT, lastEvent.identifier);
			assertEquals(RegistrationPoint.TOP_LEFT, lastEvent.oldValue);
			assertEquals(RegistrationPoint.TOP_MIDDLE, lastEvent.value);
			assertEquals(facet.registrationPoint, facet.getValue(LayoutAttributesFacet.REGISTRATION_POINT), RegistrationPoint.TOP_MIDDLE);
			
			facet.snapToPixel = true;
			
			assertEquals(4, eventCounter);
			assertEquals(LayoutAttributesFacet.SNAP_TO_PIXEL, lastEvent.identifier);
			assertEquals(false, lastEvent.oldValue);
			assertEquals(true, lastEvent.value);
			assertEquals(facet.snapToPixel, facet.getValue(LayoutAttributesFacet.SNAP_TO_PIXEL), true);
			
			facet.scaleMode = ScaleMode.LETTERBOX;
			
			assertEquals(5, eventCounter);
			assertEquals(LayoutAttributesFacet.SCALE_MODE, lastEvent.identifier);
			assertEquals(null, lastEvent.oldValue);
			assertEquals(ScaleMode.LETTERBOX, lastEvent.value);
			assertEquals(facet.scaleMode, facet.getValue(LayoutAttributesFacet.SCALE_MODE), ScaleMode.LETTERBOX);
			
			assertEquals(undefined, facet.getValue(null));
			assertEquals(undefined, facet.getValue(new StringIdentifier("@*#$^98367423874")));
			
			assertTrue(facet.synthesizer is NullFacetSynthesizer);
		}
	}
}