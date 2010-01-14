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
package org.osmf.captioning.media
{
	import org.osmf.captioning.CaptioningPluginInfo;
	import org.osmf.captioning.loader.CaptioningLoadedContext;
	import org.osmf.captioning.loader.CaptioningLoader;
	import org.osmf.captioning.model.CaptioningDocument;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.Facet;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.metadata.TemporalFacet;
	import org.osmf.proxies.ProxyElement;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.URL;

	/**
	 * The CaptioningProxyElement class is a wrapper for the media supplied.
	 * It's purpose is to override the loadable trait to allow the retrieval and
	 * processing of an Timed Text file used for captioning.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class CaptioningProxyElement extends ProxyElement
	{
		/**
		 * Constructor.
		 * 
		 * @inheritDoc
		 * 
		 * @param continueLoadOnFailure Specifies whether or not the 
		 * class should continue the load process if the captioning
		 * document fails to load. The default value is <code>true</code>.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function CaptioningProxyElement(wrappedElement:MediaElement=null, continueLoadOnFailure:Boolean=true)
		{
			super(wrappedElement);
			_continueLoadOnFailure = continueLoadOnFailure;
		}
		
		/**
		 * Specifies whether or not this class should continue loading
		 * the media element when the captioning document
		 * fails to load.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get continueLoadOnFailure():Boolean
		{
			return _continueLoadOnFailure;
		}
				
		/**
		 * @inheritDoc
		 */
		override protected function setupOverriddenTraits():void
		{
			super.setupOverriddenTraits();
			
			// Override the LoadTrait with our own custom LoadTrait,
			// which retrieves the Timed Text document, parses it, and sets up
			// the object model representing the caption data.
			
			// Get the Timed Text url resource from the metadata of the element
			// that is wrapped.
			var mediaElement:MediaElement = super.wrappedElement;
			var tempResource:MediaResourceBase = (mediaElement && mediaElement.resource != null) ? mediaElement.resource : resource;
			if (tempResource == null)
			{
				dispatchEvent(new MediaErrorEvent( MediaErrorEvent.MEDIA_ERROR, false, false, 
								new MediaError(MediaErrorCodes.HTTP_IO_LOAD_ERROR)));
			}
			else
			{
				var facet:Facet = tempResource.metadata.getFacet(CaptioningPluginInfo.CAPTIONING_METADATA_NAMESPACE);
				if (facet == null)
				{
					if (!_continueLoadOnFailure)
					{
						dispatchEvent(new MediaErrorEvent( MediaErrorEvent.MEDIA_ERROR, false, false, 
										new MediaError(MediaErrorCodes.HTTP_IO_LOAD_ERROR)));
					}
				}
				else
				{		
					var timedTextURL:String = facet.getValue(new ObjectIdentifier(CaptioningPluginInfo.CAPTIONING_METADATA_KEY_URI));
					if (timedTextURL != null)
					{
						loadTrait = new LoadTrait(new CaptioningLoader(), new URLResource(new URL(timedTextURL)));
						
						loadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
						addTrait(MediaTraitType.LOAD, loadTrait);
					}
					else if (!_continueLoadOnFailure)
					{
						dispatchEvent(new MediaErrorEvent( MediaErrorEvent.MEDIA_ERROR, false, false, 
										new MediaError(MediaErrorCodes.HTTP_IO_LOAD_ERROR)));
					}
 
				}
			} 
		}
		
		private function onLoadStateChange(event:LoadEvent):void
		{
			if (event.loadState == LoadState.READY)
			{
				var loadedContext:CaptioningLoadedContext = loadTrait.loadedContext as CaptioningLoadedContext
				var document:CaptioningDocument = loadedContext.document;
				var mediaElement:MediaElement = super.wrappedElement;
				
				// Create a new TemporalFacet, add it to the metadata for the mediaelement
				var temporalFacetDynamic:TemporalFacet = 
						new TemporalFacet(CaptioningPluginInfo.CAPTIONING_TEMPORAL_METADATA_NAMESPACE, super.wrappedElement);
				
				for (var i:int = 0; i < document.numCaptions; i++)
				{
					temporalFacetDynamic.addValue(document.getCaptionAt(i));
				}
				
				mediaElement.metadata.addFacet(temporalFacetDynamic);			

				cleanUp();
			}
			else if (event.loadState == LoadState.LOAD_ERROR)
			{
				if (!_continueLoadOnFailure)
				{
					dispatchEvent(event.clone());
				}
				else
				{
					cleanUp();
				}
			}
		}
		
		private function cleanUp():void
		{
			// Our work is done, remove the custom LoadTrait.  This will
			// expose the base LoadTrait, which we can then use to do
			// the actual load.
			removeTrait(MediaTraitType.LOAD);
			
			var loadTrait:LoadTrait = getTrait(MediaTraitType.LOAD) as LoadTrait;
			if (loadTrait != null)
			{
				loadTrait.load();
			}
		}
		
		private var loadTrait:LoadTrait;
		private var _continueLoadOnFailure:Boolean;
				
		private static const ERROR_MISSING_CAPTION_METADATA:String = "Media Element is missing Captioning metadata";
		private static const ERROR_MISSING_RESOURCE:String = "Media Element is missing a valid resource";
		
	}
}
