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
	import org.osmf.chrome.controlbar.widgets.*;
	
	public class ControlBar extends ControlBarBase
	{
		public static const URL_INPUT:String = "urlInput";
		public static const SCRUB_BAR:String = "scrubBar";
		public static const PAUSE_BUTTON:String = "pauseButton";
		public static const PLAY_BUTTON:String = "playButton";
		public static const STOP_BUTTON:String = "stopButton";
		public static const QUALITY_MANUAL_BUTTON:String = "qualityManualButton";
		public static const QUALITY_AUTO_BUTTON:String = "qualityAutoButton";
		public static const QUALITY_INCREASE:String = "qualityIncrease";
		public static const QUALITY_DECREASE:String = "qualityDecrease";
		public static const EJECT_BUTTON:String = "ejectButton";
		public static const FULL_SCREEN_ENTER:String = "fullScreenEnter";
		public static const FULL_SCREEN_LEAVE:String = "fullScreenLeave";
		public static const SOUND_LESS:String = "soundLess";
		public static const SOUND_MORE:String = "soundMore";
		
		public static const BUTTONS_VERTICAL_OFFSET:Number = 10;
		public static const SCRUBBAR_VERTICAL_OFFSET:Number = 22;
		public static const BORDER_SPACE:Number = 9;
		
		public function ControlBar(showStopButton:Boolean)
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
			widget.setPosition(1, 0);
				
			widget = addWidget(QUALITY_MANUAL_BUTTON, new QualityManualButton());
			widget.setPosition(BORDER_SPACE, BUTTONS_VERTICAL_OFFSET);
			
			widget = addWidget(QUALITY_AUTO_BUTTON, new QualityAutoButton());
			widget.setPosition(BORDER_SPACE, BUTTONS_VERTICAL_OFFSET);
			
			widget = addWidget(QUALITY_INCREASE, new QualityIncreaseButton());
			widget.setRegistrationTarget(QUALITY_AUTO_BUTTON, Direction.RIGHT);
			widget.setPosition(1, 0);
			
			widget = addWidget(QUALITY_DECREASE, new QualityDecreaseButton());
			widget.setRegistrationTarget(QUALITY_INCREASE, Direction.RIGHT);
			widget.setPosition(1, 0);
			
			widget = addWidget(FULL_SCREEN_ENTER, new FullScreenEnterButton());
			widget.setPosition(292, BUTTONS_VERTICAL_OFFSET);
			
			widget = addWidget(FULL_SCREEN_LEAVE, new FullScreenLeaveButton());
			widget.setPosition(292, BUTTONS_VERTICAL_OFFSET);
			
			widget = addWidget(SOUND_LESS, new SoundLessButton());
			widget.setRegistrationTarget(FULL_SCREEN_LEAVE, Direction.LEFT);
			widget.setPosition(3, 0);
			
			widget = addWidget(SOUND_MORE, new SoundMoreButton());
			widget.setRegistrationTarget(SOUND_LESS, Direction.LEFT);
			widget.setPosition(1, 0);
		}
	}
}