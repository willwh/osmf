package org.osmf.syndication.media
{
	import org.osmf.media.MediaElement;
	import org.osmf.syndication.model.Entry;
	
	public class MediaGenerator
	{
		public function MediaGenerator(mediaResolver:IMediaResolver=null)
		{
			this.mediaResolver = mediaResolver;
			if (this.mediaResolver == null)
			{
				this.mediaResolver = new DefaultMediaResolver();
			}
		}
		
		public function createMediaElement(entry:Entry):MediaElement
		{
			return mediaResolver.createMediaElement(entry);
		}

		private var mediaResolver:IMediaResolver;
	}
}
