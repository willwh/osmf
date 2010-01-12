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

package org.osmf.chrome.controlbar
{
	import flash.events.MouseEvent;
	
	import org.osmf.chrome.controlbar.widgets.*;
	
	public class ControlBar extends ControlBarBase
	{
		public static const URL_INPUT:String = "urlInput";
		public static const SCRUB_BAR:String = "scrubBar";
		public static const PAUSE_BUTTON:String = "pauseButton";
		public static const PLAY_BUTTON:String = "playButton";
		public static const STOP_BUTTON:String = "stopButton";
		public static const QUALITY_BUTTON:String = "qualityButton";
		public static const QUALITY_INCREASE:String = "qualityIncrease";
		public static const QUALITY_DECREASE:String = "qualityDecrease";
		public static const QUALITY_LABEL:String = "qualityLabel";
		public static const EJECT_BUTTON:String = "ejectButton";
		public static const FULL_SCREEN_ENTER:String = "fullScreenEnter";
		public static const FULL_SCREEN_LEAVE:String = "fullScreenLeave";
		public static const SOUND_LESS:String = "soundLess";
		public static const SOUND_MORE:String = "soundMore";
		public static const PIN_UP_BUTTON:String = "pinUpButton";
		public static const PIN_DOWN_BUTTON:String = "pinDownButton";
		
		public static const BUTTONS_VERTICAL_OFFSET:Number = 10;
		public static const SCRUBBAR_VERTICAL_OFFSET:Number = 22;
		public static const BORDER_SPACE:Number = 9;
		
		public function ControlBar()
		{
			super();
			
			var widget:ControlBarWidget;

			widget = addWidget(URL_INPUT, new URLInput());
			widget.setPosition(BORDER_SPACE,0);
			
			widget = addWidget(SCRUB_BAR, new ScrubBar());
			widget.setPosition(0, SCRUBBAR_VERTICAL_OFFSET);
						
			widget = addWidget(STOP_BUTTON, new StopButton());
			widget.setPosition(width / 2 - widget.width / 2, BUTTONS_VERTICAL_OFFSET);
			
			widget = addWidget(PLAY_BUTTON, new PlayButton());
			widget.setRegistrationTarget(STOP_BUTTON, Direction.RIGHT);
			widget.setPosition(1, 0);

			widget = addWidget(PAUSE_BUTTON, new PauseButton());
			widget.setRegistrationTarget(PLAY_BUTTON, Direction.RIGHT);
			widget.setPosition(1, 0);
			
			widget = addWidget(EJECT_BUTTON, new EjectButton());
			widget.setRegistrationTarget(STOP_BUTTON, Direction.LEFT);
			
			widget = addWidget(PIN_UP_BUTTON, new PinUpButton());
			widget.setPosition(BORDER_SPACE, BUTTONS_VERTICAL_OFFSET);
			widget.addEventListener(MouseEvent.CLICK, onPinButtonClick);
			widget.hint = "Click to auto hide the control bar";
			
			widget = addWidget(PIN_DOWN_BUTTON, new PinDownButton());
			widget.setRegistrationTarget(PIN_UP_BUTTON, Direction.RIGHT);
			widget.setPosition(1, 0);
			widget.hint = "Click to lock the control bar in place";
			widget.addEventListener(MouseEvent.CLICK, onPinButtonClick);
			
			widget = addWidget(QUALITY_BUTTON, new QualityModeToggle());
			widget.setRegistrationTarget(PIN_DOWN_BUTTON, Direction.RIGHT);
			widget.hint = "Click to toggle between automatic and manual quality mode";
			widget.setPosition(3, 0);
			
			widget = addWidget(QUALITY_INCREASE, new QualityIncreaseButton());
			widget.setRegistrationTarget(QUALITY_BUTTON, Direction.RIGHT);
			widget.setPosition(-2, 4);
			
			widget = addWidget(QUALITY_DECREASE, new QualityDecreaseButton());
			widget.setRegistrationTarget(QUALITY_INCREASE, Direction.RIGHT);
			widget.setPosition(1, 0);
			
			widget = addWidget(QUALITY_LABEL, new QualityLabel());
			widget.setRegistrationTarget(QUALITY_DECREASE, Direction.RIGHT);
			widget.setPosition(0, -3);
			
			widget = addWidget(FULL_SCREEN_ENTER, new FullScreenEnterButton());
			widget.setPosition(292, BUTTONS_VERTICAL_OFFSET);
			widget.hint = "Click to enter full screen mode";
			
			widget = addWidget(FULL_SCREEN_LEAVE, new FullScreenLeaveButton());
			widget.setPosition(292, BUTTONS_VERTICAL_OFFSET);
			widget.hint = "Click to leave full screen mode";
			
			widget = addWidget(SOUND_LESS, new SoundLessButton());
			widget.setRegistrationTarget(FULL_SCREEN_LEAVE, Direction.LEFT);
			widget.setPosition(3, 0);
			
			widget = addWidget(SOUND_MORE, new SoundMoreButton());
			widget.setRegistrationTarget(SOUND_LESS, Direction.LEFT);
			widget.setPosition(1, 0);
		}
		
		private function onPinButtonClick(event:MouseEvent):void
		{
			autoHide = !autoHide;
		}
	}
}