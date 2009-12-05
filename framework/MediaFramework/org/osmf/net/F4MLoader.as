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
package org.osmf.net
{
	import __AS3__.vec.Vector;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osmf.audio.AudioElement;
	import org.osmf.audio.SoundLoader;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.image.ImageElement;
	import org.osmf.image.ImageLoader;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaInfo;
	import org.osmf.media.MediaInfoType;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.net.dynamicstreaming.DynamicStreamingNetLoader;
	import org.osmf.proxies.MediaElementLoadedContext;
	import org.osmf.proxies.MediaElementLoader;
	import org.osmf.swf.SWFElement;
	import org.osmf.swf.SWFLoader;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.video.VideoElement;
	
	/**
	 * The FMMLoader will load the Flash Media Manifest format
	 * files, generate a NetLoaded context corresponding to the resources
	 * specified in the fmm file.
	 */ 
	public class F4MLoader extends MediaElementLoader
	{
			
		//MimeType
		public static const F4M_MIME_TYPE:String = "application/f4m+xml";
					
		/**
		 * Generate a new FMMLoader.  
		 * @param netLoader The factory that is used to create MediaElements based on the 
		 * media specified in the manifest file. a default factory is created for the base OSMF media
		 * types, Video, Audio, Image, and SWF.
		 */ 	
		public function F4MLoader(factory:MediaFactory = null)
		{							
			if(factory == null)
			{
				factory = new MediaFactory();
				factory.addMediaInfo(new MediaInfo("VideoDynamicStreaming", new DynamicStreamingNetLoader(), function():MediaElement{return new VideoElement(new DynamicStreamingNetLoader())}, MediaInfoType.STANDARD));
				factory.addMediaInfo(new MediaInfo("Video", new NetLoader(), function():MediaElement{return new VideoElement(new NetLoader())}, MediaInfoType.STANDARD));
				factory.addMediaInfo(new MediaInfo("Audio", new SoundLoader(), function():MediaElement{return new AudioElement(new SoundLoader())}, MediaInfoType.STANDARD));
				factory.addMediaInfo(new MediaInfo("AudioStreaming", new NetLoader(), function():MediaElement{return new AudioElement(new NetLoader())}, MediaInfoType.STANDARD));
				factory.addMediaInfo(new MediaInfo("Image", new ImageLoader(), function():MediaElement{return new ImageElement(new ImageLoader())}, MediaInfoType.STANDARD));
				factory.addMediaInfo(new MediaInfo("SWF", new SWFLoader(), function():MediaElement{return new SWFElement(new SWFLoader())}, MediaInfoType.STANDARD));
			}			
			this.factory = factory;				
		}

		/**
		 * ineritDoc
		 */ 
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			var suportedMimeTypes:Vector.<String> = new Vector.<String>();
			suportedMimeTypes.push(F4M_MIME_TYPE);
			var supported:int = MetadataUtils.checkMetadataMatchWithResource(resource, new Vector.<String>(), suportedMimeTypes);
			
			if (supported == MetadataUtils.METADATA_MATCH_FOUND)
			{
				return true;
			}
			else if (resource is URLResource)
			{
				var url:URLResource = URLResource(resource);
				var extension:String = url.url.path.substr(url.url.path.length-3,3);
				return extension == F4M_EXTENSION;
			}		
			else
			{
				return false;
			}
		}
		
		/**
		 * ineritDoc
		 */
		override public function load(loadable:ILoadable):void
		{
			super.load(loadable);
			updateLoadable(loadable, LoadState.LOADING);
			
			var loader:URLLoader = new URLLoader(new URLRequest(URLResource(loadable.resource).url.rawUrl));
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
						
			function onError(event:ErrorEvent):void
			{				
				updateLoadable(loadable, LoadState.LOAD_ERROR); 				
				loadable.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new MediaError(0, event.text)));
			}			
			function onComplete(event:Event):void
			{			
				try
				{
					var manifest:Manifest = ManifestParser.parse(event.target.data);
				}
				catch(parseError:Error)
				{					
					updateLoadable(loadable, LoadState.LOAD_ERROR);
					loadable.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new MediaError(parseError.errorID, parseError.message)));
				}
				
				//Load externals
				
				var unfinishedLoads:Number = 0;
				
				for each (var item:Media in manifest.media)
				{
					var request:URLRequest;
					var loader:URLLoader;
					
					//Bootstrap
					
					if (item.bootstrapInfoURL != null)
					{										
						loader = new URLLoader();
						unfinishedLoads++;
						loader.addEventListener(Event.COMPLETE, onLoadComplete);
						loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
						loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
					
						function onLoadComplete(event:Event):void
						{
							unfinishedLoads--;
							item.bootstrapInfo = URLLoader(event.target).data;
							if (unfinishedLoads == 0)
							{
								finishLoad(manifest, loadable)
							}
						}
						loader.load(new URLRequest(item.bootstrapInfoURL));
					}
					
					//DRM Metadata
					
					if (item.drmMetadataURL != null)
					{												
						loader = new URLLoader();
						unfinishedLoads++;
						loader.addEventListener(Event.COMPLETE, onDRMLoadComplete);
						loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
						loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
					
						function onDRMLoadComplete(event:Event):void
						{
							unfinishedLoads--;
							item.drmMetadata = URLLoader(event.target).data;
							if (unfinishedLoads == 0)
							{
								finishLoad(manifest, loadable)
							}
						}
						loader.load(new URLRequest(item.bootstrapInfoURL));
					}					
				}	
				if (unfinishedLoads == 0) // No external resources
				{
					finishLoad(manifest, loadable);
				}														
			}		
		} 
		
		private function finishLoad(manifest:Manifest, loadable:ILoadable):void
		{
			var netResource:IMediaResource = ManifestParser.createResource(manifest, URLResource(loadable.resource).url);	
			
			try
			{
				var loadedElem:MediaElement = factory.createMediaElement(netResource);	
			}
			catch(parseError:Error)
			{					
				updateLoadable(loadable, LoadState.LOAD_ERROR);
				loadable.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new MediaError(parseError.errorID, parseError.message)));
			}			
			
			if (loadedElem.hasOwnProperty("defaultDuration"))
			{
				loadedElem["defaultDuration"] = manifest.duration;	
			}									
			var context:MediaElementLoadedContext = new MediaElementLoadedContext(loadedElem);																		
			updateLoadable(loadable, LoadState.READY, context);		
		}
		
		/**
		 * ineritDoc
		 */
		override public function unload(loadable:ILoadable):void
		{
			super.unload(loadable);						
		}
		
		
		
		private static const F4M_EXTENSION:String = "f4m";
		
		private var factory:MediaFactory;
		
	}
}