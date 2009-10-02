package org.osmf.composition
{
	import org.osmf.events.SwitchingChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.net.dynamicstreaming.DynamicStreamingItem;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.netmocker.MockDynamicStreamingNetLoader;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.ISwitchable;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TestISwitchable;
	import org.osmf.utils.FMSURL;
	import org.osmf.video.VideoElement;

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
			
			var stateQueue:Array = [SwitchingChangeEvent.SWITCHSTATE_REQUESTED,SwitchingChangeEvent.SWITCHSTATE_REQUESTED, SwitchingChangeEvent.SWITCHSTATE_COMPLETE];
			
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
		
		public function testSerialSwitchMaxIndex():void
		{
			var ch1:MediaElement = serialElem.getChildAt(0);
									
			switchable.maxIndex = 1;
			
			assertEquals(switchable.maxIndex, (ch1.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).maxIndex, 1);
			
			switchable.maxIndex = 2;
			
			assertEquals(switchable.maxIndex, (ch1.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).maxIndex, 2);

		}
		
		public function testSerialSwitchAutoOn():void
		{
			var ch1:MediaElement = serialElem.getChildAt(0);
			var ch2:MediaElement = serialElem.getChildAt(1);
			
			serialElem.removeChildAt(0);
			serialElem.removeChildAt(0);
			
			(ch1.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).autoSwitch = false;
			
			(ch2.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();
			(ch2.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).autoSwitch = false;
			
			serialElem.addChild(ch1);
			serialElem.addChild(ch2);	
			
			assertEquals(switchable.autoSwitch, (ch1.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).autoSwitch, false );
			assertEquals(switchable.autoSwitch, (ch2.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).autoSwitch, false );
				
			
		}
		
		public function testSerialSwitchSequence():void
		{
			var asynchTrigger:Function = addAsync(function():void {}, 10000);
			var switchable:ISwitchable = createInterfaceObject(1) as ISwitchable;
			
			switchable.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onState);
			switchable.autoSwitch = false;
			
			var stateQueue:Array = [ SwitchingChangeEvent.SWITCHSTATE_REQUESTED, SwitchingChangeEvent.SWITCHSTATE_REQUESTED, SwitchingChangeEvent.SWITCHSTATE_COMPLETE];
			switchable.switchTo(2);
			
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
				
		private var serialElem:SerialElement;
		
	}
}