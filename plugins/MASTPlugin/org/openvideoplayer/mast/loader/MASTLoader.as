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
******************************************************/
package org.openvideoplayer.mast.loader
{
	import org.openvideoplayer.events.LoaderEvent;
	import org.openvideoplayer.events.MediaErrorEvent;
	import org.openvideoplayer.loaders.LoaderBase;
	import org.openvideoplayer.mast.model.*;
	import org.openvideoplayer.mast.parser.MASTParser;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.HTTPLoadedContext;
	import org.openvideoplayer.utils.HTTPLoader;
	
	/**
	 * Loader for the MASTProxyElement.
	 **/
	public class MASTLoader extends LoaderBase
	{
		/**
		 * Constructor.
		 * 
		 * @param The HTTPLoader to be used by this MASTLoader to retrieve
		 * the MAST document.  If null, then a new one will be created on
		 * demand.
		 */
		public function MASTLoader(httpLoader:HTTPLoader=null)
		{
			super();
			
			this.httpLoader = httpLoader != null ? httpLoader : new HTTPLoader();			
		}
		
		/**
		 * @private
		 **/
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			return httpLoader.canHandleResource(resource);
		}
		
		/**
		 * Loads a MAST document.
		 * <p>Updates the ILoadable's <code>loadedState</code> property to LOADING
		 * while loading and to LOADED upon completing a successful load and parse of the
		 * MAST document.</p>
		 * 
		 * @see org.openvideoplayer.traits.LoadState
		 * @param loadable The ILoadable to be loaded.
		 */
		override public function load(loadable:ILoadable):void
		{
			super.load(loadable);
			
			updateLoadable(loadable, LoadState.LOADING);			
						
			httpLoader.addEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onHTTPLoaderStateChange);
			
			// Create a temporary ILoadable for this purpose, so that our main
			// ILoadable doesn't reflect any of the state changes from the
			// loading of the URL, and so that we can catch any errors.
			var httpLoadable:LoadableTrait = new LoadableTrait(httpLoader, loadable.resource);
						
			httpLoadable.addEventListener(MediaErrorEvent.MEDIA_ERROR, onLoadableError);
			
			trace("MASTLoader: Downloading document at " + URLResource(httpLoadable.resource).url.rawUrl);
			
			httpLoader.load(httpLoadable);
			
			function onHTTPLoaderStateChange(event:LoaderEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					// This is a terminal state, so remove all listeners.
					httpLoader.removeEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onHTTPLoaderStateChange);
					httpLoadable.removeEventListener(MediaErrorEvent.MEDIA_ERROR, onLoadableError);
	
					var loadedContext:HTTPLoadedContext = event.loadedContext as HTTPLoadedContext;
					
					var parser:MASTParser = new MASTParser();
					var mastDocument:MASTDocument;
					
					try
					{
						mastDocument = parser.parse(loadedContext.urlLoader.data.toString());
					}
					catch(e:Error)
					{
						updateLoadable(loadable, LoadState.LOAD_FAILED);
						throw e;
					}
					
					updateLoadable(loadable, LoadState.LOADED, new MASTLoadedContext(mastDocument));
					
				}
				else if (event.newState == LoadState.LOAD_FAILED)
				{
					// This is a terminal state, so remove the listener.  But
					// don't remove the error event listener, as that will be
					// removed when the error event for this failure is
					// dispatched.
					httpLoader.removeEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onHTTPLoaderStateChange);
					
					updateLoadable(loadable, event.newState);
				}
			}
			
			function onLoadableError(event:MediaErrorEvent):void
			{
				// Only remove this listener, as there will be a corresponding
				// event for the load failure.
				httpLoadable.removeEventListener(MediaErrorEvent.MEDIA_ERROR, onLoadableError);
				
				loadable.dispatchEvent(event.clone());
			}						
		}
		
		/**
		 * Unloads the document.  
		 * 
		 * <p>Updates the ILoadable's <code>loadedState</code> property to UNLOADING
		 * while unloading and to CONSTRUCTED upon completing a successful unload.</p>
		 *
		 * @param ILoadable ILoadable to be unloaded.
		 * @see org.openvideoplayer.traits.LoadState
		 */ 
		override public function unload(loadable:ILoadable):void
		{
			super.unload(loadable);

			// Nothing to do.
			updateLoadable(loadable, LoadState.UNLOADING, loadable.loadedContext);			
			updateLoadable(loadable, LoadState.CONSTRUCTED);
		}		

		private var httpLoader:HTTPLoader;		
	}
}
