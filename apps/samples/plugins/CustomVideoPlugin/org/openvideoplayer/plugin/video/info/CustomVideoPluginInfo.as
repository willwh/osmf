package org.openvideoplayer.plugin.video.info
{
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaInfo;
	import org.openvideoplayer.plugin.video.loader.CustomNetLoader;
	import org.openvideoplayer.plugin.video.media.CustomVideoElement;
	import org.openvideoplayer.plugin.IPluginInfo;
	
	
	public class CustomVideoPluginInfo implements IPluginInfo
	{
		public function CustomVideoPluginInfo()
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
			var customNetLoader:CustomNetLoader = new CustomNetLoader();
			
			return new MediaInfo("org.openvideoplayer.video.CustomVideo", customNetLoader, CustomVideoElement, new Array(customNetLoader));
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