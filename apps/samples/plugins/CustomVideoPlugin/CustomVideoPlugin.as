package 
{
	import flash.display.Sprite;
	
	import org.openvideoplayer.plugin.video.info.CustomVideoPluginInfo;
	import org.openvideoplayer.plugin.IPluginInfo;

	public class CustomVideoPlugin extends Sprite
	{
		public function CustomVideoPlugin()
		{
			init();
		}
			
		private function init():void
		{
			_customVideoPluginInfo = new CustomVideoPluginInfo();
		}
		
		public function get pluginInfo():IPluginInfo
		{		
			return _customVideoPluginInfo;
		}
		
		private var _customVideoPluginInfo:CustomVideoPluginInfo;
	}
}
