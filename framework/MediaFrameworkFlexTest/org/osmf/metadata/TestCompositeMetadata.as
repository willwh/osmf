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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.composition.CompositionMode;
	import org.osmf.events.CompositeMetadataEvent;
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
			assertNull(cm.getFacetSynthesizer(new URL(null)));
			
			assertEquals(cm.numChildren, 0);
			
			assertThrows(cm.childAt, 0);
			assertThrows(cm.addChild, 0);
			assertDispatches(cm, [CompositeMetadataEvent.CHILD_ADD], cm.addChild, metadata);
			assertEquals(1, cm.numChildren);
			assertEquals(metadata, cm.childAt(0));
			assertThrows(cm.addChild, metadata);
			assertDispatches(cm, [CompositeMetadataEvent.CHILD_REMOVE], cm.removeChild, metadata);
			assertEquals(0, cm.numChildren);
			assertThrows(cm.removeChild, metadata);
			assertThrows(cm.removeChild, null);
			
			assertEquals(0, cm.getFacetGroupNamespaceURLs().length);
			assertNull(cm.getFacetSynthesizer(null));
			assertThrows(cm.removeFacetSynthesizer, null);
			assertThrows(cm.addFacetSynthesizer, null);
			
			var url:URL = new URL("myURL");
			var synth:AFacetSynthesizer = new AFacetSynthesizer(url);
			cm.addFacetSynthesizer(synth);
			assertEquals(synth, cm.getFacetSynthesizer(url));
			assertThrows(function():void{cm.addFacetSynthesizer(synth)});
			cm.removeFacetSynthesizer(synth);
			assertNull(null, cm.getFacetSynthesizer(url));
			cm.addFacetSynthesizer(synth);
			
			var facet:IFacet = new ObjectFacet(url,"test");
			cm.addChild(metadata);
			assertDispatches
				(	cm
				,	[ CompositeMetadataEvent.FACET_GROUP_ADD
					, CompositeMetadataEvent.CHILD_FACET_ADD
					]
				,	function():void 
					{
						metadata.addFacet(facet);	
					} 
				);
				
			
			var md2:Metadata = new Metadata();
			md2.addFacet(facet);
			assertDispatches
				( 	cm
				, 	[ CompositeMetadataEvent.CHILD_ADD
					, CompositeMetadataEvent.FACET_GROUP_CHANGE	
				  	]
				, 	function():void 
					{
						cm.addChild(md2);	
					} 
				);
				
			assertDispatches
				( 	cm
				, 	[ CompositeMetadataEvent.CHILD_FACET_REMOVE
					, CompositeMetadataEvent.FACET_GROUP_CHANGE	
				  	]
				, 	function():void 
					{
						md2.removeFacet(facet);
					} 
				);
				
			assertDispatches
				( 	cm
				, 	[ CompositeMetadataEvent.CHILD_FACET_REMOVE
					, CompositeMetadataEvent.FACET_GROUP_CHANGE
					, CompositeMetadataEvent.FACET_GROUP_REMOVE
				  	]
				, 	function():void 
					{
						metadata.removeFacet(facet);
					} 
				);
			
			assertDispatches
				( 	cm
				, 	[ CompositeMetadataEvent.CHILD_REMOVE
				  	]
				, 	function():void 
					{
						cm.removeChild(metadata);
					} 
				);
		}
	
		private function assertThrows(f:Function, ...arguments):void
		{
			try
			{
				f.apply(null,arguments);
				fail();
			}
			catch(e:Error)
			{	
			}
		}
		
		private function assertDispatches(dispatcher:EventDispatcher, types:Array, f:Function, ...arguments):void
		{
			var dispatched:Dictionary = new Dictionary();
			function handler(event:Event):void
			{
				dispatched[event.type] = true;
			}
			
			var type:String;
			for each (type in types)
			{
				dispatcher.addEventListener(type, handler);
			}
			
			f.apply(null, arguments);
			
			for each (type in types)
			{
				dispatcher.removeEventListener(type, handler);
			}
			
			for each (type in types)
			{
				if (dispatched[type] != true)
				{
					fail("Event of type " + type + " was not fired.");
				}
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