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
package org.openvideoplayer.plugin
{
	import __AS3__.vec.Vector;
	
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.openvideoplayer.events.MediaError;
	import org.openvideoplayer.events.MediaErrorCodes;
	import org.openvideoplayer.events.MediaErrorEvent;
	import org.openvideoplayer.loaders.LoaderBase;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.metadata.MediaType;
	import org.openvideoplayer.metadata.MetadataUtils;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	
	internal class DynamicPluginLoader extends PluginLoader
	{
		/**
		 * Constructor
		 */
		public function DynamicPluginLoader(mediaFactory:MediaFactory)
		{
			super(mediaFactory);
		}

		/**
		 * @inheritDoc
		 */
	    override public function canHandleResource(resource:IMediaResource):Boolean
	    {
			var rt:int = MetadataUtils.checkMetadataMatchWithResource(resource, MEDIA_TYPES_SUPPORTED, MIME_TYPES_SUPPORTED);
			if (rt != MetadataUtils.METADATA_MATCH_UNKNOWN)
			{
				return rt == MetadataUtils.METADATA_MATCH_FOUND;
			}			
			
	    	var urlResource:IURLResource = resource as IURLResource;
	    	if (urlResource != null && urlResource.url != null)
	    	{
	    		return ((urlResource.url.protocol.search(/^http|https/i) != -1)
						&& (urlResource.url.path.search(/\.swf$/i) != -1));

	    	}
	    	else
	    	{
				return false;
	    	}
	    }

		/**
		 * @inheritDoc
		 */
		override public function load(loadable:ILoadable):void
		{
			// Check for invalid state.
			validateLoad(loadable);
			
			updateLoadable(loadable, LoadState.LOADING);

			var urlReq:URLRequest = new URLRequest((loadable.resource as IURLResource).url.toString());
			var loader:Loader = new Loader();			
			var context:LoaderContext = new LoaderContext();

			// Set the context's application domain to the current domain
			// so that we can cast IPluginInfo implementation from the plugin to 
			// the IPluginInfo definition found in the framework
			//
			// Actually we don't need to worry about application domain because the default
			// behavior works fine for the plugin architecture.
			// context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);

			// If the loaded swf does not live in the same security domain as the loading swf,
			// Flash Player will not merge the types defined in the two domains. Even if it happens
			// that there are two types of identical name, Flash Player will still consider them
			// different by tagging with different versions. Therefore, it is mandatory to 
			// have loaded swf and loading swf live in the same security domain. The following 
			// line of code does exactly this. 
			context.securityDomain = SecurityDomain.currentDomain;

			toggleLoaderListeners(loader, true);

			try
			{
				loader.load(urlReq, context);
			}
			catch (ioError:IOError)
			{
				onIOError(null, ioError.message);
			}
			catch (securityError:SecurityError)
			{
				onSecurityError(null, securityError.message);
			}

			function toggleLoaderListeners(loader:Loader, on:Boolean):void
			{
				if (on)
				{
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				}
				else
				{
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				}
			}
			
			function onLoadComplete(event:Event):void
			{
				toggleLoaderListeners(loader, false);
	
				var root:Object = event.target.content;
				var pluginInfo:IPluginInfo = root[PLUGININFO_PROPERTY_NAME] as IPluginInfo;
				
				loadFromPluginInfo(loadable, pluginInfo, loader);
			}

			function onIOError(ioEvent:IOErrorEvent, ioEventDetail:String=null):void
			{	
				toggleLoaderListeners(loader, false);
				
				updateLoadable(loadable, LoadState.LOAD_FAILED);
				loadable.dispatchEvent
					( new MediaErrorEvent
						( new MediaError
							( MediaErrorCodes.SWF_IO_LOAD_ERROR
							, ioEvent ? ioEvent.text : ioEventDetail
							)
						)
					);
			}
			
			function onSecurityError(securityEvent:SecurityErrorEvent, securityEventDetail:String=null):void
			{	
				toggleLoaderListeners(loader, false);
				
				updateLoadable(loadable, LoadState.LOAD_FAILED);
				loadable.dispatchEvent
					( new MediaErrorEvent
						( new MediaError
							( MediaErrorCodes.SWF_SECURITY_LOAD_ERROR
							, securityEvent ? securityEvent.text : securityEventDetail
							)
						)
					);
			}
		}

		// Internals
		//

		/**
		 * @inheritDoc
		 */
		override public function unload(loadable:ILoadable):void
		{
			var loadedContext:PluginLoadedContext = loadable.loadedContext as PluginLoadedContext;
			if (loadedContext != null && loadedContext.loader != null)
			{
				loadedContext.loader.unloadAndStop();
			}

			super.unload(loadable);
		}
		
		private static const PLUGININFO_PROPERTY_NAME:String = "pluginInfo";
		
		private static const MIME_TYPES_SUPPORTED:Vector.<String> = Vector.<String>(["application/x-shockwave-flash"]);
		private static const MEDIA_TYPES_SUPPORTED:Vector.<String> = Vector.<String>([MediaType.SWF]);
	}
}