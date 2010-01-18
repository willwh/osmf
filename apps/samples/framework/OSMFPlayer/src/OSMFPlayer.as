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
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
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
	import org.osmf.containers.MediaContainer;
	import org.osmf.display.ScaleMode;
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
	
	[Frame(factoryClass="Preloader")]
	[SWF(backgroundColor="0x000000", frameRate="25", width="640", height="380")]
	public class OSMFPlayer extends Sprite
	{
		public function OSMFPlayer(preloader:Preloader)
		{
			super();
			
			this.preloader = preloader;
			_stage = preloader.stage;
			
			// Parse configuration from the parameters passed on
			// embedding OSMFPlayer.swf:
			configuration = new Configuration(preloader.loaderInfo.parameters);
			
			// Set the SWF scale mode, and listen to the _stage change
			// dimensions:
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			
			setupContextMenu();
			
			setupMediaFactory();
			
			// Construct a media player instance. This will help in loading
			// the element that the factory will construct:
			player = new MediaPlayer();
			
			setupMediaContainer();
			
			setupUserInterface();
			
			// Simulate the _stage resizing, to update the dimensions of the
			// container and overlay:
			onStageResize();
			
			// Try to load the currently set URL (if any):
			loadURL(new URL(configuration.url));
		}
		
		// Internals
		//
		
		private function setupContextMenu():void
		{
			// Setup a context menu:
			osmfMenuItem = new ContextMenuItem("OSMF Web Player v." + Version.version());
			osmfMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onOSMFContextMenuItemSelect);
			
			customContextMenu = new ContextMenu();
			customContextMenu.hideBuiltInItems();
			customContextMenu.customItems.push(osmfMenuItem);
			
			contextMenu = customContextMenu;	
		}
		
		private function setupMediaFactory():void
		{
			// Construct a media factory. A media factory can create
			// media elements on being passed a resource.
			factory = new DefaultMediaFactory();
		}
		
		private function setupMediaContainer():void
		{
			// Construct a MediaContainer that will be used to show the media
			// on screen once it has loaded.
			container = new MediaContainer();
			container.clipChildren = true;
			container.backgroundColor = configuration.backgroundColor;
			container.backgroundAlpha = isNaN(configuration.backgroundColor) ? 0 : 1;
			addChild(container);
			
			// Create a transparent overlay. This is a work-around for the
			// context menu otherwise not triggering MENU_ITEM_SELECT when being
			// invoked while over a Video object:
			overlay = new Sprite();
			addChild(overlay);
		}
		
		private function setupUserInterface():void
		{
			// Construct a default control bar, and add extra listeners to
			// to some of its widgets:
			
			controlBar = new ControlBar();
			controlBar.autoHide = configuration.autoHideControlBar;
			controlBar.container = container;
			addChild(controlBar);
			
			var urlInput:URLInput = controlBar.getWidget(ControlBar.URL_INPUT) as URLInput;
			urlInput.addEventListener(Event.CHANGE, onInputURLChange);
			urlInput.url = configuration.url;
			
			var button:Button = controlBar.getWidget(ControlBar.EJECT_BUTTON) as Button;
			button.addEventListener(MouseEvent.CLICK, onEjectButtonClick);
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
					container.removeMediaElement(element);
				}
				
				if (player.playing)
				{
					player.stop();
				}
				
				player.media
					= controlBar.element
					= null;
				
				CONFIG::DEBUG
				{
					if (value)
					{
						value = new DebuggerElementProxy(value, preloader.debugger);
					}
					
					preloader.debugger.send("media change", value);
				}
				
				element
					= player.media 
					= controlBar.element
					= value;
					
				if (element)
				{
					// Set the element to occupy 100% of the container's available
					// width, and height:
					LayoutUtils.setRelativeLayout(element.metadata, 100, 100);
					// Set the element to scale "LETTERBOX" style, meaning that the
					// media's original width:height ratio will be respected. If there's
					// surplus space, then the content will be shown centered:
					LayoutUtils.setLayoutAttributes(element.metadata, ScaleMode.LETTERBOX, RegistrationPoint.CENTER);
					
					// Add the element to the media container:
					container.addMediaElement(element);
				}
			}
		}
				
		// Handlers
		//
		
		private function onStageResize(event:Event = null):void
		{
			LayoutUtils.setAbsoluteLayout(container.metadata, _stage.stageWidth, _stage.stageHeight);
			
			var g:Graphics = overlay.graphics; 
			g.clear();
			g.beginFill(0xffffff, 0);
			g.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			
			CONFIG::DEBUG
			{
				preloader.debugger.send("stage resize", _stage.stageWidth, _stage.stageHeight);
			}
		}
		
		private function onEjectButtonClick(event:MouseEvent):void
		{
			_stage.displayState = StageDisplayState.NORMAL;
			updateTargetElement(null);
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
		
		private var preloader:Preloader;
		private var _stage:Stage;
		
		private var customContextMenu:ContextMenu;
		private var osmfMenuItem:ContextMenuItem;
		
		private var configuration:Configuration;
		private var factory:MediaFactory;
		private var player:MediaPlayer;
		
		private var element:MediaElement;
		
		private var container:MediaContainer;
		private var controlBar:ControlBarBase;
		
		private var overlay:Sprite;
	}
}            