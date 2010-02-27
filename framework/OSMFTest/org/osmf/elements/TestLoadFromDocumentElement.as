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
	import org.osmf.elements.proxyClasses.LoadFromDocumentLoadTrait;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.LoaderEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.Metadata;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;
	
	public class TestLoadFromDocumentElement extends TestProxyElement
	{
				
		public function testWithLoader():void
		{
			var resource:URLResource = new URLResource("http://example.com/blah");
			var loader:LoaderBase = new LoaderBase();
			var elem:LoadFromDocumentElement = new LoadFromDocumentElement(resource, loader);
			var testMetadata:Metadata = new Metadata();
			elem.addMetadata(NS_URL, testMetadata);
						
			var wrapped:MediaElement = new MediaElement();
						
			assertEquals(resource, elem.resource);
				
			resource = new URLResource("http://newresource.com/test");		
			elem.resource = resource;
			assertEquals(resource, elem.resource);
									
			assertTrue(elem.hasTrait(MediaTraitType.LOAD));
			
			assertNotNull(elem.getMetadata(NS_URL));
			
			var load:LoadFromDocumentLoadTrait = elem.getTrait(MediaTraitType.LOAD) as LoadFromDocumentLoadTrait;
			
			assertNotNull(load);
			
			load.mediaElement = wrapped;
			loader.dispatchEvent(new LoaderEvent(LoadEvent.LOAD_STATE_CHANGE, false, false, loader, load, LoadState.LOADING, LoadState.READY));
			
			// Ensure metadata proxy is functioning properly
			assertEquals(elem.getMetadata(NS_URL), testMetadata);		
			
			assertEquals(elem.metadata.keys.length, wrapped.metadata.keys.length);
						
		}
		
		private static const NS_URL:String = "http://www.adobe.com";
	}
}