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
package org.osmf.composition
{
	import flash.events.EventDispatcher;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * Dispatched when the requested MediaElement has been found, or when it
	 * has been determined that no such MediaElement exists.
	 * 
	 * @eventType org.osmf.composition.events.TraitLoaderEvent.TRAIT_FOUND
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="traitFound",type="org.osmf.composition.events.TraitLoaderEvent")]

	/**
	 * Utility class for doing conditional loads of MediaElements.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	internal class TraitLoader extends EventDispatcher
	{
		/**
		 * Iterates over a list of MediaElements looking for a given trait, and
		 * returns the first MediaElement in the list which either has the trait,
		 * or which acquires the trait as a result of being loaded.  (As such,
		 * has the side effect of loading all MediaElements in the list up until
		 * it finds one with the requested trait.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function findOrLoadMediaElementWithTrait(mediaElements:Array, traitType:String):void
		{
			var noSuchTrait:Boolean = true;
			
			for each (var mediaElement:MediaElement in mediaElements)
			{
				var loadTrait:LoadTrait = mediaElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
				
				if (mediaElement.hasTrait(traitType))
				{
					// If the next MediaElement has the requested trait, then
					// we're done.
					//
					
					noSuchTrait = false;
					
					dispatchFindOrLoadEvent(mediaElement);
					break;
				}
				else if (loadTrait != null &&
						 loadTrait.loadState != LoadState.READY)
				{
					// If the next MediaElement doesn't have the trait, but has
					// the LoadTrait and is not yet loaded, then we should
					// load it in case the trait gets added as a result of the
					// load operation.
					//
					
					// We're not sure yet if there's a trait.
					noSuchTrait = false;
					
					loadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
					
					// If it's already loading, then we only need to wait for
					// the event.
					if (loadTrait.loadState != LoadState.LOADING)
					{
						loadTrait.load();
					}
					break;
					
					function onLoadStateChange(event:LoadEvent):void
					{
						var loadTrait:LoadTrait = event.target as LoadTrait;
						if (loadTrait.loadState == LoadState.READY)
						{
							if (mediaElement.hasTrait(traitType))
							{
								dispatchFindOrLoadEvent(mediaElement);
							}
							else
							{
								// Recursively call this method, after stripping
								// off all MediaElements up to and including
								// the one we're iterating over (i.e. the one
								// we just loaded).
								findOrLoadMediaElementWithTrait
									( mediaElements.slice(mediaElements.indexOf(mediaElement)+1)
									, traitType
									);
							}
						}
					}
				}
			}
			
			if (noSuchTrait)
			{
				dispatchFindOrLoadEvent(null);
			}
		}
		
		private function dispatchFindOrLoadEvent(mediaElement:MediaElement):void
		{
			dispatchEvent(new TraitLoaderEvent(mediaElement));
		}
	}
}