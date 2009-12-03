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
package org.osmf.metadata
{
	import flexunit.framework.TestCase;
	
	import org.osmf.composition.CompositionMode;
	import org.osmf.utils.URL;

	public class TestCompositeMetadata extends TestCase
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
			assertNull(cm.getFacetSynthesizer(new URL()));
			
			assertEquals(cm.numChildren, 0);
			
			assertThrows(function():void{cm.childAt(0)});
			assertThrows(function():void{cm.addChild(null)});
			cm.addChild(metadata);
			assertEquals(1, cm.numChildren);
			assertEquals(metadata, cm.childAt(0));
			assertThrows(function():void{cm.addChild(metadata)});
			cm.removeChild(metadata);
			assertEquals(0, cm.numChildren);
			assertThrows(function():void{cm.removeChild(metadata)});
			assertThrows(function():void{cm.removeChild(null)});
			
			assertEquals(0, cm.getFacetGroupNamespaceURLs().length);
			assertNull(cm.getFacetSynthesizer(null));
			assertThrows(function():void{cm.removeFacetSynthesizer(null)});
			assertThrows(function():void{cm.addFacetSynthesizer(null)});
			
			var url:URL = new URL("myURL");
			var synth:AFacetSynthesizer = new AFacetSynthesizer(url);
			cm.addFacetSynthesizer(synth);
			assertEquals(synth, cm.getFacetSynthesizer(url));
			assertThrows(function():void{cm.addFacetSynthesizer(synth)});
			cm.removeFacetSynthesizer(synth);
			assertNull(null, cm.getFacetSynthesizer(url));
			cm.addFacetSynthesizer(synth);
		}
	
		private function assertThrows(f:Function):void
		{
			try
			{
				f();
				fail();
			}
			catch(e:Error)
			{	
			}
		}
	}
}
	import org.osmf.metadata.FacetSynthesizer;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.FacetGroup;
	import org.osmf.composition.CompositionMode;
	import org.osmf.metadata.IFacet;
	import org.osmf.utils.URL;
	

class AFacetSynthesizer extends FacetSynthesizer
{
	public function AFacetSynthesizer(namespaceURL:URL)
	{
		super(namespaceURL);
	}
	
	override public function synthesize
		( targetMetadata:Metadata
		, facetGroup:FacetGroup
		, mode:CompositionMode
		, activeMetadata:Metadata
		):IFacet
	{
		return null;
	}
}