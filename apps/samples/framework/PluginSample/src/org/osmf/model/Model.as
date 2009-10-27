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
*  Contributor(s): Akamai Technologies
*  
*****************************************************/
package org.osmf.model
{
	import mx.collections.ArrayCollection;
	
	import org.osmf.audio.*;
	import org.osmf.media.*;
	import org.osmf.net.*;
	import org.osmf.plugin.*;
	import org.osmf.swf.*;
	import org.osmf.traits.*;
	import org.osmf.video.*;
	
	public class Model
	{
		private static var _instance:Model;
		
		public static function getInstance():Model
		{
			if (_instance == null)
			{
				_instance = new Model();
			}
			
			return _instance;
		}
		
		public var mediaFactory:MediaFactory;
		public var pluginManager:PluginManager;
		public var resourceHandlers:ArrayCollection;

		public function Model()
		{
			// initialization						
			mediaFactory = new MediaFactory(new AppResourceHandlerResolver());
			pluginManager = new PluginManager(mediaFactory);
			
			var loader:ILoader = new NetLoader();
			mediaFactory.addMediaInfo
				( new MediaInfo
					( "Standard video element"
					, loader as IMediaResourceHandler
					, createVideoElement
					)
				);
				
			loader = new SoundLoader();
			mediaFactory.addMediaInfo
				( new MediaInfo
					( "Standard audio element"
					, loader as IMediaResourceHandler
					, createAudioElement
					)
				);
				
			loader = new SWFLoader();
			mediaFactory.addMediaInfo
				( new MediaInfo
					( "Standard SWF element"
					, loader as IMediaResourceHandler
					, createSWFElement
					)
				);
			
			initResourceHandlers();
		}
		
		public function updatePriorityByMediaInfoId(mediaInfoId:String, priority:int):void
		{
			getResourceHandlerByMediaInfoId(mediaInfoId).priority = priority;
		}
		
		public function getResourceHandlerByMediaInfoId(mediaInfoId:String):ResourceHandlerDescriptor
		{
			for (var i:int = 0; i < resourceHandlers.length; i++)
			{
				var handler:ResourceHandlerDescriptor 
					= resourceHandlers.getItemAt(i) as ResourceHandlerDescriptor;
				if (handler.mediaInfoId == mediaInfoId)
				{
					return handler;
				}
			}
			
			return null;
		}

		public function updateResourceHandlers():void
		{
			var oldHandlers:ArrayCollection = resourceHandlers;
			initResourceHandlers();
			for (var i:int = 0; i < resourceHandlers.length; i++)
			{
				var handler:ResourceHandlerDescriptor 
					= resourceHandlers.getItemAt(i) as ResourceHandlerDescriptor;
				updatePriority(handler, oldHandlers);
			}
		}
		
		private function updatePriority(
			handler:ResourceHandlerDescriptor, handlers:ArrayCollection):void
		{
			for (var i:int = 0; i < handlers.length; i++)
			{
				var item:ResourceHandlerDescriptor 
					= handlers.getItemAt(i) as ResourceHandlerDescriptor;
				if (item.mediaInfoId == handler.mediaInfoId)
				{
					handler.priority = item.priority;
					break;
				}
			}
		}
		
		private function createVideoElement():MediaElement
		{
			return new VideoElement(new NetLoader());
		}
		
		private function createAudioElement():MediaElement
		{
			return new AudioElement(new SoundLoader());
		}
		
		private function createSWFElement():MediaElement
		{
			return new SWFElement(new SWFLoader());
		}

		private function initResourceHandlers():void
		{
			resourceHandlers = new ArrayCollection();
			for (var i:int = 0; i < mediaFactory.numMediaInfos; i++)
			{
				var mediaInfo:MediaInfo = mediaFactory.getMediaInfoAt(i);
				if (mediaInfo != null)
				{
					resourceHandlers.addItem(new ResourceHandlerDescriptor(mediaInfo));
				}
			}
		}
	}
}