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
	import flash.errors.IllegalOperationError;
	
	import org.osmf.captioning.CaptioningPluginInfo;
	import org.osmf.captioning.loader.CaptioningLoadedContext;
	import org.osmf.captioning.loader.CaptioningLoader;
	import org.osmf.captioning.model.CaptioningDocument;
	import org.osmf.events.LoadEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.IFacet;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.metadata.TemporalFacet;
	import org.osmf.proxies.ProxyElement;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadableTrait;
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
		 * document fails to load. The default value is <code>false</code>.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function CaptioningProxyElement(wrappedElement:MediaElement=null, continueLoadOnFailure:Boolean=false)
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
		
		public function set continueLoadOnFailure(value:Boolean):void
		{
			_continueLoadOnFailure = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setupOverriddenTraits():void
		{
			super.setupOverriddenTraits();
			
			// Override the ILoadable trait with our own custom ILoadable,
			// which retrieves the Timed Text document, parses it, and sets up
			// the object model representing the caption data.
			
			// Get the Timed Text url resource from the metadata of the element
			// that is wrapped.
			var mediaElement:MediaElement = super.wrappedElement;
			var tempResource:IMediaResource = (mediaElement && mediaElement.resource != null) ? mediaElement.resource : resource;
			if (tempResource == null)
			{
				if (!_continueLoadOnFailure)
				{
					throw new IllegalOperationError(ERROR_MISSING_RESOURCE);
				}
			}
			else
			{
				var facet:IFacet = tempResource.metadata.getFacet(CaptioningPluginInfo.CAPTIONING_METADATA_NAMESPACE);
				if (facet == null)
				{
					if (!_continueLoadOnFailure)
					{
						throw new IllegalOperationError(ERROR_MISSING_CAPTION_METADATA);
					}
				}
				else
				{		
					var timedTextURL:String = facet.getValue(new ObjectIdentifier(CaptioningPluginInfo.CAPTIONING_METADATA_KEY_URI));
					loadableTrait = new LoadableTrait(new CaptioningLoader(), new URLResource(new URL(timedTextURL)));
					
					loadableTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
					addTrait(MediaTraitType.LOADABLE, loadableTrait);
				}
			} 
		}
		
		private function onLoadStateChange(event:LoadEvent):void
		{
			if (event.loadState == LoadState.READY)
			{
				var loadedContext:CaptioningLoadedContext = loadableTrait.loadedContext as CaptioningLoadedContext
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

				// Our work is done, remove the custom ILoadable.  This will
				// expose the base ILoadable, which we can then use to do
				// the actual load.
				removeTrait(MediaTraitType.LOADABLE);
				var loadable:ILoadable = getTrait(MediaTraitType.LOADABLE) as ILoadable;
				if (loadable)
				{
					loadable.load();
				}
			}
			else if (event.loadState == LoadState.LOAD_ERROR)
			{
				dispatchEvent(event.clone());
			}
		}
		
		private var loadableTrait:LoadableTrait;
		private var _continueLoadOnFailure:Boolean;
				
		private static const ERROR_MISSING_CAPTION_METADATA:String = "Media Element is missing Captioning metadata";
		private static const ERROR_MISSING_RESOURCE:String = "Media Element is missing a valid resource";
		
	}
}
