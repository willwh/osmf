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
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.ui.ContextMenuItem;
	
	import org.osmf.chrome.configuration.WidgetsParser;
	import org.osmf.chrome.debug.FPSMeter;
	import org.osmf.chrome.debug.MemoryMeter;
	import org.osmf.chrome.widgets.AlertDialog;
	import org.osmf.chrome.widgets.EjectButton;
	import org.osmf.chrome.widgets.URLInput;
	import org.osmf.chrome.widgets.Widget;
	import org.osmf.containers.MediaContainer;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.layout.LayoutRenderer;
	import org.osmf.layout.LayoutTargetSprite;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	
	CONFIG::DEBUG 
	{
	import org.osmf.logging.Log;
	}
	
	[Frame(factoryClass="Preloader")]
	[SWF(backgroundColor="0x000000", frameRate="25", width="640", height="380")]
	public class OSMFPlayer extends Sprite
	{
		public function OSMFPlayer(preloader:Preloader)
		{
			super();
			
			this.preloader = preloader;
			_stage = preloader.stage;
			
			CONFIG::DEBUG
			{
				Log.loggerFactory = new DebuggerLoggerFactory(preloader.debugger);
			}
			
			// Parse configuration from the parameters passed on
			// embedding OSMFPlayer.swf:
			configuration = new PlayerConfiguration(preloader.loaderInfo.parameters);
			
			// Set the SWF scale mode, and listen to the _stage change
			// dimensions:
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			
			setupMediaFactory();
			setupMediaPlayer();
			setupMediaContainer();
			setupUserInterface();
			
			// Simulate the _stage resizing, to update the dimensions of the
			// container and overlay:
			onStageResize();
			
			// Try to load the currently set URL (if any):
			loadURL(configuration.url);
		}
		
		// Internals
		//
		
		private function setupMediaFactory():void
		{
			// Construct a media factory. A media factory can create
			// media elements on being passed a resource.
			factory = new DefaultMediaFactory();
		}
		
		private function setupMediaPlayer():void
		{
			// Construct a media player instance. This will help in loading
			// the element that the factory will construct:
			player = new MediaPlayer();
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
			player.addEventListener(MediaPlayerCapabilityChangeEvent.IS_DYNAMIC_STREAM_CHANGE, onIsDynamicStreamChange);
		}
		
		private function setupMediaContainer():void
		{
			// Construct a MediaContainer that will be used to show the media
			// on screen once it has loaded.
			containerRenderer = new LayoutRenderer();
			container = new MediaContainer(containerRenderer);
			container.clipChildren = true;
			container.backgroundColor = configuration.backgroundColor;
			container.backgroundAlpha = isNaN(configuration.backgroundColor) ? 0 : 1;
			addChild(container);
		}
		
		private function setupUserInterface():void
		{
			widgetsParser = new WidgetsParser();
			widgetsParser.addType("memoryMeter", MemoryMeter);
			widgetsParser.addType("fpsMeter", FPSMeter);
			widgetsParser.parse
				( preloader.configuration.configuration.widgets.*
				, preloader.configuration.assetsManager
				); 
			
			// Add widgets on top of the media:
			var index:Number = 10000;
			for each (var widget:Widget in widgetsParser.widgets)
			{
				widget.layoutMetadata.index = index++;
				containerRenderer.addTarget(widget);
			}
			
			var urlInput:URLInput = widgetsParser.getWidget("urlInput") as URLInput;
			urlInput.addEventListener(Event.CHANGE, onInputURLChange);
			urlInput.url = configuration.url;
			
			var button:EjectButton = widgetsParser.getWidget("ejectButton") as EjectButton;
			if (button)
			{
				button.addEventListener(MouseEvent.CLICK, onEjectButtonClick);
			}
			
			alert = widgetsParser.getWidget("alert") as AlertDialog;
		}
		
		private function loadURL(url:String):void
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
				
				player.media = null;
				for each (var widget:Widget in widgetsParser.widgets)
				{
					widget.mediaElement = null;
				}
				
				CONFIG::DEBUG
				{
					if (value)
					{
						value = new DebuggerElementProxy(value, preloader.debugger);
					}
					
					preloader.debugger.send("TRACE", "media change", value);
				}
				
				element
					= player.media 
					= value;
					
				if (element)
				{
					for each (widget in widgetsParser.widgets)
					{
						widget.mediaElement = element;
					}
					
					// Add the element to the media container:
					container.addMediaElement(element);
				}
			}
		}
				
		// Handlers
		//
		
		private function onStageResize(event:Event = null):void
		{
			// Propagate dimensions to the main container:
			container.layoutMetadata.width = _stage.stageWidth;
			container.layoutMetadata.height = _stage.stageHeight;
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
				loadURL(urlInput.url);
			}
		}
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			alert.alert("Error", event.error.message + "\n" + event.error.detail);
		}
		
		private function onIsDynamicStreamChange(event:MediaPlayerCapabilityChangeEvent):void
		{
			if (player.isDynamicStream)
			{
				player.autoDynamicStreamSwitch = configuration.autoSwitchQuality;
			}
		}
		
		private var preloader:Preloader;
		private var _stage:Stage;
		
		private var osmfMenuItem:ContextMenuItem;
		
		private var configuration:PlayerConfiguration;
		private var factory:MediaFactory;
		private var player:MediaPlayer;
		
		private var element:MediaElement;
		
		private var container:MediaContainer;
		private var containerRenderer:LayoutRenderer;
		
		private var widgetsParser:WidgetsParser; 
		
		private var alert:AlertDialog;
		private var overlay:LayoutTargetSprite;
	}
}            