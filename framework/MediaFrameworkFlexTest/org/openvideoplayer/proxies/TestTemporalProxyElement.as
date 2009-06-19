package org.openvideoplayer.proxies
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import org.openvideoplayer.events.DurationChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.TestMediaElement;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.PausibleTrait;
	import org.openvideoplayer.traits.PlayableTrait;
	import org.openvideoplayer.traits.SeekableTrait;
	import org.openvideoplayer.traits.TemporalTrait;

	public class TestTemporalProxyElement extends TestMediaElement
	{
		public function TestTemporalProxyElement()
		{
			super();
		}
		
		public function testConstructor():void
		{
			try 
			{
				new TemporalProxyElement();
				new TemporalProxyElement(NaN);
				new TemporalProxyElement(NaN, new MediaElement());
			}
			catch(error:IllegalOperationError)
			{
				fail();
			}
		}
		
		public function testTraits():void
		{
			var mediaElement:MediaElement = new MediaElement();
			var proxy:TemporalProxyElement = new TemporalProxyElement(NaN, mediaElement);
			
			assertTrue(mediaElement.getTrait(MediaTraitType.TEMPORAL) == null);
			assertTrue(proxy.getTrait(MediaTraitType.TEMPORAL) != null);
			
			assertTrue(mediaElement.getTrait(MediaTraitType.PAUSIBLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.PAUSIBLE) != null);
			
			assertTrue(mediaElement.getTrait(MediaTraitType.PLAYABLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.PLAYABLE) != null);
			
			assertTrue(mediaElement.getTrait(MediaTraitType.SEEKABLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.SEEKABLE) != null);
			
			assertTrue(proxy.getTrait(MediaTraitType.AUDIBLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.BUFFERABLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.LOADABLE) == null);
			assertTrue(proxy.getTrait(MediaTraitType.SPATIAL) == null);
			assertTrue(proxy.getTrait(MediaTraitType.VIEWABLE) == null);
		}
		
		public function testEvents():void
		{
			events = new Vector.<Event>();
			var mediaElement:MediaElement = new MediaElement();
			var proxy:TemporalProxyElement = new TemporalProxyElement(NaN, mediaElement);
			
			var temporal:TemporalTrait = proxy.getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var pausible:PausibleTrait = proxy.getTrait(MediaTraitType.PAUSIBLE) as PausibleTrait;
			var playable:PlayableTrait = proxy.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			var seekable:SeekableTrait = proxy.getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			
			playable.play();
			assertTrue(pausible.paused == false);
			pausible.pause();
			assertTrue(playable.playing == false);
			playable.play();
			assertTrue(pausible.paused == false);
		}
		
		public function eventCatcher(event:Event):void
		{
			events.push(event);
		}
		
		private var events:Vector.<Event>;
	}
}