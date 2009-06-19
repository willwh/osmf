package org.openvideoplayer.plugins.composition
{
	import org.openvideoplayer.plugin.IPluginInfo;
	
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaInfo;
	import org.openvideoplayer.net.NetLoader;
	
	import org.openvideoplayer.composition.ParallelElement;
	import org.openvideoplayer.composition.SerialElement;
	
	public class CompositionPluginInfo implements IPluginInfo
	{
		public function CompositionPluginInfo()
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
			var mediaInfos:MediaInfo;
			
			switch(index)
			{
				case 0:
				mediaInfos = new MediaInfo("org.openvideoplayer.composition.SerialElement", netLoader, SerialElement, new Array(netLoader));
				break;
				case 1:
				mediaInfos = new MediaInfo("org.openvideoplayer.composition.ParallelElement", netLoader, ParallelElement, new Array(netLoader));
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