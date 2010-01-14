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
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.proxies.MediaElementLoadedContext;
	import org.osmf.proxies.MediaElementLoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	
	/**
	 * The F4MLoader will load the Flash Media Manifest format
	 * files, generate a NetLoaded context corresponding to the resources
	 * specified in the f4m file.
	 */ 
	public class F4MLoader extends MediaElementLoader
	{
		// MimeType
		public static const F4M_MIME_TYPE:String = "application/f4m+xml";
					
		/**
		 * Generate a new F4MLoader.  
		 * @param factory The factory that is used to create MediaElements based on the 
		 * media specified in the manifest file. A default factory is created for the base OSMF media
		 * types, Video, Audio, Image, and SWF.
		 */ 	
		public function F4MLoader(factory:MediaFactory = null)
		{
			super();
			
			supportedMimeTypes.push(F4M_MIME_TYPE);		
			if (factory == null)
			{
				factory = new DefaultMediaFactory();
			}		
			this.parser = new ManifestParser();	
			this.factory = factory;				
		}

		/**
		 * @private
		 */ 
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{	
			var supported:int = MetadataUtils.checkMetadataMatchWithResource(resource, new Vector.<String>(), supportedMimeTypes);
			
			if (supported == MetadataUtils.METADATA_MATCH_FOUND)
			{
				return true;
			}
			else if (resource is URLResource)
			{
				var urlResource:URLResource = URLResource(resource);
				var extension:String = urlResource.url.path.substr(urlResource.url.path.length-3,3);
				return extension == F4M_EXTENSION;
			}		
			else
			{
				return false;
			}
		}
		
		/**
		 * @private
		 */
		override public function load(loadTrait:LoadTrait):void
		{
			super.load(loadTrait);
			updateLoadTrait(loadTrait, LoadState.LOADING);
			
			var manifest:Manifest;
			var manifestLoader:URLLoader = new URLLoader(new URLRequest(URLResource(loadTrait.resource).url.rawUrl));
			manifestLoader.addEventListener(Event.COMPLETE, onComplete);
			manifestLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			manifestLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
						
			function onError(event:ErrorEvent):void
			{				
				updateLoadTrait(loadTrait, LoadState.LOAD_ERROR); 				
				loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new MediaError(0, event.text)));
			}			
			function onComplete(event:Event):void
			{	
				manifestLoader.removeEventListener(Event.COMPLETE, onComplete);
				manifestLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				manifestLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);		
				try
				{					
					manifest = parser.parse(event.target.data);
				}
				catch (parseError:Error)
				{					
					updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
					loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new MediaError(parseError.errorID, parseError.message)));
				}
				
				// Load externals
				
				var unfinishedLoads:Number = 0;
				
				for each (var item:Media in manifest.media)
				{										
					// DRM Metadata  - we may make this load on demand in the future.					
					if (item.drmMetadataURL != null)
					{												
						var drmLoader:URLLoader = new URLLoader();
						unfinishedLoads++;
						drmLoader.addEventListener(Event.COMPLETE, onDRMLoadComplete);
						drmLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
						drmLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
					
						function onDRMLoadComplete(event:Event):void
						{
							event.target.removeEventListener(Event.COMPLETE, onDRMLoadComplete);
							event.target.removeEventListener(IOErrorEvent.IO_ERROR, onError);
							event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
							unfinishedLoads--;
							item.drmMetadata = URLLoader(event.target).data;
							if (unfinishedLoads == 0)
							{
								finishLoad();
							}
						}
						drmLoader.load(new URLRequest(item.drmMetadataURL.rawUrl));
					}					
				}	
				if (unfinishedLoads == 0) // No external resources
				{
					finishLoad();
				}														
			}	
			
			function finishLoad():void
			{			
				var netResource:MediaResourceBase = parser.createResource(manifest, URLResource(loadTrait.resource).url);	
				
				try
				{
					var loadedElem:MediaElement = factory.createMediaElement(netResource);	
				}
				catch (parseError:Error)
				{					
					updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
					loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new MediaError(parseError.errorID, parseError.message)));
				}			
				
				if (loadedElem.hasOwnProperty("defaultDuration")  && !isNaN(manifest.duration))
				{
					loadedElem["defaultDuration"] = manifest.duration;	
				}									
				var context:MediaElementLoadedContext = new MediaElementLoadedContext(loadedElem);																		
				updateLoadTrait(loadTrait, LoadState.READY, context);		
			}				
		}
		
		/**
		 * @private
		 */
		override public function unload(loadTrait:LoadTrait):void
		{
			super.unload(loadTrait);	
			updateLoadTrait(loadTrait, LoadState.UNINITIALIZED, null);					
		}
				
		private static const F4M_EXTENSION:String = "f4m";
		
		private var supportedMimeTypes:Vector.<String> = new Vector.<String>();		
		private var factory:MediaFactory;	
		private var parser:ManifestParser;	
	}
}