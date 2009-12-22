package org.osmf.plugin
{
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.metadata.Metadata;
	import org.osmf.net.NetLoader;
	import org.osmf.video.VideoElement;

	public class CreateOnLoadPluginInfo implements IPluginInfo
	{
		public function CreateOnLoadPluginInfo()
		{
			super();
			_mediaInfo = new MediaInfo("org.osmf.plugin.CreateOnLoadPlugin", new NetLoader(), createElement, MediaInfoType.CREATE_ON_LOAD);
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
		public function getMediaInfoAt(index:int):MediaInfo
		{
			return _mediaInfo;
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
		
		public function initializePlugin(metadata:Metadata):void
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
			return new VideoElement(new NetLoader());			
		}
		
		private var _createCount:Number = 0;
		private var _pluginMetadata:Metadata;
		private var _mediaInfo:MediaInfo;
		
	}
}