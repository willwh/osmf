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
	import flash.display.*;
	import flash.events.*;
	
	import org.osmf.chrome.application.*;
	import org.osmf.chrome.configuration.*;
	import org.osmf.chrome.debug.*;
	import org.osmf.chrome.widgets.*;
	import org.osmf.containers.*;
	import org.osmf.events.*;
	import org.osmf.layout.*;
	import org.osmf.media.*;
	import org.osmf.net.*;
	import org.osmf.player.configuration.*;
	import org.osmf.player.debug.*;
	import org.osmf.player.preloader.*;
	import org.osmf.traits.*;
	
	CONFIG::DEBUG 
	{
	import org.osmf.logging.Log;
	}
	
	[Frame(factoryClass="org.osmf.player.preloader.Preloader")]
	[SWF(backgroundColor="0x000000", frameRate="25", width="640", height="380")]
	public class OSMFPlayer extends ChromeApplication
	{
		public function OSMFPlayer(preloader:Preloader)
		{
			// Store pre-loader references:
			CONFIG::DEBUG
			{
				debugger = preloader.debugger;
				Log.loggerFactory = new DebuggerLoggerFactory(preloader.debugger);
			}

			super();
			
			// Set the SWF scale mode, and listen to the stage change
			// dimensions:
			_stage = preloader.stage;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			
			// Parse configuration from the parameters passed on embedding
			// OSMFPlayer.swf:
			configuration = new PlayerConfiguration(preloader.loaderInfo.parameters);
			
			// Setup the ChromeApplication (base class):		
			setup(preloader.configuration);
			
			// Simulate the stage resizing, to update the dimensions of the
			// container:
			onStageResize();
			
			// Try to load the URL set on the configuration:
			url = configuration.url;
		}
		
		// Internals
		//
		
		override protected function constructWidgetsParser():WidgetsParser
		{
			var widgets:WidgetsParser = super.constructWidgetsParser();
			
			// Add a number of (debug) type widgets:
			widgets.addType("memoryMeter", MemoryMeter);
			widgets.addType("fpsMeter", FPSMeter);
			
			return widgets;
		}
		
		override protected function processSetupComplete():void
		{
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
			player.addEventListener(MediaPlayerCapabilityChangeEvent.IS_DYNAMIC_STREAM_CHANGE, onIsDynamicStreamChange);
			player.addEventListener(MediaPlayerCapabilityChangeEvent.CAN_BUFFER_CHANGE, onCanBufferChange);
			
			container.clipChildren = true;
			container.backgroundColor = configuration.backgroundColor;
			container.backgroundAlpha = isNaN(configuration.backgroundColor) ? 0 : 1;
			
			var urlInput:URLInput = widgets.getWidget("urlInput") as URLInput;
			if (urlInput)
			{
				urlInput.addEventListener(Event.CHANGE, onInputURLChange);
				urlInput.url = configuration.url;
			}
			
			var button:EjectButton = widgets.getWidget("ejectButton") as EjectButton;
			if (button)
			{
				button.addEventListener(MouseEvent.CLICK, onEjectButtonClick);
			}
			
			alert = widgets.getWidget("alert") as AlertDialog;
		}
		
		override protected function processNewMedia(value:MediaElement):MediaElement
		{
			var result:MediaElement;
			if (value != null)
			{
				CONFIG::DEBUG
				{
					if (value)
					{
						result = new DebuggerElementProxy(value, debugger);
					}
					
					debugger.send("TRACE", "media change", value);
				}
			}
			return result;
		}
				
		// Handlers
		//
		
		private function onCanBufferChange(event:MediaPlayerCapabilityChangeEvent):void
		{
			var loadTrait:NetStreamLoadTrait;
			if (event.enabled)
			{
				if (player.media != null)
				{
					loadTrait = player.media.getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
					if (loadTrait != null)
					{
						loadTrait.netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					}
				}
			}
			else
			{
				if (player.media != null)
				{
					loadTrait = player.media.getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
					if (loadTrait != null)
					{
						loadTrait.netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					}
				}
			}
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			if (event.info.code == NetStreamCodes.NETSTREAM_BUFFER_EMPTY)
			{
				if (player.media != null)
				{
					var loadTrait:NetStreamLoadTrait = player.media.getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
					if (loadTrait != null)
					{
						if (loadTrait.netStream.bufferTime >= 2.0)
						{
							loadTrait.netStream.bufferTime += 1.0;
						}
						else
						{
							loadTrait.netStream.bufferTime = 2.0;
						}						
					}
				}
			}
		}
		
		private function onStageResize(event:Event = null):void
		{
			// Propagate dimensions to the main container:
			width = _stage.stageWidth;
			height = _stage.stageHeight;
		}
		
		private function onEjectButtonClick(event:MouseEvent):void
		{
			// Escape full-screen mode (if applicable):
			_stage.displayState = StageDisplayState.NORMAL;
			
			// Reset the current media:
			media = null;
		}
		
		private function onInputURLChange(event:Event):void
		{
			var urlInput:URLInput = event.target as URLInput;
			if (urlInput)
			{
				if (alert)
				{
					alert.close();
				}
				url = urlInput.url;
			}
		}
		
		private function onMediaError(event:MediaErrorEvent):void
		{
			// Compose error message:
			var message:String
				= event.error.message
				+ (event.error.detail ? "\n" + event.error.detail : "");
			
			// If an alert widget is available, use it. Otherwise, trace the message:
			if (alert)
			{
				alert.alert("Error", message);
			}
			else
			{
				trace("Error:",event.error.message + "\n" + event.error.detail); 
			}
		}
		
		private function onIsDynamicStreamChange(event:MediaPlayerCapabilityChangeEvent):void
		{
			// Apply the configuration's autoSwitchQuality setting:
			if (player.isDynamicStream)
			{
				player.autoDynamicStreamSwitch = configuration.autoSwitchQuality;
			}
		}
		
		private var _stage:Stage;
		CONFIG::DEBUG {	private var debugger:Debugger; }
		
		private var configuration:PlayerConfiguration;
		private var alert:AlertDialog;
	}
}            