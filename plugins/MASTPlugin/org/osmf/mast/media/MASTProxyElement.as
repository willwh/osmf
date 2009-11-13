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
package org.osmf.mast.media
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.composition.SerialElement;
	import org.osmf.events.LoadableStateChangeEvent;
	import org.osmf.events.TraitsChangeEvent;
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;
	import org.osmf.mast.loader.MASTDocumentProcessedEvent;
	import org.osmf.mast.loader.MASTDocumentProcessor;
	import org.osmf.mast.loader.MASTLoadedContext;
	import org.osmf.mast.loader.MASTLoader;
	import org.osmf.mast.managers.MASTConditionManager;
	import org.osmf.mast.model.*;
	import org.osmf.mast.traits.MASTPlayableTrait;
	import org.osmf.mast.types.MASTConditionType;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.IFacet;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.proxies.ProxyElement;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.ITemporal;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayableTrait;
	import org.osmf.utils.URL;

	/**
	 * The MASTProxyElement class is a wrapper for the media supplied.
	 * It's purpose is to override the loadable and playable traits to 
	 * allow the processing of a MAST document and to insert the media
	 * elements found in the MAST payload.
	 */
	public class MASTProxyElement extends ProxyElement
	{
		public static const MAST_METADATA_NAMESPACE:URL	= new URL("http://www.akamai.com/mast");
		public static const METADATA_KEY_URI:String = "url";
		
		/**
		 * Constructor.
		 * 
		 * @inheritDoc
		 **/
		public function MASTProxyElement(wrappedElement:MediaElement=null)
		{
			super(wrappedElement);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set wrappedElement(value:MediaElement):void
		{
			if (value != null &&
				!(value is SerialElement))
			{
				// Wrap any child in a SerialElement.
				var serialElement:SerialElement = new SerialElement();
				serialElement.addChild(value);
				
				value = serialElement;
			}
			
			super.wrappedElement = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setupOverriddenTraits():void
		{
			super.setupOverriddenTraits();
			
			// Override the ILoadable trait with our own custom ILoadable,
			// which retrieves the MAST document, parses it, and sets up
			// the triggers in relation to our wrapped MediaElement.
			//
			
			// Get the MAST url resource from the metadata of the element
			// that is wrapped.
			var serialElement:SerialElement = super.wrappedElement as SerialElement;
			var mediaElement:MediaElement = serialElement.getChildAt(0);
			
			var tempResource:IMediaResource = (mediaElement && mediaElement.resource != null) ? mediaElement.resource : resource;
			if (tempResource == null)
			{
				throw new IllegalOperationError(ERROR_MISSING_RESOURCE);
			}
			
			var facet:IFacet = tempResource.metadata.getFacet(MAST_METADATA_NAMESPACE);
			if (facet == null)
			{
				throw new IllegalOperationError(ERROR_MISSING_MAST_METADATA);
			}			
			
			var mastURL:String = facet.getValue(new ObjectIdentifier(METADATA_KEY_URI));
			
			loadableTrait = new LoadableTrait(new MASTLoader(), new URLResource(new URL(mastURL)));
			
			loadableTrait.addEventListener
				( LoadableStateChangeEvent.LOAD_STATE_CHANGE
				, onLoadStateChange
				);
			
			addTrait(MediaTraitType.LOADABLE, loadableTrait); 
			
			// Override the IPlayable trait so we can do any necessary
			// pre-processing, such as a payload that would cause a 
			// pre-roll.
			
			var playableTrait:PlayableTrait = new MASTPlayableTrait(this);
			addTrait(MediaTraitType.PLAYABLE, playableTrait);
		}
		
		private function removeCustomPlayableTrait():void
		{
			var playableTrait:MASTPlayableTrait = this.getTrait(MediaTraitType.PLAYABLE) as MASTPlayableTrait;
			
			if (playableTrait)
			{
				removeTrait(MediaTraitType.PLAYABLE);
				
				if (playableTrait.playRequestPending)
				{
					// Call play on the original trait
				
					var playable:IPlayable = this.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
					
					if (playable == null)
					{
						// Trait is not present yet, we need to wait for it to be added
						this.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
					}
					else
					{
						playable.play();
					}
					
				}	
			}
		}
			
		private function onTraitAdd(event:TraitsChangeEvent):void
		{
			this.removeEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
			
			if (event.traitType == MediaTraitType.PLAYABLE)
			{
				var playable:IPlayable = this.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
				playable.play();
			}
		}
				
		private function onLoadStateChange(event:LoadableStateChangeEvent):void
		{
			if (event.loadState == LoadState.READY)
			{
				var loadedContext:MASTLoadedContext = loadableTrait.loadedContext as MASTLoadedContext
				
				var processor:MASTDocumentProcessor = new MASTDocumentProcessor();
				processor.addEventListener(MASTDocumentProcessedEvent.PROCESSED, onDocumentProcessed, false, 0, true);
				var mediaElement:MediaElement = (wrappedElement as SerialElement).getChildAt(0);
				var causesPendingPlayRequest:Boolean = processor.processDocument(loadedContext.document, mediaElement);

				// If there was no condition that causes a pending play request
				// remove the custom IPlayable
				if (!causesPendingPlayRequest)
				{
					removeCustomPlayableTrait();
				}

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
		
		private function onDocumentProcessed(event:MASTDocumentProcessedEvent):void
		{
			var serialElement:SerialElement = wrappedElement as SerialElement;
			
			// Each inline element needs to be inserted into the location that
			// will cause it to be the current (or next) item.
			for each (var inlineElement:MediaElement in event.inlineElements)
			{
				var insertionIndex:int = getInsertionIndex(serialElement, event.condition);
				
				// If we are inserting at zero, we need to remove the original and then
				// add it again to force SerialElement to update it's listening index
				var tempMediaElement:MediaElement = null;
				if (insertionIndex == 0)
				{
					tempMediaElement = serialElement.removeChildAt(0);
				}
				
				serialElement.addChildAt(inlineElement, insertionIndex);
				
				if (tempMediaElement != null)
				{
					serialElement.addChild(tempMediaElement);
				}
			}
			
			// Now we can remove the custom IPlayable trait
			this.removeCustomPlayableTrait();
		}
		
		private function getInsertionIndex(serialElement:SerialElement, condition:MASTCondition):int
		{
			// Generally, the insertion index is the index of the current
			// child, so that the inserted child becomes the new current child.
			var index:int = 0;
			
			if ((condition.type == MASTConditionType.EVENT) && (MASTConditionManager.conditionIsPostRoll(condition)))
			{
				index++;
			}
			else
			{	
				// However, if our current child is in the midst of playback, we
				// don't want to interrupt it, so we insert immediately after the
				// current child.
				var currentChild:MediaElement = serialElement.getChildAt(index);
				if (currentChild != null)
				{
					// Treat it as playing if it's playing or has a positive currentTime.
					var temporal:ITemporal = currentChild.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
					if (temporal != null &&	temporal.currentTime > 0)
					{
						index++;
					}
					else
					{
						var playable:IPlayable = currentChild.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
						if (playable != null &&	playable.playing)
						{
							index++;
						}
					}
				}
			}
			
			CONFIG::LOGGING
			{
				logger.debug("MASTProxyElement - getInsertionIndex() about to return "+index);
			}
			return index;
		}
		
		private var loadableTrait:LoadableTrait;
		
		private static const ERROR_MISSING_MAST_METADATA:String = "Media Element is missing MAST metadata";
		private static const ERROR_MISSING_RESOURCE:String = "Media Element is missing a valid resource";
		
		CONFIG::LOGGING
		private static const logger:ILogger = Log.getLogger("MASTProxyElement");			
		
	}
}
