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
package org.osmf.elements.proxyClasses
{
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	
	import org.osmf.events.MetadataEvent;
	import org.osmf.metadata.Facet;
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.URL;
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * Internal class used by the FactoryElement to proxy metadata.
	 */ 
	public class MetadataProxy extends Metadata
	{
		public function MetadataProxy()
		{
			wrapped = new Metadata();
		}
			
		public function set metadata(value:Metadata):void
		{			
			// Transfer all old facets to new:
			for each(var url:String in wrapped.namespaceURLs)
			{
				value.addFacet(wrapped.getFacet(new URL(url)));
			}
			wrapped = value;		
			wrapped.addEventListener(MetadataEvent.FACET_ADD, redispatch);
			wrapped.addEventListener(MetadataEvent.FACET_REMOVE, redispatch);	
		}
		
		/** 
		 * @private
		 */ 
		override public function getFacet(nameSpace:URL):Facet
		{				
			return wrapped.getFacet(nameSpace);		
		}
		
		/** 
		 * @private
		 */ 
		override public function addFacet(data:Facet):void
		{
			wrapped.addFacet(data);						
		}
		
		/** 
		 * @private
		 */ 
		override public function removeFacet(data:Facet):Facet
		{			
			return wrapped.removeFacet(data);
		}	
			
		/** 
		 * @private
		 */ 
		override public function get namespaceURLs():Vector.<String>
		{			
			return wrapped.namespaceURLs;
		}
			
		private function redispatch(event:Event):void
		{
			dispatchEvent(event.clone());
		}
				
		private var wrapped:Metadata;
	}
}