package org.osmf.examples.plugins
{
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.metadata.Metadata;
	import org.osmf.plugin.IPluginInfo;

	public class ReferencePluginInfo implements IPluginInfo
	{
		public function ReferencePluginInfo()
		{
			info = new MediaInfo("com.adobe.osmf.example.reference", new Tracker(), createMediaElement, MediaInfoType.CREATE_ON_LOAD);
		}

		public function get numMediaInfos():int
		{
			return 1;
		}
		
		public function getMediaInfoAt(index:int):MediaInfo
		{
			return info;
		}
		
		public function isFrameworkVersionSupported(version:String):Boolean
		{
			return true;
		}
		
		public function createMediaElement():MediaElement
		{
			return new Tracker();
		}
		
		public function initializePlugin(metadata:Metadata):void
		{
			
		}
		
		private var info:MediaInfo;
		
	}
}