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
package org.osmf.elements
{
	import org.osmf.elements.proxyClasses.FactoryLoadTrait;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.LoaderEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.URL;
	
	public class TestFactoryElement extends TestProxyElement
	{
				
		public function testWithLoader():void
		{
			var resource:URLResource = new URLResource(new URL("http://example.com/blah"));
			var loader:LoaderBase = new LoaderBase();
			var factory:FactoryElement = new FactoryElement(resource, loader);
			var testFacet:KeyValueFacet = new KeyValueFacet("http://adobe.com/");
			factory.metadata.addFacet(testFacet);
						
			var wrapped:MediaElement = new MediaElement();
						
			assertEquals(resource, factory.resource);
				
			resource = new URLResource(new URL("http://newresource.com/test"));		
			factory.resource = resource;
			assertEquals(resource, factory.resource);
									
			assertTrue(factory.hasTrait(MediaTraitType.LOAD));
			
			assertNotNull(factory.metadata);
			
			var load:FactoryLoadTrait = factory.getTrait(MediaTraitType.LOAD) as FactoryLoadTrait;
			
			assertNotNull(load);
			
			load.mediaElement = wrapped;
			loader.dispatchEvent(new LoaderEvent(LoadEvent.LOAD_STATE_CHANGE, false, false, loader, load, LoadState.LOADING, LoadState.READY));
			
			// Ensure metadata proxy is functioning properly
			assertEquals(factory.metadata.getFacet("http://adobe.com/"), testFacet);		
			
			assertEquals(factory.metadata.namespaceURLs.length, wrapped.metadata.namespaceURLs.length);
						
		}
	}
}