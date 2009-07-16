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
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.media.MediaFactory;
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
	    	var urlResource:IURLResource = resource as IURLResource;
	    	if (urlResource != null && urlResource.url != null)
	    	{
	    		return ((urlResource.url.protocol.search(/^http|https/i) != -1)
						&& (urlResource.url.path.search(/.swf$/i) != -1));

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
			var resource:IURLResource = loadable.resource as IURLResource;
			if (canHandleResource(resource))
			{
				// Load the loader swf into a ByteArray:
				var request:URLRequest = new URLRequest(resource.url.toString());
				var loader:Loader = new Loader();
				var context:LoaderContext = new LoaderContext();
				var root:Object;
				var swfRoot:Object;
				
				// Set the context's application domain to the current domain
				// so that we can cast IPluginInfo implementation from the plugin to 
				// the IPluginInfo definition found in the framework
				//
				// Actually we don't need to worry about application domain because the default
				// behavior works fine for the plugin architecture.
//				context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);

				// If the loaded swf does not live in the same security domain as the loading swf,
				// Flash Player will not merge the types defined in the two domains. Even if it happens
				// that there are two types of identical name, Flash Player will still consider them
				// different by tagging with different versions. Therefore, it is mandatory to 
				// have loaded swf and loading swf live in the same security domain. The following 
				// line of code does exactly this. 
				context.securityDomain = SecurityDomain.currentDomain;

				function onLoadComplete(event:Event):void
				{
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadIoError);
					loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadIoError);
		
					root = event.target.content;
					var pluginInfo:IPluginInfo = root[PLUGININFO_PROPERTY_NAME] as IPluginInfo;
					
					loadFromPluginInfo(loadable, pluginInfo, loader);
				}

				function onLoadIoError(event:IOErrorEvent):void
				{
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadIoError);
					loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadIoError);
					
					updateLoadable(loadable, LoadState.LOAD_FAILED);
				}
				
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadIoError);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadIoError);
				
				try
				{
					loader.load(request, context);
				}
				catch (ioError:IOError)
				{
					onLoadIoError(null);
				}
				catch (securityError:SecurityError)
				{
					onLoadIoError(null);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function unload(loadable:ILoadable):void
		{
			super.unload(loadable);
			var loadedContext:PluginLoadedContext = loadable.loadedContext as PluginLoadedContext;
			if (loadedContext.loader != null)
			{
				loadedContext.loader.unloadAndStop();
			}
		}
		
		private static const PLUGININFO_PROPERTY_NAME:String = "pluginInfo";
		
	}
}