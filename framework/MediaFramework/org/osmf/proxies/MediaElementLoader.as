package org.osmf.proxies
{
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.LoaderBase;

	/**
	 * The Base class for Chained loaders that are used by the 
	 * LoadableProxyElement.
	 */ 
	public class MediaElementLoader extends LoaderBase
	{
		/**
		 * Creates a new MediaElementLoader
		 */ 
		public function MediaElementLoader()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 * @throws Error if the LoadedContext is not a MediaElementLoadedContext
		 */ 
		override protected function updateLoadable(loadable:ILoadable, newState:String, loadedContext:ILoadedContext=null):void
		{
			if(loadedContext != null && !(loadedContext is MediaElementLoadedContext))
			{
				throw new Error("Invalid LoadedContext for MediaElementLoadedContext");
			}	
			super.updateLoadable(loadable, newState, loadedContext);
		}  
		
	}
}