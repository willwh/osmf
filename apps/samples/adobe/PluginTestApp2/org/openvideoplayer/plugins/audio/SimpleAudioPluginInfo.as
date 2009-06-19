package org.openvideoplayer.plugins.audio
{
	import org.openvideoplayer.plugin.IPluginInfo;
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaInfo;
	
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.audio.AudioElement;
	
	
	public class SimpleAudioPluginInfo implements IPluginInfo
	{
		public function SimpleAudioPluginInfo()
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
			var netLoader:NetLoader = new NetLoader();
			return new MediaInfo("org.openvideoplayer.video.Audio", netLoader, AudioElement, new Array(netLoader));
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