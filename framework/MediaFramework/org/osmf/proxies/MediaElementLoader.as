package org.osmf.proxies
{
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.LoaderBase;

	/**
	 * The Base class for Chained loaders that are used by the 
	 * LoadableProxyElement.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	public class MediaElementLoader extends LoaderBase
	{
		/**
		 * Creates a new MediaElementLoader
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function MediaElementLoader()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 * @throws Error if the LoadedContext is not a MediaElementLoadedContext
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
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