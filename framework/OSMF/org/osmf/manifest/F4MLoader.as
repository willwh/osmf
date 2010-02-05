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
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.proxies.FactoryLoadTrait;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.utils.URL;
	
	/**
	 * The F4MLoader is a LoaderBase that's capable of loading files of the Flash
	 * Media Manifest format, also known as F4M files (after the file extension).
	 * 
	 * For details on the Flash Media Manifest format, see
	 * http://opensource.adobe.com/wiki/display/osmf/Flash+Media+Manifest+File+Format+Specification.
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	public class F4MLoader extends LoaderBase
	{
		/**
		 * The MIME type for F4M files.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const F4M_MIME_TYPE:String = "application/f4m+xml";
					
		/**
		 * Constructor.
		 * 
		 * @param factory The factory that is used to create MediaElements based on the 
		 * media specified in the manifest file.  If no factory is provided, the F4MLoader
		 * will use a DefaultMediaFactory.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
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
		override protected function executeLoad(loadTrait:LoadTrait):void
		{
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
					manifest = parser.parse(event.target.data, getRootUrl(URLResource(loadTrait.resource).url));
				}
				catch (parseError:Error)
				{					
					updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
					loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new MediaError(parseError.errorID, parseError.message)));
				}
				
				// Load externals
				
				var unfinishedLoads:Number = 0;
				
				if (manifest != null)
				{
					for each (var item:DRMAdditionalHeader in manifest.drmAdditionalHeaders)
					{										
						// DRM Metadata  - we may make this load on demand in the future.					
						if (item.url != null)
						{		
							function completionCallback(success:Boolean):void
							{
								if (success)
								{
									unfinishedLoads--;					
								}
								
								if (unfinishedLoads == 0)
								{
									finishLoad();
								}
							}

							unfinishedLoads++;
							loadAdditionalHeader(item, completionCallback, onError);										
						}					
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
				
				FactoryLoadTrait(loadTrait).mediaElement = loadedElem;																		
				updateLoadTrait(loadTrait, LoadState.READY, new F4MLoadedContext());		
			}				
		}
		
		/**
		 * @private
		 */
		override protected function executeUnload(loadTrait:LoadTrait):void
		{
			updateLoadTrait(loadTrait, LoadState.UNINITIALIZED, null);					
		}
		
		private function loadAdditionalHeader(item:DRMAdditionalHeader, completionCallback:Function, onError:Function):void
		{
			var drmLoader:URLLoader = new URLLoader();
			drmLoader.dataFormat = URLLoaderDataFormat.BINARY;
			drmLoader.addEventListener(Event.COMPLETE, onDRMLoadComplete);
			drmLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			drmLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		
			function onDRMLoadComplete(event:Event):void
			{
				event.target.removeEventListener(Event.COMPLETE, onDRMLoadComplete);
				event.target.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				item.data = URLLoader(event.target).data;
				completionCallback(true);
			}
			
			drmLoader.load(new URLRequest(item.url.rawUrl));
		}	
			
		private function getRootUrl(url:URL):URL
		{
			var path:String = url.rawUrl.substr(0, url.rawUrl.lastIndexOf("/"));
			
			return new URL(path);
		}
		
		private static const F4M_EXTENSION:String = "f4m";
		
		private var supportedMimeTypes:Vector.<String> = new Vector.<String>();		
		private var factory:MediaFactory;	
		private var parser:ManifestParser;	
	}
}