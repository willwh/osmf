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
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
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
	import org.osmf.utils.Version;
	
	[SWF(backgroundColor="0x000000",frameRate="25")]
	public class WebPlayer extends Sprite
	{
		public function WebPlayer()
		{
			super();
			
			// Setup a context menu:
			osmfMenuItem = new ContextMenuItem("OSMF Web Player v." + Version.version());
			osmfMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onOSMFContextMenuItemSelect);
			
			customContextMenu = new ContextMenu();
			customContextMenu.hideBuiltInItems();
			customContextMenu.customItems.push(osmfMenuItem);
			
			contextMenu = customContextMenu;
			
			// Parse configuration from the parameters passed on
			// embedding WebPlayer.swf:
			configuration = new Configuration(loaderInfo.parameters);
			
			// Set the SWF scale mode, and listen to the stage change
			// dimensions:
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			// Construct a media factory. A media factory can create
			// media elements on being passed a resource. Manually add
			// support for the Flash Media Format file type:
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
			
			// Construct a media player instance. This will help in loading
			// the element that the factory will construct:
			player = new MediaPlayer();
			
			// Construct a RegionGateway that will be used to show the media
			// on screen once it has loaded.
			region = new RegionGateway();
			region.clipChildren = true;
			region.backgroundColor = configuration.backgroundColor;
			region.backgroundAlpha = isNaN(configuration.backgroundColor) ? 0 : 1;
			addChild(region);
			onStageResize();
			
			// Construct a default control bar, and add extra listeners to
			// to some of its widgets:
			
			controlBar = new DefaultControlBar(configuration.showStopButton);
			controlBar.region = region;
			addChild(controlBar);
			
			var urlInput:URLInput = controlBar.getWidget(DefaultControlBar.URL_INPUT) as URLInput;
			urlInput.addEventListener(Event.CHANGE, onInputURLChange);
			urlInput.url = configuration.url;
			
			var button:Button = controlBar.getWidget(DefaultControlBar.QUALITY_AUTO_SWITCH) as Button;
			button.addEventListener(MouseEvent.CLICK, onQualityModeClick);
			
			button = controlBar.getWidget(DefaultControlBar.EJECT_BUTTON) as Button;
			button.addEventListener(MouseEvent.CLICK, onEjectButtonClick);
			
			// Try to load the currently set URL (if any):
			loadURL(new URL(configuration.url));
		}
		
		// Internals
		//
		
		private function onStageResize(event:Event = null):void
		{
			LayoutUtils.setAbsoluteLayout(region.metadata, stage.stageWidth, stage.stageHeight);
		}
		
		private function loadURL(url:URL):void
		{
			updateTargetElement(factory.createMediaElement(new URLResource(url)));	
		}
		
		private function updateTargetElement(value:MediaElement):void
		{
			if (value != element)
			{
				if (element)
				{
					element.gateway = null;
				}
				
				if (player.playing)
				{
					player.stop();
				}
				
				player.element 
					= controlBar.element
					= null;
				
				element
					= player.element 
					= controlBar.element
					= value;
					
				if (element)
				{
					LayoutUtils.setRelativeLayout(element.metadata, 100, 100);
					LayoutUtils.setLayoutAttributes(element.metadata, ScaleMode.LETTERBOX, RegistrationPoint.CENTER);
					
					element.gateway = region;
				}
			}
		}
				
		// Handlers
		//
		
		private function onEjectButtonClick(event:MouseEvent):void
		{
			stage.displayState = StageDisplayState.NORMAL;
			updateTargetElement(null);
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
		
		private function onOSMFContextMenuItemSelect(event:ContextMenuEvent):void
		{
			flash.net.navigateToURL(new URLRequest("http://www.osmf.org"), "_blank");
		}
		
		private var customContextMenu:ContextMenu;
		private var osmfMenuItem:ContextMenuItem;
		
		private var configuration:Configuration;
		private var factory:MediaFactory;
		private var player:MediaPlayer;
		
		private var element:MediaElement;
		
		private var region:RegionGateway;
		private var controlBar:ControlBar;
	}
}            