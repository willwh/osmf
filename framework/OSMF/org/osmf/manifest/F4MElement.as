package org.osmf.manifest
{
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.proxies.FactoryElement;

	public class F4MElement extends FactoryElement
	{
		/**
		 * Creates a new F4MElement. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function F4MElement(resource:URLResource = null, loader:F4MLoader = null)
		{
			if (loader == null)
			{
				loader = new F4MLoader();
			}			
			super(resource, loader);									
		}	
			
	}
}