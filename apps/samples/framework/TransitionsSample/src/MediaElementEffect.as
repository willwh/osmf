package
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.effects.Effect;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	
	public class MediaElementEffect
	{
		private var complete:Timer;
		private var timeTrait:TimeTrait;
		private var _duration:Number;
		private var mediaElement:MediaElement;
		private var _padding:Number;
		private var playTrait:PlayTrait;
		protected var effect:Effect;
		
		public function MediaElementEffect(padding:Number, element:MediaElement)
		{	
			mediaElement = element;
			_padding = padding;
						
			if (mediaElement)
			{
				if (!mediaTimeTrait || !mediaSeekTrait || !mediaPlayTrait)
				{
					mediaElement.addEventListener(MediaElementEvent.TRAIT_ADD, onTrait);
				}
				if (mediaTimeTrait)
				{
					_duration =  mediaTimeTrait.duration - _padding;
					mediaTimeTrait.addEventListener(TimeEvent.DURATION_CHANGE, onDuration);
				}
				if (mediaSeekTrait)
				{
					mediaSeekTrait.addEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
				}
				if (mediaPlayTrait)
				{		
					mediaPlayTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayState);
				}
			}
			
			//Complete timer (give it a default duration until the video gets its real duration
			complete = new Timer(50, 1);
			complete.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
		}
				
		private function onTrait(event:MediaElementEvent):void
		{
			if (event.traitType == MediaTraitType.TIME)
			{				
				_duration =  mediaTimeTrait.duration - _padding;
				mediaTimeTrait.addEventListener(TimeEvent.DURATION_CHANGE, onDuration);
			}
			if (event.traitType == MediaTraitType.SEEK)
			{
				mediaSeekTrait.addEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
			}
			if (event.traitType == MediaTraitType.PLAY)
			{
				mediaPlayTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayState);
			}
		}
				
		public function get padding():Number
		{
			return _padding;
		}
			
		protected function resetTimer():void
		{			
			complete.reset();
			if (!isNaN(mediaTimeTrait.duration) && 
				!isNaN(mediaTimeTrait.currentTime) &&
				mediaTimeTrait.currentTime < (mediaTimeTrait.duration - padding))
			{
				
				complete.delay =  (mediaTimeTrait.duration - mediaTimeTrait.currentTime - padding)*1000;
				complete.repeatCount = 1;
				complete.start();
			}			
		}
		
		protected function get mediaPlayTrait():PlayTrait
		{
			return (mediaElement.getTrait(MediaTraitType.PLAY) as PlayTrait);
		}
				
		protected function get mediaTimeTrait():TimeTrait
		{
			return (mediaElement.getTrait(MediaTraitType.TIME) as TimeTrait);
		}
				
		protected function get mediaSeekTrait():SeekTrait
		{
			return (mediaElement.getTrait(MediaTraitType.SEEK) as SeekTrait);
		}
				
		protected function doTransition(reversed:Boolean, startFrom:Number = 0):void
		{			
			var display:DisplayObject;			
			if(effect)
			{
				effect.stop();
			}			
			if (mediaElement.hasTrait(MediaTraitType.DISPLAY_OBJECT))
			{
				display = (mediaElement.getTrait(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait).displayObject;
			}
			if (display)
			{		
				var fade:Fade =  new Fade(display);
				effect = fade;
				fade.duration = padding*1000; 
				fade.alphaFrom = 0;
				fade.alphaTo = 1;
				fade.play([display], reversed);
			}			
		}
		
		/**
		 * Setup the ending timer.
		 */ 
		private function onDuration(value:TimeEvent):void
		{
			_duration =  mediaTimeTrait.duration - _padding;	
			if (mediaPlayTrait.playState == PlayState.PLAYING)
			{
				resetTimer();
			}
		}
		
		/**
		 * Fire the exit transition.
		 */ 
		private function onComplete(event:TimerEvent):void
		{				
			complete.stop();
			doTransition(true);
		}
		
		private function onPlayState(value:PlayEvent):void
		{
			if (value.playState == PlayState.PLAYING)
			{				
				resetTimer();
				if (mediaTimeTrait.currentTime == 0)
				{
					doTransition(false, 0);
				}
			}
			else if (value.playState == PlayState.PAUSED)
			{				
				complete.stop();
			}
		}
		
		private function onSeekingChange(value:SeekEvent):void
		{
			resetTimer();
		}	
		
				
	}
}