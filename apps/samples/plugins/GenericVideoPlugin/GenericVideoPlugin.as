package {
	import flash.display.Sprite;
	
	import org.openvideoplayer.plugin.video.info.VideoPluginInfo;
	import org.openvideoplayer.plugin.IPluginInfo;

	public class GenericVideoPlugin extends Sprite
	{
		public function GenericVideoPlugin()
		{
				init();
		}
			
		private function init():void
		{
			_videoPluginInfo = new VideoPluginInfo();
		}
		
		public function get pluginInfo():IPluginInfo
		{
			
			return _videoPluginInfo;
		}
		
		private var _videoPluginInfo:VideoPluginInfo;

	}
}
