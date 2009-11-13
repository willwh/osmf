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
package org.osmf.mast.loader
{
	import org.osmf.events.LoaderEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.mast.model.*;
	import org.osmf.mast.parser.MASTParser;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.URLResource;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.utils.HTTPLoadedContext;
	import org.osmf.utils.HTTPLoader;
	CONFIG::LOGGING
	{
	import org.osmf.logging.*;		
	}
	
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
		 * @see org.osmf.traits.LoadState
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
			
			CONFIG::LOGGING
			{
				logger.debug("Downloading document at " + URLResource(httpLoadable.resource).url.rawUrl);
			}
			
			httpLoader.load(httpLoadable);
			
			function onHTTPLoaderStateChange(event:LoaderEvent):void
			{
				if (event.newState == LoadState.READY)
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
						updateLoadable(loadable, LoadState.LOAD_ERROR);
						throw e;
					}
					
					updateLoadable(loadable, LoadState.READY, new MASTLoadedContext(mastDocument));
					
				}
				else if (event.newState == LoadState.LOAD_ERROR)
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
		 * while unloading and to UNINITIALIZED upon completing a successful unload.</p>
		 *
		 * @param ILoadable ILoadable to be unloaded.
		 * @see org.osmf.traits.LoadState
		 */ 
		override public function unload(loadable:ILoadable):void
		{
			super.unload(loadable);

			// Nothing to do.
			updateLoadable(loadable, LoadState.UNLOADING, loadable.loadedContext);			
			updateLoadable(loadable, LoadState.UNINITIALIZED);
		}		

		private var httpLoader:HTTPLoader;		
		
		CONFIG::LOGGING
		{	
			private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("MASTLoader");		
		}	
	}
}
