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
package org.openvideoplayer.image
{
	import __AS3__.vec.Vector;
	
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	import org.openvideoplayer.events.MediaError;
	import org.openvideoplayer.events.MediaErrorCodes;
	import org.openvideoplayer.events.MediaErrorEvent;
	import org.openvideoplayer.loaders.LoaderBase;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.metadata.MediaType;
	import org.openvideoplayer.metadata.MetadataUtils;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.utils.*;

	/**
	 * The ImageLoader class creates a flash.display.Loader object, 
	 * which it uses to load and unload an image.
	 * <p>The image is loaded from the URL provided by the
	 * <code>resource</code> property of the ILoadable that is passed
	 * to the ImageLoader's <code>load()</code> method.</p>
	 *
	 * @see ImageElement
	 * @see org.openvideoplayer.traits.ILoadable
	 * @see flash.display.Loader
	 */ 
	public class ImageLoader extends LoaderBase
	{
		/**
		 * Constructs a new ImageLoader.
		 */ 
		public function ImageLoader()
		{
			super();
		}
		
		/**
		 * Indicates whether this ImageLoader is capable of handling the specified resource.
		 * Returns <code>true</code> for IURLResources with GIF, JPG, or PNG extensions.
		 * @param resource Resource proposed to be loaded.
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
				return (urlResource.url.path.search(/\.gif$|\.jpg$|\.png$/i) != -1);
			}	
			return false;
		}
		
		/**
		 * Loads an image using a flash.display.Loader object. 
		 * <p>Updates the ILoadable's <code>loadedState</code> property to LOADING
		 * while loading and to LOADED upon completing a successful load.</p> 
		 * 
		 * @see org.openvideoplayer.traits.LoadState
		 * @see flash.display.Loader#load()
		 * @param ILoadable ILoadable to be loaded.
		 */ 
		override public function load(loadable:ILoadable):void
		{
			// Check for invalid state.
			validateLoad(loadable);
			
			updateLoadable(loadable, LoadState.LOADING);
			
			var urlReq:URLRequest = new URLRequest((loadable.resource as IURLResource).url.toString());
			var loader:Loader = new Loader();
			toggleLoaderListeners(loader, true);
			try
			{
				loader.load(urlReq);
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
				
				updateLoadable(loadable, LoadState.LOADED, new ImageLoadedContext(loader));
			}

			function onIOError(ioEvent:IOErrorEvent, ioEventDetail:String=null):void
			{	
				toggleLoaderListeners(loader, false);
				
				updateLoadable(loadable, LoadState.LOAD_FAILED);
				loadable.dispatchEvent
					( new MediaErrorEvent
						( new MediaError
							( MediaErrorCodes.IMAGE_IO_LOAD_ERROR
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
							( MediaErrorCodes.IMAGE_SECURITY_LOAD_ERROR
							, securityEvent ? securityEvent.text : securityEventDetail
							)
						)
					);
			}
		}

		
		/**
		 * Unloads an image using a flash.display.Loader object.  
		 * 
		 * <p>Updates the ILoadable's <code>loadedState</code> property to UNLOADING
		 * while unloading and to CONSTRUCTED upon completing a successful unload.</p>
		 *
		 * @param ILoadable ILoadable to be unloaded.
		 * @see org.openvideoplayer.traits.LoadState
		 * @see flash.display.Loader#unload()
		 */ 
		override public function unload(loadable:ILoadable):void
		{
			// Check for invalid state.
			validateUnload(loadable);

			var context:ImageLoadedContext = (loadable.loadedContext) as ImageLoadedContext;
			updateLoadable(loadable, LoadState.UNLOADING, context);			
			context.loader.unload();
			updateLoadable(loadable, LoadState.CONSTRUCTED);
		}
		
		// Internals
		//

		private static const MIME_TYPES_SUPPORTED:Vector.<String> = Vector.<String>(["image/png", "image/gif", "image/jpeg"]);
			
		private static const MEDIA_TYPES_SUPPORTED:Vector.<String> = Vector.<String>([MediaType.IMAGE]);
	}
}