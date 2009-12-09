package org.osmf.media
{
	import org.osmf.audio.AudioElement;
	import org.osmf.audio.SoundLoader;
	import org.osmf.image.ImageElement;
	import org.osmf.image.ImageLoader;
	import org.osmf.net.NetLoader;
	import org.osmf.net.dynamicstreaming.DynamicStreamingNetLoader;
	import org.osmf.swf.SWFElement;
	import org.osmf.swf.SWFLoader;
	import org.osmf.video.VideoElement;
	
	/**
	 * A MediaFactory that is prepopulated with all of the 
	 * defaut OSMF MediaElements, including: Video, Video (dynamic streaming),
	 * audio, streaming audio, image, and swfs.  
	 */ 
	public class DefaultMediaFactory extends MediaFactory
	{
		/**
		 * Creates a new instance of the DefaultMediaFactory
		 */ 
		public function DefaultMediaFactory()
		{			
			addMediaInfo(new MediaInfo("org.osmf.video.dynamicStreaming", new DynamicStreamingNetLoader(), function():MediaElement{return new VideoElement(new DynamicStreamingNetLoader())}, MediaInfoType.STANDARD));
			addMediaInfo(new MediaInfo("org.osmf.video", new NetLoader(), function():MediaElement{return new VideoElement(new NetLoader())}, MediaInfoType.STANDARD));
			addMediaInfo(new MediaInfo("org.osmf.audio", new SoundLoader(), function():MediaElement{return new AudioElement(new SoundLoader())}, MediaInfoType.STANDARD));
			addMediaInfo(new MediaInfo("org.osmf.audio.streaming", new NetLoader(), function():MediaElement{return new AudioElement(new NetLoader())}, MediaInfoType.STANDARD));
			addMediaInfo(new MediaInfo("org.osmf.image", new ImageLoader(), function():MediaElement{return new ImageElement(new ImageLoader())}, MediaInfoType.STANDARD));
			addMediaInfo(new MediaInfo("org.osmf.swf", new SWFLoader(), function():MediaElement{return new SWFElement(new SWFLoader())}, MediaInfoType.STANDARD));
		}

	}
}