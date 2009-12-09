package org.osmf.proxies
{
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	
	import org.osmf.events.MetadataEvent;
	import org.osmf.metadata.IFacet;
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.URL;
	
	internal class MetadataProxy extends Metadata
	{
		public function MetadataProxy()
		{
			wrapped = new Metadata();
		}
			
		public function set metadata(value:Metadata):void
		{			
			//Transfer all old facets to new.
			for each(var url:URL in wrapped.namespaceURLs)
			{
				value.addFacet(wrapped.getFacet(url));
			}
			wrapped = value;		
			wrapped.addEventListener(MetadataEvent.FACET_ADD, redispatch);
			wrapped.addEventListener(MetadataEvent.FACET_REMOVE, redispatch);	
		}
		
		/** 
		 * @inheritDoc
		 */ 
		override public function getFacet(nameSpace:URL):IFacet
		{				
			return wrapped.getFacet(nameSpace);		
		}
		
		/** 
		 * @inheritDoc
		 */ 
		override public function addFacet(data:IFacet):void
		{
			if (wrapped != null)
			{
				wrapped.addFacet(data);		
			}				
		}
		
		/** 
		 * @inheritDoc
		 */ 
		override public function removeFacet(data:IFacet):IFacet
		{			
			return wrapped.removeFacet(data);
		}	
			
		/** 
		 * @inheritDoc
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