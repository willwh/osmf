package org.osmf.chrome.controlbar.widgets
{
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osmf.media.MediaElement;
	import org.osmf.traits.DynamicStreamTrait;
	import org.osmf.traits.MediaTraitType;
	
	public class QualityModeToggle extends Button
	{
			
		[Embed("../assets/images/quality_up.png")]
		public var qualityUpType:Class;
		[Embed("../assets/images/quality_down.png")]
		public var qualityDownType:Class;
		[Embed("../assets/images/quality_disabled.png")]
		public var qualityDisabledType:Class;
		
		public function QualityModeToggle(up:Class = null, down:Class = null, disabled:Class = null)
		{
			super
				( up || qualityUpType
				, down || qualityDownType
				, disabled || qualityDisabledType
				); 
		}
		// Overrides
		//
		
		override protected function get requiredTraits():Vector.<String>
		{
			return _requiredTraits;
		}
		
		override protected function processElementChange(oldElement:MediaElement):void
		{
			visibilityDeterminingEventHandler();
		}
		
		override protected function processRequiredTraitsAvailable(element:MediaElement):void
		{
			dynamicStream = element.getTrait(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait;
			visibilityDeterminingEventHandler();
		}
		
		override protected function processRequiredTraitsUnavailable(element:MediaElement):void
		{
			dynamicStream = null;
			visibilityDeterminingEventHandler();
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			dynamicStream.autoSwitch = !dynamicStream.autoSwitch;
		}
		
		// Internals
		//
		
		private function visibilityDeterminingEventHandler(event:Event = null):void
		{
			enabled = dynamicStream != null;
			
			visible
				=	element != null 
				&&	enabled == true
		}
		
		private var dynamicStream:DynamicStreamTrait;
		
		/* static */
		private static const _requiredTraits:Vector.<String> = new Vector.<String>;
		_requiredTraits[0] = MediaTraitType.DYNAMIC_STREAM;
	}
}