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

package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osmf.chrome.controlbar.*;
	import org.osmf.chrome.controlbar.widgets.*;
	import org.osmf.display.ScaleMode;
	import org.osmf.gateways.RegionGateway;
	import org.osmf.layout.LayoutUtils;
	import org.osmf.layout.RegistrationPoint;
	import org.osmf.manifest.F4MLoader;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.proxies.LoadableProxyElement;
	import org.osmf.utils.URL;
	
	[SWF(backgroundColor="0x000000",frameRate="25")]
	public class WebPlayer extends Sprite
	{
		public function WebPlayer()
		{
			super();
			
			// Parse configuration from the parameters passed on
			// embedding WebPlayer.swf:
			configuration = new Configuration(loaderInfo.parameters);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize);
				
			factory = new DefaultMediaFactory();
			factory.addMediaInfo     
				( new MediaInfo
					( "org.osmf.flashmanifest"
					, new F4MLoader()
					, function():MediaElement
						{
							return new LoadableProxyElement(new F4MLoader());
						}
					, MediaInfoType.STANDARD
					)
				);
				
			player = new MediaPlayer();
			
			region = new RegionGateway();
			region.clipChildren = true;
			region.backgroundColor = configuration.backgroundColor;
			region.backgroundAlpha = isNaN(configuration.backgroundColor) ? 0 : 1;
			addChild(region);
			onStageResize();
			
			controlBar = new ControlBar();
			controlBar.region = region;
			
			var widget:ControlBarWidget;

			widget = controlBar.addWidget("urlInput", new URLInput());
			widget.setPosition(9,0);
			widget.addEventListener(Event.CHANGE, onInputURLChange);
			URLInput(widget).url = configuration.url;
			
			widget = controlBar.addWidget("scrubBar", new ScrubBar());
			widget.setPosition(0, 0);
			
			widget = controlBar.addWidget("playButton", new PlayButton());
			widget.setPosition(9, 20);

			widget = controlBar.addWidget("pauseButton", new PauseButton());
			widget.setRegistrationTarget("playButton", Direction.RIGHT);
			widget.setPosition(1, 0);
			
			if (configuration.showStopButton)
			{
				widget = controlBar.addWidget("stopButton", new StopButton());
				widget.setRegistrationTarget("pauseButton", Direction.RIGHT);
				widget.setPosition(1, 0);
			}
				
			widget = controlBar.addWidget("qualityAutoSwitch", new QualityAutoSwitchToggle());
			widget.setRegistrationTarget(configuration.showStopButton ? "stopButton" : "pauseButton", Direction.RIGHT);
			widget.addEventListener(MouseEvent.CLICK, onQualityModeClick);
			widget.setPosition(3, 0);
			
			widget = controlBar.addWidget("qualityIncrease", new QualityIncreaseButton());
			widget.setRegistrationTarget("qualityAutoSwitch", Direction.RIGHT);
			widget.setPosition(1, 0);
			
			widget = controlBar.addWidget("qualityDecrease", new QualityDecreaseButton());
			widget.setRegistrationTarget("qualityIncrease", Direction.RIGHT);
			widget.setPosition(1, 0);
			
			widget = controlBar.addWidget("ejectButton", new EjectButton());
			widget.setPosition(292, 20);
			widget.addEventListener(MouseEvent.CLICK, onEjectButtonClick);
			
			widget = controlBar.addWidget("fullScreenEnter", new FullScreenEnterButton());
			widget.setRegistrationTarget("ejectButton", Direction.LEFT);
			widget.setPosition(3, 0);
			
			widget = controlBar.addWidget("fullScreenLeave", new FullScreenLeaveButton());
			widget.setRegistrationTarget("fullScreenEnter", Direction.LEFT);
			widget.setPosition(0, 0);
			
			widget = controlBar.addWidget("soundLess", new SoundLessButton());
			widget.setRegistrationTarget("fullScreenLeave", Direction.LEFT);
			widget.setPosition(3, 0);
			
			widget = controlBar.addWidget("soundMore", new SoundMoreButton());
			widget.setRegistrationTarget("soundLess", Direction.LEFT);
			widget.setPosition(1, 0);
			
			addChild(controlBar);
			
			loadURL(new URL(configuration.url));
		}
		
		// Internals
		//
		
		private function onStageResize(event:Event = null):void
		{
			LayoutUtils.setAbsoluteLayout(region.metadata, stage.stageWidth, stage.stageHeight);
		}
		
		private function set element(value:MediaElement):void
		{
			if (value != _element)
			{
				if (_element)
				{
					_element.gateway = null;
				}
				
				if (player.playing)
				{
					player.stop();
				}
				
				player.element 
					= controlBar.element
					= null;
				
				_element
					= player.element 
					= controlBar.element
					= value;
					
				if (_element)
				{
					LayoutUtils.setRelativeLayout(_element.metadata, 100, 100);
					LayoutUtils.setLayoutAttributes(_element.metadata, ScaleMode.LETTERBOX, RegistrationPoint.CENTER);
					
					_element.gateway = region;
				}
			}
		}
				
		private function onEjectButtonClick(event:MouseEvent):void
		{
			stage.displayState = StageDisplayState.NORMAL;
			element = null;
		}
		
		private function onQualityModeClick(event:MouseEvent):void
		{
			// The DynamicStreaming trait doesn't signal 'autoSwitch' changing,
			// so the related buttons have to be manually updated, like so:
			
			var qualityIncrease:QualityIncreaseButton
				= controlBar.getWidget("qualityIncrease")
				as QualityIncreaseButton;
				
			var qualityDecrease:QualityDecreaseButton
				= controlBar.getWidget("qualityDecrease")
				as QualityDecreaseButton;
				
			qualityIncrease.update();
			qualityDecrease.update();
		}
		
		private function onInputURLChange(event:Event):void
		{
			var urlInput:URLInput = event.target as URLInput;
			if (urlInput)
			{
				loadURL(new URL(urlInput.url));
			}
		}
		
		private function loadURL(url:URL):void
		{
			element = factory.createMediaElement(new URLResource(url));	
		}
		
		private var configuration:Configuration;
		private var factory:MediaFactory;
		private var player:MediaPlayer;
		
		private var _element:MediaElement;
		
		private var region:RegionGateway;
		private var controlBar:ControlBar;
		
		private static const REMOTE_PROGRESSIVE:String
			= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		
		private static const REMOTE_MANIFEST:String
			= "http://mediapm.edgesuite.net/osmf/content/test/manifest-files/progressive.f4m";
			
		private static const REMOTE_MBR_MANIFEST:String
			= "http://mediapm.edgesuite.net/osmf/content/test/manifest-files/dynamic_Streaming.f4m";
	}
}            