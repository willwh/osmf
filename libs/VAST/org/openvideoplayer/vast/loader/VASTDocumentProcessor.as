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
package org.openvideoplayer.vast.loader
{
	import __AS3__.vec.Vector;
	
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.logging.ILogger;
	import org.openvideoplayer.logging.Log;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.HTTPLoader;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.vast.model.VASTAd;
	import org.openvideoplayer.vast.model.VASTDocument;
	import org.openvideoplayer.vast.model.VASTInlineAd;
	import org.openvideoplayer.vast.model.VASTTrackingEvent;
	import org.openvideoplayer.vast.model.VASTUrl;
	import org.openvideoplayer.vast.model.VASTWrapperAd;
	import org.openvideoplayer.vast.parser.VASTParser;

	[Event("processed")]
	[Event("processingFailed")]
	
	internal class VASTDocumentProcessor extends EventDispatcher
	{
		public function VASTDocumentProcessor(maxNumWrapperRedirects:Number, httpLoader:HTTPLoader)
		{
			super();
			
			this.maxNumWrapperRedirects = maxNumWrapperRedirects;
			this.httpLoader = httpLoader;
		}

		public function processVASTDocument(documentContents:String):void
		{
			var processingFailed:Boolean = false;
			
			var vastDocument:VASTDocument = null;
			
			var documentXML:XML = null;
			try
			{
				documentXML = new XML(documentContents);
			}
			catch (error:TypeError)
			{
				processingFailed = true;
			}
			
			if (documentXML != null)
			{
				var parser:VASTParser = new VASTParser();
				vastDocument = parser.parse(documentXML);
				if (vastDocument != null)
				{
					// If the VAST document has a wrapper, we may need to load it.
					var numWrappers:int = getNumVASTWrappers(vastDocument); 
	
					CONFIG::LOGGING
					{
						logger.debug("Document has " + numWrappers + " wrappers");
					}
	
					if (numWrappers > 0)
					{
						loadVASTWrappers(vastDocument);
					}
					else
					{
						dispatchEvent(new VASTDocumentProcessedEvent(VASTDocumentProcessedEvent.PROCESSED, vastDocument));
					}
				}
				else
				{
					processingFailed = true;
				}
			}
			
			if (processingFailed)
			{
				CONFIG::LOGGING
				{
					logger.debug("Processing failed for document with contents: " + documentContents);
				}
					
				dispatchEvent(new VASTDocumentProcessedEvent(VASTDocumentProcessedEvent.PROCESSING_FAILED));
			}
		}
		
		private function getNumVASTWrappers(vastDocument:VASTDocument):int
		{
			var count:int = 0;
			
			var ads:Vector.<VASTAd> = vastDocument.ads;
			for each (var ad:VASTAd in ads)
			{
				if (needLoadVASTWrapper(ad))
				{
					count++;
				}
			}
			
			return count;
		}

		private function needLoadVASTWrapper(ad:VASTAd):Boolean
		{
			return ad.wrapperAd != null
				&&	(  maxNumWrapperRedirects == -1
					|| maxNumWrapperRedirects > 0
					);
		}
		
		private function loadVASTWrappers(vastDocument:VASTDocument):void
		{
			var numLoadsToComplete:int = getNumVASTWrappers(vastDocument);
			var noFailedLoads:Boolean = true;
			
			var ads:Vector.<VASTAd> = vastDocument.ads;
			for (var i:int = 0; i < ads.length; i++)
			{
				var ad:VASTAd = ads[i];
				
				CONFIG::LOGGING
				{
					logger.debug("Inspecting ad " + ad.id);
				}
				
				if (needLoadVASTWrapper(ad))
				{
					loadVASTWrapper(ad, completionCallback);
				}
			}
			
			function completionCallback(success:Boolean):void
			{
				numLoadsToComplete--;
				
				if (noFailedLoads)
				{
					if (success == false)
					{
						noFailedLoads = false;

						// Signal that the processing failed on our first failure.
						dispatchEvent(new VASTDocumentProcessedEvent(VASTDocumentProcessedEvent.PROCESSING_FAILED));						
					}
					else
					{
						CONFIG::LOGGING
						{
							logger.debug("" + numLoadsToComplete + " more wrapper ads to load");
						}

						// Wait until the last load completes before signaling
						// success.
						if (numLoadsToComplete == 0)
						{
							dispatchEvent(new VASTDocumentProcessedEvent(VASTDocumentProcessedEvent.PROCESSED, vastDocument));
						}
					}
				}
			}
		}
		
		private function loadVASTWrapper(ad:VASTAd, completionCallback:Function):void
		{
			CONFIG::LOGGING
			{
				logger.debug("Ad " + ad.id + " is a wrapper, loading...");
			}
			
			// Use another VASTLoader to load the wrapper, decrementing
			// our redirect count so that we don't redirect too many times.
			var wrapperLoader:VASTLoader
				= new VASTLoader
					( Math.max(-1, maxNumWrapperRedirects-1)
					, httpLoader
					)
				;
			
			var wrapperResource:URLResource
				= new URLResource
					( new URL(ad.wrapperAd.vastAdTagURL)
					);
					
			var wrapperLoadable:LoadableTrait = new LoadableTrait(wrapperLoader, wrapperResource);
			wrapperLoadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onWrapperLoadableStateChange);
			wrapperLoadable.load();
			
			function onWrapperLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					wrapperLoadable.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onWrapperLoadableStateChange);
					
					// Merge the wrapper's ad with the original ad.
 					var wrapperLoadedContext:VASTLoadedContext = event.loadable.loadedContext as VASTLoadedContext;
					var success:Boolean = mergeAds(ad, wrapperLoadedContext.vastDocument);
						
					CONFIG::LOGGING
					{
						logger.debug("Wrapper ad " + ad.id + " loaded");
						logger.debug("Merging wrapper ad " + ad.id + " with nested document at " + URLResource(wrapperResource).url.rawUrl);
						logger.debug("Merge " + (success ? "succeeded" : "failed"));
					} 

					completionCallback(success);
				}
				else if (event.newState == LoadState.LOAD_FAILED)
				{
					wrapperLoadable.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onWrapperLoadableStateChange);

					CONFIG::LOGGING
					{
						logger.debug("Wrapper ad " + ad.id + " load failed");
					}
					
					completionCallback(false);
				}
			}
		}
		
		private function mergeAds(rootAd:VASTAd, nestedDocument:VASTDocument):Boolean
		{
			var success:Boolean = false;
			
			// The goal here is to have the rootAd expose the inlineAd from the
			// nested document, rather than its own wrappedAd.  Doing so is
			// straightforward, in that we can just copy the inline ad from
			// the nested document to the rootAd.  Note that it's possible
			// that the nested document has more than one inlineAd.  If that
			// happens, we just take the first one.
			for each (var nestedAd:VASTAd in nestedDocument.ads)
			{ 
				// Not finding an inline ad is cause for failure.
				if (nestedAd.inlineAd != null)
				{
					rootAd.inlineAd = nestedAd.inlineAd;
					success = true;
					break;
				}
			}
			
			// Now that we've merged, we need to copy the relevant properties
			// from the rootAd's wrapperAd into its new inlineAd.
			//
			
			var wrapperAd:VASTWrapperAd = rootAd.wrapperAd;
			var inlineAd:VASTInlineAd = rootAd.inlineAd;
			
			// Copy the impressions over.
			for each (var impression:VASTUrl in wrapperAd.impressions)
			{
				inlineAd.addImpression(impression);
			}
			
			// Copy the tracking events over.
			for each (var trackingEvent:VASTTrackingEvent in wrapperAd.trackingEvents)
			{
				var inlineAdTrackingEvent:VASTTrackingEvent = inlineAd.getTrackingEventByType(trackingEvent.type);
				if (inlineAdTrackingEvent != null)
				{
					inlineAdTrackingEvent.urls = inlineAdTrackingEvent.urls.concat(trackingEvent.urls);
				}
				else
				{
					inlineAd.addTrackingEvent(trackingEvent);
				}
			}
			
			// TODO: Merge companion ads, nonlinear ads, and video clicks.
			// Note that the spec is ambiguous about merging impressions from
			// companion and non-linear ads.  Should the impression be matched
			// by ID?  Should each impression be copied to each ad?  Not sure.
			 
			// Now, we can remove the rootAd's wrapperAd, since the inlineAd
			// now contains the merged details of both the original wrapperAd
			// and the nested inlineAd.
			rootAd.wrapperAd = null;
			
			return success;
		}
		
		private var maxNumWrapperRedirects:Number;
		private var httpLoader:HTTPLoader;

		CONFIG::LOGGING
		private static const logger:ILogger = Log.getLogger("VASTDocumentProcessor");
	}
}