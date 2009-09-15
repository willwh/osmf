package org.openvideoplayer.composition
{
	import org.openvideoplayer.events.SwitchingChangeEvent;
	import org.openvideoplayer.media.MediaElement;
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

	public class TestSerialSwitchableTrait extends TestISwitchable
	{		
		override public function testGetBitrateForIndex():void
		{
			assertEquals(500, switchable.getBitrateForIndex(0));
			assertEquals(800, switchable.getBitrateForIndex(1));
			assertEquals(1000, switchable.getBitrateForIndex(2));
			assertEquals(3000, switchable.getBitrateForIndex(3));		
		}
		
		override protected function createInterfaceObject(... args):Object
		{
			
			var dsr:DynamicStreamingResource = new DynamicStreamingResource(new FMSURL("http://www.example.com/ondemand"));
			dsr.addItem(new DynamicStreamingItem("stream_500kbps", 500));
			dsr.addItem(new DynamicStreamingItem("stream_800kbps", 800));
			dsr.addItem(new DynamicStreamingItem("stream_1000kbps", 1000));
			dsr.addItem(new DynamicStreamingItem("stream_3000kbps", 3000));
			
			var netLoader:MockDynamicStreamingNetLoader = new MockDynamicStreamingNetLoader();
								
			if(args[0])
			{						
				netLoader.netStreamExpectedDuration = args[0];
			}
			else
			{
				netLoader.netStreamExpectedDuration = 5;
			}
			var elem:VideoElement = new VideoElement(netLoader, dsr);
			var elem2:VideoElement = new VideoElement(netLoader, dsr);
			serialElem = new SerialElement();
			
			serialElem.addChild(elem);
			serialElem.addChild(elem2);
			
			(serialElem.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();	
			
			switchable = serialElem.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable;				
														
			(serialElem.getTrait(MediaTraitType.PLAYABLE) as IPlayable).play();			
			
			return switchable;
		}
					
		public function testSerialSwitchReq():void
		{
			var switchable:ISwitchable = createInterfaceObject() as ISwitchable;
			var asynchTrigger:Function = addAsync(function():void {}, 3000)
			
			switchable.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onState);
			switchable.autoSwitch = false;
			
			var stateQueue:Array = [SwitchingChangeEvent.SWITCHSTATE_REQUESTED, SwitchingChangeEvent.SWITCHSTATE_COMPLETE];
			
			switchable.switchTo(2);
						
			var firstChild:MediaElement = serialElem.getChildAt(0);
			var secondChild:MediaElement = serialElem.getChildAt(1);
			var secondSwitch:ISwitchable;
						
			function onState(event:SwitchingChangeEvent):void
			{						
				assertEquals(stateQueue.shift(), event.newState);
				assertFalse(switchable.autoSwitch);
				if(stateQueue.length == 0)
				{	
					switchable.removeEventListener(	SwitchingChangeEvent.SWITCHING_CHANGE, onState);			
					asynchTrigger(null);
				}
			}			
		}
		
		public function testSerialSwitchSequence():void
		{
			var asynchTrigger:Function = addAsync(function():void {}, 10000);
			var switchable:ISwitchable = createInterfaceObject(1) as ISwitchable;
			
			switchable.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onState);
			switchable.autoSwitch = false;
			
			var stateQueue:Array = [ SwitchingChangeEvent.SWITCHSTATE_REQUESTED, SwitchingChangeEvent.SWITCHSTATE_COMPLETE, SwitchingChangeEvent.SWITCHSTATE_COMPLETE];
			switchable.switchTo(2);
			
			function onState(event:SwitchingChangeEvent):void
			{						
				trace('onState' + event.newState );
				assertEquals(stateQueue.shift(), event.newState);
				assertFalse(switchable.autoSwitch);
				if(stateQueue.length == 0)
				{	
					switchable.removeEventListener(	SwitchingChangeEvent.SWITCHING_CHANGE, onState);			
					asynchTrigger(null);
				}
			}	
			
		}
				
		private var serialElem:SerialElement;
		
	}
}