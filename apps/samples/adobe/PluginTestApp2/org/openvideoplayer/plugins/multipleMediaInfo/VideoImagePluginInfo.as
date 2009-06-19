package org.openvideoplayer.plugins.multipleMediaInfo
{
	import org.openvideoplayer.image.ImageElement;
	import org.openvideoplayer.image.ImageLoader;
	import org.openvideoplayer.video.VideoElement;
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaInfo;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.plugin.IPluginInfo;
	
	public class VideoImagePluginInfo implements IPluginInfo
	{
		public function VideoImagePluginInfo()
		{
		}

		/**
		 * Returns the number of <code>MediaInfo</code> objects the plugin wants
		 * to register
		 */
		public function get numMediaInfos():int
		{
			return 2;
		}

		/**
		 * Returns a <code>MediaInfo</code> object at the supplied index position
		 */
		public function getMediaInfoAt(index:int):IMediaInfo
		{
			var netLoader:NetLoader = new NetLoader();
			var imageLoader:ImageLoader = new ImageLoader();
			var mediaInfos:MediaInfo;
			
			switch(index)
			{
				case 0:
				mediaInfos = new MediaInfo("org.openvideoplayer.multiplemedia.Video", netLoader, VideoElement, new Array(netLoader));
				break;
				case 1:
				mediaInfos = new MediaInfo("org.openvideoplayer.multiplemedia.Image", imageLoader, ImageElement, new Array(imageLoader));
				break;
			}
			return mediaInfos
		}
		
		/**
		 * Returns if the given version of the framework is supported by the plugin. If the 
		 * return value is <code>true</code>, the framework proceeds with loading the plugin. 
		 * If the value is <code>false</code>, the framework does not load the plugin.
		 */
		public function isFrameworkVersionSupported(version:String):Boolean
		{
			return true;
		}
		

	}
}