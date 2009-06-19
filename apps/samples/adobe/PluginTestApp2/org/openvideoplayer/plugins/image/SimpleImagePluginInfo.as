package org.openvideoplayer.plugins.image
{
	import org.openvideoplayer.image.ImageLoader;
	import org.openvideoplayer.image.ImageElement;
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaInfo;
	import org.openvideoplayer.plugin.IPluginInfo;

	
	public class SimpleImagePluginInfo implements IPluginInfo
	{
		public function SimpleImagePluginInfo()
		{
		}
		
		/**
		 * Returns the number of <code>MediaInfo</code> objects the plugin wants
		 * to register
		 */
		public function get numMediaInfos():int
		{
			return 1;
		}

		/**
		 * Returns a <code>MediaInfo</code> object at the supplied index position
		 */
		public function getMediaInfoAt(index:int):IMediaInfo
		{
			
			var imageLoader:ImageLoader = new ImageLoader();
			return new MediaInfo("org.openvideoplayer.image.Image", imageLoader, ImageElement, new Array(imageLoader));
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