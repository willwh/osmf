package org.openvideoplayer.events
{
	import flash.events.Event;
	
	import org.openvideoplayer.metadata.IFacet;

	/**
	 * Metadata Events are dispatched by the IMetadata object when 
	 * IFacets are added or removed from the metadata collection.
	 */ 
	public class MetadataEvent extends Event
	{
		/**
		 * Dispatched when a value is added to a IFacet.
		 */ 
		public static const FACET_ADD:String = "facetAdd";
		
		/**
		 * Dispatched when a value is removed from a IFacet.
		 */ 
		public static const FACET_REMOVE:String = "facetRemove";
					
		/**
		 * Constructs a new metadata event.  
		 * @param facet the facet that is changing.
		 */ 				
		public function MetadataEvent(facet:IFacet, type:String, 
		                              bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_facet = facet;			
		}
		
		/**
		 *  @returns The metadata IFacet associated with this event. 
		 */ 
		public function get facet():IFacet
		{
			return _facet;
		}
		
		/**
		 * @private
		 */ 
		override public function clone():Event
		{
			return new MetadataEvent(_facet, type, bubbles, cancelable);
		}
		
		private var _facet:IFacet;		
	}
}