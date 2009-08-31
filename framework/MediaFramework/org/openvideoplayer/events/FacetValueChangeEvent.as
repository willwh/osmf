package org.openvideoplayer.events
{
	import org.openvideoplayer.metadata.IFacet;
	import org.openvideoplayer.metadata.IIdentifier;

	/**
	 * FacetValueChangeEvent is the event dispatched when the data within a facet changes.
	 * Data is tracked within an IFacet using an IIdentifier.  The newly changed value is also present in this 
	 * event, as well as the old value.
	 */ 
	public class FacetValueChangeEvent extends FacetValueEvent
	{
		/**
		 * Dispatched when a value is updated on a IFacet.
		 */ 
		public static const VALUE_CHANGE:String = "facetValueChange";
		
		public function FacetValueChangeEvent(identifier:IIdentifier, value:*, oldValue:*)
		{
			super(identifier, value, VALUE_CHANGE);
			_oldValue = oldValue;
		}
		
		/**
		 * @returns the value of the 
		 */ 
		public function get oldValue():*
		{
			return _oldValue;
		}
		
		private var _oldValue:*;
		
	}
}