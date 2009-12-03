/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.captioning.loader
{
	import org.osmf.captioning.model.CaptioningDocument;
	import org.osmf.captioning.parsers.DFXPParser;
	import org.osmf.captioning.parsers.ICaptioningParser;
	import org.osmf.events.LoaderEvent;
	import org.osmf.events.MediaErrorEvent;
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
	 * Loader class for the CaptioningProxyElement.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class CaptioningLoader extends LoaderBase
	{
		/**
		 * Constructor.
		 * 
		 * @param httpLoader The HTTPLoader to be used by this CaptioningLoader 
		 * to retrieve the Timed Text document. If null, a new one will be 
		 * created.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function CaptioningLoader(httpLoader:HTTPLoader=null)
		{
			super();
			
			this.httpLoader = httpLoader != null ? httpLoader : new HTTPLoader();
		}
		
		/**
		 * @private
		 */
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			return httpLoader.canHandleResource(resource);
		}

		/**
		 * Loads a Timed Text document.
		 * <p>Updates the ILoadable's <code>loadedState</code> property to LOADING
		 * while loading and to LOADED upon completing a successful load and parse of the
		 * Timed Text document.</p>
		 * 
		 * @see org.osmf.traits.LoadState
		 * @param loadable The ILoadable to be loaded.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
				if (logger != null)
				{
					logger.debug("Downloading document at " + URLResource(httpLoadable.resource).url.rawUrl);
				}
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
					
					var parser:ICaptioningParser = createCaptioningParser();
					var captioningDocument:CaptioningDocument;
					
					try
					{
						captioningDocument = parser.parse(loadedContext.urlLoader.data.toString());
					}
					catch(e:Error)
					{
						CONFIG::LOGGING
						{
							if (logger != null)
							{
								logger.debug("Error parsing captioning document: " + e.errorID + "-" + e.message);
							}
						}
						updateLoadable(loadable, LoadState.LOAD_ERROR);
						throw e;
					}
					
					updateLoadable(loadable, LoadState.READY, new CaptioningLoadedContext(captioningDocument));
					
				}
				else if (event.newState == LoadState.LOAD_ERROR)
				{
					// This is a terminal state, so remove the listener.  But
					// don't remove the error event listener, as that will be
					// removed when the error event for this failure is
					// dispatched.
					httpLoader.removeEventListener(LoaderEvent.LOADABLE_STATE_CHANGE, onHTTPLoaderStateChange);
					
					CONFIG::LOGGING
					{
						if (logger != null)
						{
							logger.debug("Error loading captioning document");;
						}
					}
					
					
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
		 * @see org.osmf.traits.LoadState
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		override public function unload(loadable:ILoadable):void
		{
			super.unload(loadable);

			// Nothing to do.
			updateLoadable(loadable, LoadState.UNLOADING, loadable.loadedContext);			
			updateLoadable(loadable, LoadState.UNINITIALIZED);
		}
		
		/**
		 * Override to create your own parser.
		 */
		protected function createCaptioningParser():ICaptioningParser
		{
			return new DFXPParser();
		}

		private var httpLoader:HTTPLoader;		
		
		CONFIG::LOGGING
		{	
			private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("CaptioningLoader");		
		}	
	}
}
