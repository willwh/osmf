package org.openvideoplayer.composition
{
	import org.openvideoplayer.events.SwitchingChangeEvent;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingItem;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingResource;
	import org.openvideoplayer.netmocker.MockDynamicStreamingNetLoader;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.ISwitchable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.TestISwitchable;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.video.VideoElement;
	
	public class TestParallelSwitchableTrait extends TestISwitchable
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
			var parallelElem:ParallelElement = new ParallelElement();
			
			parallelElem.addChild(elem);
			parallelElem.addChild(elem2);
			
			(parallelElem.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();
												
			/*ISwitchable(parallelElem.getTrait(MediaTraitType.SWITCHABLE)).addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onChange);									
			ISwitchable(elem.getTrait(MediaTraitType.SWITCHABLE)).addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onChildChange);									
			ISwitchable(elem2.getTrait(MediaTraitType.SWITCHABLE)).addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onChildChange);									
			*/
			IPlayable(parallelElem.getTrait(MediaTraitType.PLAYABLE)).play();	
												
			return parallelElem.getTrait(MediaTraitType.SWITCHABLE);
		}
		
		private function onChange(event:SwitchingChangeEvent):void
		{
			if(event.newState == SwitchingChangeEvent.SWITCHSTATE_COMPLETE)
			{
				trace('onChange complete');
			}
		}
		
		private function onChildChange(event:SwitchingChangeEvent):void
		{
			if(event.newState == SwitchingChangeEvent.SWITCHSTATE_COMPLETE)
			{
				trace('onChildChange - complete');
			}
		}
		
		
	}
}