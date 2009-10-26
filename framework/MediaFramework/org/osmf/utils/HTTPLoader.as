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
package org.osmf.utils
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IURLResource;
	import org.osmf.media.URLResource;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoaderBase;

	/**
	 * Implementation of ILoader that can retrieve an URLResource using HTTP.
	 **/
	public class HTTPLoader extends LoaderBase
	{
		/**
		 * Constructor.
		 */
		public function HTTPLoader()
		{
			super();
		}
				
		/**
		 * Returns true for any resource using the HTTP(S) protocol.
		 **/
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			// Rule out protocols other than http(s).
			//
			
			var urlResource:IURLResource = resource as IURLResource;
			
			if (	urlResource == null
				|| 	urlResource.url == null
				||  urlResource.url.rawUrl == null
				||  urlResource.url.rawUrl.length <= 0
			   )
			{
				return false;
			}
						
			if (urlResource.url.protocol.search(/http$|https$/i) == -1)
			{
				return false;
			}
					
			return true;
		}
		
		/**
		 * Loads an URL over HTTP.
		 * 
		 * <p>Updates the ILoadable's <code>loadedState</code> property to LOADING
		 * while loading and to LOADED upon completing a successful load of the 
		 * URL.</p> 
		 * 
		 * @see org.osmf.traits.LoadState
		 * @see flash.display.Loader#load()
		 * @param ILoadable ILoadable to be loaded.
		 */ 
		override public function load(loadable:ILoadable):void
		{
			super.load(loadable);
			
			updateLoadable(loadable, LoadState.LOADING);
			
			var urlResource:URLResource = loadable.resource as URLResource;

			var urlReq:URLRequest = new URLRequest(urlResource.url.toString());
			var loader:URLLoader = createURLLoader();

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

			function toggleLoaderListeners(loader:URLLoader, on:Boolean):void
			{
				if (on)
				{
					loader.addEventListener(Event.COMPLETE, onLoadComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				}
				else
				{
					loader.removeEventListener(Event.COMPLETE, onLoadComplete);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				}
			}

			function onLoadComplete(event:Event):void
			{
				toggleLoaderListeners(loader, false);
				
				updateLoadable(loadable, LoadState.LOADED, new HTTPLoadedContext(loader));
			}

			function onIOError(ioEvent:IOErrorEvent, ioEventDetail:String=null):void
			{	
				toggleLoaderListeners(loader, false);
				
				updateLoadable(loadable, LoadState.LOAD_FAILED);
				loadable.dispatchEvent(new MediaErrorEvent(new MediaError(MediaErrorCodes.HTTP_IO_LOAD_ERROR, 
																				ioEvent ? ioEvent.text : ioEventDetail)));
			}

			function onSecurityError(securityEvent:SecurityErrorEvent, securityEventDetail:String=null):void
			{	
				toggleLoaderListeners(loader, false);
				
				updateLoadable(loadable, LoadState.LOAD_FAILED);
				loadable.dispatchEvent(new MediaErrorEvent(new MediaError(MediaErrorCodes.HTTP_SECURITY_LOAD_ERROR, 
																			securityEvent ? securityEvent.text : securityEventDetail)));
			}
		}
		
		/**
		 * Unloads the resource.  
		 * 
		 * <p>Updates the ILoadable's <code>loadedState</code> property to UNLOADING
		 * while unloading and to CONSTRUCTED upon completing a successful unload.</p>
		 *
		 * @param ILoadable ILoadable to be unloaded.
		 * @see org.osmf.traits.LoadState
		 */ 
		override public function unload(loadable:ILoadable):void
		{
			super.unload(loadable);

			// Nothing to do.
			updateLoadable(loadable, LoadState.UNLOADING, loadable.loadedContext);			
			updateLoadable(loadable, LoadState.CONSTRUCTED);
		}
		
		/**
		 * Creates the URLLoader to make the request.  Called by load().
		 * 
		 * Subclasses can override this method to set specific properties on
		 * the URLLoader.
		 **/
		protected function createURLLoader():URLLoader
		{
			return new URLLoader();
		}
	}
}