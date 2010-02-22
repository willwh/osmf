/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.chrome.controlbar.widgets
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import org.osmf.chrome.controlbar.ControlBarWidget;
	import org.osmf.chrome.events.ScrubberEvent;
	import org.osmf.chrome.fonts.Fonts;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	
	public class ScrubBar extends ControlBarWidget
	{
		[Embed(source="../assets/images/scrubBarTrack.png")]
		private static var scrubBarTrackType:Class;
		
		private static var SCRUBBER_VERTICAL_OFFSET:Number = 8;
		private static var SCRUBBER_START:Number = 50;
		private static var SCRUBBER_END:Number = 260;
		private static var TIME_LABELS_Y:Number = 5;
		
		public function ScrubBar(track:Class = null)
		{
			track ||= scrubBarTrackType;
			
			currentTime = Fonts.getDefaultTextField();
			currentTime.height = 20;
			currentTime.width = 52;
			currentTime.alpha = 0.4;
			currentTime.x = 7;
			currentTime.y = TIME_LABELS_Y;
			addChild(currentTime);
			
			remainingTime = Fonts.getDefaultTextField(TextFormatAlign.RIGHT);
			remainingTime.height = 20;
			remainingTime.width = 45;
			remainingTime.alpha = 0.4;
			remainingTime.x = 268;
			remainingTime.y = TIME_LABELS_Y;
			
			addChild(remainingTime);
			
			var scrubBarClickArea:Sprite = new Sprite();
			scrubBarClickArea.x = SCRUBBER_START + 2;
			scrubBarClickArea.y = 6;
			scrubBarClickArea.addEventListener(MouseEvent.MOUSE_DOWN, onTrackMouseDown);
			scrubBarClickArea.graphics.beginFill(0xFFFFFF, 0);
			scrubBarClickArea.graphics.drawRect(0, 4, SCRUBBER_END - SCRUBBER_START + 4, 10);
			scrubBarClickArea.graphics.endFill();
			addChild(scrubBarClickArea);
			
			scrubBarTrack = new track();
			scrubBarTrack.x = SCRUBBER_START + 2;
			scrubBarTrack.y = SCRUBBER_VERTICAL_OFFSET + 3;
			addChild(scrubBarTrack);
			
			scrubber = new Scrubber();
			scrubber.enabled = false;
			scrubber.x = SCRUBBER_START;
			scrubber.origin = SCRUBBER_START;
			scrubber.y = SCRUBBER_VERTICAL_OFFSET;
			scrubber.range = SCRUBBER_END - SCRUBBER_START;
			scrubber.addEventListener(ScrubberEvent.SCRUB_START, onScrubberStart);
			scrubber.addEventListener(ScrubberEvent.SCRUB_UPDATE, onScrubberUpdate);
			scrubber.addEventListener(ScrubberEvent.SCRUB_END, onScrubberEnd);
			
			addChild(scrubber);
			
			currentPositionTimer = new Timer(1000/50, 0);
			currentPositionTimer.addEventListener(TimerEvent.TIMER, onTimerTick);
			
			updateState();
			
			super();
		}
		
		// Overrides
		//
		
		override protected function get requiredTraits():Vector.<String>
		{
			return _requiredTraits;
		}
		
		override protected function processRequiredTraitsAvailable(element:MediaElement):void
		{
			updateState();
		}
		
		override protected function processRequiredTraitsUnavailable(element:MediaElement):void
		{
			updateState();
		}
		
		override protected function onElementTraitAdd(event:MediaElementEvent):void
		{
			updateState();
		}
		
		override protected function onElementTraitRemove(event:MediaElementEvent):void
		{
			updateState();
		}
		
		// Internals
		//
		
		private function updateState():void
		{
			visible = element != null;
			scrubber.enabled = element ? element.hasTrait(MediaTraitType.SEEK) : false;
			updateTimerState();
		}
		
		private function updateTimerState():void
		{
			var temporal:TimeTrait = element ? element.getTrait(MediaTraitType.TIME) as TimeTrait : null;
			if (temporal == null)
			{
				currentPositionTimer.stop();
				
				resetUI();
			}
			else
			{
				currentPositionTimer.start();
			}
		}
		
		private function onTimerTick(event:Event):void
		{
			var temporal:TimeTrait = element ? element.getTrait(MediaTraitType.TIME) as TimeTrait : null;
			if (temporal != null)
			{
				var duration:Number = temporal.duration;
				var position:Number = temporal.currentTime;
			
				currentTime.text
					= prettyPrintSeconds(position);
					
				remainingTime.text
					= "-" 
					+ prettyPrintSeconds(Math.max(0, duration - position));
				
				var scrubberX:Number
						= 	SCRUBBER_START
						+ 	(	(SCRUBBER_END - SCRUBBER_START)
								* position
							)
							/ duration
						||	SCRUBBER_START; // defaul value if calc. returns NaN.
							
				scrubber.x = Math.min(SCRUBBER_END, Math.max(SCRUBBER_START, scrubberX));
			}
			else
			{
				resetUI();
			}
		}
		
		private function prettyPrintSeconds(seconds:Number):String
		{
			seconds = Math.round(isNaN(seconds) ? 0 : seconds);
			return Math.floor(seconds / 3600) 
				 + ":"
				 + (seconds % 3600 < 600 ? "0" : "")
				 + Math.floor(seconds % 3600 / 60)
				 + ":"
				 + (seconds % 60 < 10 ? "0" : "") + seconds % 60;
		}
		
		private function onScrubberStart(event:ScrubberEvent):void
		{
			var playable:PlayTrait = element.getTrait(MediaTraitType.PLAY) as PlayTrait;
			if (playable)
			{
				preScrubPlayState = playable.playState;
				if (playable.canPause && playable.playState != PlayState.PAUSED)
				{
					playable.pause();
				}
			}
		}
		
		private function onScrubberUpdate(event:ScrubberEvent = null):void
		{
			var temporal:TimeTrait = element ? element.getTrait(MediaTraitType.TIME) as TimeTrait : null;
			var seekable:SeekTrait = element.getTrait(MediaTraitType.SEEK) as SeekTrait;
			if (temporal && seekable)
			{
				var time:Number = temporal.duration * (scrubber.x - SCRUBBER_START) / (SCRUBBER_END - SCRUBBER_START);
				seekable.seek(time);
			}
		}
		
		private function onScrubberEnd(event:ScrubberEvent):void
		{
			onScrubberUpdate();
			
			if (preScrubPlayState)
			{
				var playable:PlayTrait = element.getTrait(MediaTraitType.PLAY) as PlayTrait;
				if (playable)
				{
					if (playable.playState != preScrubPlayState)
					{
						switch (preScrubPlayState)
						{
							case PlayState.STOPPED:
								playable.stop();
								break;
							case PlayState.PLAYING:
								playable.play();
								break;
						}
					}
				}
			}
		}
		
		private function onTrackMouseDown(evenet:MouseEvent):void
		{
			scrubber.start();
		}
		
		private function resetUI():void
		{
			currentTime.text = "0:00:00";
			remainingTime.text = "-0:00:00";
			scrubber.x = SCRUBBER_START;
		}
		
		private var scrubber:Scrubber;
		private var currentTime:TextField;
		private var remainingTime:TextField;
		
		private var currentPositionTimer:Timer;
		
		private var scrubBarTrack:DisplayObject;
		
		private var scrubberCurrentFace:DisplayObject;
		private var scrubberUp:DisplayObject;
		private var scrubberDown:DisplayObject;
		private var scrubberDisabled:DisplayObject;
		private var preScrubPlayState:String;
		
		/* static */
		private static const _requiredTraits:Vector.<String> = new Vector.<String>;
		_requiredTraits[0] = MediaTraitType.TIME;
	}
}