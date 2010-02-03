package org.osmf.smil.elements
{
	import org.osmf.media.MediaResourceBase;
	import org.osmf.proxies.FactoryElement;
	import org.osmf.smil.loader.SMILLoader;

	public class SMILElement extends FactoryElement
	{
		public function SMILElement(resource:MediaResourceBase = null, loader:SMILLoader = null)
		{
			if (loader == null)
			{
				loader = new SMILLoader();
			}
			super(resource, loader);		
		}
		
	}
}