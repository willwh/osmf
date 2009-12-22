package org.osmf.examples.plugins
{
	import org.osmf.media.IMediaReferrer;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IMediaResourceHandler;
	import org.osmf.media.MediaElement;
	import org.osmf.video.VideoElement;

	public class Tracker extends MediaElement implements IMediaResourceHandler, IMediaReferrer
	{
		public function Tracker()
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
			return true;			
		}
		
		
		
	}
}