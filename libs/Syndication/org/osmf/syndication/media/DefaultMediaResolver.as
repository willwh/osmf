package org.osmf.syndication.media
{
	import org.osmf.elements.VideoElement;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.syndication.model.Entry;

	public class DefaultMediaResolver implements IMediaResolver
	{
		public function createMediaElement(entry:Entry):MediaElement
		{
			var mediaElement:MediaElement;
			
			switch (entry.enclosure.type)
			{
				case "video/x-flv":
				case "video/x-f4v": 
				case "video/mp4": 
				case "video/mp4v-es": 
				case "video/x-m4v": 
				case "video/3gpp": 
				case "video/3gpp2": 
				case "video/quicktime":
					mediaElement = new VideoElement(new URLResource(entry.enclosure.url), new NetLoader());
					break;		 
			}
			
			return mediaElement;
		}
	}
}
