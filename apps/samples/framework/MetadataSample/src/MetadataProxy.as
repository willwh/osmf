package
{
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.metadata.KeyValueFacet;
	import org.openvideoplayer.metadata.ObjectIdentifier;
	import org.openvideoplayer.net.NetStreamCodes;
	import org.openvideoplayer.proxies.ProxyElement;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.video.VideoElement;

	public class MetadataProxy extends ProxyElement
	{
		public static const VIDEO_METADATA:URL = new URL("http://example.com/metadata");
		
		public function MetadataProxy(video:VideoElement)
		{
			super(video);
			videoElement = video;	
			(videoElement.getTrait(MediaTraitType.LOADABLE) as ILoadable).addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoaded);				
		}
		
		private function onLoaded(event:LoadableStateChangeEvent):void
		{
			if(event.newState == LoadState.LOADED)
			{
				videoElement.client.addHandler(NetStreamCodes.ON_META_DATA, onMetadata);
			}
		}
				
		private function onMetadata(info:Object):void
		{
			var kv:KeyValueFacet = new KeyValueFacet(VIDEO_METADATA);
			
			for (var key:Object in info)
			{
				kv.addValue(new ObjectIdentifier(key), info[key]);
			} 						
			metadata.addFacet(kv);	 	
		}
		
		private var videoElement:VideoElement;	
	}
}