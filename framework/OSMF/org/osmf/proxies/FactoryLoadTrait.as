package org.osmf.proxies
{
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;

	/**
	 * @private
	 */ 
	public class FactoryLoadTrait extends LoadTrait
	{
		/**
		 * @private
		 * Constructs a new FactoryLoad trait.
		 */ 
		public function FactoryLoadTrait(loader:LoaderBase, resource:MediaResourceBase)
		{
			super(loader, resource);
		}
		
		/**
		 * @private
		 * The MediaElement created by the FactoryElement's loader.
		 */ 
		public var mediaElement:MediaElement;
		
		
	}
}