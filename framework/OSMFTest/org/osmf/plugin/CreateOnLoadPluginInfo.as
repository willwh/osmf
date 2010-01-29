package org.osmf.plugin
{
	import __AS3__.vec.Vector;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.metadata.Metadata;
	import org.osmf.net.NetLoader;
	import org.osmf.video.VideoElement;

	public class CreateOnLoadPluginInfo extends PluginInfo
	{
		public function CreateOnLoadPluginInfo()
		{
			var mediaInfo:MediaInfo = new MediaInfo("org.osmf.plugin.CreateOnLoadPlugin", new NetLoader(), createElement, MediaInfoType.CREATE_ON_LOAD);
			var mediaInfos:Vector.<MediaInfo> = new Vector.<MediaInfo>();
			mediaInfos.push(mediaInfo);
			
			super(mediaInfos, "0.9.0");
		}
		
		override public function initializePlugin(metadata:Metadata):void
		{
			_pluginMetadata = metadata;
		}
		
		public function get pluginMetadata():Metadata
		{
			return _pluginMetadata;
		}
		
		public function get createCount():Number
		{
			return _createCount;
		}
		
		private function createElement():MediaElement
		{
			_createCount++;
			return new VideoElement();			
		}
		
		private var _createCount:Number = 0;
		private var _pluginMetadata:Metadata;
		private var _mediaInfo:MediaInfo;
		
	}
}