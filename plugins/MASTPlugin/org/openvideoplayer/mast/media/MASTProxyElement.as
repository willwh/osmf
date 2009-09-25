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
package org.openvideoplayer.mast.media
{
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.mast.loader.MASTDocumentProcessedEvent;
	import org.openvideoplayer.mast.loader.MASTDocumentProcessor;
	import org.openvideoplayer.mast.loader.MASTLoadedContext;
	import org.openvideoplayer.mast.loader.MASTLoader;
	import org.openvideoplayer.mast.model.*;
	import org.openvideoplayer.mast.traits.MASTPlayableTrait;
	import org.openvideoplayer.mast.types.MASTConditionType;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.metadata.IFacet;
	import org.openvideoplayer.metadata.ObjectIdentifier;
	import org.openvideoplayer.proxies.ProxyElement;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.ITemporal;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.PlayableTrait;
	import org.openvideoplayer.utils.URL;

	public class MASTProxyElement extends ProxyElement
	{
		public static const MAST_METADATA_NAMESPACE:URL	= new URL("http://www.akamai.com/mast");
		public static const METADATA_KEY_URI:String = "url";
		
		/**
		 * Constructor.
		 **/
		public function MASTProxyElement(wrappedElement:MediaElement=null)
		{
			super(wrappedElement);
		}
		
		public function removeCustomPlayableTrait():void
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
			
			var facet:IFacet = tempResource.metadata.getFacet(MAST_METADATA_NAMESPACE);
			//$$$todo: throw an exception if facet is null
			
			var mastURL:String = facet.getValue(new ObjectIdentifier(METADATA_KEY_URI));
			
			var loadableTrait:LoadableTrait
				= new LoadableTrait(new MASTLoader(), new URLResource(new URL(mastURL)));
			
			loadableTrait.addEventListener
				( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
				, onLoadableStateChange
				);
			
			addTrait(MediaTraitType.LOADABLE, loadableTrait); 
			
			// Override the IPlayable trait so we can do any necessary
			// pre-processing.
			
			var playableTrait:PlayableTrait = new MASTPlayableTrait(this);
			addTrait(MediaTraitType.PLAYABLE, playableTrait);
			
		}
		
		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			if (event.newState == LoadState.LOADED)
			{
				var loadedContext:MASTLoadedContext = event.loadable.loadedContext as MASTLoadedContext
				
				var processor:MASTDocumentProcessor = new MASTDocumentProcessor();
				processor.addEventListener(MASTDocumentProcessedEvent.PROCESSED, onDocumentProcessed, false, 0, true);
				processor.processDocument(loadedContext.document, wrappedElement);

				// Our work is done, remove the custom ILoadable.  This will
				// expose the base ILoadable, which we can then use to do
				// the actual load.
				removeTrait(MediaTraitType.LOADABLE);
				(getTrait(MediaTraitType.LOADABLE) as ILoadable).load();
				
				// Tell the overriden IPlayable trait about the MAST DOM
				var playableTrait:MASTPlayableTrait = getTrait(MediaTraitType.PLAYABLE) as MASTPlayableTrait;
				playableTrait.mastDocument = loadedContext.document;
				playableTrait.documentProcessor = processor;
				
			}
			else if (event.newState == LoadState.LOAD_FAILED)
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
			
			if ((condition.type == MASTConditionType.EVENT) && (MASTPlayableTrait.conditionIsPostRoll(condition)))
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
					// Treat it as playing if it's playing or has a positive position.
					var temporal:ITemporal = currentChild.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
					if (temporal != null &&	temporal.position > 0)
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
			
			trace("MASTProxyElement - getInsertionIndex() about to return "+index);
			return index;
		}
	}
}