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
package org.osmf.manifest
{
	import __AS3__.vec.Vector;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.proxies.MediaElementLoadedContext;
	import org.osmf.proxies.MediaElementLoader;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	
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
		public function F4MLoader(parser:ManifestParser = null, factory:MediaFactory = null)
		{		
			supportedMimeTypes.push(F4M_MIME_TYPE);		
			if (parser == null)
			{
				parser = new ManifestParser();
			}		
			if (factory == null)
			{
				factory = new DefaultMediaFactory();
			}		
			this.parser = parser;	
			this.factory = factory;				
		}

		/**
		 * @ineritDoc
		 */ 
		override public function canHandleResource(resource:IMediaResource):Boolean
		{	
			var supported:int = MetadataUtils.checkMetadataMatchWithResource(resource, new Vector.<String>(), supportedMimeTypes);
			
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
		 * @ineritDoc
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
					var manifest:Manifest = parser.parse(event.target.data);
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
					
					//DRM Metadata  - we could make this load on demand in the future.
					
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
						loader.load(new URLRequest(item.drmMetadataURL.rawUrl));
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
			var netResource:IMediaResource = parser.createResource(manifest, URLResource(loadable.resource).url);	
			
			try
			{
				var loadedElem:MediaElement = factory.createMediaElement(netResource);	
			}
			catch(parseError:Error)
			{					
				updateLoadable(loadable, LoadState.LOAD_ERROR);
				loadable.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new MediaError(parseError.errorID, parseError.message)));
			}			
			
			if (loadedElem.hasOwnProperty("defaultDuration")  && !isNaN(manifest.duration))
			{
				loadedElem["defaultDuration"] = manifest.duration;	
			}									
			var context:MediaElementLoadedContext = new MediaElementLoadedContext(loadedElem);																		
			updateLoadable(loadable, LoadState.READY, context);		
		}
		
		/**
		 * @ineritDoc
		 */
		override public function unload(loadable:ILoadable):void
		{
			super.unload(loadable);	
			updateLoadable(loadable, LoadState.UNINITIALIZED, null);					
		}
				
		private static const F4M_EXTENSION:String = "f4m";
		
		private var supportedMimeTypes:Vector.<String> = new Vector.<String>();		
		private var factory:MediaFactory;	
		private var parser:ManifestParser;	
	}
}