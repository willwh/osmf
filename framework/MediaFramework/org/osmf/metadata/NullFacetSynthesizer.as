package org.osmf.metadata
{
	import org.osmf.composition.CompositionMode;
	import org.osmf.utils.URL;

	public class NullFacetSynthesizer extends FacetSynthesizer
	{
		/**
		 * @inheritDoc
		 */		
		public function NullFacetSynthesizer(nameSpace:URL)
		{
			super(nameSpace);
		}
		
		// Overrides
		//
		
		override public function synthesize(targetMetadata:Metadata, facetGroup:FacetGroup, mode:CompositionMode, activeMetadata:Metadata):IFacet
		{
			return null;
		}
		
	}
}