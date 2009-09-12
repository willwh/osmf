package org.openvideoplayer.composition
{
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingItem;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingResource;
	import org.openvideoplayer.netmocker.MockDynamicStreamingNetLoader;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.TestISwitchable;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.video.VideoElement;

	public class TestSerialSwitchableTrait extends TestISwitchable
	{
		override protected function createInterfaceObject(... args):Object
		{
			var dsr:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL("http://www.example.com/ondemand"));
			dsr.addItem(new DynamicStreamingItem("stream_500kbps", 500));
			dsr.addItem(new DynamicStreamingItem("stream_800kbps", 800));
			dsr.addItem(new DynamicStreamingItem("stream_1000kbps", 1000));
			dsr.addItem(new DynamicStreamingItem("stream_3000kbps", 3000));
			
			var netLoader:MockDynamicStreamingNetLoader = new MockDynamicStreamingNetLoader();
				
			var elem:VideoElement = new VideoElement(netLoader, dsr);
			var elem2:VideoElement = new VideoElement(netLoader, dsr);
			var serialElem:SerialElement = new SerialElement();
			
			serialElem.addChild(elem);
			serialElem.addChild(elem2);
			
			(serialElem.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();
						
			IPlayable(serialElem.getTrait(MediaTraitType.PLAYABLE)).play();			
												
			return serialElem.getTrait(MediaTraitType.SWITCHABLE);
		}
		
	}
}