package org.osmf.syndication.media
{
	import org.osmf.media.MediaElement;
	import org.osmf.syndication.model.Entry;
	
	public interface IMediaResolver
	{
		function createMediaElement(entry:Entry):MediaElement;
	}
}
