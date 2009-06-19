package org.openvideoplayer.events
{
	import flash.events.Event;
	
	import org.openvideoplayer.media.IMediaInfo;

	public class NewMediaInfoEvent extends Event
	{
		public static const NEW_MEDIA_INFO:String = "New MediaInfo";
		
		public function NewMediaInfoEvent(type:String, mediaInfo:IMediaInfo, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.mediaInfo = mediaInfo;
		}
		
		public var mediaInfo:IMediaInfo;
		
	}
}