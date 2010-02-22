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
package org.osmf.elements.compositeClasses
{
	import org.osmf.flexunit.TestCaseEx;
	import org.osmf.metadata.Facet;
	import org.osmf.metadata.FacetGroup;
	import org.osmf.metadata.FacetKey;
	import org.osmf.metadata.FacetSynthesizer;
	import org.osmf.metadata.Metadata;

	public class TestCompositeMetadata extends TestCaseEx
	{
		public function testCompositeMetadataBase():void
		{
			var cm:CompositeMetadata = new CompositeMetadata();
			assertNotNull(cm);
			
			assertNull(cm.mode);
			cm.mode = CompositionMode.SERIAL;
			assertEquals(cm.mode, CompositionMode.SERIAL);
			
			assertNull(cm.activeChild);
			var metadata:Metadata = new CompositeMetadata(); 
			cm.activeChild = metadata;
			assertEquals(metadata, cm.activeChild);
			
			assertNull(cm.getFacetSynthesizer(null));
			
			assertEquals(cm.numChildren, 0);
			
			assertThrows(cm.getChildAt, 0);
			assertThrows(cm.addChild, 0);
			assertDispatches(cm, [CompositeMetadataEvent.CHILD_ADD], cm.addChild, metadata);
			assertEquals(1, cm.numChildren);
			assertEquals(metadata, cm.getChildAt(0));
			assertThrows(cm.addChild, metadata);
			assertDispatches(cm, [CompositeMetadataEvent.CHILD_REMOVE], cm.removeChild, metadata);
			assertEquals(0, cm.numChildren);
			assertThrows(cm.removeChild, metadata);
			assertThrows(cm.removeChild, null);
			
			assertEquals(0, cm.getFacetGroupNamespaceURLs().length);
			assertNull(cm.getFacetSynthesizer(null));
			assertThrows(cm.removeFacetSynthesizer, null);
			assertThrows(cm.addFacetSynthesizer, null);
			
			var url:String = "myURL";
			var synth:AFacetSynthesizer = new AFacetSynthesizer(url);
			cm.addFacetSynthesizer(synth);
			assertEquals(synth, cm.getFacetSynthesizer(url));
			assertThrows(function():void{cm.addFacetSynthesizer(synth)});
			cm.removeFacetSynthesizer(synth);
			assertNull(null, cm.getFacetSynthesizer(url));
			cm.addFacetSynthesizer(synth);
			
			var facet:Facet = new Facet(url);
			facet.addValue(new FacetKey(url),"test");
			cm.addChild(metadata);
			assertDispatches
				(	cm
				,	[ CompositeMetadataEvent.FACET_GROUP_ADD
					, CompositeMetadataEvent.CHILD_FACET_ADD
					]
				,	metadata.addFacet
				,	facet
				);	
			
			var md2:Metadata = new Metadata();
			md2.addFacet(facet);
			assertDispatches
				( 	cm
				, 	[ CompositeMetadataEvent.CHILD_ADD
					, CompositeMetadataEvent.FACET_GROUP_CHANGE	
				  	]
				, 	cm.addChild
				,	md2
				);
				
			assertDispatches
				( 	cm
				, 	[ CompositeMetadataEvent.CHILD_FACET_REMOVE
					, CompositeMetadataEvent.FACET_GROUP_CHANGE	
				  	]
				, 	md2.removeFacet
				,	facet
				);
				
			assertDispatches
				( 	cm
				, 	[ CompositeMetadataEvent.CHILD_FACET_REMOVE
					, CompositeMetadataEvent.FACET_GROUP_CHANGE
					, CompositeMetadataEvent.FACET_GROUP_REMOVE
				  	]
				, 	metadata.removeFacet
				,	facet 
				);
			
			assertDispatches
				( 	cm
				, 	[ CompositeMetadataEvent.CHILD_REMOVE
				  	]
				, 	cm.removeChild
				,	metadata
				);
		}
	
		public function testCompositeMetadataEvent():void
		{
			var child:Metadata = new Metadata();
			var facet:Facet = new Facet("test");
			var facetGroup:FacetGroup = new FacetGroup("");
			var facetSynthesizer:FacetSynthesizer = new AFacetSynthesizer("");
			var e:CompositeMetadataEvent
				= new CompositeMetadataEvent
					( CompositeMetadataEvent.CHILD_ADD
					, false, false
					, child, facet, facetGroup, facetSynthesizer
					);
					
			assertNotNull(e);
			assertEquals(child, e.child);
			assertEquals(facet, e.facet);
			assertEquals(facetGroup, e.facetGroup);
			assertEquals(facetSynthesizer, e.suggestedFacetSynthesizer);
		}
	}
}

import org.osmf.elements.compositeClasses.CompositionMode;
import org.osmf.metadata.Facet;
import org.osmf.metadata.FacetGroup;
import org.osmf.metadata.FacetSynthesizer;
import org.osmf.metadata.Metadata;

class AFacetSynthesizer extends FacetSynthesizer
{
	public function AFacetSynthesizer(namespaceURL:String)
	{
		super(namespaceURL);
	}
	
	override public function synthesize
		( targetMetadata:Metadata
		, facetGroup:FacetGroup
		, mode:String
		, activeMetadata:Metadata
		):Facet
	{
		return null;
	}
}