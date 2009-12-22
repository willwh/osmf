package org.osmf.plugins.smoothing
{
	import org.osmf.media.IMediaReferrer;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IMediaResourceHandler;
	import org.osmf.media.MediaElement;
	import org.osmf.video.VideoElement;

	/**
	 * The actual media element that does the referrencing and smoothing of
	 * video elements.
	 */ 
	public class Smoother extends MediaElement implements IMediaResourceHandler, IMediaReferrer
	{
		public function Smoother()
		{
			super();
		}
		
		public function canHandleResource(resource:IMediaResource):Boolean
		{
			return false;
		}
		
		public function addReference(element:MediaElement):void
		{
			if (element is VideoElement)
			{
				VideoElement(element).smoothing = true;
			}
		}
		
		public function canReferenceMedia(element:MediaElement):Boolean
		{
			return element is VideoElement;			
		}
		
		
		
	}
}