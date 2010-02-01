package  org.osmf.plugins.smoothing
{
	import __AS3__.vec.Vector;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.metadata.Metadata;
	import org.osmf.plugin.PluginInfo;
	import org.osmf.utils.URL;

	/**
	 * The plugin info for the smoothing plugin.
	 */ 
	public class SmootherPluginInfo extends PluginInfo
	{
		public function SmootherPluginInfo()
		{
			var mediaInfo:MediaInfo = new MediaInfo("com.adobe.osmf.example.smoother", new Smoother(), createMediaElement, MediaInfoType.CREATE_ON_LOAD);
			var mediaInfos:Vector.<MediaInfo> = new Vector.<MediaInfo>();
			mediaInfos.push(mediaInfo);
			
			super(mediaInfos)
		}
				
		override public function initializePlugin(metadata:Metadata):void
		{
			if (metadata.getFacet(new URL("http://org.yourcompany/creation_params/")))
			{
				trace('Got resource metadata');
			}
		}
		
		private function createMediaElement():MediaElement
		{
			return new Smoother();
		}
	}
}