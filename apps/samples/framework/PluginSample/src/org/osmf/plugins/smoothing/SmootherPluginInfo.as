package  org.osmf.plugins.smoothing
{
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.metadata.Metadata;
	import org.osmf.plugin.IPluginInfo;
	import org.osmf.utils.URL;

	/**
	 * The plugin info for the smoothing plugin.
	 */ 
	public class SmootherPluginInfo implements IPluginInfo
	{
		public function SmootherPluginInfo()
		{
			info = new MediaInfo("com.adobe.osmf.example.smoother", new Smoother(), createMediaElement, MediaInfoType.CREATE_ON_LOAD);
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
			return new Smoother();
		}
		
		public function initializePlugin(metadata:Metadata):void
		{
			if (metadata.getFacet(new URL("http://org.yourcompany/creation_params/")))
			{
				trace('Got resource metadata');
			}
		}
		
		private var info:MediaInfo;
		
	}
}